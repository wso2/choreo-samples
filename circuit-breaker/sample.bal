import ballerina/http;

final http:Client cbrBackend = check new ("http://localhost:8090", {
    circuitBreaker: {
        rollingWindow: {
            timeWindow: 10,
            bucketSize: 2,
            requestVolumeThreshold: 0
        },
        failureThreshold: 0.2,
        resetTime: 10,
        statusCodes: [400, 404, 500]
    },
    timeout: 2
});

service / on new http:Listener(8090) {

    private int counter = 1;

    resource function get gateway() returns string|error {
        string payload = check cbrBackend->get("/hello");
        return payload;
    }
        
    resource function get hello() returns string|http:InternalServerError {
        lock {
            if self.counter % 5 == 3 {

                self.counter += 1;
                return {body: string `Error occurred while processing the request ${self.counter - 1}.`};
            } else {

                self.counter += 1;

                return string `Request ${self.counter - 1} processed successfully.`;
            }
        }
    }
}
