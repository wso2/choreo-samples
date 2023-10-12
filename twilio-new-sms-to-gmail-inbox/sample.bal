import ballerina/log;
import ballerinax/googleapis.gmail;
import ballerinax/trigger.twilio as twilioListener;

type OAuth2RefreshTokenGrantConfig record {
    string clientId;
    string clientSecret;
    string refreshToken;
    string refreshUrl = "https://oauth2.googleapis.com/token";
};

// Gmail configurations parameters
@display {label: "Sender Email", description: "Email of Sender"}
configurable string sender = ?;
@display {label: "Recipient Email", description: "Email of Recipient"}
configurable string recipient = ?;
@display {label: "Email Subject", description: "Subject of Email"}
configurable string subject = ?;
@display {label: "Gmail OAuth2 Configuration", description: "OAuth2 Configuration of Gmail"}
configurable OAuth2RefreshTokenGrantConfig gmailOauthConfig = ?;

listener twilioListener:Listener twilioSmsListener = new (8090);

@display {label: "Twilio New SMS to Gmail Message"}
service twilioListener:SmsStatusService on twilioSmsListener {
    remote function onReceived(twilioListener:SmsStatusChangeEventWrapper event) returns error? {
        string 'from = event?.From ?: "";
        string to = event?.To ?: "";
        string toCountry = event?.ToCountry ?: "";
        gmail:Client gmailClient = check new ({
            auth: {
                ...gmailOauthConfig
            }
        });
        gmail:Message sendMessageResponse = check gmailClient->sendMessage({
            recipient: recipient,
            sender: sender,
            subject: subject,
            messageBody: "SMS Received \nFrom : " + 'from + "\nTo : " + to + "\nToCountry : " + toCountry,
            contentType: gmail:TEXT_PLAIN
        });
        log:printInfo("Email sent succesfully! Message ID: ", messageId = sendMessageResponse?.id.toString());
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
