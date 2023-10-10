import ballerina/lang.'int as ints;
import ballerina/log;
import ballerina/regex;
import ballerina/url;
import ballerinax/googleapis.sheets;
import ballerinax/trigger.twilio as twilioListener;

type OAuth2RefreshTokenGrantConfig record {
    string clientId;
    string clientSecret;
    string refreshToken;
    string refreshUrl = "https://www.googleapis.com/oauth2/v3/token";
};

// Google sheets configuration parameters
@display {label: "Google Sheets OAuth2 Configuration", description: "OAuth2 Configuration of Google Sheets"}
configurable OAuth2RefreshTokenGrantConfig sheetOAuthConfig = ?;
@display {label: "Google Spreadsheet ID", description: "ID of Google Spreadsheet"}
configurable string spreadsheetId = ?;
@display {label: "Google Worksheet Name", description: "Name of Google Worksheet"}
configurable string worksheetName = ?;

// Constants
const COLUMN_NAME = "A";
const SPACE_STRING = " ";
const LANGUAGE_SEGMENT = 1;
const VOTE_COUNT_COLUMN = 1;

listener twilioListener:Listener twilioSmsListener = new (8090);

@display {label: "SMS Voting Survey to Google Sheets Summary"}
service twilioListener:SmsStatusService on twilioSmsListener {
    remote function onReceived(twilioListener:SmsStatusChangeEventWrapper event) returns error? {
        string messageBody = event?.Body ?: "";
        string decodedMessageBody = check url:decode(messageBody, "UTF-8");
        string[] messageBodyParts = regex:split(decodedMessageBody, SPACE_STRING);
        string languageToVote = messageBodyParts[LANGUAGE_SEGMENT];

        sheets:Client spreadsheetClient = check new ({
            auth: {
                ...sheetOAuthConfig
            }
        });
        sheets:Column languageList = check spreadsheetClient->getColumn(spreadsheetId, worksheetName, COLUMN_NAME);
        foreach int row in 1 ... languageList.values.length() {
            (int|string|decimal) rowValue = languageList.values[row - 1];
            if ((rowValue is string) && rowValue.equalsIgnoreCaseAscii(languageToVote)) {
                sheets:Row rowData = check spreadsheetClient->getRow(spreadsheetId, worksheetName, row);
                int currentVoteCount = check ints:fromString(<string>rowData.values[VOTE_COUNT_COLUMN]);
                string voteCountCell = string `B${row}`;
                check spreadsheetClient->setCell(spreadsheetId, worksheetName, voteCountCell, currentVoteCount + 1);
                log:printInfo("Voted successfully!");
            }
        }
    }

    remote function onSent(twilioListener:SmsStatusChangeEventWrapper event) returns error? {
        return;
    }

    remote function onDelivered(twilioListener:SmsStatusChangeEventWrapper event) returns error? {
        return;
    }

    remote function onAccepted(twilioListener:SmsStatusChangeEventWrapper event) returns error? {
        return;
    }

    remote function onFailed(twilioListener:SmsStatusChangeEventWrapper event) returns error? {
        return;
    }

    remote function onQueued(twilioListener:SmsStatusChangeEventWrapper event) returns error? {
        return;
    }

    remote function onReceiving(twilioListener:SmsStatusChangeEventWrapper event) returns error? {
        return;
    }

    remote function onSending(twilioListener:SmsStatusChangeEventWrapper event) returns error? {
        return;
    }

    remote function onUndelivered(twilioListener:SmsStatusChangeEventWrapper event) returns error? {
        return;
    }
}
