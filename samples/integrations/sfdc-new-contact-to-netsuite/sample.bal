import ballerina/http;
import ballerina/log;
import ballerina/regex;
import ballerinax/netsuite;
import ballerinax/sfdc;

const string COMMA = ",";
const string EQUAL_SIGN = "=";
const string CLOSING_BRACKET = "}";
const string NO_STRING = "";
const string CHANNEL_NAME = "/data/ContactChangeEvent";

@display {label: "Salesforce Username"}
configurable string & readonly sfdcUsername = ?;

@display {
    kind: "password",
    label: "Salesforce Password"
}
configurable string & readonly sfdcPassword = ?;

@display {label: "NetSuite Account ID"}
configurable string & readonly nsAccountId = ?;

@display {label: "NetSuite Consumer ID"}
configurable string & readonly nsConsumerId = ?;

@display {label: "NetSuite Consumer Secret"}
configurable string & readonly nsConsumerSecret = ?;

@display {label: "NetSuite Token"}
configurable string & readonly nsToken = ?;

@display {label: "NetSuite Token Secret"}
configurable string & readonly nsTokenSecret = ?;

@display {label: "NetSuite Base URL"}
configurable string & readonly nsBaseURL = ?;

@display {label: "NetSuite Subsidiary ID"}
configurable string & readonly nsSubsidiaryID = ?;

sfdc:ListenerConfiguration sfdcListenerConfig = {
    username: sfdcUsername,
    password: sfdcPassword
};

listener sfdc:Listener sfdcEventListener = new (sfdcListenerConfig);

@sfdc:ServiceConfig {channelName: CHANNEL_NAME}
service on sfdcEventListener {
    remote function onCreate(sfdc:EventData contact) returns error? {
        json contactId = contact?.metadata?.recordId;
        map<json> contactMap = contact.changedData;
        string firstName = NO_STRING;
        string lastName = NO_STRING;
        json title = contactMap["Title"];
        json phone = contactMap["Phone"];
        json email = contactMap["Email"];
        json fax = contactMap["Fax"];
        string[] nameParts = regex:split(contactMap.get("Name").toString(), COMMA);
        if (nameParts.length() >= 2) {
            firstName = regex:split(nameParts[0], EQUAL_SIGN)[1];
            lastName = regex:split(regex:replaceFirst(nameParts[1], CLOSING_BRACKET, NO_STRING), EQUAL_SIGN)[1];
        } else {
            lastName = regex:split(regex:replaceFirst(nameParts[0], CLOSING_BRACKET, NO_STRING), EQUAL_SIGN)[1];
        }

        netsuite:RecordInputRef subsidiary = {
            internalId: nsSubsidiaryID,
            'type: netsuite:SUBSIDIARY
        };
        netsuite:NewContact newContact = {
            firstName: firstName,
            lastName: lastName,
            title: title.toString(),
            phone: phone.toString(),
            email: email.toString(),
            fax: fax.toString(),
            subsidiary: subsidiary
        };
        netsuite:Client netSuiteClient = check new ({
            accountId: nsAccountId,
            consumerId: nsConsumerId,
            consumerSecret: nsConsumerSecret,
            token: nsToken,
            tokenSecret: nsTokenSecret,
            baseURL: nsBaseURL
        });
        netsuite:RecordAddResponse output = check netSuiteClient->addNewContact(newContact);
        log:printInfo("Contact added successfully");
    }
}

service on new http:Listener(8090) {
    isolated resource function get .() returns http:Ok => {};
}
