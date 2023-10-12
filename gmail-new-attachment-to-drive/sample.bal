import ballerina/lang.array;
import ballerina/log;
import ballerinax/googleapis.drive;
import ballerinax/googleapis.gmail;
import ballerinax/trigger.google.mail;
import ballerina/http;

type OAuth2RefreshTokenGrantConfig record {
    string clientId;
    string clientSecret;
    string refreshToken;
    string refreshUrl = "https://oauth2.googleapis.com/token";
};

configurable string gDriveFolderId = ?;
configurable OAuth2RefreshTokenGrantConfig gDriveOauthConfig = ?;
configurable mail:ListenerConfig config = ?; 

listener http:Listener httpListener = new(8090);
listener mail:Listener webhookListener = new(config, httpListener);

@display { label: "Gmail New Attachment to Google Drive" }
service mail:GmailService on webhookListener {
    
    remote function onNewEmail(mail:Message message ) returns error? {
      //Not Implemented
    }
    remote function onNewThread(mail:MailThread thread ) returns error? {
      //Not Implemented
    }
    remote function onEmailLabelAdded(mail:ChangedLabel changedLabel ) returns error? {
      //Not Implemented
    }
    remote function onEmailStarred(mail:Message message ) returns error? {
      //Not Implemented
    }
    remote function onEmailLabelRemoved(mail:ChangedLabel changedLabel ) returns error? {
      //Not Implemented
    }
    remote function onEmailStarRemoved(mail:Message message ) returns error? {
      //Not Implemented
    }
    remote function onNewAttachment(mail:MailAttachment attachment ) returns error? {
      gmail:Client gmailClient = check new ({
            auth: {
                clientId: config.clientId,
                clientSecret: config.clientSecret,
                refreshToken: config.refreshToken,
                refreshUrl: config.refreshUrl
            }
        });
        gmail:MessageBodyPart[] triggerResponse = attachment.msgAttachments;
        foreach gmail:MessageBodyPart item in triggerResponse {
            gmail:MessageBodyPart gmailResponse = check gmailClient->getAttachment(attachment.messageId, item?.fileId.
            toString());
            drive:Client driveClient = check new ({
                auth: {
                    clientId: gDriveOauthConfig.clientId,
                    clientSecret: gDriveOauthConfig.clientSecret,
                    refreshToken: gDriveOauthConfig.refreshToken,
                    refreshUrl: gDriveOauthConfig.refreshUrl
                }
            });
            byte[] content = check array:fromBase64(gmailResponse?.data.toString());
            _ = check driveClient->uploadFileUsingByteArray(content, item?.fileName.toString(),
            gDriveFolderId);
            log:printInfo("File uploaded successfully");
    }
  }
}

service /ignore on httpListener {}