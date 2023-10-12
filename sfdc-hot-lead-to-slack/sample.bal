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
const string CHANNEL_NAME = "/data/LeadChangeEvent";

configurable ListenerConfig salesforceListenerConfig = ?;
configurable OAuth2RefreshTokenGrantConfig salesforceOAuthConfig = ?;
configurable string salesforceBaseUrl = ?;

// Slack configuration parameters
configurable string slackToken = ?;
configurable string slackChannelName = ?;

listener sfdcListener:Listener sfdcEventListener = new ({
    username: salesforceListenerConfig.username,
    password: salesforceListenerConfig.password,
    channelName: CHANNEL_NAME
});

@display { label: "Salesforce New Hot Lead to Slack Channel Message" }
service  sfdcListener:RecordService on sfdcEventListener {
    remote function onCreate(sfdcListener:EventData payload) returns error? {
        string sLeadId = payload?.metadata?.recordId ?: "";
        sfdc:Client sfdcClient = check new ({
            baseUrl: salesforceBaseUrl,
            auth: {
                clientId: salesforceOAuthConfig.clientId,
                clientSecret: salesforceOAuthConfig.clientSecret,
                refreshToken: salesforceOAuthConfig.refreshToken,
                refreshUrl: salesforceOAuthConfig.refreshUrl
            }
        });
        json leadRecord = check sfdcClient->getLeadById(sLeadId.toString());
        string rating = check leadRecord.Rating;

        // Create the message ad post it in slack if the Lead created is a "HOT" lead
        if rating == "Hot" {
            string leadName = check leadRecord.Name;
            string leadSalutation = check leadRecord.Salutation;
            string leadCompany = check leadRecord.Company;
            string leadId = check leadRecord.Id;
            string message = string `Hot Lead Added. | Lead Name: ${leadSalutation} ${
                leadName}  Company: ${leadCompany} | Link: <${salesforceBaseUrl}/${leadId}>`;
            slack:Client slackClient = check new ({auth: {token: slackToken}});

            _ = check slackClient->postMessage({
                channelName: slackChannelName,
                text: message
            });
            log:printInfo("Message posted in Slack Successfully");
        }
    }

    remote function onDelete(sfdcListener:EventData payload) returns error? {
        return;
    }

    remote function onRestore(sfdcListener:EventData payload) returns error? {
        return;
    }

    remote function onUpdate(sfdcListener:EventData payload) returns error? {
        return;
    }
}

service /ignore on new http:Listener(8090) {}
