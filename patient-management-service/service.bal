import ballerina/http;
import ballerina/log;

// In-memory patient store
map<json> patients = {};

service /mediflow on new http:Listener(9090) {

    // Health check endpoint
    resource function get health(http:Caller caller, http:Request req) returns error? {
        log:printInfo("Health check endpoint invoked");
        check caller->respond({"status": "MediFlow is operational"});
    }

    // Add a new patient
    resource function post patients(http:Caller caller, http:Request req) returns error? {
        json|error payload = req.getJsonPayload();
        if payload is json {
            string name = check payload.name;
            if name is string {
                name = name.toLowerAscii();
                patients[name] = payload;
                log:printInfo("Added patient: " + name);
                check caller->respond({"message": "Patient added", "patient": payload});
            }
        } else {
            check caller->respond("Invalid JSON payload");
        }
    }

    // Retrieve a patient by name
    resource function get patients/[string name](http:Caller caller, http:Request req) returns error? {
        string lowerCaseName = name.toLowerAscii();
        json? patient = patients[lowerCaseName];
        if patient is json {
            check caller->respond(patient);
        }
        return caller->respond(string `Patient ${name} not found`);
    }

    // List all patients
    resource function get patients(http:Caller caller, http:Request req) returns error? {
        check caller->respond(patients);
    }
}
