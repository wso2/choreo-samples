import ballerina/http;

service http:Service / on new http:Listener(8090) {
    resource function post route(http:Caller outboundEP, http:Request req) returns http:Response | error {
        http:Client locationEP =  check new ("https://samples.choreoapps.dev");
        json jsonMsg = <json> check req.getJsonPayload();
        json itemString = <json> check jsonMsg.item;
            
        if (itemString.toString() == "employee") {
            http:Response empResponse =
                <http:Response> check locationEP->get("/company/hr/employee/1");
            return empResponse;
        } else {
            http:Response deptResponse =
                <http:Response> check locationEP->get("/company/hr/department/1");
            return deptResponse;
        }
    }
}

