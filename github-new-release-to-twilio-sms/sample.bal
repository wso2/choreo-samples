import ballerina/http;
import ballerina/log;
import ballerinax/trigger.github;
import ballerinax/twilio;

// Github configuration parameters
configurable github:ListenerConfig gitHubListenerConfig = ?;

// Twilio configuration parameters
configurable string TwilioAccountSID = ?;
configurable string TwilioAuthToken = ?;
configurable string fromMobile = ?;
configurable string toMobile = ?;

// Release Keys
final string[] & readonly releaseKeys = ["html_url", "tag_name", "name", "body"];

listener http:Listener httpListener = new(8090);
listener github:Listener gitHubListener = new (gitHubListenerConfig, httpListener);

@display { label: "GitHub New Release to Twilio SMS" }
service github:ReleaseService on gitHubListener {
    remote function onReleased(github:ReleaseEvent payload) returns error? {
        string message = "Github new release available! \n";
        github:Release releaseInfo = payload.release;
        foreach string releaseKey in releaseKeys {
            if releaseInfo.hasKey(releaseKey) {
                message += string `${releaseKey} : ${releaseInfo.get(releaseKey).toString()}${"\n"}`;
            }
        }
        twilio:Client twilioClient = check new ({
            twilioAuth: {
                accountSId: TwilioAccountSID,
                authToken: TwilioAuthToken
            }
        });
        _ = check twilioClient->sendSms(fromMobile, toMobile, message);
        log:printInfo("SMS for new release sent successfully!");
    }

    remote function onPublished(github:ReleaseEvent payload) returns error? {
        return;
    }
    remote function onUnpublished(github:ReleaseEvent payload) returns error? {
        return;
    }
    remote function onCreated(github:ReleaseEvent payload) returns error? {
        return;
    }
    remote function onEdited(github:ReleaseEvent payload) returns error? {
        return;
    }
    remote function onDeleted(github:ReleaseEvent payload) returns error? {
        return;
    }
    remote function onPreReleased(github:ReleaseEvent payload) returns error? {
        return;
    }
}

service /ignore on httpListener {}
