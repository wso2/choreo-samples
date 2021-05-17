import ballerina/io;
import ballerinax/sfdc;
import ballerinax/twilio;

// Constants
const string TOPIC_PREFIX = "/topic/";
const string TYPE_UPDATED = "updated";

// Salesforce configuration parameters
@display { label: "SalesForce User name" }
configurable string & readonly username = ?;
@display { label: "SalesForce Password" }
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
    remote function onEvent(json opportunity) returns error? {
        io:StringReader sr = new (opportunity.toJsonString());
        json opportunityInfo = check sr.readJson();  
        json eventType = check opportunityInfo.event.'type;                
        if (TYPE_UPDATED.equalsIgnoreCaseAscii(eventType.toString())) {
            json opportunityId = check opportunityInfo.sobject.Id;            
            json opportunityObject = check opportunityInfo.sobject; 
            string message = "Salesforce opportunity updated successfully! \n";
            map<json> opportunityMap = <map<json>> opportunityObject;

            foreach var entry in opportunityMap.entries() {
                if(entry[1] != ()) {
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
