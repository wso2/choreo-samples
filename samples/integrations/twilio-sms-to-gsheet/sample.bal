import ballerina/http;
import ballerina/lang.'int as ints;
import ballerina/log;
import ballerina/regex;
import ballerina/url;
import ballerinax/googleapis.sheets;
import ballerinax/twilio.'listener as twilioListener;

// Twilio configuration parameters
@display {label: "Twilio Auth Token"}
configurable string & readonly twilioAuthToken = ?;

@display {label: "Twilio Callback URL"}
configurable string & readonly callbackUrl = ?;

// Google sheets configuration parameters
@display {
    kind: "OAuthConfig",
    provider: "Google Sheets",
    label: "Set Up Google Sheets Connection"
}
configurable http:OAuth2RefreshTokenGrantConfig & readonly sheetOAuthConfig = ?;

@display {
    kind: "ConnectionField",
    connectionRef: "sheetOAuthConfig",
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

// Constants
const COLUMN_NAME = "A";
const SPACE_STRING = " ";
const LANGUAGE_SEGMENT = 1;
const VOTE_COUNT_COLUMN = 1;

listener twilioListener:Listener twListener = new (8090, twilioAuthToken, callbackUrl);

service / on twListener {
    remote function onSmsReceived(twilioListener:SmsStatusChangeEvent event) returns error? {
        string messageBody = event?.Body ?: "";
        string decodedMessageBody = check url:decode(messageBody, "UTF-8");
        string[] messageBodyParts = regex:split(decodedMessageBody, SPACE_STRING);
        string languageToVote = messageBodyParts[LANGUAGE_SEGMENT];

        sheets:Client spreadsheetClient = check new ({oauthClientConfig: sheetOAuthConfig});
        sheets:Column languageList = check spreadsheetClient->getColumn(spreadsheetId, worksheetName, COLUMN_NAME);
        foreach int row in 1 ... languageList.values.length() {
            var rowValue = languageList.values[row - 1];
            if ((rowValue is string) && rowValue.equalsIgnoreCaseAscii(languageToVote)) {
                sheets:Row rowData = check spreadsheetClient->getRow(spreadsheetId, worksheetName, row);
                int currentVoteCount = check ints:fromString(<string>rowData.values[VOTE_COUNT_COLUMN]);
                string voteCountCell = string `B${row}`;
                check spreadsheetClient->setCell(spreadsheetId, worksheetName, voteCountCell, <@untainted>
                currentVoteCount + 1);
                log:printInfo("Voted successfully!");
            }
        }
    }
}
