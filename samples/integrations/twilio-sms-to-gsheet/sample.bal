import ballerina/http;
import ballerina/log;
import ballerina/regex;
import ballerina/url;
import ballerinax/twilio.'listener as twilioListener;
import ballerinax/googleapis.sheets as sheets;
import ballerina/lang.'int as ints;

@display { kind: "WebhookURL", label: "Set up callback URL for Twilio listener" }
configurable string & readonly callbackUrl = ?;
@display { label: "Twilio Auth Token" }
configurable string & readonly twilioAuthToken = ?;
@display { kind: "OAuthConfig", provider: "Google Sheets", label: "Set up Google Sheets connection" }
configurable http:OAuth2RefreshTokenGrantConfig & readonly sheetOauthConfig = ?;
@display { kind: "ConnectionField", connectionRef: "sheetOauthConfig", provider: "Google Sheets", 
            operationName: "getAllSpreadsheets", label: "Spreadsheet Name" }
configurable string & readonly sheetId = ?;
@display { kind: "ConnectionField", connectionRef: "sheetOauthConfig", argRef: "sheetId", provider: "Google Sheets", 
            operationName: "getSheetList", label: "Worksheet Name" }
configurable string & readonly workSheetName = ?;

const COLUMN_NAME = "A";
const EMPTY_STRING = " ";

listener twilioListener:Listener twListener = new (8090, twilioAuthToken, callbackUrl);

service / on twListener {
    remote function onSmsReceived(twilioListener:SmsStatusChangeEvent event) returns error? {
        sheets:Client spreadsheetClient = check new ({
            oauthClientConfig: sheetOauthConfig
        });
        string? messageBody = event?.Body;
        log:printInfo(messageBody.toString());
        if (messageBody is string) {
            var decodedMessageBody = check url:decode(messageBody, "UTF-8");
            string[] messageBodyParts = regex:split(decodedMessageBody, EMPTY_STRING);
            string languageToVote = messageBodyParts[1];
            var languageList = check spreadsheetClient->getColumn(sheetId, workSheetName, 
                COLUMN_NAME);
            foreach var row in 1 ... languageList.length() {
                var rowValue = languageList[row - 1];
                if ((rowValue is string) && rowValue.equalsIgnoreCaseAscii(languageToVote)) {
                    var rowData = check spreadsheetClient->getRow(sheetId, workSheetName, row);
                    int currentVoteCount = check ints:fromString(<string>rowData[1]);
                    string cellNumber = string `B${row}`;
                    (string|int)[] values = [languageToVote, currentVoteCount + 1];
                    var appendResult = check spreadsheetClient->setCell(sheetId, 
                        workSheetName, cellNumber, <@untainted>currentVoteCount + 1);
                } 
            }
        }            

    } 
}

