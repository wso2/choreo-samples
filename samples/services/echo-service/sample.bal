import ballerina/http;

service / on new http:Listener(8090) {
    resource function post .(http:Caller caller, http:Request req) returns string | error {
        return req.getTextPayload();
    }
}
