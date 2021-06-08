import ballerina/log;
import ballerinax/googleapis.drive as drive;
import ballerinax/googleapis.drive.'listener as listen;
import ballerinax/twilio;

@display {label: "Google Drive Client ID"}
configurable string & readonly driveClientId = ?;

@display {label: "Google Drive Client Secret"}
configurable string & readonly driveClientSecret = ?;

@display {label: "Google Drive Refresh Token"}
configurable string & readonly driveRefreshToken = ?;

@display {label: "Domain Verification File Content"}
configurable string & readonly domainVerificationFileContent = ?;

@display {
    kind: "WebhookURL",
    label: "Set Up Choreo application invocation URL"
}
configurable string & readonly CHOREO_APP_INVOCATION_URL = ?;
string address = CHOREO_APP_INVOCATION_URL + "/events";

@display {label: "Twilio Account SID"}
configurable string & readonly accountSid = ?;

@display {label: "Twilio Auth Token"}
configurable string & readonly authToken = ?;

@display {label: "SMS Sender's Phone Number"}
configurable string & readonly fromNumber = ?;

@display {label: "SMS Recipient's Phone Number"}
configurable string & readonly toNumber = ?;

drive:Configuration config = {clientConfig: {
        clientId: driveClientId,
        clientSecret: driveClientSecret,
        refreshToken: driveRefreshToken,
        refreshUrl: drive:REFRESH_URL
    }};

listen:ListenerConfiguration configuration = {
    port: 8090,
    callbackURL: address,
    domainVerificationFileContent: domainVerificationFileContent,
    clientConfiguration: config
};

listener listen:Listener gDrivelistener = new (configuration);

service / on gDrivelistener {
    remote function onFileCreate(listen:Change changeInfo) returns error? {
        string message = "New file added to gdrive with file Id : " + changeInfo?.fileId.toString() + " & name : " + 
        changeInfo?.file?.name.toString();
        twilio:Client twilioClient = check new ({
            accountSId: accountSid,
            authToken: authToken
        });
        twilio:SmsResponse result = check twilioClient->sendSms(fromNumber, toNumber, message);
        log:printInfo("Sms sent succesfully");
    }
}
