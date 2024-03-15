import ballerina/http;
import ballerina/config;

// Define a configurable string variable
configurable string greetingSuffix = "";

service /hello on new http:Listener(8090) {
  resource function get greeting() returns string {
    // Access the configurable string and concatenate with "Hello, World!"
    return "Hello, World!" + greetingSuffix;
  }
}
