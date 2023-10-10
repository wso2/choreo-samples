import ballerina/http;
import ballerina/log;
import ballerina/regex;
import ballerina/time;
import ballerinax/pipedrive;
import ballerinax/trello;

// Pipedrive configuration parameters
@display {label: "Pipedrive API Keys Configuration", description: "The API keys configuration of the Pipedrive client"}
configurable pipedrive:ApiKeysConfig pipedriveApiKeysConfig = ?;

// Trello configuration parameters
@display {label: "Trello API Keys Configuration", description: "The API keys configuration of the Trello client"}
configurable trello:ApiKeysConfig trelloApiKeysConfig = ?;
@display {label: "Trello List ID", description: "ID of the Trello list that the card should be added to"}
configurable string idList = ?;

pipedrive:Client pipedriveClient = check new (pipedriveApiKeysConfig);
trello:Client trelloClient = check new (trelloApiKeysConfig);

public function main() returns error? {
    string today = regex:split(time:utcToString(time:utcNow()), "T")[0];
    pipedrive:GetActivitiesResponse200 pipedriveResponse = check pipedriveClient->getActivities('type = "task", 
        startDate = today, done = 0);
    pipedrive:ActivityResponseObjectData[] data = pipedriveResponse?.data ?: [];
    
    if data.length() == 0 {
        return error("Pipedrive activities are empty.");
    }

    foreach pipedrive:ActivityResponseObjectData item in data {
        trello:Cards card = {
            idList,
            name: item?.subject ?: "",
            desc: item?.note ?: "",
            due: item?.due_date ?: ""
        };
        http:Response|error trelloResponse = trelloClient->addCards(card);
        if trelloResponse is error {
            log:printError(string `Failed to add Pipedrive activity with subject "${item?.subject ?: "Nil"}"`);
            continue;
        }
        log:printInfo(string `Pipedrive activity with subject ${
            item?.subject ?: "Nil"} added to Trello successfully!`);
    }
}
