import ballerina/http;

service / on new http:Listener(8090) {
    resource function post .(http:Caller caller, http:Request req) returns json | http:Response | error {
        json message = check req.getJsonPayload();
        if ( message.name.firstName is json && message.name.lastName is json 
            &&  message.address.streetAddress is json &&  message.address.city is json 
            &&  message.additionalInfo.dateOfBirth is json) {
            string fullName =  <string> check message.name.firstName + <string> check message.name.lastName;
            string address = <string> check message.address.streetAddress + "," + <string> check message.address.city;
            string dateOfBirth = <string> check message.additionalInfo.dateOfBirth;
            json response = {
                "name" : fullName,
                "address" : address,
                "dob": dateOfBirth
            };
            return response;
        } else {
            http:Response errorResponse = new;
            errorResponse.statusCode = 500;
            errorResponse.setPayload("Expected fields are not present in Request payload");
            return errorResponse;
        }
    }
}