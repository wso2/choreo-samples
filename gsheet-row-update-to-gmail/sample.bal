import ballerina/http;
import ballerina/log;
import ballerinax/googleapis.gmail;
import ballerinax/trigger.google.sheets;

// Types
type OAuth2RefreshTokenGrantConfig record {
    string clientId;
    string clientSecret;
    string refreshToken;
    string refreshUrl = "https://oauth2.googleapis.com/token";
};

type MapAnydata map<anydata>;

// Google sheets configuration parameters
configurable string spreadsheetId = ?;
configurable string worksheetName = ?;

// Google gmail configuration parameters
configurable OAuth2RefreshTokenGrantConfig gmailOAuthConfig = ?;
configurable string recipientAddress = ?;
configurable string senderAddress = ?;

listener http:Listener httpListener = new(8090);
listener sheets:Listener gSheetListener = new({
    spreadsheetId: spreadsheetId
}, httpListener);

@display { label: "Google Sheets Row Update to Gmail Message" }
service sheets:SheetRowService on gSheetListener {
    remote function onUpdateRow(sheets:GSheetEvent payload) returns error? {
        if (payload?.worksheetName == worksheetName) {
            string eventDetails = "\nUpdated Google Sheets Row Information\n\n";
            map<anydata> eventInfoMap = check payload.cloneWithType(MapAnydata);
            string[] keys = eventInfoMap.keys();
            int position = 0;
            foreach var item in eventInfoMap {
                if (item.toString() != "") {
                    eventDetails += keys[position] + " : " + item.toString() + "\n";
                }
                position += 1;
            }

            gmail:Client gmailClient = check new ({
                auth: {
                    clientId: gmailOAuthConfig.clientId,
                    clientSecret: gmailOAuthConfig.clientSecret,
                    refreshToken: gmailOAuthConfig.refreshToken,
                    refreshUrl: gmailOAuthConfig.refreshUrl
                }
            });
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

    remote function onAppendRow(sheets:GSheetEvent payload) returns error? {
      return;
    }
}

service /ignore on httpListener {}
