import ballerina/http;
import ballerina/log;
import ballerinax/netsuite;
import ballerinax/salesforce as sfdc;
import ballerinax/trigger.salesforce as sfdcListener;


// Types
type SalesforceListenerConfig record {|
    string username;
    string password;
|};

type SalesforceOAuthConfig record {|
    string clientId;
    string clientSecret;
    string refreshToken;
    string refreshUrl;
|};

// Constants
const string EMPTY_STRING = "";
const string CHANNEL_NAME = "/data/AccountChangeEvent";

// Salesforce configuration parameters
configurable SalesforceListenerConfig salesforceListenerConfig = ?;
configurable SalesforceOAuthConfig salesforceOAuthConfig = ?;
configurable string salesforceBaseUrl = ?;


// Netsuite configuration parameters
configurable netsuite:ConnectionConfig netsuiteClientConfig = ?;
configurable string netsuiteSubsidiaryID = ?;

listener sfdcListener:Listener sfdcEventListener = new ({
    username: salesforceListenerConfig.username,
    password: salesforceListenerConfig.password,
    channelName: CHANNEL_NAME
});

@display { label: "Salesforce New Account to NetSuite New Customer" }
service sfdcListener:RecordService on sfdcEventListener {
    isolated remote function onCreate(sfdcListener:EventData payload) returns error? {
        string? accountId = payload?.metadata?.recordId;
        sfdc:Client sfdcClient = check new ({
            baseUrl: salesforceBaseUrl,
            auth: {
                clientId: salesforceOAuthConfig.clientId,
                clientSecret: salesforceOAuthConfig.clientSecret,
                refreshToken: salesforceOAuthConfig.refreshToken,
                refreshUrl: salesforceOAuthConfig.refreshUrl
            }
        });

        if accountId is () {
            return error("Account ID can not be null");
        } 

        json account = check sfdcClient-> getAccountById(accountId);
        netsuite:RecordInputRef subsidiary = {
            internalId: netsuiteSubsidiaryID,
            'type: netsuite:SUBSIDIARY
        };

        netsuite:NewCustomer customer = {
            companyName: let json|error value = account.Name in value is error ? EMPTY_STRING: value.toString(),
            phone:  let json|error value = account.Phone in value is error ? EMPTY_STRING: value.toString(),
            fax: let json|error value = account.Fax in value is error ? EMPTY_STRING: value.toString(),
            email: let json|error value = account.Email in value is error ? EMPTY_STRING: value.toString(),
            subsidiary: subsidiary,
            isInactive: false,
            accountNumber: let json|error value = account.accountNumber in value is error ? EMPTY_STRING: value.toString()
        };

        netsuite:Client netSuiteClient = check new ({
            accountId: netsuiteClientConfig.accountId,
            consumerId: netsuiteClientConfig.consumerId,
            consumerSecret: netsuiteClientConfig.consumerSecret,
            token: netsuiteClientConfig.token,
            tokenSecret: netsuiteClientConfig.tokenSecret,
            baseURL: netsuiteClientConfig.baseURL
        });

        netsuite:RecordAddResponse|error response = netSuiteClient->addNewCustomer(customer);
        if response is error {
            log:printError("New customer adding was not successful", response);
        } else {
            log:printInfo("New Customer adding was successful", response = response);
        }   
    }

    remote function onUpdate(sfdcListener:EventData payload) returns error? {}

    remote function onDelete(sfdcListener:EventData payload) returns error? {}

    remote function onRestore(sfdcListener:EventData payload) returns error? {}
}

service /ignore on new http:Listener(8090) {}
