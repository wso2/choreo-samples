import ballerina/http;
import ballerina/log;
import ballerinax/trigger.salesforce as sfdcListener;
import ballerinax/twilio;

// Salesforce listener configuration parameters
type SalesforceListenerConfig record {
    string username;
    string password;
};

// Twilio configuration parameters
type TwilioClientConfig record {
    string accountSid;
    string authToken;
};

// Constants
const string CHANNEL_NAME = "/data/OpportunityChangeEvent";

configurable SalesforceListenerConfig salesforceListenerConfig = ?;
configurable TwilioClientConfig twilioClientConfig = ?;
configurable string twilioFromNumber = ?;
configurable string twilioToNumber = ?;

listener sfdcListener:Listener sfdcEventListener = new ({
    username: salesforceListenerConfig.username,
    password: salesforceListenerConfig.password,
    channelName: CHANNEL_NAME
});

@display { label: "Salesforce Opportunity Update to Twilio SMS" }
service  sfdcListener:RecordService on sfdcEventListener {
    remote function onUpdate(sfdcListener:EventData payload) returns error? {
        string message = "Salesforce opportunity updated successfully! \n";
        map<json> opportunityMap = payload.changedData;
        foreach [string, json] [key, value] in opportunityMap.entries() {
            // Create message content
            if value != () {
                message += string `${key} : ${value.toString()}${"\n"}`;
            }
        }

        twilio:Client twilioClient = check new ({
            twilioAuth: {
                accountSId: twilioClientConfig.accountSid,
                authToken: twilioClientConfig.authToken
            }
        });

        _ = check twilioClient->sendSms(twilioFromNumber, twilioToNumber, message);

        log:printInfo(string `SMS for opportunity update sent to ${twilioToNumber} successfully.`);
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
