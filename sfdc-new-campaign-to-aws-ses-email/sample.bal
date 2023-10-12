import ballerina/http;
import ballerina/log;
import ballerinax/aws.ses;
import ballerinax/trigger.salesforce as sfdcListener;

// Types
type SalesforceListenerConfig record {
    string username;
    string password;
};

// Constants
const string CHANNEL_NAME = "/data/CampaignChangeEvent";

// Salesforce configuration parameters
configurable SalesforceListenerConfig salesforceListenerConfig = ?;

// Amazon SES configuration parameters
configurable ses:AwsCredentials awsCredentialsConfig = ?;
configurable string senderEmail = ?;
configurable string receiverEmail = ?;

final ses:Client amazonSesClient = check new({
    awsCredentials: {
        accessKeyId: awsCredentialsConfig.accessKeyId,
        secretAccessKey: awsCredentialsConfig.secretAccessKey
    }
});

listener sfdcListener:Listener sfdcEventListener = new ({
    username: salesforceListenerConfig.username,
    password: salesforceListenerConfig.password,
    channelName: CHANNEL_NAME
});

@display { label: "Salesforce New Campaign to AWS SES Email" }
service sfdcListener:RecordService on sfdcEventListener {
    isolated remote function onCreate(sfdcListener:EventData payload) returns error? {
        string message = "New Salesforce campaign created successfully! \n";
        map<json> campaignMap = payload.changedData;
        foreach [string, json] [key, value] in campaignMap.entries() {
            if value != () {
                message += string `${key} : ${value.toJsonString()}${"\n"}`;
            }
        }

        ses:EmailRequest req = {
            Content: {
                Simple: {
                    Body: {
                        Text: {
                            Charset: "UTF-8",
                            Data: message
                        }
                    },
                    Subject: {
                        Charset: "UTF-8",
                        Data: "New Salesforce Campaign!"
                    }
                }
            },
            Destination: {
                ToAddresses: [receiverEmail]
            },
            FromEmailAddress: senderEmail
        };
        ses:MessageSentResponse|error response = amazonSesClient->sendEmail(req);
        if (response is ses:MessageSentResponse) {
            log:printInfo("Email sent successfully!. Message ID : " + response.MessageId.toString());
        } else {
            log:printError("Failed to send email!", 'error = response);
        }
    }

    isolated remote function onUpdate(sfdcListener:EventData payload) returns error? {
        return;
    }

    isolated remote function onDelete(sfdcListener:EventData payload) returns error? {
        return;
    }

    isolated remote function onRestore(sfdcListener:EventData payload) returns error? {
        return;
    }
}

service /ignore on new http:Listener(8090) {}
