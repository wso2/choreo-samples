import ballerina/http;
import ballerina/log;
import ballerinax/salesforce as sfdc;
import ballerinax/slack;
import ballerinax/trigger.salesforce as sfdcListener;

// Salesforce client configuration parameters
type OAuth2RefreshTokenGrantConfig record {
    string refreshUrl = "https://login.salesforce.com/services/oauth2/token";
    string refreshToken;
    string clientId;
    string clientSecret;
};

// Salesforce listener configuration parameters
type ListenerConfig record {
    string username;
    string password;
};

// Constants
const string CHANNEL_NAME = "/data/OpportunityChangeEvent";
const string CLOSED_WON = "Closed Won";

configurable ListenerConfig salesforceListenerConfig = ?;
configurable OAuth2RefreshTokenGrantConfig salesforceOAuthConfig = ?;
configurable string salesforceBaseUrl = ?;

configurable string slackToken = ?;
configurable string slackChannelName = ?;

listener sfdcListener:Listener sfdcEventListener = new ({
    username: salesforceListenerConfig.username,
    password: salesforceListenerConfig.password,
    channelName: CHANNEL_NAME
});

@display { label: "Salesforce Opportunity 'Closed Won' to Slack Channel Message" }
service  sfdcListener:RecordService on sfdcEventListener {
    remote function onUpdate(sfdcListener:EventData payload) returns error? {
        string stageName = check payload.changedData.StageName;
        if stageName == CLOSED_WON {
            log:printInfo("Opportunity Won!");
            json opportunityId = payload?.metadata?.recordId;
            sfdc:Client sfdcClient = check new ({
                baseUrl: salesforceBaseUrl,
                auth: {
                    clientId: salesforceOAuthConfig.clientId,
                    clientSecret: salesforceOAuthConfig.clientSecret,
                    refreshToken: salesforceOAuthConfig.refreshToken,
                    refreshUrl: salesforceOAuthConfig.refreshUrl
                }
            });
            json opportunityRecord = check sfdcClient->getOpportunityById(opportunityId.toString());

            //Create message content
            string opportunityName = check opportunityRecord.Name;
            string message = string `Opportunity Won! Name: ${opportunityName} | Link: < ${
                salesforceBaseUrl}/${opportunityId.toString()} >`;

            slack:Client slackClient = check new ({auth: {token: slackToken}});
            _ = check slackClient->postMessage({
                channelName: slackChannelName,
                text: message
            });
            log:printInfo(string `Message posted in Slack channel ${slackChannelName} successfully!`);
        }
    }

    remote function onCreate(sfdcListener:EventData payload) returns error? {
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
