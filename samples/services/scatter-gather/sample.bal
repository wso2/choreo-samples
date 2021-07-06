import ballerina/http;

service / on new http:Listener(8090) {
    resource function post employees(http:Caller caller, http:Request req) returns json | error {
        http:Client locationEP = check new ("https://samples.choreoapps.dev");
        json jsonMsg = <json>check req.getJsonPayload();
        json[] idList = <json[]>check jsonMsg.employeeIds;
        json[] employeInfoList = [];
        foreach json id in idList {
            http:Response empResponse =
                    <http:Response> check locationEP->get("/company/hr/employee/" + id.toJsonString());
            json empResponseJson = <json>check empResponse.getJsonPayload();
            employeInfoList.push(empResponseJson);
        }
        json aggregatedResponse = {"EmployeeDetails" : employeInfoList};
        return aggregatedResponse;
    }
}