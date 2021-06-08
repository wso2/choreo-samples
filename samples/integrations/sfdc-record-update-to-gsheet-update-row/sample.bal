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
configurable string sfdcBaseUrl = ?;

@display {label: "Salesforce Object"}
configurable string sfdcObject = ?;

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
configurable string spreadsheetId = ?;

@display {
    kind: "ConnectionField",
    connectionRef: "sheetsOAuthConfig",
    argRef: "spreadsheetId",
    provider: "Google Sheets",
    operationName: "getSheetList",
    label: "Worksheet Name"
}
configurable string worksheetName = ?;

// Constants
const string CHANNEL_PREFIX = "/data/";
const string EVENT_POSTFIX = "ChangeEvent";
const string BASE_URL = "/services/data/v48.0/sobjects/";
const string SOBJECT_ID = "Id";
const string SFDC_REFRESH_URL = "https://login.salesforce.com/services/oauth2/token";
const int HEADINGS_ROW = 1;

listener sfdc:Listener sfdcEventListener = new ({
    username: sfdcUsername,
    password: sfdcPassword
});

@sfdc:ServiceConfig {channelName: CHANNEL_PREFIX + sfdcObject + EVENT_POSTFIX}
service on sfdcEventListener {
    remote function onUpdate(sfdc:EventData sobject) returns error? {
        string sObjectId = sobject?.metadata?.recordId ?: "";
        string path = BASE_URL + sfdcObject + "/" + sObjectId;
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

        string[] headerValues = [];
        (int|string|decimal)[] values = [];

        string updatedRecordId = "";
        string updatedColumn = "";
        int updatedRow = 0;
        int columnCounter = 0;
        int rowCounter = 1;

        map<json> sObjectMap = <map<json>>sobjectRecord;
        foreach var [key, value] in sObjectMap.entries() {
            headerValues.push(key.toString());
            values.push(value.toString());
            if (key.toString() == SOBJECT_ID) {
                updatedRecordId = value.toString();
                updatedColumn = getColumnLetter(columnCounter);
            }
            columnCounter = columnCounter + 1;
        }

        sheets:Client spreadsheetClient = check new ({oauthClientConfig: sheetOAuthConfig});
        sheets:Row headers = check spreadsheetClient->getRow(spreadsheetId, worksheetName, HEADINGS_ROW);
        if (headers.values.length() == 0) {
            check spreadsheetClient->appendRowToSheet(spreadsheetId, worksheetName, headerValues);
        }

        sheets:Column updatedColumnData = check spreadsheetClient->getColumn(spreadsheetId, worksheetName, 
        updatedColumn);
        foreach var item in updatedColumnData.values {
            if (item == updatedRecordId) {
                updatedRow = rowCounter;
            }
            rowCounter = rowCounter + 1;
        }

        check spreadsheetClient->createOrUpdateRow(spreadsheetId, worksheetName, updatedRow, values);

        log:printInfo("Record updated successfully! Updated Record ID : " + updatedRecordId);
    }
}

isolated function getColumnLetter(int position) returns string {
    string[] columnNames = 
    ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", 
    "X", "Y", "Z"];
    if (position >= columnNames.length()) {
        string a = getColumnLetter((position / columnNames.length()) - 1);
        string b = getColumnLetter(position % columnNames.length());
        return a.concat("", b);
    }
    return columnNames[position];
}

service on new http:Listener(8090) {
    isolated resource function get .() returns http:Ok => {};
}
