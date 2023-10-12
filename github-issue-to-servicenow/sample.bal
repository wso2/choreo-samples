import ballerina/http;
import ballerina/log;
import ballerinax/servicenow;
import ballerinax/trigger.github;

const DATABASE = "database";
const HARDWARE = "hardware";
const INQUIRY = "inquiry";
const NETWORK = "network";
const NONE = "";
const SOFTWARE = "software";

const HIGH = 1;
const MEDIUM = 2;
const LOW = 3;

const INCIDENT = "incident";

type Category DATABASE|HARDWARE|INQUIRY|NETWORK|NONE|SOFTWARE;

type Urgency HIGH|MEDIUM|LOW;

type Impact HIGH|MEDIUM|LOW;

type ServiceNowIncident record {|
    string short_description;
    string description;
    Category category;
    Urgency urgency = LOW;
    Impact impact = MEDIUM;
|};

type CreatedServiceNowIncident record {
    string number;
    string sys_id;
    string opened_at;
    string sys_created_by;
};

type CreatedIncidentResponse record {
    CreatedServiceNowIncident result;
};

// ServiceNow configuration parameters
configurable http:CredentialsConfig serviceNowConfig = ?;
configurable string serviceNowURL = ?;

// Github configuration parameters
configurable github:ListenerConfig gitHubListenerConfig = ?;

listener http:Listener httpListener = new(8090);
listener github:Listener gitHubListener = new (gitHubListenerConfig, httpListener);

@display { label: "GitHub New Issue to ServiceNow Record" }
service github:IssuesService on gitHubListener {

    remote function onOpened(github:IssuesEvent payload) returns error? {
        github:Issue issue = payload.issue;

        servicenow:Client|error serviceNowClient = new ({auth: serviceNowConfig}, serviceNowURL);

        if serviceNowClient is error {
            log:printError("Error during ServiceNow client creation", serviceNowClient);
            return;
        }
        ServiceNowIncident incident = {
            short_description: issue.title,
            description: issue.body ?: "",
            category: SOFTWARE
        };
        string tableName = INCIDENT;

        json|error response = serviceNowClient->createRecord(tableName, incident);

        if response is error {
            log:printError(string`"Error while insert issue ${issue.number} into ServiceNow incident table."`,
                           response);
            return;
        }
        CreatedIncidentResponse|error createdIncident = response.cloneWithType();
        if createdIncident is error {
            log:printError(createdIncident.toString(), createdIncident);
            return;
        }
        string number = createdIncident.result.number;
        string sys_created_by = createdIncident.result.sys_created_by;
        string sys_id = createdIncident.result.sys_id;
        log:printInfo(string`"Incident No: ${number} is created by ${sys_created_by} with sys_id: ${sys_id}
        referring to Github issue ${issue.number}"`);
    }
    remote function onClosed(github:IssuesEvent payload) returns error? {
        return;
    }
    remote function onReopened(github:IssuesEvent payload) returns error? {
        return;
    }
    remote function onAssigned(github:IssuesEvent payload) returns error? {
        return;
    }
    remote function onUnassigned(github:IssuesEvent payload) returns error? {
        return;
    }
    remote function onLabeled(github:IssuesEvent payload) returns error? {
        return;
    }
    remote function onUnlabeled(github:IssuesEvent payload) returns error? {
        return;
    }
}

service /ignore on httpListener {}
