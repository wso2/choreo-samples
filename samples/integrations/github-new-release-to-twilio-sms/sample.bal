import ballerina/http;
import ballerinax/github.webhook as webhook;
import ballerinax/twilio;
import ballerina/websub;

// Keys related to the release
const string RELEASE_URL = "html_url"; 
const string RELEASE_TAG_NAME = "tag_name";
const string RELEASE_NAME = "name";
const string RELEASE_DESCRIPTION = "body";

// Github configuration parameters
@display { kind: "OAuthConfig", provider: "GitHub", label: "Set up GitHub connection" }
configurable http:BearerTokenConfig & readonly gitHubTokenConfig = ?;
@display { kind: "ConnectionField", connectionRef: "gitHubTokenConfig", provider: "GitHub", operationName: "getUserRepositoryList", label: "GitHub Repository URL"}
configurable string & readonly githubRepoURL = ?;
@display { kind: "WebhookURL", label: "Set up callback URL for GitHub webhook"}
configurable string & readonly gitHubCallbackUrl = ?;

// Twilio configuration parameters
@display { label: "Twilio Account SID" }
configurable string & readonly accountSId = ?;
@display { label: "Twilio Auth Token" }
configurable string & readonly authToken = ?;
@display { label: "SMS Sender's Phone Number" }
configurable string & readonly fromMobile = ?;
@display { label: "SMS Recipient's Phone Number" }
configurable string & readonly toMobile = ?;

// Initialize the Github Listener
listener webhook:Listener githubListener = new (8090);

@websub:SubscriberServiceConfig {
    target: [webhook:HUB, githubRepoURL + "/events/*.json"],
    callback: gitHubCallbackUrl,
    httpConfig: {
        auth: gitHubTokenConfig
    }
}
service /subscriber on githubListener {
    remote function onReleased(webhook:ReleaseEvent event) returns error? {
        webhook:Release releaseInfo = event.release; 
        (string)[] releaseKeys = [RELEASE_URL, RELEASE_TAG_NAME, RELEASE_NAME, RELEASE_DESCRIPTION];
        string message = "Github new release available! \n";

        foreach var releaseKey in releaseKeys {
            if (releaseInfo.hasKey(releaseKey)) {
                message = message + releaseKey + " : " + releaseInfo.get(releaseKey).toString() + "\n";  
            }   
        }
        // Initialize the Twilio Client
        twilio:Client twilioClient = new ({
            accountSId: accountSId,
            authToken: authToken
        });
        twilio:SmsResponse result = check twilioClient->sendSms(fromMobile, toMobile, message);
    }
}

