import ballerina/http;
import ballerina/xmldata;

service / on new http:Listener(8090) {
    resource function post convert(@http:Payload xml xmlnMsg) returns json|error {
        json jsonMsg = check xmldata:toJson(xmlnMsg);
        return jsonMsg;
    }
}
