import ballerina/http;
import ballerina/log;
import ballerinax/googleapis.sheets;
import ballerinax/sfdc;

// Constants
const string CHANNEL_NAME = "/data/LeadChangeEvent";
const int HEADINGS_ROW = 1;

// Salesforce configuration parameters
@display {label: "Salesforce Client ID"}
configurable string & readonly sfdcClientId = ?;

@display {label: "Salesforce Client Secret"}
configurable string & readonly sfdcClientSecret = ?;

@display {label: "Salesforce Refresh Token"}
configurable string & readonly sfdcRefreshToken = ?;

@display {label: "Salesforce Refresh URL"}
configurable string & readonly sfdcRefreshUrl = ?;

@display {label: "Salesforce Endpoint URL"}
configurable string & readonly sfdcBaseURL = ?;

@display {label: "Salesforce Username"}
configurable string & readonly sfdcUsername = ?;

@display {
    kind: "password",
    label: "Salesforce Password"
}
configurable string & readonly sfdcPassword = ?;

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

@sfdc:ServiceConfig {channelName: CHANNEL_NAME}
service on sfdcEventListener {
    remote function onCreate(sfdc:EventData lead) returns error? {
        json leadId = lead?.metadata?.recordId;
        sfdc:Client sfdcClient = check new ({
            baseUrl: sfdcBaseURL,
            clientConfig: {
                clientId: sfdcClientId,
                clientSecret: sfdcClientSecret,
                refreshToken: sfdcRefreshToken,
                refreshUrl: sfdcRefreshUrl
            }
        });
        json leadRecord = check sfdcClient->getLeadById(leadId.toString());
        string[] headerValues = [];
        (int|string|decimal)[] values = [];
        map<json> leadMap = <map<json>>leadRecord;
        foreach var entry in leadMap.entries() {
            headerValues.push(entry[0].toString());
            values.push(entry[1].toString());
        }

        sheets:Client spreadsheetClient = check new ({oauthClientConfig: sheetOAuthConfig});
        sheets:Row headers = check spreadsheetClient->getRow(spreadsheetId, worksheetName, HEADINGS_ROW);
        if (headers.values.length() == 0) {
            check spreadsheetClient->appendRowToSheet(spreadsheetId, worksheetName, headerValues);
        }
        check spreadsheetClient->appendRowToSheet(spreadsheetId, worksheetName, values);
        log:printInfo("New lead appended successfully");
    }
}

service on new http:Listener(8090) {
    isolated resource function get .() returns http:Ok => {};
}
