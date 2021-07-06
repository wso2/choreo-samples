import ballerina/http;
import ballerina/log;
import ballerina/websub;
import ballerinax/github.webhook as webhook;
import ballerinax/twilio;

// Github configuration parameters
@display {
    kind: "OAuthConfig",
    provider: "GitHub",
    label: "Set Up GitHub Connection"
}
configurable http:BearerTokenConfig & readonly gitHubTokenConfig = ?;

@display {
    kind: "ConnectionField",
    connectionRef: "gitHubTokenConfig",
    provider: "GitHub",
    operationName: "getUserRepositoryList",
    label: "GitHub Repository URL"
}
configurable string & readonly gitHubRepoUrl = ?;

@display {
    kind: "WebhookURL",
    label: "Set Up Callback URL for GitHub Webhook"
}
configurable string & readonly gitHubCallbackUrl = ?;

// Twilio configuration parameters
@display {label: "Twilio Account SID"}
configurable string & readonly accountSid = ?;

@display {label: "Twilio Auth Token"}
configurable string & readonly authToken = ?;

@display {label: "SMS Sender's Phone Number"}
configurable string & readonly fromMobile = ?;

@display {label: "SMS Recipient's Phone Number"}
configurable string & readonly toMobile = ?;

// Keys related to the release
const string RELEASE_URL = "html_url";
const string RELEASE_TAG_NAME = "tag_name";
const string RELEASE_NAME = "name";
const string RELEASE_DESCRIPTION = "body";

listener webhook:Listener githubListener = new (8090);

@websub:SubscriberServiceConfig {
    target: [webhook:HUB, gitHubRepoUrl + "/events/*.json"],
    callback: gitHubCallbackUrl + "/subscriber",
    httpConfig: {auth: gitHubTokenConfig}
}
service /subscriber on githubListener {
    remote function onReleased(webhook:ReleaseEvent event) returns error? {
        string message = "Github new release available! \n";
        string[] releaseKeys = [RELEASE_URL, RELEASE_TAG_NAME, RELEASE_NAME, RELEASE_DESCRIPTION];
        webhook:Release releaseInfo = event.release;
        foreach var releaseKey in releaseKeys {
            if (releaseInfo.hasKey(releaseKey)) {
                message += releaseKey + " : " + releaseInfo.get(releaseKey).toString() + "\n";
            }
        }

        twilio:Client twilioClient = check new ({
            accountSId: accountSid,
            authToken: authToken
        });
        twilio:SmsResponse sendSmsResponse = check twilioClient->sendSms(fromMobile, toMobile, message);
        log:printInfo("SMS for new release sent successfully!");   
    }
}
