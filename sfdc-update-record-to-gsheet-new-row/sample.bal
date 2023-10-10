import ballerina/http;
import ballerina/log;
import ballerinax/googleapis.sheets;
import ballerinax/salesforce as sfdc;
import ballerinax/trigger.salesforce as sfdcListener;

type GsheetCellValueType int|string|decimal;

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

// Salesforce listener configuration parameters
type ListenerConfig record {
    string username;
    string password;
};

const string CHANNEL_PREFIX = "/data/";
const string EVENT_POSTFIX = "ChangeEvent";
const string BASE_URL = "/services/data/v48.0/sobjects/";
const int HEADINGS_ROW = 1;

configurable ListenerConfig salesforceListenerConfig = ?;
configurable SalesforceOAuth2Config salesforceOAuthConfig = ?;
configurable string salesforceBaseUrl = ?;
configurable string salesforceObject = ?;

configurable GSheetOAuth2Config sheetOAuthConfig = ?;
configurable string spreadsheetId = ?;
configurable string worksheetName = ?;

listener sfdcListener:Listener sfdcEventListener = new ({
    username: salesforceListenerConfig.username,
    password: salesforceListenerConfig.password,
    channelName: CHANNEL_PREFIX + salesforceObject + EVENT_POSTFIX
});

@display { label: "Salesforce Record Update to Google Sheets New Row" }
service  sfdcListener:RecordService on sfdcEventListener {
    remote function onUpdate(sfdcListener:EventData payload) returns error? {
        json sObjectId = payload?.metadata?.recordId;
        string path = BASE_URL + salesforceObject + "/" + sObjectId.toString();
        sfdc:Client sfdcClient = check new ({
            baseUrl: salesforceBaseUrl,
            auth: {
                clientId: salesforceOAuthConfig.clientId,
                clientSecret: salesforceOAuthConfig.clientSecret,
                refreshToken: salesforceOAuthConfig.refreshToken,
                refreshUrl: salesforceOAuthConfig.refreshUrl
            }
        });
        // Get relevent sobject information
        map<json> sobjectInfo = <map<json>>check sfdcClient->getRecord(path);

        // Populate column names, values for GSheet
        string[] headerValues = [];
        GsheetCellValueType[] values = [];
        foreach [string, json] [key, value] in sobjectInfo.entries() {
            headerValues.push(key);
            values.push(value.toString());
        }

        sheets:Client gSheetClient = check new ({
            auth: {
                clientId: sheetOAuthConfig.clientId,
                clientSecret: sheetOAuthConfig.clientSecret,
                refreshToken: sheetOAuthConfig.refreshToken,
                refreshUrl: sheetOAuthConfig.refreshUrl
            }
        });
        sheets:Row headers = check gSheetClient->getRow(spreadsheetId, worksheetName, HEADINGS_ROW);
        if headers.values.length() == 0 {
            check gSheetClient->appendRowToSheet(spreadsheetId, worksheetName, headerValues);
        }
        check gSheetClient->appendRowToSheet(spreadsheetId, worksheetName, values);

        log:printInfo(string `Updated ${salesforceObject} with Id ${sObjectId.toString()} appended to the spreadsheet successfully!`);
    }

    remote function onCreate(sfdcListener:EventData payload) returns error? {
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
