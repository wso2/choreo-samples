import ballerina/http;
import ballerina/log;
import ballerina/websub;
import ballerinax/github.webhook;
import ballerinax/slack;

const string RELEASE_TAG_NAME = "tag_name";
const string TARGET_COMMITTISH = "target_commitish";
const string VERSION_NUMBER = "Version Number";
const string TARGET_BRANCH = "Target branch";

@display {
    kind: "OAuthConfig",
    provider: "GitHub",
    label: "Set Up GitHub connection"
}
configurable http:BearerTokenConfig & readonly gitHubTokenConfig = ?;

@display {
    kind: "WebhookURL",
    label: "Set Up Callback URL for GitHub Webhook"
}
configurable string & readonly gitHubCallbackUrl = ?;

@display {
    kind: "ConnectionField",
    connectionRef: "gitHubTokenConfig",
    provider: "GitHub",
    operationName: "getUserRepositoryList",
    label: "GitHub Repository URL"
}
configurable string & readonly githubRepoURL = ?;

@display {label: "Slack Auth Token"}
configurable string & readonly slackAuthToken = ?;

@display {label: "Slack Channel Name"}
configurable string & readonly slackChannelName = ?;

listener webhook:Listener githubListener = new (8090);

@websub:SubscriberServiceConfig {
    target: [webhook:HUB, githubRepoURL + "/events/*.json"],
    callback: gitHubCallbackUrl + "/subscriber",
    httpConfig: {auth: gitHubTokenConfig}
}
service /subscriber on githubListener {
    remote function onReleased(webhook:ReleaseEvent event) returns error? {
        webhook:Release releaseInfo = event.release;
        record {| string 'key; string value; |}[] requiredFields = [{
            'key: VERSION_NUMBER,
            value: RELEASE_TAG_NAME
        }, {
            'key: TARGET_BRANCH,
            value: TARGET_COMMITTISH
        }];
        string message = "There is a new release in GitHub ! \n <" + releaseInfo.html_url + ">\n";
        foreach var 'field in requiredFields {
            if (releaseInfo.hasKey('field.value)) {
                message += string `${'field.'key} : ${releaseInfo.get('field.value).toString()}` + "\n";
            }
        }

        slack:Client slackClient = check new ({bearerTokenConfig: {token: slackAuthToken}});
        string response = check slackClient->postMessage({
            channelName: slackChannelName,
            text: message
        });
        log:printInfo("Message sent successfully");
    }
}
