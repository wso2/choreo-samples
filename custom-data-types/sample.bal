import ballerina/http;

type Student record {|
    string studentId;
    string firstName;
    string lastName;
    decimal mathematics;
    decimal science;
    decimal arts;
|};

type GradingReport record {|
    string studentId;
    decimal averageGrade;
|};

// INFO: Pass a JSON such as {"studentId": "1874", "firstName": "Jane", "lastName":"Smith", "mathematics" : 85, "science" : 75, "arts":80} in the request body
//       when invoking the grades resource function.
service / on new http:Listener(8090) {
    resource function post average_grade(@http:Payload Student student) returns GradingReport => {
        studentId: student.studentId,
        averageGrade: (student.mathematics + student.science + student.arts) / 3
    };
}
