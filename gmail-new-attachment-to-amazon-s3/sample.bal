import ballerina/http;
import ballerina/lang.array;
import ballerina/log;
import ballerinax/aws.s3;
import ballerinax/googleapis.gmail;
import ballerinax/trigger.google.mail;

// Gmail configuration parameters
@display {label: "Gmail Connection Configuration", description: "The connection configuration of the Gmail listener"}
configurable mail:ListenerConfig gmailConfig = ?;

// Amazon S3 configuration parameters
@display {label: "Amazon S3 Connection Configuration", description: "The connection configuration of the Amazon S3 client"}
configurable s3:ConnectionConfig amazonS3Config = ?;
@display {label: "Amazon S3 Bucket Name", description: "The unique name of the Amazon S3 bucket"}
configurable string bucketName = ?;

listener http:Listener httpListener = new (8090);
listener mail:Listener webhookListener = new (gmailConfig, httpListener);

@display {label: "Gmail New Attachment to Amazon S3"}
service mail:GmailService on webhookListener {

    remote function onNewEmail(mail:Message message) returns error? {
        //Not Implemented
    }
    remote function onNewThread(mail:MailThread thread) returns error? {
        //Not Implemented
    }
    remote function onEmailLabelAdded(mail:ChangedLabel changedLabel) returns error? {
        //Not Implemented
    }
    remote function onEmailStarred(mail:Message message) returns error? {
        //Not Implemented
    }
    remote function onEmailLabelRemoved(mail:ChangedLabel changedLabel) returns error? {
        //Not Implemented
    }
    remote function onEmailStarRemoved(mail:Message message) returns error? {
        //Not Implemented
    }
    remote function onNewAttachment(mail:MailAttachment attachment) returns error? {
        gmail:Client gmailClient = check new ({
            auth: {
                clientId: gmailConfig.clientId,
                clientSecret: gmailConfig.clientSecret,
                refreshToken: gmailConfig.refreshToken,
                refreshUrl: gmailConfig.refreshUrl
            }
        });
        s3:Client amazonS3Client = check new (amazonS3Config);

        gmail:MessageBodyPart[] msgAttachments = attachment.msgAttachments;
        if msgAttachments.length() == 0 {
            return error("Gmail attachments are empty.");
        }

        foreach gmail:MessageBodyPart msgAttachment in msgAttachments {
            string? attachementId = msgAttachment?.fileId;
            string? objectName = msgAttachment.fileName;
            if attachementId is () || objectName is () {
                continue;
            }

            gmail:MessageBodyPart|error gmailAttachment = gmailClient->getAttachment(attachment.messageId, 
                attachementId);
            if gmailAttachment is error {
                log:printError(string `Attachment details for attachment ID ${attachementId} not found!`, 
                    gmailAttachment);
                continue;
            }

            byte[]|error content = array:fromBase64(gmailAttachment.data ?: "");
            if content is error {
                log:printError(content.message());
                continue;
            }

            error? s3Object = amazonS3Client->createObject(bucketName, objectName, content);
            if s3Object is error {
                log:printError(string `Amazon S3 object creation for attachment ${attachementId} failed!`, s3Object);
                continue;
            }
            log:printInfo(string `Attachment ${attachementId} uploaded successfully!`);
        }
    }
}

service /ignore on httpListener {}
