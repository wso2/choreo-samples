import ballerina/http;
import ballerina/log;
// Schedule:  * * * * *

public function main() returns error? {
    http:Client healthCheckAPI = check new ("https://samples.choreoapps.dev");
    http:Response|error healthCheckResponse = healthCheckAPI->get("/company/hr/employee/1");
    if (healthCheckResponse is http:Response) {
        log:printInfo("API Status : Healthy");
    } else {
        log:printInfo("API Status : Unhealthy");
    }
}