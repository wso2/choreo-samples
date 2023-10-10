import ballerina/http;

service / on new http:Listener(8090) {
    resource function post .(@http:Payload string textMsg) returns string {
        return textMsg;
    }
}
