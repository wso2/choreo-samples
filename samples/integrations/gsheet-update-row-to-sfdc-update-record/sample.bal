import ballerina/http;
import ballerina/log;
import ballerina/regex;
import ballerinax/googleapis.sheets as sheets;
import ballerinax/googleapis.sheets.'listener as sheetsListener;
import ballerinax/sfdc;

// Constants
const string INTEGER_REGEX = "\\d+";
const string RECORD_ID = "Id";
const string SFDC_REFRESH_URL = "https://login.salesforce.com/services/oauth2/token";

// Google sheets client configuration parameters
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

// Salesforce client configuration parameters
@display {label: "Salesforce Client ID"}
configurable string & readonly sfdcClientId = ?;

@display {label: "Salesforce Client Secret"}
configurable string & readonly sfdcClientSecret = ?;

@display {label: "Salesforce Refresh Token"}
configurable string & readonly sfdcRefreshToken = ?;

@display {label: "Salesforce Endpoint URL"}
configurable string & readonly sfdcBaseURL = ?;

@display {label: "Salesforce Object"}
configurable string & readonly sfdcObject = ?;

// Initialize the Google Sheets listener
sheetsListener:SheetListenerConfiguration sheetListenerConfig = {
    port: 8090,
    spreadsheetId: spreadsheetId
};

// Create the Google Sheets listener
listener sheetsListener:Listener gSheetListener = new (sheetListenerConfig);

service / on gSheetListener {
    remote function onUpdateRow(sheetsListener:GSheetEvent event) returns error? {
        if (event?.eventInfo?.worksheetName == worksheetName) {
            int? startingRowPosition = event?.eventInfo["startingRowPosition"];
            string? rangeUpdated = event?.eventInfo["rangeUpdated"];
            sheets:Client spreadsheetClient = check new ({oauthClientConfig: sheetOAuthConfig});
            if (rangeUpdated is string && startingRowPosition is int) {
                string a1Notation = getA1NotationForUpdatedColumnHeadings(rangeUpdated);
                sheets:Range updatedColumnHeadingsResult = check spreadsheetClient->getRange(spreadsheetId, 
                worksheetName, a1Notation);
                (int|string|decimal)[][] updatedColumnHeadings = updatedColumnHeadingsResult.values;
                (int|string|float)[][]? updatedValues = event?.eventInfo["newValues"];
                sheets:Range columnHeadingsResult = check spreadsheetClient->getRange(spreadsheetId, worksheetName, 
                "1:1");
                (int|string|decimal)[][] columnHeadings = columnHeadingsResult.values;
                string recordIdColumn = getIdColumn(columnHeadings[0]);
                sheets:Cell recordId = check spreadsheetClient->getCell(spreadsheetId, worksheetName, recordIdColumn + 
                startingRowPosition.toString());

                sfdc:Client sfdcClient = check new ({
                    baseUrl: sfdcBaseURL,
                    clientConfig: {
                        clientId: sfdcClientId,
                        clientSecret: sfdcClientSecret,
                        refreshToken: sfdcRefreshToken,
                        refreshUrl: SFDC_REFRESH_URL
                    }
                });
                if (updatedValues is (int|string|float)[][]) {
                    map<json> updatedRecord = createJsonRecord(updatedColumnHeadings[0], updatedValues[0]);
                    sfdc:Error? res = check sfdcClient->updateRecord(sfdcObject, recordId.value.toString(), 
                    updatedRecord);
                    log:printInfo("Record Updated Successfully!");
                }
            }
        } else {
            log:printError("Event received was not from the configured worksheet");
        }
    }
}

isolated function getA1NotationForUpdatedColumnHeadings(string rangeUpdated) returns string {
    return regex:replaceAll(rangeUpdated, INTEGER_REGEX, "1");
}

isolated function getIdColumn((int|string|decimal)[] columnHeadings) returns string {
    int idColumnIndex = -1;
    foreach int index in 0 ..< columnHeadings.length() {
        if (columnHeadings[index].toString() == RECORD_ID) {
            idColumnIndex = index;
        }
    }
    return getColumnLetter(idColumnIndex);
}

isolated function getColumnLetter(int position) returns string {
    string[] columnNames = 
    ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"];
    if (position >= columnNames.length()) {
        string a = getColumnLetter((position / columnNames.length()) - 1);
        string b = getColumnLetter(position % columnNames.length());
        return a.concat("", b);
    }
    return columnNames[position];
}

isolated function createJsonRecord((int|string|decimal)[] columnNames, (string|int|float)[] values) returns map<json> {
    map<json> jsonMap = {};
    foreach int index in 0 ..< columnNames.length() {
        jsonMap[columnNames[index].toString()] = values[index];
    }
    return jsonMap;
}
