import ballerina/http;
import ballerina/log;
import ballerinax/sfdc;
import ballerinax/slack;

const string CHANNEL_NAME = "/data/OpportunityChangeEvent";
const string SFDC_REFRESH_URL = "https://login.salesforce.com/services/oauth2/token";

@display {label: "Salesforce Client Id"}
configurable string & readonly sfdcClientId = ?;

@display {label: "Salesforce Client Secret"}
configurable string & readonly sfdcClientSecret = ?;

@display {label: "Salesforce Refresh Token"}
configurable string & readonly sfdcRefreshToken = ?;

@display {label: "Salesforce Endpoint URL"}
configurable string & readonly sfdcBaseURL = ?;

@display {label: "Salesforce Username"}
configurable string & readonly sfdcUsername = ?;

@display {
    kind: "password",
    label: "Salesforce Password"
}
configurable string & readonly sfdcPassword = ?;

@display {label: "Slack Auth Token"}
configurable string & readonly slackToken = ?;

@display {label: "Slack Channel Name"}
configurable string & readonly slackChannelName = ?;

sfdc:ListenerConfiguration sfdcListenerConfig = {
    username: sfdcUsername,
    password: sfdcPassword
};

listener sfdc:Listener sfdcEventListener = new (sfdcListenerConfig);

@sfdc:ServiceConfig {channelName: CHANNEL_NAME}
service on sfdcEventListener {
    remote function onUpdate(sfdc:EventData opportunity) returns error? {
        string opportunityId = opportunity?.metadata?.recordId ?: "";
        string stageName = check opportunity.changedData.StageName;
        sfdc:Client sfdcClient = check new ({
            baseUrl: sfdcBaseURL,
            clientConfig: {
                clientId: sfdcClientId,
                clientSecret: sfdcClientSecret,
                refreshToken: sfdcRefreshToken,
                refreshUrl: SFDC_REFRESH_URL
            }
        });
        json opportunityRecord = check sfdcClient->getOpportunityById(opportunityId.toString());
        string opportunityName = check opportunityRecord.Name;
        string message = "Opportunity Updated | Opportunity Name : " + opportunityName + " | " + 
        " Opportunity Status: " + stageName + " | Link: <" + sfdcBaseURL + "/" + opportunityId + ">";

        slack:Client slackClient = check new ({bearerTokenConfig: {token: slackToken}});
        string response = check slackClient->postMessage({
            channelName: slackChannelName,
            text: message
        });
        log:printInfo("Message posted in Slack Successfully");
    }
}

service on new http:Listener(8090) {
    isolated resource function get .() returns http:Ok => {};
}
