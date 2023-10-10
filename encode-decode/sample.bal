import ballerina/http;
import ballerina/lang.array;
import ballerina/regex;
import ballerina/url;

const string CHAR_SET = "UTF-8";
const string SEPARATOR = ":";

service / on new http:Listener(8090) {
    resource function post encode(string username, string password) returns string|error {
        string urlEncodedString;
        string base64EncodedString = array:toBase64((username + SEPARATOR + password).toBytes());
        urlEncodedString = check url:encode(base64EncodedString, CHAR_SET);

        return urlEncodedString;
    }

    resource function post authenticate(string credentials) returns boolean|http:BadRequest|error {
        string urlDecodedString = check url:decode(credentials, CHAR_SET);
        byte[] base64DecodedBytes = check array:fromBase64(urlDecodedString);
        string userNamePasswordPair = check string:fromBytes(base64DecodedBytes);

        if !userNamePasswordPair.includes(SEPARATOR, 0) {
            http:BadRequest response = {body: "Unexpected credentials format."};
            return response;
        }

        string[] tuple = regex:split(userNamePasswordPair, SEPARATOR);
        json userDatabase = getUserDataAsJson();
        json[] users = <json[]>check userDatabase.users;

        foreach json item in users {
            string userName = check item.userName;
            string password = check item.password;
            if userName == tuple[0] && password == tuple[1] {
                return true;
            }
        }

        return false;
    }
}

function getUserDataAsJson() returns json {
    return {
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
}
