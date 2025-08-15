import ballerina/test;
import ballerina/http;

http:Client testClient = check new ("http://localhost:8090");

// Test 1: Test greeting response for a specific name: Alice
@test:Config {}
function testGreetingForSpecificName() returns error? {
    http:Response response = check testClient->get("/?name=Alice");
    test:assertEquals(response.statusCode, 200);
    json payload = check response.getJsonPayload();
    Greeting greeting = check payload.cloneWithType(Greeting);
    test:assertEquals(greeting.'from, "Choreo");
    test:assertEquals(greeting.to, "Alice");
    test:assertEquals(greeting.message, "Welcome to Choreo!");
}

// Test 2: Test greeting response structure and types
@test:Config {}
function testGreetingResponseStructure() returns error? {
    http:Response response = check testClient->get("/?name=TestUser");
    test:assertEquals(response.statusCode, 200);
    json payload = check response.getJsonPayload();
    test:assertTrue(payload.'from is string);
    test:assertTrue(payload.to is string);
    test:assertTrue(payload.message is string);
}
