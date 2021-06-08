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
const string CHANNEL_NAME = "/data/OpportunityChangeEvent";

listener sfdc:Listener sfdcEventListener = new ({
    username: sfdcUsername,
    password: sfdcPassword
});

@sfdc:ServiceConfig {channelName: CHANNEL_NAME}
service on sfdcEventListener {
    remote function onUpdate(sfdc:EventData opportunity) returns error? {
        string message = "Salesforce opportunity updated successfully! \n";
        map<json> opportunityMap = opportunity.changedData;
        foreach var entry in opportunityMap.entries() {
            if (entry[1] != ()) {
                message += entry[0] + " : " + entry[1].toString() + "\n";
            }
        }

        twilio:Client twilioClient = check new ({
            accountSId: twilioAccountSid,
            authToken: twilioAuthToken
        });
        twilio:SmsResponse sendSmsResponse = check twilioClient->sendSms(fromNumber, toNumber, message);
        log:printInfo("SMS for opportunity update sent successfully!");
    }
}

service on new http:Listener(8090) {
    isolated resource function get .() returns http:Ok => {};
}
