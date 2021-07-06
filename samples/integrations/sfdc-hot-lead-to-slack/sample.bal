import ballerina/http;
import ballerina/log;
import ballerinax/sfdc;
import ballerinax/slack;

const string CHANNEL_NAME = "/data/LeadChangeEvent";
const string SFDC_REFRESH_URL = "https://login.salesforce.com/services/oauth2/token";

@display {label: "Salesforce Client ID"}
configurable string & readonly sfdcClientId = ?;

@display {label: "Salesforce Client Secret"}
configurable string & readonly sfdcClientSecret = ?;

@display {label: "Salesforce Refresh Token"}
configurable string & readonly sfdcRefreshToken = ?;

@display {label: "Salesforce Username"}
configurable string & readonly sfdcUsername = ?;

@display {
    kind: "password",
    label: "Salesforce Password"
}
configurable string & readonly sfdcPassword = ?;

@display {label: "Salesforce Endpoint URL"}
configurable string & readonly sfdcBaseURL = ?;

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
    remote function onCreate(sfdc:EventData lead) returns error? {
        string sLeadId = lead?.metadata?.recordId ?: "";
        sfdc:Client sfdcClient = check new ({
            baseUrl: sfdcBaseURL,
            clientConfig: {
                clientId: sfdcClientId,
                clientSecret: sfdcClientSecret,
                refreshToken: sfdcRefreshToken,
                refreshUrl: SFDC_REFRESH_URL
            }
        });
        json leadRecord = check sfdcClient->getLeadById(sLeadId.toString());
        string rating = check leadRecord.Rating;
        if (rating == "Hot") {
            string leadName = check leadRecord.Name;
            string leadSalutation = check leadRecord.Salutation;
            string leadCompany = check leadRecord.Company;
            string leadId = check leadRecord.Id;
            string message = "Hot Lead Added. | Lead Name: " + leadSalutation + leadName + " Company: " + leadCompany + 
            " | Link: <" + sfdcBaseURL + "/" + leadId + ">";
            slack:Client slackClient = check new ({bearerTokenConfig: {token: slackToken}});
            string response = check slackClient->postMessage({
                channelName: slackChannelName,
                text: message
            });
            log:printInfo("Message posted in Slack Successfully");
        }
    }
}

service on new http:Listener(8090) {
    isolated resource function get .() returns http:Ok => {};
}
