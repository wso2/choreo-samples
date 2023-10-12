import ballerina/http;

service / on new http:Listener(8090) {
    resource function post .(http:Request req) returns json|error {
        http:Client clientEP = check new ("https://postman-echo.com/post");
        json clientResponse = check clientEP->forward("/", req);
        return clientResponse;
    }
}
