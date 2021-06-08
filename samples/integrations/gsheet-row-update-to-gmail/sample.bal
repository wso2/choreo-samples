import ballerina/log;
import ballerina/http;
import ballerinax/googleapis.sheets.'listener as sheetsListener;
import ballerinax/googleapis.gmail;

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
    connectionRef: "sheetOauthConfig",
    argRef: "spreadsheetId",
    provider: "Google Sheets",
    operationName: "getSheetList",
    label: "Worksheet Name"
}
configurable string & readonly worksheetName = ?;

// Google gmail configuration parameters
@display {
    kind: "OAuthConfig",
    provider: "Gmail",
    label: "Set Up Google Gmail Connection"
}
configurable http:OAuth2RefreshTokenGrantConfig & readonly gmailOauthConfig = ?;

@display {label: "Recipient's Email"}
configurable string & readonly recipientAddress = ?;

@display {label: "Sender's Email"}
configurable string & readonly senderAddress = ?;

type MapAnydata map<anydata>;

listener sheetsListener:Listener gSheetListener = new ({
    port: 8090,
    spreadsheetId: spreadsheetId
});

service / on gSheetListener {
    remote function onUpdateRow(sheetsListener:GSheetEvent event) returns error? {
        if (event?.eventInfo?.worksheetName == worksheetName) {
            string eventDetails = "\nUpdated Google Sheets Row Information\n\n";
            map<anydata> eventInfoMap = check event?.eventInfo.cloneWithType(MapAnydata);
            string[] keys = eventInfoMap.keys();
            int position = 0;
            foreach var item in eventInfoMap {
                if (item.toString() != "") {
                    eventDetails += keys[position] + " : " + item.toString() + "\n";
                }
                position += 1;
            }

            gmail:Client gmailClient = new ({oauthClientConfig: gmailOauthConfig});
            gmail:Message sendMessageResponse = check gmailClient->sendMessage({
                recipient: recipientAddress,
                sender: senderAddress,
                subject: "Google Sheets Row Updated!",
                messageBody: eventDetails,
                contentType: "text/plain"
            });
            log:printInfo("Mail sent successfully! Message ID: ", messageId = sendMessageResponse?.id.toString());
            log:printInfo("Mail sent successfully! Thread ID: ", threadId = sendMessageResponse?.threadId.toString());
        }
    }
}
