import ballerina/http;

type Request record {|
    string item;
|};

service / on new http:Listener(8090) {
    resource function post route(@http:Payload Request payload) returns json|error {
        http:Client locationEP = check new ("https://samples.choreoapps.dev/company/hr");
        string itemString = payload.item;

        string path = itemString == "employee" ? "/employee/1" : "/department/1";
        json response = check locationEP->get(path);
        return response;
    }
}
