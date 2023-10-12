import ballerina/http;
import ballerina/log;
import ballerinax/trigger.slack as slackListener;
import ballerinax/twilio;


// Types
type TwilioClientConfig record {
    string accountSId;
    string authToken;
};

// Slack configuration parameters
configurable string verificationToken = ?;
configurable string channelId = ?;

// Twilio configuration parameters
configurable TwilioClientConfig twilioClientConfig = ?;
configurable string fromNumber = ?;
configurable string toNumber = ?;

listener http:Listener httpListener = new(8090);
listener slackListener:Listener slackEventListener = new ({
    verificationToken: verificationToken
}, httpListener);

service slackListener:MessageService on slackEventListener {
    isolated remote function onMessage(slackListener:Message payload) returns error? {
        string eventChannelId = payload.event.channel;
        string text = payload.event["text"].toString();
        if channelId == eventChannelId {
            string message = string `New message in the channel : ${channelId}  ${"\n"}Message : ${text}`;
            twilio:Client twilioClient = check new ({
                twilioAuth: {
                    accountSId: twilioClientConfig.accountSId,
                    authToken: twilioClientConfig.authToken
                }
            });
            twilio:SmsResponse response = check twilioClient->sendSms(fromNumber, toNumber, message);
            log:printInfo("SMS(SID: "+ response.sid +") for new lead creation sent successfully");
        }
    }

    remote function onMessageAppHome(slackListener:GenericEventWrapper payload) returns error? {
        return;
    }

    remote function onMessageChannels(slackListener:GenericEventWrapper payload) returns error? {
        return;
    }

    remote function onMessageGroups(slackListener:GenericEventWrapper payload) returns error? {
        return;
    }

    remote function onMessageIm(slackListener:GenericEventWrapper payload) returns error? {
        return;
    }

    remote function onMessageMpim(slackListener:GenericEventWrapper payload) returns error? {
        return;
    }
}

service /ignore on httpListener {}
