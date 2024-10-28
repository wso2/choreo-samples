import ballerina/http;
import ballerina/log;

configurable string invoke_url = ?;
configurable string invoke_resource = ?;

isolated  http:Client httpClient = check new (invoke_url);

service /readinglist on new http:Listener(9090) {

    isolated resource function get invoke() returns json|error? {
        log:printInfo("get invoked");
        lock {
            json payload = check httpClient->get(invoke_resource);
            return payload.clone();
        }
    }
}

