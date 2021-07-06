import ballerina/http;
import ballerina/log;
import ballerinax/googleapis.sheets as sheets;
import ballerinax/sfdc;

// Salesforce listener configuration parameters
@display {label: "Salesforce Username"}
configurable string & readonly sfdcUsername = ?;

@display {
    kind: "password",
    label: "Salesforce Password"
}
configurable string & readonly sfdcPassword = ?;

// Salesforce client configuration parameters
@display {label: "Salesforce Client ID"}
configurable string & readonly sfdcClientId = ?;

@display {label: "Salesforce Client Secret"}
configurable string & readonly sfdcClientSecret = ?;

@display {label: "Salesforce Refresh Token"}
configurable string & readonly sfdcRefreshToken = ?;

@display {label: "Salesforce Endpoint URL"}
configurable string & readonly sfdcBaseUrl = ?;

@display {label: "Salesforce Object"}
configurable string & readonly sfdcObject = ?;

// Google sheets configuration parameters
@display {
    kind: "OAuthConfig",
    provider: "Google Sheets",
    label: "Set Up Google Sheets Connection"
}
configurable http:OAuth2RefreshTokenGrantConfig & readonly sheetOAuthConfig = ?;

@display {
    kind: "ConnectionField",
    connectionRef: "sheetsOAuthConfig",
    provider: "Google Sheets",
    operationName: "getAllSpreadsheets",
    label: "Spreadsheet Name"
}
configurable string & readonly spreadsheetId = ?;

@display {
    kind: "ConnectionField",
    connectionRef: "sheetsOAuthConfig",
    argRef: "spreadsheetId",
    provider: "Google Sheets",
    operationName: "getSheetList",
    label: "Worksheet Name"
}
configurable string & readonly worksheetName = ?;

// Constants
const string CHANNEL_PREFIX = "/data/";
const string EVENT_POSTFIX = "ChangeEvent";
const string BASE_URL = "/services/data/v48.0/sobjects/";
const string SFDC_REFRESH_URL = "https://login.salesforce.com/services/oauth2/token";
const int HEADINGS_ROW = 1;

listener sfdc:Listener sfdcEventListener = new ({
    username: sfdcUsername,
    password: sfdcPassword
});

@sfdc:ServiceConfig {channelName: CHANNEL_PREFIX + sfdcObject + EVENT_POSTFIX}
service on sfdcEventListener {
    remote function onCreate(sfdc:EventData sobject) returns error? {
        string[] headerValues = [];
        (int|string|decimal)[] values = [];

        string sobjectId = sobject?.metadata?.recordId ?: "";
        string path = BASE_URL + sfdcObject + "/" + sobjectId;
        sfdc:Client sfdcClient = check new ({
            baseUrl: sfdcBaseUrl,
            clientConfig: {
                clientId: sfdcClientId,
                clientSecret: sfdcClientSecret,
                refreshToken: sfdcRefreshToken,
                refreshUrl: SFDC_REFRESH_URL
            }
        });
        json sobjectRecord = check sfdcClient->getRecord(path);
        map<json> sobjectMap = <map<json>>sobjectRecord;
        foreach var entry in sobjectMap.entries() {
            headerValues.push(entry[0].toString());
            values.push(entry[1].toString());
        }

        sheets:Client gSheetClient = check new ({oauthClientConfig: sheetOAuthConfig});
        sheets:Row headers = check gSheetClient->getRow(spreadsheetId, worksheetName, HEADINGS_ROW);
        if (headers.values.length() == 0) {
            check gSheetClient->appendRowToSheet(spreadsheetId, worksheetName, headerValues);
        }
        check gSheetClient->appendRowToSheet(spreadsheetId, worksheetName, values);
        log:printInfo(sfdcObject + " added to spreadsheet successfully");
    }
}

service on new http:Listener(8090) {
    isolated resource function get .() returns http:Ok => {};
}
