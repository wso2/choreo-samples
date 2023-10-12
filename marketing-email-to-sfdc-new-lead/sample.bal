import ballerina/log;
import ballerinax/googleapis.gmail;
import ballerinax/salesforce;
import ballerinax/trigger.salesforce as sfdcListener;

type SfdcOAuthConfig record {|
    string refreshUrl = "https://login.salesforce.com/services/oauth2/token";
    string refreshToken;
    string clientId;
    string clientSecret;
|};

type GmailOAuthConfig record {|
    string refreshUrl = "https://oauth2.googleapis.com/token";
    string refreshToken;
    string clientId;
    string clientSecret;
|};

type SalesforceListenerConfig record {|
    string username;
    string password;
|};

configurable string salesforceBaseUrl = ?;
configurable SfdcOAuthConfig salesforceOAuthConfig = ?;
configurable SalesforceListenerConfig sfdcListenerConfig = ?;

configurable GmailOAuthConfig gmailOAuthConfig = ?;

const string CHANNEL_NAME = "/data/LeadChangeEvent";
const string GMAIL_SUBJECT = "Choreo is Now Generally Available";
const string CONTENT_TYPE = "text/html";

listener sfdcListener:Listener sfdcEventListener = new ({
    username: sfdcListenerConfig.username,
    password: sfdcListenerConfig.password,
    channelName: CHANNEL_NAME
});

service sfdcListener:RecordService on sfdcEventListener {

    remote function onCreate(sfdcListener:EventData payload) returns error? {
        string sfLeadId = check payload?.metadata?.recordId.ensureType();
        salesforce:Client salesforceEndpoint = check new ({
            baseUrl: salesforceBaseUrl,
            auth: {
                refreshUrl: salesforceOAuthConfig.refreshUrl,
                refreshToken: salesforceOAuthConfig.refreshToken,
                clientId: salesforceOAuthConfig.clientId,
                clientSecret: salesforceOAuthConfig.clientSecret
            }
        });

        json|salesforce:Error leadRecord = salesforceEndpoint->getLeadById(sfLeadId);

        if leadRecord is salesforce:Error {
            log:printError(string `Error occured while getting new lead record with Id: ${sfLeadId}.`, leadRecord);
            return;
        }

        string? leadName = check leadRecord?.Name;
        string? leadEmail = check leadRecord?.Email;

        string htmlBody = string `<h2> Hello ${leadName?:""} , </h2><h1> Create Digital Services Fast</h1>
                                  <p>Enable your dev teams to deliver new digital experiences in hours.
                                     Remove the complexity of cloud native infrastructure so your dev and 
                                     ops teams can focus on innovating fast.</p>
                                  <p><a href="https://wso2.com/choreo/" > 
                                  <b> Click here to know more about Choreo! </b></a> </p>`;

        gmail:Client gmailEndpoint = check new ({
            auth: {
                refreshUrl: gmailOAuthConfig.refreshUrl,
                refreshToken: gmailOAuthConfig.refreshToken,
                clientId: gmailOAuthConfig.clientId,
                clientSecret: gmailOAuthConfig.clientSecret
                }});

        gmail:Message|error sendMessageResponse = gmailEndpoint->sendMessage({
            recipient: leadEmail?:"",
            subject: GMAIL_SUBJECT,
            messageBody: htmlBody,
            contentType: CONTENT_TYPE
            });
        if sendMessageResponse is error {
            log:printError("Error occured while sending to new lead.", sendMessageResponse);
        } else {
            log:printInfo(sendMessageResponse.id);
        }    
    }
    remote function onUpdate(sfdcListener:EventData payload) returns error? {
        //Not Implemented
    }
    remote function onDelete(sfdcListener:EventData payload) returns error? {
        //Not Implemented
    }
    remote function onRestore(sfdcListener:EventData payload) returns error? {
        //Not Implemented
    }
}
