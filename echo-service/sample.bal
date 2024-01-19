import ballerina/http;
import ballerina/log;

// MySQL configuration parameters
configurable string name = ?;
configurable string location = ?;
configurable string age = "20";
configurable string school = ?;

service / on new http:Listener(8090) {
    resource function post .(@http:Payload string textMsg) returns string {
        log:printInfo(name + location + age + school);
        return textMsg;
    }
}
