import ballerina/http;

service / on new http:Listener(8090) {
    resource function get route(@http:Header {name: "x-item"} string headerValue) returns json|error {
        http:Client locationEP = check new ("https://samples.choreoapps.dev/company/hr");

        string path = headerValue == "employee" ? "/employee/1" : "/department/1";
        json response = check locationEP->get(path);
        return response;
    }
}
