import ballerina/http;
import ballerina/lang.array;
import ballerina/log;
import ballerinax/googleapis.drive;
import ballerinax/googleapis.gmail;
import ballerinax/googleapis.gmail.'listener as gmailListener;

@display {
    kind: "OAuth2RefreshTokenGrantConfig",
    provider: "Gmail",
    label: "Set Up Google Gmail Connection"
}
configurable http:OAuth2RefreshTokenGrantConfig & readonly gmailOauthConfig = ?;

@display {label: "Google Project ID"}
configurable string project = ?;

@display {label: "Push Endpoint URL"}
configurable string pushEndpoint = ?;

@display {label: "Google Drive Client Id"}
configurable string gDriveClientId = ?;

@display {label: "Google Drive Client Secret"}
configurable string gDriveClientSecret = ?;

@display {label: "Google Drive Client Refresh Token"}
configurable string gDriveRefreshToken = ?;

@display {label: "Google Drive Folder ID"}
configurable string parentFolderId = ?;

drive:Configuration gDriveOauthConfig = {clientConfig: {
        clientId: gDriveClientId,
        clientSecret: gDriveClientSecret,
        refreshUrl: drive:REFRESH_URL,
        refreshToken: gDriveRefreshToken
    }};

gmail:GmailConfiguration gmailListenerConfig = {oauthClientConfig: gmailOauthConfig};

listener gmailListener:Listener gmailEventListener = new (8090, gmailListenerConfig, project, pushEndpoint);

service / on gmailEventListener {
    remote function onNewAttachment(gmailListener:MailAttachment attachment) returns error? {
        gmail:Client gmailClient = new ({oauthClientConfig: gmailOauthConfig});
        gmail:MessageBodyPart[] triggerResponse = attachment.msgAttachments;
        foreach var item in triggerResponse {
            gmail:MessageBodyPart gmailResponse = check gmailClient->getAttachment(attachment.messageId, item?.fileId.
            toString());
            drive:Client driveClient = check new (gDriveOauthConfig);
            byte[] content = check array:fromBase64(gmailResponse?.data.toString());
            drive:File driveResponse = check driveClient->uploadFileUsingByteArray(content, item?.fileName.toString(), 
            parentFolderId);
            log:printInfo("File uploaded successfully");
        }

    }
}
