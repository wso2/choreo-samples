import ballerina/http;
import ballerina/log;
import ballerinax/aayu.mftg.as2;
import ballerinax/googleapis.drive;
import ballerinax/trigger.google.drive as driveListener;

@display {label: "MFT Gateway Username", description: "Username of MFT gateway account"}
configurable string username = ?;
@display {label: "MFT Gateway Password", description: "Password of MFT gateway account"}
configurable string password = ?;
@display {label: "Sender's AS2 Identifier", description: "AS2 identifier of sender"}
configurable string as2From = ?;
@display {label: "Receiver's AS2 Identifier", description: "AS2 identifier of receiver"}
configurable string as2To = ?;
@display {label: "Google Drive Listener Configuration", description: "Connection configuration of Google Drive listener"}
configurable driveListener:ListenerConfig config = ?;

listener http:Listener httpListener = new (8090);
listener driveListener:Listener webhookListener = new (config, httpListener);

@display {label: "Google Drive New File to MFTG Send Message"}
service driveListener:DriveService on webhookListener {

    remote function onFileCreate(driveListener:Change changeInfo) returns error? {
        log:printInfo("New file created");
        drive:Client driveEndpoint = check new ({
            auth: {
                clientId: config.clientId,
                clientSecret: config.clientSecret,
                refreshToken: config.refreshToken,
                refreshUrl: config.refreshUrl
            }
        });
        drive:FileContent fileContent = check driveEndpoint->getFileContent(changeInfo.fileId.toString());
        as2:Client mftgClient = check new (username, password, as2From);
        _ = check mftgClient->sendAS2Message(as2To, fileContent.mimeType, fileContent.content);
        log:printInfo("Message sent successfully!!");
    }
    remote function onFolderCreate(driveListener:Change changeInfo) returns error? {
        //Not Implemented
    }
    remote function onFileUpdate(driveListener:Change changeInfo) returns error? {
        //Not Implemented
    }
    remote function onFolderUpdate(driveListener:Change changeInfo) returns error? {
        //Not Implemented
    }
    remote function onDelete(driveListener:Change changeInfo) returns error? {
        //Not Implemented
    }
    remote function onFileTrash(driveListener:Change changeInfo) returns error? {
        //Not Implemented
    }
    remote function onFolderTrash(driveListener:Change changeInfo) returns error? {
        //Not Implemented
    }
}

service /ignore on httpListener {
}
