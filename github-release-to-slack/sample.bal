import ballerina/http;
import ballerina/log;
import ballerinax/trigger.github;
import ballerinax/slack;

// Types
type ReleaseInfo record {|
    string 'key;
    string value;
|};

// Constants
const string RELEASE_TAG_NAME = "tag_name";
const string TARGET_COMMITTISH = "target_commitish";
const string VERSION_NUMBER = "Version Number";
const string TARGET_BRANCH = "Target branch";

// Github configuration parameters
configurable github:ListenerConfig gitHubListenerConfig = ?;

// Slack configuration parameters
configurable string slackAuthToken = ?;
configurable string slackChannelName = ?;

listener http:Listener httpListener = new(8090);
listener github:Listener gitHubListener = new (gitHubListenerConfig, httpListener);

@display { label: "GitHub New Release to Slack Channel Message" }
service github:ReleaseService on gitHubListener {
    remote function onReleased(github:ReleaseEvent payload) returns error? {
        github:Release releaseInfo = payload.release;

        ReleaseInfo[] requiredFields = [
            {
                'key: VERSION_NUMBER,
                value: RELEASE_TAG_NAME
            },
            {
                'key: TARGET_BRANCH,
                value: TARGET_COMMITTISH
            }
        ];

        string message = "There is a new release in GitHub ! \n <" + releaseInfo.html_url + ">\n";
        foreach ReleaseInfo {'key, value} in requiredFields {
            if releaseInfo.hasKey(value) {
                message += string `${'key} : ${releaseInfo.get(value).toString()}${"\n"}`;
            }
        }

        slack:Client slackClient = check new ({auth: {token: slackAuthToken}});
        string response = check slackClient->postMessage({
            channelName: slackChannelName,
            text: message
        });
        log:printInfo("Message sent successfully " + response.toString());
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
