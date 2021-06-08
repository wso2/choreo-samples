import ballerina/http;

service http:Service / on new http:Listener(8090) {
    resource function get route(http:Caller outboundEP, http:Request req) returns http:Response | error {
        http:Client locationEP = check new ("https://samples.choreoapps.dev");
        string headerValue = check req.getHeader("x-item");

        if (headerValue == "employee") {
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
