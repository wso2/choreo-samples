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
const string CASE = "Case";
const string SHEET_1 = "Sheet1";
const string SALESFORCE_CASE = "Salesforce Case ";
const string SPACE = " ";
const string RESPONSE_MESSAGE = "Spreadsheet is created for new Salesforce Case Number";

// Salesforce configuration parameters
configurable SalesforceListenerConfig salesforceListenerConfig = ?;
configurable SalesforceOAuth2Config salesforceClientConfig = ?;
configurable string salesforceBaseUrl = ?;

// Google sheet configuration parameters
configurable GSheetOAuth2Config GSheetOauthConfig = ?;

listener sfdcListener:Listener sfdcListener = new ({
    username: salesforceListenerConfig.username,
    password: salesforceListenerConfig.password,
    channelName: CHANNEL_NAME
});

@display { label: "Salesforce New Case to Google Sheets New Spreadsheet" }
service sfdcListener:RecordService on sfdcListener {
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
        string caseNumber = check caseRecord.CaseNumber;
        map<json> caseMap = <map<json>>caseRecord;
        sheets:Client spreadsheetClient = check new ({
            auth: {
                clientId: GSheetOauthConfig.clientId,
                clientSecret: GSheetOauthConfig.clientSecret,
                refreshToken: GSheetOauthConfig.refreshToken,
                refreshUrl: GSheetOauthConfig.refreshUrl
            }
        });
        sheets:Spreadsheet spreadsheet = check spreadsheetClient->createSpreadsheet(SALESFORCE_CASE+ SPACE + caseNumber);
        string spreadsheetId = spreadsheet.spreadsheetId;
        sheets:Sheet sheet = check spreadsheetClient->getSheetByName(spreadsheetId, SHEET_1);
        foreach string itemKey in caseMap.keys() {
            check spreadsheetClient->appendRowToSheet(spreadsheetId, sheet.properties.title, [
                itemKey,
                caseMap.get(
                itemKey).toString()
            ]);
        }
        log:printInfo(RESPONSE_MESSAGE + SPACE + caseNumber);
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
