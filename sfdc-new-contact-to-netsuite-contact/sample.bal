import ballerina/http;
import ballerina/log;
import ballerina/regex;
import ballerinax/netsuite;
import ballerinax/trigger.salesforce as sfdcListener;

// Types
type SalesforceListenerConfig record {
    string username;
    string password;
};

// Constants
const string COMMA = ",";
const string EQUAL_SIGN = "=";
const string CLOSING_BRACKET = "}";
const string NO_STRING = "";
const string CHANNEL_NAME = "/data/ContactChangeEvent";

// Salesforce configuration parameters
configurable SalesforceListenerConfig salesforceListenerConfig = ?;

// Netsuite configuration parameters
configurable netsuite:ConnectionConfig netsuiteClientConfig = ?;
configurable string netsuiteSubsidiaryID = ?;

listener sfdcListener:Listener sfdcEventListener = new ({
    username: salesforceListenerConfig.username,
    password: salesforceListenerConfig.password,
    channelName: CHANNEL_NAME
});

@display { label: "Salesforce New Contact to NetSuite New Contact" }
service sfdcListener:RecordService on sfdcEventListener {
    isolated remote function onCreate(sfdcListener:EventData payload) returns error? {
        map<json> contactMap = payload.changedData;
        string firstName = NO_STRING;
        string lastName = NO_STRING;
        json title = contactMap["Title"];
        json phone = contactMap["Phone"];
        json email = contactMap["Email"];
        json fax = contactMap["Fax"];
        string[] nameParts = regex:split(contactMap.get("Name").toString(), COMMA);
        if nameParts.length() >= 2 {
            firstName = regex:split(nameParts[0], EQUAL_SIGN)[1];
            lastName = regex:split(regex:replaceFirst(nameParts[1], CLOSING_BRACKET, NO_STRING), EQUAL_SIGN)[1];
        } else {
            lastName = regex:split(regex:replaceFirst(nameParts[0], CLOSING_BRACKET, NO_STRING), EQUAL_SIGN)[1];
        }

        netsuite:RecordInputRef subsidiary = {
            internalId: netsuiteSubsidiaryID,
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
            accountId: netsuiteClientConfig.accountId,
            consumerId: netsuiteClientConfig.consumerId,
            consumerSecret: netsuiteClientConfig.consumerSecret,
            token: netsuiteClientConfig.token,
            tokenSecret: netsuiteClientConfig.tokenSecret,
            baseURL: netsuiteClientConfig.baseURL
        });
        _ = check netSuiteClient->addNewContact(newContact);
        log:printInfo("Contact added successfully");
    }

    remote function onUpdate(sfdcListener:EventData payload) returns error? {
        return;
    }

    remote function onDelete(sfdcListener:EventData payload) returns error? {
        return;
    }

    remote function onRestore(sfdcListener:EventData payload) returns error? {
        return;
    }
}

service /ignore on new http:Listener(8090) {}
