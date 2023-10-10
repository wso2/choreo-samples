import ballerina/http;

type Name record {|
    string firstName;
    string lastName;
|};

type Address record {|
    string streetAddress;
    string city;
|};

type AdditionalInfo record {|
    string dateOfBirth;
|};

type Employee record {|
    Name name;
    Address address;
    AdditionalInfo additionalInfo;
|};

type AggregatedEmployee record {|
    string name;
    string address;
    string dob;
|};

service / on new http:Listener(8090) {
    resource function post .(@http:Payload Employee employee) returns AggregatedEmployee {
        AggregatedEmployee response = {
            name: employee.name.firstName + " " + employee.name.lastName,
            address: employee.address.streetAddress + "," + employee.address.city,
            dob: employee.additionalInfo.dateOfBirth
        };
        return response;
    }
}
