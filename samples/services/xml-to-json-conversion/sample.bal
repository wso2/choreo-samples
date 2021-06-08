import ballerina/http;
import ballerina/xmldata;

service http:Service / on new http:Listener(8090) {
    resource function post convert(http:Caller outboundEP, http:Request req) returns json | error? {
        xml xmlnMsg = check req.getXmlPayload();
        json jsonMsg = check xmldata:toJson(xmlnMsg);
        return jsonMsg;
    }
}

