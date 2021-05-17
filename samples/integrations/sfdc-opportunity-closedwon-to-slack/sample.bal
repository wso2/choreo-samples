import ballerina/log;
import ballerina/io;
import ballerinax/sfdc;
import ballerinax/slack;

//intializing constants 
const string TOPIC_PREFIX = "/topic/";
const string UPDATED = "updated";
const string CLOSED_WON = "Closed Won";

//salesforce configuration parameters;
@display { label: "SalesForce Endpoint URL" }
configurable string & readonly epURL = ?;

@display { label: "SalesForce User name" }
configurable string & readonly sfdcUsername = ?;

@display { kind: "password", label: "SalesForce Password" }
configurable string & readonly sfdcPassword = ?;

@display { label: "SalesForce Push Topic" }
configurable string & readonly sfdc_push_topic = ?;

//slack configuration parameters
@display { label: "Slack Auth Token" }
configurable string slackToken = ?;

@display { label: "Slack Channel Name" }
configurable string & readonly slackChannelName = ?;

sfdc:ListenerConfiguration sfdc_listenerConfig = {
    username: sfdcUsername,
    password: sfdcPassword
};

//initialialize salesforce listener
listener sfdc:Listener sfdcEventListener = new (sfdc_listenerConfig);

@sfdc:ServiceConfig {topic: TOPIC_PREFIX + sfdc_push_topic}
service on sfdcEventListener {
    remote function onEvent(json opportunity) returns error? {
        io:StringReader reader = new (opportunity.toJsonString());
        json opportunityUpdate = check reader.readJson();
        json eventType = check opportunityUpdate.event.'type;
        if (UPDATED.equalsIgnoreCaseAscii(eventType.toString())) {
            json stageName = check opportunityUpdate.sobject.StageName;
            if (stageName == CLOSED_WON) {
                log:printInfo("Opportunity updated to 'Closed Won'");
                string fullName = "opportunity Name : ";
                json|error opportunityName = opportunityUpdate.sobject.Name;
                json|error opportunityId = opportunityUpdate.sobject.AccountId;

                string companyName = opportunityName is json ? " Name : " + opportunityName.toString() : "";
                string link = opportunityId is json ? (" | Link : " + "<" + epURL + "/" + opportunityId.toString() + ">") : "";
                //intialize slack client 
                slack:Client slackClient = check new ({bearerTokenConfig: {token: slackToken}});
                var response = slackClient->postMessage({
                    channelName: slackChannelName,
                    text: "Opportunity Won !!! " + companyName + link
                });
                if response is string {
                    log:printInfo("Message posted in Slack Successfully");
                } else {
                    log:printError("Error Occurred : " + response.message());
                }
            }
        }
    }
}
