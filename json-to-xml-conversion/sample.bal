import ballerina/http;
import ballerina/xmldata;

service / on new http:Listener(8090) {
    resource function post convert(@http:Payload json jsonMsg) returns xml|error? {
        xml? xmlMsg = check xmldata:fromJson(jsonMsg);
        return xmlMsg;
    }
}
