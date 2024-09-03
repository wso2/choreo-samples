// Copyright (c) 2024, WSO2 LLC. (https://www.wso2.com/) All Rights Reserved.
// 
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
// 
//     http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied. See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/io;
import ballerina/log;
import ballerina/tcp;
import ballerina/websocket;

@websocket:ServiceConfig {
    subProtocols: ["chat"]
}

service /chat on new websocket:Listener(9090) {

    resource function get .() returns websocket:Service {
        return new ChatService();
    }
}

service class ChatService {
    *websocket:Service;

    remote function onMessage(websocket:Caller caller, string chatMessage) returns error? {
        io:println(chatMessage, caller.getConnectionId());
        check caller->writeMessage("Hello!, How are you?");
    }

    remote function onError(tcp:Error err) returns tcp:Error? {
        log:printError("An error occurred", 'error = err);
    }

    remote function onClose(websocket:Caller caller, int statusCode, string reason) {
        io:println(string `Client closed connection with ${statusCode} because of ${reason} `, caller.getConnectionId());
    }

}
