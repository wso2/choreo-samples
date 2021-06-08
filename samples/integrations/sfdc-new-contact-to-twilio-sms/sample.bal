import ballerina/http;
import ballerina/log;
import ballerina/regex;
import ballerinax/sfdc;
import ballerinax/twilio;

// Constants
const string COMMA = ",";
const string EQUAL_SIGN = "=";
const string CLOSING_BRACKET = "}";
const string NO_STRING = "";
const string CHANNEL_NAME = "/data/ContactChangeEvent";

// Salesforce configuration parameters
@display {label: "Salesforce Username"}
configurable string & readonly sfdcUsername = ?;

@display {
    kind: "password",
    label: "Salesforce Password"
}
configurable string & readonly sfdcPassword = ?;

// Twilio configuration parameters
@display {label: "Twilio Account SID"}
configurable string & readonly twilioAccountSid = ?;

@display {label: "Twilio Auth Token"}
configurable string & readonly twilioAuthToken = ?;

@display {label: "SMS Sender's Phone Number"}
configurable string & readonly fromNumber = ?;

@display {label: "SMS Recipient's Phone Number"}
configurable string & readonly toNumber = ?;

sfdc:ListenerConfiguration listenerConfig = {
    username: sfdcUsername,
    password: sfdcPassword
};

listener sfdc:Listener sfdcEventListener = new (listenerConfig);

@sfdc:ServiceConfig {channelName: CHANNEL_NAME}
service on sfdcEventListener {
    remote function onCreate(sfdc:EventData contact) returns error? {
        string firstName = NO_STRING;
        string lastName = NO_STRING;
        map<json> contactMap = contact.changedData;
        string[] nameParts = regex:split(contactMap["Name"].toString(), COMMA);
        if (nameParts.length() >= 2) {
            firstName = regex:split(nameParts[0], EQUAL_SIGN)[1];
            lastName = regex:split(regex:replaceFirst(nameParts[1], CLOSING_BRACKET, NO_STRING), EQUAL_SIGN)[1];
        } else {
            lastName = regex:split(regex:replaceFirst(nameParts[0], CLOSING_BRACKET, NO_STRING), EQUAL_SIGN)[1];
        }
        string createdDate = check contact.changedData.CreatedDate;
        string message = "New contact is created! | Name: " + firstName + " " + lastName + " | Created Date: " + 
        createdDate;

        twilio:Client twilioClient = check new ({
            accountSId: twilioAccountSid,
            authToken: twilioAuthToken
        });
        twilio:SmsResponse response = check twilioClient->sendSms(fromNumber, toNumber, message);
        log:printInfo("SMS sent successfully");
    }
}

service on new http:Listener(8090) {
    isolated resource function get .() returns http:Ok => {};
}
