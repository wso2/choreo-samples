import ballerina/http;

service http:Service / on new http:Listener(8090) {
    resource function get employee/[string employeeId]() returns json|http:NotFound|http:InternalServerError|error {
        http:Client clientEP = check new ("https://samples.choreoapps.dev");
        var empResponse = <http:Response>check clientEP->get("/company/hr/employee/" + employeeId);
        if (empResponse.statusCode == http:STATUS_NOT_FOUND) {
            http:NotFound notFound = {};
            return notFound;
        }

        json employeeData = check empResponse.getJsonPayload();
        string departmentId = check employeeData.departmentId;
        string firstName = check employeeData.firstName;
        string lastName = check employeeData.lastName;
        string title = check employeeData.title;

        var deptResponse = <http:Response>check clientEP->get("/company/hr/department/" + departmentId);
        if (deptResponse.statusCode == http:STATUS_NOT_FOUND) {
            http:InternalServerError serverError = {};
            return serverError;
        }

        json departmentData = check deptResponse.getJsonPayload();
        string departmentName = check departmentData.name;
        json summary = {
            name: firstName + " " + lastName,
            title: title,
            department: departmentName
        };
        return summary;
    }
}
