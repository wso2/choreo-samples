import ballerina/http;
import ballerina/log;
import ballerinax/googleapis.gmail;
import ballerinax/twilio.'listener as twilioListener;

// Twilio configuration parameters
@display {label: "Twilio Auth Token"}
configurable string & readonly twilioAuthToken = ?;

@display {label: "Twilio Callback URL"}
configurable string & readonly callbackUrl = ?;

@display {
    kind: "OAuthConfig",
    provider: "Gmail",
    label: "Set Up Google Mail Connection"
}
configurable http:OAuth2RefreshTokenGrantConfig & readonly gmailOauthConfig = ?;

// Gmail configurations parameters
@display {label: "Recipient's Email Address"}
configurable string & readonly recipient = ?;

@display {label: "Sender's Email Address"}
configurable string & readonly sender = ?;

@display {label: "Email Subject"}
configurable string & readonly subject = ?;

listener twilioListener:Listener subscriber = new (8090, twilioAuthToken, callbackUrl);

service / on subscriber {
    remote function onSmsReceived(twilioListener:SmsStatusChangeEvent event) returns error? {
        string 'from = event?.From ?: "";
        string to = event?.To ?: "";
        string toCountry = event?.ToCountry ?: "";
        gmail:Client gmailClient = new ({oauthClientConfig: gmailOauthConfig});
        gmail:Message sendMessageResponse = check gmailClient->sendMessage({
            recipient: recipient,
            sender: sender,
            subject: subject,
            messageBody: "SMS Received \nFrom : " + 'from + "\nTo : " + to + "\nToCountry : " + toCountry,
            contentType: gmail:TEXT_PLAIN
        });
        log:printInfo("Email sent succesfully! Message ID: ", messageId = sendMessageResponse?.id.toString());
    }
}
