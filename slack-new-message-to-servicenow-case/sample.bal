import ballerina/http;
import ballerina/log;
import ballerinax/servicenow;
import ballerinax/trigger.slack as slackListener;

const string CASE_TABLE = "sn_customerservice_case";

type CreatedServiceNowCase record {
    string number;
    string sys_id;
    string opened_at;
};

type CreatedCaseResponse record {
    CreatedServiceNowCase result;
};

// Slack configuration parameters
configurable string slackVerificationToken = ?;
configurable string slackChannelId = ?;

// ServiceNow configuration parameters
configurable http:CredentialsConfig serviceNowConfig = ?;
configurable string serviceNowURL = ?;

listener http:Listener httpListener = new (8090);
listener slackListener:Listener slackEventListener = new ({
    verificationToken: slackVerificationToken
}, httpListener);

service slackListener:MessageService on slackEventListener {
    isolated remote function onMessage(slackListener:Message payload) returns error? {
        if slackChannelId == payload.event.channel {
            servicenow:Client|error serviceNowClient = new ({auth: serviceNowConfig}, serviceNowURL);
            if serviceNowClient is error {
                log:printError("Error during ServiceNow client creation", serviceNowClient);
                return;
            }

            json case = {
                short_description: payload.event["text"].toString(),
                description: string `Created via Slack by Slack user ${payload.event["user"].toString()}`
            };
            json|error response = serviceNowClient->createRecord(CASE_TABLE, case);
            if response is error {
                log:printError(string `"Error while insert message ${payload.event_id} into ServiceNow case table."`,
                            response);
                return;
            }

            CreatedCaseResponse|error createdCase = response.cloneWithType();
            if createdCase is error {
                log:printError(createdCase.toString(), createdCase);
                return;
            }
            string number = createdCase.result.number;
            string sys_id = createdCase.result.sys_id;
            log:printInfo(string
            `"Case No: ${number} is created with sys_id: ${sys_id} referring to Slack event ${payload.event_id}"`);
        }
    }

    remote function onMessageAppHome(slackListener:GenericEventWrapper payload) returns error? {
        return;
    }

    remote function onMessageChannels(slackListener:GenericEventWrapper payload) returns error? {
        return;
    }

    remote function onMessageGroups(slackListener:GenericEventWrapper payload) returns error? {
        return;
    }

    remote function onMessageIm(slackListener:GenericEventWrapper payload) returns error? {
        return;
    }

    remote function onMessageMpim(slackListener:GenericEventWrapper payload) returns error? {
        return;
    }
}

service /ignore on httpListener {
}
