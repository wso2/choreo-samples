import ballerina/http;
import ballerina/log;
import ballerinax/googleapis.sheets;
import ballerinax/sfdc;

const string CHANNEL_NAME = "/data/CaseChangeEvent";
const string SFDC_REFRESH_URL = "https://login.salesforce.com/services/oauth2/token";

@display {label: "Salesforce Client ID"}
configurable string & readonly sfdcClientId = ?;

@display {label: "Salesforce Client Secret"}
configurable string & readonly sfdcClientSecret = ?;

@display {label: "Salesforce Refresh Token"}
configurable string & readonly sfdcRefreshToken = ?;

@display {label: "Salesforce Username"}
configurable string & readonly sfdcUsername = ?;

@display {
    kind: "password",
    label: "Salesforce Password"
}
configurable string & readonly sfdcPassword = ?;

@display {label: "Salesforce Endpoint URL"}
configurable string & readonly sfdcBaseURL = ?;

@display {
    kind: "OAuthConfig",
    provider: "Google Sheets",
    label: "Set Up Google Sheets connection"
}
configurable http:OAuth2RefreshTokenGrantConfig & readonly sheetOAuthConfig = ?;

@display {
    kind: "ConnectionField",
    connectionRef: "sheetOauthConfig",
    provider: "Google Sheets",
    operationName: "getAllSpreadsheets",
    label: "Spreadsheet Name"
}
configurable string & readonly spreadsheetId = ?;

@display {
    kind: "ConnectionField",
    connectionRef: "sheetOauthConfig",
    provider: "Google Sheets",
    operationName: "getSheetList",
    label: "Worksheet Name"
}
configurable string & readonly worksheetName = ?;

sfdc:ListenerConfiguration sfdcListenerConfig = {
    username: sfdcUsername,
    password: sfdcPassword
};

listener sfdc:Listener sfdcEventListener = new (sfdcListenerConfig);

@sfdc:ServiceConfig {channelName: CHANNEL_NAME}
service on sfdcEventListener {
    remote function onCreate(sfdc:EventData case) returns error? {
        json caseId = case?.metadata?.recordId;
        sfdc:Client sfdcClient = check new ({
            baseUrl: sfdcBaseURL,
            clientConfig: {
                clientId: sfdcClientId,
                clientSecret: sfdcClientSecret,
                refreshToken: sfdcRefreshToken,
                refreshUrl: SFDC_REFRESH_URL
            }
        });
        json caseRecord = check sfdcClient->getRecordById("Case", caseId.toString());
        string caseNumber = check caseRecord.CaseNumber;
        map<json> caseMap = <map<json>>caseRecord;

        sheets:Client spreadsheetClient = check new ({oauthClientConfig: sheetOAuthConfig});
        sheets:Spreadsheet spreadsheet = check spreadsheetClient->createSpreadsheet("Salesforce Case " + caseNumber);
        string spreadsheetId = spreadsheet.spreadsheetId;
        sheets:Sheet sheet = check spreadsheetClient->getSheetByName(spreadsheetId, "Sheet1");
        foreach var itemKey in caseMap.keys() {
            check spreadsheetClient->appendRowToSheet(spreadsheetId, sheet.properties.title, [itemKey, caseMap.get(
            itemKey).toString()]);
        }
        log:printInfo("Spreadsheet is created for new Salesforce Case Number " + caseNumber);
    }
}

service on new http:Listener(8090) {
    isolated resource function get .() returns http:Ok => {};
}
