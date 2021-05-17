import ballerina/http;

service http:Service on new http:Listener(8090) {
    resource function get employee/[string employeeId] (http:Caller caller, http:Request req) returns json | int | error {
        http:Client clientEP = check new ("https://samples.choreoapps.dev");
        var empResponse = <http:Response>check clientEP->get("/company/hr/employee/" + employeeId);
        if (empResponse.statusCode == http:STATUS_NOT_FOUND) {
            return http:STATUS_NOT_FOUND;
        }

        json employeeData = check empResponse.getJsonPayload();
        string departmentId = <string>check employeeData.departmentId;
        string firstName = <string>check employeeData.firstName;
        string lastName = <string>check employeeData.lastName;
        string title = <string>check employeeData.title;

        var deptResponse = <http:Response>check clientEP->get("/company/hr/department/" + departmentId);
        if (deptResponse.statusCode == http:STATUS_NOT_FOUND) {
            return http:STATUS_INTERNAL_SERVER_ERROR;
        }

        json departmentData = check deptResponse.getJsonPayload();
        string departmentName = <string>check departmentData.name;
        json summary = {
            name: firstName + " " + lastName,
            title: title,
            department: departmentName
        };

        return summary;
    }
}
