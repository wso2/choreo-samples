import ballerina/http;
import ballerina/log;
import ballerinax/googleapis.sheets;
import ballerinax/salesforce as sfdc;
import ballerinax/trigger.salesforce as sfdcListener;

// Types
type SalesforceListenerConfig record {
    string username;
    string password;
};

type GSheetOAuth2Config record {
    string clientId;
    string clientSecret;
    string refreshToken;
    string refreshUrl = "https://www.googleapis.com/oauth2/v3/token";
};

type SalesforceOAuth2Config record {
    string clientId;
    string clientSecret;
    string refreshToken;
    string refreshUrl = "https://login.salesforce.com/services/oauth2/token";
};

// Constants
const string CHANNEL_NAME = "/data/CaseChangeEvent";
const int HEADINGS_ROW = 1;
const string RESPONSE_MESSAGE = "New case appended successfully";
const string CASE = "Case";

// Salesforce configuration parameters
configurable SalesforceListenerConfig salesforceListenerConfig = ?;
configurable SalesforceOAuth2Config salesforceClientConfig = ?;
configurable string salesforceBaseUrl = ?;

// Google sheet configuration parameters
configurable GSheetOAuth2Config GSheetOauthConfig = ?;
configurable string spreadsheetId = ?;
configurable string worksheetName = ?;

listener sfdcListener:Listener sfdcEventListener = new ({
    username: salesforceListenerConfig.username,
    password: salesforceListenerConfig.password,
    channelName: CHANNEL_NAME
});

@display { label: "Salesforce New Case to Google Sheets Row" }
service sfdcListener:RecordService on sfdcEventListener {
    remote function onCreate(sfdcListener:EventData payload) returns error? {
        json caseId = payload?.metadata?.recordId;
        sfdc:Client sfdcClient = check new ({
            baseUrl: salesforceBaseUrl,
            auth: {
                clientId: salesforceClientConfig.clientId,
                clientSecret: salesforceClientConfig.clientSecret,
                refreshToken: salesforceClientConfig.refreshToken,
                refreshUrl: salesforceClientConfig.refreshUrl
            }
        });
        json caseRecord = check sfdcClient->getRecordById(CASE, caseId.toString());
        string[] headerValues = [];
        (int|string|decimal)[] values = [];
        map<json> caseMap = <map<json>>caseRecord;
        foreach [string, json] [key, value] in caseMap.entries() {
            headerValues.push(key);
            values.push(value.toString());
        }
        sheets:Client spreadsheetClient = check new ({
            auth: {
                clientId: GSheetOauthConfig.clientId,
                clientSecret: GSheetOauthConfig.clientSecret,
                refreshToken: GSheetOauthConfig.refreshToken,
                refreshUrl: GSheetOauthConfig.refreshUrl
            }
        });
        sheets:Row headers = check spreadsheetClient->getRow(spreadsheetId, worksheetName, HEADINGS_ROW);
        if headers.values.length() == 0 {
            check spreadsheetClient->appendRowToSheet(spreadsheetId, worksheetName, headerValues);
        }
        check spreadsheetClient->appendRowToSheet(spreadsheetId, worksheetName, values);
        log:printInfo(RESPONSE_MESSAGE);
    }

    remote function onUpdate(sfdcListener:EventData payload) returns error? {
        return;
    }

    remote function onDelete(sfdcListener:EventData payload) returns error? {
        return;
    }

    remote function onRestore(sfdcListener:EventData payload) returns error? {
        return;
    }
}

service /ignore on new http:Listener(8090) {}
