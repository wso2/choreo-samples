import ballerina/http;
import ballerina/log;
import ballerina/regex;
import ballerinax/googleapis.sheets;
import ballerinax/salesforce as sfdc;
import ballerinax/trigger.google.sheets as sheetsListener;

// Types
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
type CellValueType int|string|decimal;
type EventCellValueType int|string|float;

// Constants
const string INTEGER_REGEX = "\\d+";
const string RECORD_ID = "Id";

// Google sheets configuration parameters
configurable string spreadsheetId = ?;
configurable string worksheetName = ?;
configurable GSheetOAuth2Config GSheetOAuthConfig = ?;

// Salesforce configuration parameters
configurable SalesforceOAuth2Config salesforceOAuthConfig = ?;
configurable string salesforceBaseUrl = ?;
configurable string salesforceObject = ?;

listener http:Listener httpListener = new(8090);
listener sheetsListener:Listener gSheetListener = new ({
    spreadsheetId: spreadsheetId
}, httpListener);

@display { label: "Google Sheets Row Update to Salesforce Record Update" }
service sheetsListener:SheetRowService on gSheetListener {
    remote function onUpdateRow(sheetsListener:GSheetEvent payload) returns error? {
        if payload?.worksheetName == worksheetName {
            int? startingRowPosition = payload?.startingRowPosition;
            string? updatedRange = payload?.rangeUpdated;
            sheets:Client spreadsheetClient = check new ({
                auth: {
                    clientId: GSheetOAuthConfig.clientId,
                    clientSecret: GSheetOAuthConfig.clientSecret,
                    refreshToken: GSheetOAuthConfig.refreshToken,
                    refreshUrl: GSheetOAuthConfig.refreshUrl
                }
            });
            if updatedRange is string && startingRowPosition is int {
                string columnA1Notation = getA1NotationForUpdatedColumnHeadings(updatedRange);
                sheets:Range updatedColumnHeadingsResult = check spreadsheetClient->getRange(spreadsheetId,
                    worksheetName, columnA1Notation);
                (CellValueType)[][] updatedColumnHeadings = updatedColumnHeadingsResult.values;
                (EventCellValueType)[][]? updatedValues = payload?.newValues;
                sheets:Range columnHeadingsResult = check spreadsheetClient->getRange(spreadsheetId, worksheetName,
                    "1:1");
                (CellValueType)[][] columnHeadings = columnHeadingsResult.values;
                string recordIdColumn = getIdColumn(columnHeadings[0]);
                sheets:Cell recordId = check spreadsheetClient->getCell(spreadsheetId, worksheetName, 
                    string `${recordIdColumn}${startingRowPosition}`);

                sfdc:Client sfdcClient = check new ({
                    baseUrl: salesforceBaseUrl,
                    auth: {
                        clientId: salesforceOAuthConfig.clientId,
                        clientSecret: salesforceOAuthConfig.clientSecret,
                        refreshToken: salesforceOAuthConfig.refreshToken,
                        refreshUrl: salesforceOAuthConfig.refreshUrl
                    }
                });
                if updatedValues is () || updatedValues.length() == 0 || updatedColumnHeadings.length() == 0 {
                    return ();
                }
                (EventCellValueType)[][] updatedValuesArray = <(EventCellValueType)[][]>updatedValues;
                (CellValueType)[] updatedKeys = updatedColumnHeadings[0];
                (EventCellValueType)[] updatedAttributes = updatedValuesArray[0];
                map<json> updatedRecord = createJsonRecord(updatedKeys, updatedAttributes);
                _ = check sfdcClient->updateRecord(salesforceObject, recordId.value.toString(), updatedRecord);
                log:printInfo("Record Updated Successfully!");
            }
        } else {
            log:printError("Event received was not from the configured worksheet");
        }
    }

    remote function onAppendRow(sheetsListener:GSheetEvent payload) returns error? {
      return;
    }
}

isolated function getA1NotationForUpdatedColumnHeadings(string updatedRange) returns string {
    return regex:replaceAll(updatedRange, INTEGER_REGEX, "1");
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

service /ignore on httpListener {}
