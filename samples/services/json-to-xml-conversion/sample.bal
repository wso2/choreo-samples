import ballerina/http;
import ballerina/xmldata;

service http:Service / on new http:Listener(8090) {
    resource function post convert(http:Caller outboundEP, http:Request req) 
        returns xml | xmldata:Error? | http:ClientError? {
        var jsonMsg = req.getJsonPayload();
        if (jsonMsg is json) {
            var xmlMsg = xmldata:fromJson(jsonMsg);
            return xmlMsg;
        } else {
            var clientError = jsonMsg;
            return clientError;
        }
    }
}