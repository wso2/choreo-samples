import ballerina/log;
import ballerinax/mailchimp;
import ballerinax/salesforce;
import ballerinax/trigger.salesforce as sfdcListener;

type SfdcOAuthConfig record {|
    string refreshUrl = "https://login.salesforce.com/services/oauth2/token";
    string refreshToken;
    string clientId;
    string clientSecret;
|};

type SalesforceListenerConfig record {|
    string username;
    string password;
|};

type MailchimpConfig record {|
    string username;
    string password;
|};

configurable SalesforceListenerConfig sfdcListenerConfig = ?;
configurable string salesforceBaseUrl = ?;
configurable SfdcOAuthConfig salesforceOAuthConfig = ?;

configurable MailchimpConfig mailchimpConfig = ?;
configurable string audienceName = ?;
configurable string mailchimpServiceUrl = ?;

const string CHANNEL_NAME = "/data/LeadChangeEvent";

listener sfdcListener:Listener webhookListener = new ({
    username: sfdcListenerConfig.username,
    password: sfdcListenerConfig.password,
    channelName: CHANNEL_NAME
});

@display { label: "Salesforce New Lead to Mailchimp Subscribers List" }
service sfdcListener:RecordService on webhookListener {

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
            log:printError("Error occured while getting new lead record.", leadRecord);
            return;
        }
        string? leadFirstName = check leadRecord?.FirstName;
        string? leadLastName = check leadRecord?.LastName;
        string? leadPhone = check leadRecord?.Phone;
        string? leadEmail = check leadRecord?.Email;
        mailchimp:AddListMembers1 contact = {
            email_address: leadEmail?: "",
            status: "subscribed",
            merge_fields: {
                "FNAME": leadFirstName?: "",
                "LNAME": leadLastName?: "",
                "PHONE": leadPhone?: ""
            }
        };

        mailchimp:Client mailchimpEndpoint = check new ({
            auth: {
                username: mailchimpConfig.username,
                password: mailchimpConfig.password
            }
        }, serviceUrl = mailchimpServiceUrl);

        string? audienceId = ();
        mailchimp:SubscriberLists|error audiences = mailchimpEndpoint->getLists();
        if audiences is error {
            log:printError("Error occured while getting audiences list (subscribers).", audiences);
            return;
        }

        foreach mailchimp:SubscriberList3 audience in audiences.lists {
            if audienceName == audience.name {
                audienceId = audience.id;
                break;
            }
        }

        if audienceId is () {
            log:printError("Given audience name is not in the list. Provide a valid audience name to add contact.");
            return;
        }
        
        mailchimp:ListMembers2|error contactList = mailchimpEndpoint->postListsIdMembers(audienceId, contact);
        if contactList is error {
            log:printError("Error occured while adding contact to Mailchimp subscribers list.", contactList);
            return;
        }
        log:printInfo(string`'${contactList.email_address?:""}' is added into Mailchimp subscribers list.`);
          
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
