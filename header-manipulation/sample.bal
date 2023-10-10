import ballerina/http;
import ballerina/lang.array;
import ballerina/lang.value;
import ballerina/regex;

const string CHAR_SET = "UTF-8";
const string SEPARATOR_COLON = ":";
const string SEPARATOR_SPACE = " ";
const string CREDENTIALS_KEY = "credentials";

service / on new http:Listener(8090) {
    resource function get home(@http:Header {name: "x-authorization"} string? headerValue)
                        returns string|http:Unauthorized|http:BadRequest|error {
        if headerValue is () {
            return <http:Unauthorized>{headers: {"WWW-Authenticate": "Basic realm=\"my-organization\""}};
        }

        string filteredHeader = <string>headerValue;

        if !filteredHeader.includes(SEPARATOR_SPACE, 0) {
            return <http:BadRequest>{body: "Unexpected authorization header format."};
        }

        string[] authorizationTuple = regex:split(filteredHeader, SEPARATOR_SPACE);

        if authorizationTuple.length() < 2 {
            return <http:BadRequest>{body: "Unexpected authorization header format."};
        }

        if authorizationTuple[0] == "Basic" {
            http:Client locationEP = check new ("http://localhost:8090");
            string payload = string `${CREDENTIALS_KEY}=${authorizationTuple[1]}`;
            boolean response = check locationEP->post("/authenticate", payload,
                                                    mediaType = "application/x-www-form-urlencoded",
                                                    targetType = boolean);
            if response {
                return "Welcome!";
            }
        }

        return <http:Unauthorized>{};
    }

    resource function post authenticate(http:Request req) returns boolean|http:BadRequest|error {
        map<string> formParams = check req.getFormParams();

        if formParams.hasKey(CREDENTIALS_KEY) {
            byte[] base64DecodedBytes = check array:fromBase64(formParams.get(CREDENTIALS_KEY));
            string userNamePasswordPair = check string:fromBytes(base64DecodedBytes);

            if !userNamePasswordPair.includes(SEPARATOR_COLON, 0) {
                http:BadRequest response = {body: "Unexpected credentials format."};
                return response;
            }

            string[] tuple = regex:split(userNamePasswordPair, SEPARATOR_COLON);

            if tuple.length() < 2 {
                return <http:BadRequest>{body: "Unexpected credentials format."};
            }

            _ = getUserDataAsJson();
            json[] users = check value:ensureType(getUserDataAsJson().users);
            string providedUserName = tuple[0];
            string providedPassword = tuple[1];
            foreach json item in users {
                string userName = check item.userName;
                string password = check item.password;
                if userName == providedUserName && password == providedPassword {
                    return true;
                }
            }
        }
        return false;
    }
}

function getUserDataAsJson() returns json => {
    users: [
        {
            name: "Ali Baba",
            userName: "alibaba",
            password: "opensesame"
        },
        {
            name: "Jack",
            userName: "jack",
            password: "beans"
        }
    ]
};
