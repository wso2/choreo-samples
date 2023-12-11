// Copyright (c) 2023, WSO2 LLC. (http://www.wso2.org) All Rights Reserved.

// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at

//    http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied. See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/uuid;
import ballerina/http;
import ballerina/jwt;

enum Status {
    reading = "reading",
    read = "read",
    to_read = "to_read"
}

type BookItem record {|
    string title;
    string author;
    string status;
|};

type Book record {|
    *BookItem;
    string id;
|};

map<map<Book>> books = {};
const string DEFAULT_USER = "default";

service /readinglist on new http:Listener(9090) {

    resource function get books(http:Headers headers) returns Book[]|http:BadRequest|error {
        map<Book>|http:BadRequest usersBooks = check getUsersBooks(headers);
        if (usersBooks is map<Book>) {
            return usersBooks.toArray();
        }
        return <http:BadRequest>usersBooks;
    }

    resource function post books(http:Headers headers,
                                 @http:Payload BookItem newBook) returns http:Created|http:BadRequest|error {

        string bookId = uuid:createType1AsString();
        map<Book>|http:BadRequest usersBooks = check getUsersBooks(headers);
        if (usersBooks is map<Book>) {
            usersBooks[bookId] = {...newBook, id: bookId};
            return <http:Created>{};
        }
        return <http:BadRequest>usersBooks;
    }

    resource function delete books(http:Headers headers,
                                   string id) returns http:Ok|http:BadRequest|error? {
        map<Book>|http:BadRequest usersBooks = check getUsersBooks(headers);
        if (usersBooks is map<Book>) {
            _ = usersBooks.remove(id);
            return <http:Ok>{};
        }
        return <http:BadRequest>usersBooks;
    }
}

// This function is used to get the books of the user who is logged in.
// User information is extracted from the JWT token.
function getUsersBooks(http:Headers headers) returns map<Book>|http:BadRequest|error {
        string|error jwtAssertion = headers.getHeader("x-jwt-assertion");
        if (jwtAssertion is error) {
            http:BadRequest badRequest = {
                body: {
                    "error": "Bad Request",
                    "error_description": "Error while getting the JWT token"
                }
            };
            return badRequest;
        }

        [jwt:Header, jwt:Payload] [_, payload] = check jwt:decode(jwtAssertion);
        string username = payload.sub is string ? <string>payload.sub : DEFAULT_USER;
        if (books[username] is ()) {
            books[username] = {};
        }
        return <map<Book>>books[username];
    }
