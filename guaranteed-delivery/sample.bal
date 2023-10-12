import ballerina/http;
import ballerina/lang.'string as str;
import ballerina/lang.value;
import ballerina/log;
import ballerinax/asb;
import ballerinax/googleapis.sheets as sheets;
import ballerinax/trigger.asb as asbTrigger;

// Constants
const HEADINGS_ROW = 1;

// ASB configuration parameters
configurable string connectionString = ?;
configurable string queueName = ?;

// google sheet configuration parameters
configurable string spreadsheetId = ?;
configurable string worksheetName = ?;

// HTTP service that allows JSON payload to be send in POST request
// This JSON will be pushed to a queue in Azure Service Bus in form of a message.
service / on new http:Listener(8090) {
    resource function post store(@http:Payload json jsonMsg) returns error? {
        check sendMessageToAsbQueue(jsonMsg);
    }
}

configurable record {
    string clientId;
    string clientSecret;
    string refreshToken;
    string refreshUrl = "https://www.googleapis.com/oauth2/v3/token";
} gSheetAuthConfig = ?;

sheets:Client spreadsheetClient = check new ({
    auth: {
        clientId: gSheetAuthConfig.clientId,
        clientSecret: gSheetAuthConfig.clientSecret,
        refreshToken: gSheetAuthConfig.refreshToken,
        refreshUrl: gSheetAuthConfig.refreshUrl
    }
});

// Azure service bus listener configuration
asbTrigger:ListenerConfig configuration = {
    connectionString,
    entityPath: queueName,
    receiveMode: asbTrigger:PEEKLOCK
};

listener asbTrigger:Listener asbListener = new (configuration);

type JSONrecord record{|
    string id;
    string name;
    json ...;
|};

final string[] & readonly columnNames = [
    "ID",
    "Name"
];

service asbTrigger:MessageService on asbListener {
    remote function onMessage(asbTrigger:Message message, asbTrigger:Caller caller) returns error? {
        json jsonMessage = {};
        if message?.contentType == asbTrigger:JSON {
            if message.body is byte[] {
                string stringMessage = check str:fromBytes(<byte[]> message.body);
                log:printInfo("The message received with JSON payload: " + stringMessage.toString());
                jsonMessage = check value:fromJsonString(stringMessage);
            }
        }
        JSONrecord jsonRecord = check jsonMessage.cloneWithType();

        error? result = appendSheetWithNewRecord(jsonRecord); //remove var

        // If message was not appended to sheet correctly, message will be abadoned 
        // from the queue. That means message is returned immediately back to the queue 
        // to be picked up again. Then onMessage() will be triggered again with the same 
        // message. 
        if result is error {
            log:printError(result.message());
            asbTrigger:Error? abandonResult = caller.abandon(message);
            if abandonResult is error {
                log:printError("Error while abandoning the message. It will get discarded " + abandonResult.message());
                return;
            }
            log:printInfo("Failed to deliver the message received. It was Abandoned successfully and application will retry to deliver when it is received again.");
            return;
        }
        log:printInfo("Received message is successfully delivered.");          
        asbTrigger:Error? completeResult = caller.complete(message);  
        if completeResult is error {
            log:printError("Error while completing successfully delivered message " + completeResult.message());
            return;
        }
        log:printInfo("Completed successfully delivered message.");
    }
}

function appendSheetWithNewRecord(JSONrecord jsonRecord) returns @tainted error? {

    sheets:Row existingColumnNames = check spreadsheetClient->getRow(spreadsheetId, worksheetName, HEADINGS_ROW);
    if existingColumnNames.values.length() == 0 {
        check spreadsheetClient->appendRowToSheet(spreadsheetId, worksheetName, columnNames);
    }
    check spreadsheetClient->appendRowToSheet(spreadsheetId, worksheetName, [jsonRecord.id, jsonRecord.name]);
    log:printInfo("New row appended to GSheet successfully!");

}

function sendMessageToAsbQueue(json jsonMsg) returns @tainted error? {

    // Validate the JSON
    _ = check jsonMsg.cloneWithType(JSONrecord);

    asb:Message message = {
        body: jsonMsg,
        contentType: asb:JSON,
        timeToLive: 60
    };

    // Initiating a queue sender.
    asb:MessageSender queueSender = check new (connectionString, queueName);

    log:printInfo("Sending via Asb sender client.");
    check queueSender->send(message);

    log:printInfo("Closing Asb sender client.");
    check queueSender->close();  
}
