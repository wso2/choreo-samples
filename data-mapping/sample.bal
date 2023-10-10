import ballerina/http;
import ballerina/time;

type SummaryReport record {|
    string title;
    string firstName;
    string lastName;
    string gender;
    int age;
|};

// INFO: Use employeeNo 1-4 when invoking this service

service / on new http:Listener(8090) {
    resource function get summary/[string employeeNo]() returns SummaryReport|error {
        http:Client clientEP = check new ("https://samples.choreoapps.dev/company/hr/employee");
        json employeeData = check clientEP->get(string `/details/${employeeNo}`);

        SummaryReport person = {
            title: "Summarized Employee Information",
            firstName: check employeeData.firstName,
            lastName: check employeeData.lastName,
            gender: check employeeData.gender,
            age: check getTimeDifferenceInYears(check time:utcFromString(check employeeData.dateOfBirth), time:utcNow())
        };

        return person;
    }
}

function getTimeDifferenceInYears(time:Utc fromTime, time:Utc toTime) returns int|error {
    time:Seconds seconds = time:utcDiffSeconds(toTime, fromTime);
    decimal years = seconds.abs() / (24 * 365 * 3600);
    return <int>years.round();
}
