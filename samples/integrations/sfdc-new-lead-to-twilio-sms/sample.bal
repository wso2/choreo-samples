import ballerina/http;
import ballerina/log;
import ballerinax/sfdc;
import ballerinax/twilio;

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

// Salesforce channel name
const string CHANNEL_NAME = "/data/LeadChangeEvent";

listener sfdc:Listener sfdcEventListener = new ({
    username: sfdcUsername,
    password: sfdcPassword
});

@sfdc:ServiceConfig {channelName: CHANNEL_NAME}
service on sfdcEventListener {
    remote function onCreate(sfdc:EventData lead) returns error? {
        string message = "New Salesforce lead created successfully! \n";
        map<json> leadMap = lead.changedData;
        foreach var entry in leadMap.entries() {
            if (entry[1] != ()) {
                message += entry[0] + " : " + entry[1].toString() + "\n";
            }
        }

        twilio:Client twilioClient = check new ({
            accountSId: twilioAccountSid,
            authToken: twilioAuthToken
        });
        twilio:SmsResponse sendSmsResponse = check twilioClient->sendSms(fromNumber, toNumber, message);
        log:printInfo("SMS for new lead creation sent successfully!");
    }
}

service on new http:Listener(8090) {
    isolated resource function get .() returns http:Ok => {};
}
