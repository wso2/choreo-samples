import ballerina/io;
import ballerinax/sfdc;
import ballerinax/twilio;

// Constants
const string TOPIC_PREFIX = "/topic/";
const string TYPE_CREATED = "created";

// Salesforce configuration parameters
@display { label: "SalesForce User name" }
configurable string & readonly username = ?;
@display { kind: "password", label: "SalesForce Password" }
configurable string & readonly password = ?;
@display { label: "SalesForce Push Topic" }
configurable string & readonly sfPushTopic = ?;

sfdc:ListenerConfiguration listenerConfig = {
    username: username,
    password: password
};

// Twilio configuration parameters
@display { label: "Twilio Account SID" }
configurable string & readonly accountSId = ?;
@display { label: "Twilio Auth Token" }
configurable string & readonly authToken = ?;
@display { label: "SMS From mobile no." }
configurable string & readonly twFromMobile = ?;
@display { label: "SMS To mobile no." }
configurable string & readonly twToMobile = ?;

// Initialize the Salesforce Listener
listener sfdc:Listener sfdcEventListener = new (listenerConfig);

@sfdc:ServiceConfig {
    topic: TOPIC_PREFIX + sfPushTopic
}
service on sfdcEventListener {
    remote function onEvent(json lead) returns error? {
        io:StringReader reader = new (lead.toJsonString());
        json leadInfo = check reader.readJson();         
        json eventType = check leadInfo.event.'type;  
        if (TYPE_CREATED.equalsIgnoreCaseAscii(eventType.toString())) {
            json leadId = check leadInfo.sobject.Id;
            json leadObject = check leadInfo.sobject;
            string message = "New Salesforce lead created successfully! \n";
            map<json> leadMap = <map<json>> leadObject;
            
            foreach var entry in leadMap.entries() {
                if (entry[1] != ()) {
                    message = message + entry[0] + " : " + entry[1].toString() + "\n";
                }
            }
            // Initialize the Twilio Client
            twilio:Client twilioClient = new ({
                accountSId: accountSId,
                authToken: authToken
            });
            twilio:SmsResponse result = check twilioClient->sendSms(twFromMobile, twToMobile, message);
        }     
    }
}
