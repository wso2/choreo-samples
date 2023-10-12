import ballerina/http;

type Employee record {|
    string name;
    string title;
    string department;
|};

service / on new http:Listener(8090) {
    resource function get employee/[string employeeId]() returns Employee|error? {
        http:Client clientEP = check new ("https://samples.choreoapps.dev/company/hr");
        json employeeData = check clientEP->get("/employee/" + employeeId);

        string departmentId = check employeeData.departmentId;
        string firstName = check employeeData.firstName;
        string lastName = check employeeData.lastName;
        string title = check employeeData.title;

        json departmentData = check clientEP->get("/department/" + departmentId);

        string departmentName = check departmentData.name;
        Employee summary = {
            name: firstName + " " + lastName,
            title: title,
            department: departmentName
        };
        return summary;
    }
}
