import ballerina/http;

// INFO: Pass a JSON such as {"name":"Grade 1-A","teacher":{"name":"Katherine Peterson","phone-number":"+447458197233"},"students":[{"name":"Tom Johnson","phone-number":"+447422134277"},{"name":"Anne Stevenson","phone-number":"+447476488899"},{"name":"Jason David","phone-number":"+447466548798"}]} in the request body
//       when invoking the grades resource function.
service / on new http:Listener(8090) {
    resource function post phone_numbers(@http:Payload json classDetails) returns json|error {
        string[] phoneNumbers = [];
        json[] students = check classDetails.students.ensureType();
        phoneNumbers.push(check classDetails.teacher.phone\-number.ensureType(string));
        foreach json student in students {
            phoneNumbers.push(check student.phone\-number.ensureType(string));
        }

        return {
            className: check classDetails.name.ensureType(string),
            phone\-numbers: phoneNumbers
        };
    }
}
