import ballerina/http;
import ballerina/log;
import ballerinax/trigger.salesforce as sfdcListener;
import ballerinax/twitter;

// Types
type SalesforceListenerConfig record {
    string username;
    string password;
};

type TwitterClientConfig record {
    string apiKey;
    string apiSecret;
    string accessToken;
    string accessTokenSecret;
};

// Salesforce configuration parameters
configurable SalesforceListenerConfig salesforceListenerConfig = ?;

// Twitter configuration parameters
configurable TwitterClientConfig twitterClientConfig = ?;

// Constants
const string CHANNEL_NAME = "/data/CampaignChangeEvent";

listener sfdcListener:Listener sfdcEventListener = new ({
    username: salesforceListenerConfig.username,
    password: salesforceListenerConfig.password,
    channelName: CHANNEL_NAME
});

@display { label: "Salesforce New Campaign to Twitter Post" }
service sfdcListener:RecordService on sfdcEventListener {
    remote function onCreate(sfdcListener:EventData payload) returns error? {
        
        string campaignName = check payload.changedData.Name;
        string campaignStartDate = check payload.changedData.StartDate;
        string campaignEndDate = check payload.changedData.EndDate;
        string campaignType = "Campaign Event";
        if payload.changedData.Type is string {
            campaignType = check payload.changedData.Type;
        }

        string TwitterMessage = campaignType + ":" + campaignName + "\n\n" + "There will be a campaign run by WSO2 named" 
                                + campaignName + "on date" + campaignStartDate + "ending on date" + campaignEndDate;
    
        twitter:Client twitterClient = check new({
            apiKey: twitterClientConfig.apiKey,
            apiSecret: twitterClientConfig.apiSecret,
            accessToken: twitterClientConfig.accessToken,
            accessTokenSecret: twitterClientConfig.accessTokenSecret
        });

        twitter:Tweet|error result = twitterClient->tweet(TwitterMessage);
        if result is twitter:Tweet {
            log:printInfo("Twitter post created Successfully. Tweet ID: " + result.id.toString());
        } else {
            log:printError(msg = result.toString());
        }
    }

    remote function onUpdate(sfdcListener:EventData payload) returns error? {
        return;
    }

    remote function onDelete(sfdcListener:EventData payload) returns error? {
        return;
    }

    remote function onRestore(sfdcListener:EventData payload) returns error? {
        return;
    }
}

service /ignore on new http:Listener(8090) {}
