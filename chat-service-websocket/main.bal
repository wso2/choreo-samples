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
