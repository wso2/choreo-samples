import ballerina/http;
import ballerina/log;
import ballerinax/trigger.google.drive as driveListener;
import ballerinax/twilio;


configurable string accountSid = ?;
configurable string authToken = ?;
configurable string fromNumber = ?;
configurable string toNumber = ?;

configurable driveListener:ListenerConfig config = ?; 
listener http:Listener httpListener = new(8090);
listener driveListener:Listener webhookListener = new(config, httpListener);

@display { label: "Google Drive New File to Twilio SMS" }
service driveListener:DriveService on webhookListener {
    
    remote function onFileCreate(driveListener:Change changeInfo ) returns error? {
              string message = "New file added to gdrive with file Id : " + changeInfo?.fileId.toString() + " & name : " +
        changeInfo?.file?.name.toString();
        twilio:Client twilioClient = check new ({
            twilioAuth: {
                accountSId: accountSid,
                authToken: authToken
            }
        });
         _ = check twilioClient->sendSms(fromNumber, toNumber, message);
        log:printInfo("Sms sent succesfully");
    }
    remote function onFolderCreate(driveListener:Change changeInfo ) returns error? {
      //Not Implemented
    }
    remote function onFileUpdate(driveListener:Change changeInfo ) returns error? {
      //Not Implemented
    }
    remote function onFolderUpdate(driveListener:Change changeInfo ) returns error? {
      //Not Implemented
    }
    remote function onDelete(driveListener:Change changeInfo ) returns error? {
      //Not Implemented
    }
    remote function onFileTrash(driveListener:Change changeInfo ) returns error? {
      //Not Implemented
    }
    remote function onFolderTrash(driveListener:Change changeInfo ) returns error? {
      //Not Implemented
    }
}

service /ignore on httpListener {}