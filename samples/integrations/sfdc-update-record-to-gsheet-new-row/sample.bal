import ballerina/http;
import ballerina/log;
import ballerinax/googleapis.sheets;
import ballerinax/sfdc;


// Constants
const string CHANNEL_PREFIX = "/data/";
const string EVENT_POSTFIX = "ChangeEvent";
const string BASE_URL = "/services/data/v48.0/sobjects/";
const int HEADINGS_ROW = 1;
const string SFDC_REFRESH_URL = "https://login.salesforce.com/services/oauth2/token";

// Salesforce configuration parameters
@display {label: "Salesforce Client ID"}
configurable string & readonly sfdcClientId = ?;

@display {label: "Salesforce Client Secret"}
configurable string & readonly sfdcClientSecret = ?;

@display {label: "Salesforce Refresh Token"}
configurable string & readonly sfdcRefreshToken = ?;

@display {label: "Salesforce Endpoint URL"}
configurable string & readonly sfdcBaseURL = ?;

@display {label: "Salesforce Username"}
configurable string & readonly sfdcUsername = ?;

@display {
    kind: "password",
    label: "Salesforce Password"
}
configurable string & readonly sfdcPassword = ?;

@display {label: "Salesforce Object"}
configurable string & readonly sfdcObject = ?;

// Google sheet configuration parameters
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

sfdc:ListenerConfiguration sfdcListenerConfig = {
    username: sfdcUsername,
    password: sfdcPassword
};

listener sfdc:Listener sfdcEventListener = new (sfdcListenerConfig);

@sfdc:ServiceConfig {channelName: CHANNEL_PREFIX + sfdcObject + EVENT_POSTFIX}
service on sfdcEventListener {
    remote function onUpdate(sfdc:EventData sobject) returns error? {
        json sObjectId = sobject?.metadata?.recordId;
        string path = BASE_URL + sfdcObject + "/" + sObjectId.toString();
        sfdc:Client sfdcClient = check new ({
            baseUrl: sfdcBaseURL,
            clientConfig: {
                clientId: sfdcClientId,
                clientSecret: sfdcClientSecret,
                refreshToken: sfdcRefreshToken,
                refreshUrl: SFDC_REFRESH_URL
            }
        });
        map<json> sobjectMap = <map<json>>check sfdcClient->getRecord(path);
        string[] headerValues = [];
        (int|string|decimal)[] values = [];
        foreach var entry in sobjectMap.entries() {
            headerValues.push(entry[0].toString());
            values.push(entry[1].toString());
        }

        sheets:Client spreadsheetClient = check new ({oauthClientConfig: sheetOAuthConfig});
        sheets:Row headers = check spreadsheetClient->getRow(spreadsheetId, worksheetName, HEADINGS_ROW);
        if (headers.values.length() == 0) {
            check spreadsheetClient->appendRowToSheet(spreadsheetId, worksheetName, headerValues);
        }
        check spreadsheetClient->appendRowToSheet(spreadsheetId, worksheetName, values);
        log:printInfo("Record update appended successfully!");

    }
}

service on new http:Listener(8090) {
    isolated resource function get .() returns http:Ok => {};
}
