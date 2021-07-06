import ballerina/http;

service / on new http:Listener(8090) {
    resource function post .(http:Caller caller, http:Request req) returns http:Response | error {
        http:Client clientEP = check new ("https://postman-echo.com/post");
        var clientResponse = <http:Response> check clientEP->forward("/", req);
        return clientResponse;
    }
}