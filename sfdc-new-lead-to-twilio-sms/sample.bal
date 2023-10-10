import ballerina/http;
import ballerina/log;
import ballerinax/trigger.salesforce as sfdcListener;
import ballerinax/twilio;

// Types
type SalesforceListenerConfig record {
    string username;
    string password;
};

type TwilioClientConfig record {
    string accountSId;
    string authToken;
};

// Constants
const string CHANNEL_NAME = "/data/LeadChangeEvent";

// Salesforce configuration parameters
configurable SalesforceListenerConfig salesforceListenerConfig = ?;

// Twilio configuration parameters
configurable TwilioClientConfig twilioClientConfig = ?;
configurable string fromNumber = ?;
configurable string toNumber = ?;

listener sfdcListener:Listener sfdcEventListener = new ({
    username: salesforceListenerConfig.username,
    password: salesforceListenerConfig.password,
    channelName: CHANNEL_NAME
});

@display { label: "Salesforce New Lead to Twilio SMS" }
service sfdcListener:RecordService on sfdcEventListener {
    remote function onCreate(sfdcListener:EventData payload) returns error? {
        string message = "New Salesforce lead created successfully! \n";
        map<json> leadMap = payload.changedData;
        foreach [string, json] [key, value] in leadMap.entries() {
            if value != () {
                message += string `${key} : ${value.toString()}${"\n"}`;
            }
        }
        twilio:Client twilioClient = check new ({
            twilioAuth: {
                accountSId: twilioClientConfig.accountSId,
                authToken: twilioClientConfig.authToken
            }
        });
        twilio:SmsResponse response = check twilioClient->sendSms(fromNumber, toNumber, message);
        log:printInfo("SMS(SID: "+ response.sid +") for new lead creation sent successfully");
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
