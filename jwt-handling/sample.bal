import ballerina/http;
import ballerina/jwt;
import ballerina/time;
import ballerina/io;

// INFO: Use a JWT as the jwt query parameter when invoking this service
service / on new http:Listener(8090) {
    resource function post extract(string jwt) returns json|http:BadRequest|error {
        [jwt:Header, jwt:Payload] [header, payload] = check jwt:decode(jwt);
        string? signingAlgorithm = header["alg"];
        int? exp = payload["exp"];
        string? issuer = payload["iss"];
        string? subject = payload["sub"];
        if exp is int{io:println(exp);}
        if (!(signingAlgorithm is ()) && !(issuer is ()) && !(subject is ()) && !(exp is ())) {
            boolean hasExpierd = (exp - time:utcNow()[0]) < 0;
            return {issuer, subject, signingAlgorithm, hasExpierd};
        } else {
            return <http:BadRequest>{body: "Unexpected JWT format."};
        }
    }
}
