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
const string CHANNEL_NAME = "/data/LeadChangeEvent";
const int HEADINGS_ROW = 1;

// Salesforce configuration parameters
configurable SalesforceListenerConfig salesforceListenerConfig = ?;
configurable SalesforceOAuth2Config salesforceOAuthConfig = ?;
configurable string salesforceBaseUrl = ?;

// Google sheet configuration parameters
configurable GSheetOAuth2Config GSheetOAuthConfig = ?;
configurable string spreadsheetId = ?;
configurable string worksheetName = ?;

listener sfdcListener:Listener sfdcEventListener = new ({
    username: salesforceListenerConfig.username,
    password: salesforceListenerConfig.password,
    channelName: CHANNEL_NAME
});

@display { label: "Salesforce New Lead to Google Sheets Row" }
service sfdcListener:RecordService on sfdcEventListener {
    remote function onCreate(sfdcListener:EventData payload) returns error? {
        json leadId = payload?.metadata?.recordId;
        sfdc:Client sfdcClient = check new ({
            baseUrl: salesforceBaseUrl,
            auth: {
                clientId: salesforceOAuthConfig.clientId,
                clientSecret: salesforceOAuthConfig.clientSecret,
                refreshToken: salesforceOAuthConfig.refreshToken,
                refreshUrl: salesforceOAuthConfig.refreshUrl
            }
        });
        json leadRecord = check sfdcClient->getLeadById(leadId.toString());
        string[] headerValues = [];
        (int|string|decimal)[] values = [];
        map<json> leadMap = <map<json>>leadRecord;
        foreach [string, json] [key, value] in leadMap.entries() {
            headerValues.push(key);
            values.push(value.toString());
        }

        sheets:Client spreadsheetClient = check new ({
            auth: {
                clientId: GSheetOAuthConfig.clientId,
                clientSecret: GSheetOAuthConfig.clientSecret,
                refreshToken: GSheetOAuthConfig.refreshToken,
                refreshUrl: GSheetOAuthConfig.refreshUrl
            }
        });
        sheets:Row headers = check spreadsheetClient->getRow(spreadsheetId, worksheetName, HEADINGS_ROW);
        if headers.values.length() == 0 {
            check spreadsheetClient->appendRowToSheet(spreadsheetId, worksheetName, headerValues);
        }
        check spreadsheetClient->appendRowToSheet(spreadsheetId, worksheetName, values);
        log:printInfo("New lead appended successfully");
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
