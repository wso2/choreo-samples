import ballerina/http;
import ballerina/log;
import ballerina/regex;
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
const string COMMA = ",";
const string EQUAL_SIGN = "=";
const string CLOSING_BRACKET = "}";
const string NO_STRING = "";
const string CHANNEL_NAME = "/data/ContactChangeEvent";

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

@display { label: "Salesforce New Contact to Twilio SMS" }
service sfdcListener:RecordService on sfdcEventListener {
    remote function onCreate(sfdcListener:EventData payload) returns error? {
        string firstName = NO_STRING;
        string lastName = NO_STRING;
        map<json> contactMap = payload.changedData;
        string[] nameParts = regex:split(contactMap["Name"].toString(), COMMA);
        if nameParts.length() >= 2 {
            firstName = regex:split(nameParts[0], EQUAL_SIGN)[1];
            lastName = regex:split(regex:replaceFirst(nameParts[1], CLOSING_BRACKET, NO_STRING), EQUAL_SIGN)[1];
        } else {
            lastName = regex:split(regex:replaceFirst(nameParts[0], CLOSING_BRACKET, NO_STRING), EQUAL_SIGN)[1];
        }
        string createdDate = check payload.changedData.CreatedDate;
        string message = string `New contact is created! | Name: ${firstName} ${lastName} | Created Date: ${createdDate}`;
        twilio:Client twilioClient = check new ({
            twilioAuth: {
                accountSId: twilioClientConfig.accountSId,
                authToken: twilioClientConfig.authToken
            }
        });
        twilio:SmsResponse response = check twilioClient->sendSms(fromNumber, toNumber, message);
        log:printInfo("SMS(SID: "+ response.sid +") sent successfully");
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
