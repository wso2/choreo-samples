import ballerina/log;
import ballerinax/slack.'listener as slack;
import ballerinax/twilio;

// Slack configuration parameters
@display {label: "Slack Channel ID"}
configurable string & readonly channelId = ?;

@display {label: "Slack Verification Token"}
configurable string & readonly verificationToken = ?;

// Twilio configuration parameters
@display {label: "Twilio Account SID"}
configurable string & readonly twilioAccountSid = ?;

@display {label: "Twilio Auth Token"}
configurable string & readonly twilioAuthToken = ?;

@display {label: "Twilio Mobile No"}
configurable string & readonly fromNumber = ?;

@display {label: "Receiver Mobile No"}
configurable string & readonly toNumber = ?;

slack:ListenerConfiguration slackListenerConfig = {
    port: 8090,
    verificationToken: verificationToken
};

listener slack:Listener slacker = new (slackListenerConfig);

service /slack on slacker {
    remote function onMessage(slack:SlackEvent eventInfo) returns error? {
        string eventChannelId = eventInfo.event["channel"].toString();
        slack:EventType event = eventInfo.event;
        json blocks = event["blocks"].toJson();
        json[] blocksMap = <json[]>blocks;
        json[] elements = <json[]>check blocksMap[0].elements;
        json[] innerElements = <json[]>check elements[0].elements;
        string text = check innerElements[0].text;
        if (channelId == eventChannelId) {
            string message = "New message in the channel : " + channelId.toString() + "\nMessage : " + text;
            twilio:Client twilioClient = check new ({
                accountSId: twilioAccountSid,
                authToken: twilioAuthToken
            });
            twilio:SmsResponse result = check twilioClient->sendSms(fromNumber, toNumber, message);
            log:printInfo("SMS sent succesfully");
        }
    }
}
