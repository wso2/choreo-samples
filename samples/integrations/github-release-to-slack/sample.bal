import ballerina/http;
import ballerina/websub;
import ballerinax/github.webhook;
import ballerinax/slack;

@display { kind: "OAuthConfig", provider: "GitHub", label: "Set up GitHub connection" }
configurable http:BearerTokenConfig & readonly gitHubTokenConfig = ?;
@display { kind: "WebhookURL", label: "Set up callback URL for GitHub webhook"}
configurable string & readonly gitHubCallbackUrl = ?;
@display { kind: "ConnectionField", connectionRef: "gitHubTokenConfig", provider: "GitHub", operationName: "getUserRepositoryList", label: "GitHub Repository URL"}
configurable string & readonly githubRepoURL = ?;

@display { label: "Slack Channel Name" }
configurable string & readonly slackChannelName = ?;
@display { label: "Slack Auth Token" }
configurable string & readonly slackAuthToken = ?;

const RELEASE_URL = "html_url"; 
const RELEASE_TAG_NAME = "tag_name";
const TARGET_COMMITTISH = "target_commitish";
const VERSION_NUMBER = "Version Number";
const TARGET_BRANCH = "Target branch";
const SEMICOLON = " : ";

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
        string message = "There is a new release in GitHub ! \n";
        [string,string][] releaseTuples = [[VERSION_NUMBER, RELEASE_TAG_NAME], [TARGET_BRANCH, TARGET_COMMITTISH]];
        message += "<" + releaseInfo.get(RELEASE_URL).toString() + ">\n";
        foreach var releaseTuple in releaseTuples {
            if (releaseInfo.hasKey(releaseTuple[1])) {
                message += releaseTuple[0] + SEMICOLON + releaseInfo.get(releaseTuple[1]).toString() + "\n";
            }
        }
        slack:Client slackClient = check new ({
            bearerTokenConfig: {
                token: slackAuthToken
            }
        });
        var result = check slackClient->postMessage({
            channelName: slackChannelName,
            text: message
        });
    }
}
