import ballerina/http;
import ballerina/log;
import ballerinax/trigger.github;
import ballerinax/twitter;

// Types
type TwitterClientConfig record {
    string apiKey;
    string apiSecret;
    string accessToken;
    string accessTokenSecret;
};

// Github configuration parameters
configurable github:ListenerConfig gitHubListenerConfig = ?;

// Twitter configuration parameters
configurable TwitterClientConfig twitterClientConfig = ?;

listener http:Listener httpListener = new(8090);
listener github:Listener gitHubListener = new (gitHubListenerConfig, httpListener);

@display { label: "GitHub New Release to Twitter Post" }
service github:ReleaseService on gitHubListener {
    remote function onReleased(github:ReleaseEvent payload) returns error? {

        github:Release releaseInfo = payload.release; 
        string releaseTitle = "";
        string releaseDescription = "";
        string urlForRelease = "";
        if releaseInfo.get("name") is string {
            releaseTitle = releaseInfo.get("name").toString();
        }
        if releaseInfo.get("body") is string {
            releaseDescription = releaseInfo.get("body").toString();
        }
        if releaseInfo.get("body") is string {
            urlForRelease = releaseInfo.get("html_url").toString();
        }

        string twitterMessage = releaseTitle + "\n\n" + "Link: " + urlForRelease + "\n" + releaseDescription;

        twitter:Client twitterClient = check new({
            apiKey: twitterClientConfig.apiKey,
            apiSecret: twitterClientConfig.apiSecret,
            accessToken: twitterClientConfig.accessToken,
            accessTokenSecret: twitterClientConfig.accessTokenSecret
        });

        twitter:Tweet|error result = twitterClient->tweet(twitterMessage);
        if result is twitter:Tweet {
            log:printInfo("Twitter post created Successfully. Tweet ID: " + result.id.toString());
        } else {
            log:printError(msg = result.toString());
        }
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
