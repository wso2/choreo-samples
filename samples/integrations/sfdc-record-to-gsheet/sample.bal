import ballerina/log;
import ballerina/io;
import ballerinax/sfdc;
import ballerina/http;
import ballerinax/googleapis.sheets as sheets;

// Constants
const string TOPIC_PREFIX = "/topic/";
const string CREATED = "created";
const string BASE_URL = "/services/data/v48.0/sobjects/";

// Salesforce configuration parameters
@display { kind: "OAuthConfig", provider: "Salesforce", label: "Setup Salesforce connection" }
configurable http:OAuth2RefreshTokenGrantConfig & readonly sfdcOAuthConfig = ?;
@display { label: "EndPoint URL" }
configurable string epURL = ?;
@display { label: "SalesForce User name" }
configurable string sfdcUsername = ?;
@display { kind: "password", label: "SalesForce Password" }
configurable string sfdcPassword = ?;
@display { label: "SalesForce Push Topic" }
configurable string sfdcPushTopic = ?;
@display { label: "SFDC Object" }
configurable string sfdcObject = ?;

sfdc:ListenerConfiguration sfdcListenerConfig = {
    username: sfdcUsername,
    password: sfdcPassword
};

// Gsheet configuration parameters
@display { kind: "OAuthConfig", provider: "Google Sheets", label: "Setup GSheets connection" }
configurable http:OAuth2RefreshTokenGrantConfig & readonly sheetsOAuthConfig = ?;
@display { kind: "ConnectionField", connectionRef: "sheetsOAuthConfig", provider: "Google Sheets", operationName: "getAllSpreadsheets", label: "Spread sheet name"}
configurable string spreadsheetId = ?;
@display { kind: "ConnectionField", connectionRef: "sheetsOAuthConfig", argRef: "spreadsheetId", provider: "Google Sheets", operationName: "getSheetList", label: "Work Sheet Name"}
configurable string worksheetName = ?;

// Initialize the Salesforce Listener
listener sfdc:Listener sfdcEventListener = new (sfdcListenerConfig);

@sfdc:ServiceConfig {topic: TOPIC_PREFIX + sfdcPushTopic}
service on sfdcEventListener {
    remote function onEvent(json sobject) returns error? {
        io:StringReader reader = new (sobject.toJsonString());
        json sobjectInfo = check reader.readJson();
        json eventType = check sobjectInfo.event.'type;
        if (CREATED.equalsIgnoreCaseAscii(eventType.toString())) {
            (int|string|float)[] values = [];
            (string)[] headerValues = [];
            json sobjectId = check sobjectInfo.sobject.Id;
            string path = BASE_URL + sfdcObject + "/" + sobjectId.toString();
            sfdc:Client sfdcClient = check new ({
                baseUrl: epURL,
                clientConfig: sfdcOAuthConfig
            });
            json sobjectRecord = check sfdcClient->getRecord(path);
            map<json> sobjectMap = <map<json>>sobjectRecord;
            foreach var entry in sobjectMap.entries() {
                headerValues.push(entry[0].toString());
                values.push(entry[1].toString());
            }
            // Initialize the Google Sheets Client
            sheets:Client gSheetClient = check new ({
                oauthClientConfig: sheetsOAuthConfig
            });
            (int|string|float)[] headers = check gSheetClient->getRow(spreadsheetId, worksheetName, 1);
            if (headers == []) {
                var headerResp = check gSheetClient->appendRowToSheet(spreadsheetId, worksheetName, headerValues);
            } 
            var sheetResp = gSheetClient->appendRowToSheet(spreadsheetId, worksheetName, values);
            if (sheetResp is error) {
                log:printError(sheetResp.toString());
            } else {
                log:printInfo(sfdcObject + " added to Spreadsheet Successfully");
            }
        }
    }
}
