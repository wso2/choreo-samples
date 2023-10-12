import ballerina/http;

type Request record {|
    int[] employeeIds;
|};

type Employees record {|
    json[] employeeDetails;
|};

service / on new http:Listener(8090) {
    resource function post employees(@http:Payload Request payload) returns Employees|error? {
        http:Client locationEP = check new ("https://samples.choreoapps.dev/company/hr");
        int[] idList = payload.employeeIds;
        json[] employeInfoList = [];
        foreach int id in idList {
            json empResponseJson = check locationEP->get(string `/employee/${id}`);
            employeInfoList.push(empResponseJson);
        }
        Employees aggregatedResponse = {employeeDetails: employeInfoList};
        return aggregatedResponse;
    }
}
