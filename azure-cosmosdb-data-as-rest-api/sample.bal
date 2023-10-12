import ballerina/http;
import ballerinax/azure_cosmosdb as cosmosdb;

configurable string baseUrl = ?;
configurable string containerId = ?;
configurable string databaseId = ?;
configurable string primaryKeyOrResourceToken = ?;

type Employee record {
    string empId;
    string firstName;
    string? lastName?;
    string email;
    string designation;
};

final cosmosdb:DataPlaneClient cosmosClient = check new ({
    baseUrl,
    primaryKeyOrResourceToken
});

service / on new http:Listener(8090) {

    isolated resource function post employees(@http:Payload Employee payload) returns error? {
        string id = payload.empId;
        json empJson = check payload.cloneWithType(json);
        _ = check cosmosClient->createDocument(databaseId, containerId, id, <map<json>>empJson, id);
    }

    isolated resource function get employees/[string empId]() returns Employee|error {
        return cosmosClient->getDocument(databaseId, containerId, empId, empId);
    }

    isolated resource function put employees(@http:Payload Employee payload) returns error? {
        string id = payload.empId;
        json empJson = check payload.cloneWithType(json);
        _ = check cosmosClient->replaceDocument(databaseId, containerId, id, <map<json>>empJson, id);
    }

    isolated resource function delete employees/[string empId]() returns error? {
        _ = check cosmosClient->deleteDocument(databaseId, containerId, empId, empId);
    }

}
