import ballerina/http;
import ballerina/log;
import ballerina/regex;
import ballerinax/sfdc;
import ballerinax/googleapis.sheets as sheets;
import ballerinax/googleapis.sheets.'listener as sheetsListener;

// Google sheets configuration parameters
@display {
    kind: "OAuthConfig",
    provider: "Google Sheets",
    label: "Set Up Google Sheets Connection"
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
    connectionRef: "sheetOAuthConfig",
    argRef: "spreadsheetId",
    provider: "Google Sheets",
    operationName: "getSheetList",
    label: "Worksheet Name"
}
configurable string & readonly worksheetName = ?;

// Salesforce configuration parameters
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

// Constants
const string INTEGER_REGEX = "\\d+";
const string HEADINGS_ROW = "1";
const string SFDC_REFRESH_URL = "https://login.salesforce.com/services/oauth2/token";

sheetsListener:SheetListenerConfiguration sheetListenerConfig = {
    port: 8090,
    spreadsheetId: spreadsheetId
};

listener sheetsListener:Listener gSheetListener = new (sheetListenerConfig);

service / on gSheetListener {
    remote function onAppendRow(sheetsListener:GSheetEvent event) returns error? {
        if (event?.eventInfo?.worksheetName == worksheetName) {
            // Get the appended range
            string? rangeUpdated = event?.eventInfo["rangeUpdated"];
            (int|string|decimal)[][]? appendedColumnHeadings = ();
            if (rangeUpdated is string) {
                sheets:Client spreadsheetClient = check new ({oauthClientConfig: sheetOAuthConfig});
                // Get the appended column headings A1 notation
                string a1NotationForHeadings = regex:replaceAll(rangeUpdated, INTEGER_REGEX, HEADINGS_ROW);
                // Get the appended column headings 
                sheets:Range appendedColumnHeadingsResult = check spreadsheetClient->getRange(spreadsheetId, 
                worksheetName, a1NotationForHeadings);
                appendedColumnHeadings = appendedColumnHeadingsResult.values;
            }

            // Get the appended values 
            (int|string|float)[][]? appendedValues = event?.eventInfo["newValues"];

            if (!(appendedValues is ()) && !(appendedColumnHeadings is ())) {
                map<json> newRecord = {};
                foreach int index in 0 ..< appendedColumnHeadings[0].length() {
                    newRecord[appendedColumnHeadings[0][index].toString()] = appendedValues[0][index];
                }

                sfdc:Client sfdcClient = check new ({
                    baseUrl: sfdcBaseUrl,
                    clientConfig: {
                        clientId: sfdcClientId,
                        clientSecret: sfdcClientSecret,
                        refreshToken: sfdcRefreshToken,
                        refreshUrl: SFDC_REFRESH_URL
                    }
                });
                // Specify the record type (sfdcObject) to create. For example an 'Account' record type.
                string createRecordResponse = check sfdcClient->createRecord(sfdcObject, newRecord);
                log:printInfo("Record created successfully!. Record ID : " + createRecordResponse);
            }
        }
    }
}
