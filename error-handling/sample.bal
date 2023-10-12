import ballerina/http;

const string NON_EXISTING_ENDPOINT = "http://nonexistentEP/mock";

// INFO: Use the query parameter option 0 or 1 when invoking this service
service / on new http:Listener(8090) {
    resource function post invoke(int option) returns string|http:NotFound|http:BadRequest|error {
        if (option == 0) {
            http:Client endpoint = check new (NON_EXISTING_ENDPOINT);
            http:Response response = check endpoint->get("/");

            return response.getTextPayload();
        } else if (option == 1) {
            http:Client endpoint = check new (NON_EXISTING_ENDPOINT);
            http:Response|error response = endpoint->get("/");

            if response is error {
                return <http:NotFound>{body: "Cannot access " + NON_EXISTING_ENDPOINT};
            } else {
                return response.getTextPayload();
            }
        }

        return <http:BadRequest>{body: "Unknown option. Please give one of the options [0 or 1]"};
    }
}
