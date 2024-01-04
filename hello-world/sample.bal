import ballerina/http;

type Greeting record {|
    string to;
    string content;
|};

configurable Greeting greeting = ?;

service /hello on new http:Listener(8090) {
    resource function get greeting() returns string {
        string message = string `Hello ${greeting.to}! ${greeting.content}`;
        return message;
    }
}
