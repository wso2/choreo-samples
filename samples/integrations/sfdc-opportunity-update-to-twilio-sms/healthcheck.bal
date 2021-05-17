import ballerina/http;

service on new http:Listener(8090) {
    resource function get .(http:Caller caller, http:Request req) returns http:Response|error {
        http:Response resp = new;
        resp.statusCode = 200;
        return resp;
    }
}