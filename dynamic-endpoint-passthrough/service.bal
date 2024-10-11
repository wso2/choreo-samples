import ballerina/http;

configurable string invoke_url = ?;

service / on new http:Listener(9090) {
    resource function get greeting(string name) returns json|error {
        http:Client clientEP = check new (invoke_url);

        return check clientEP->/(name = name);
    }
}

