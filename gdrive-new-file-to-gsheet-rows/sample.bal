import ballerina/http;
import ballerina/log;
import ballerinax/googleapis.sheets;
import ballerinax/trigger.google.drive as driveListener;

const int HEADER_ROW = 1;

type OAuth2RefreshTokenGrantConfig record {
    string clientId;
    string clientSecret;
    string refreshToken;
    string refreshUrl = "https://www.googleapis.com/oauth2/v3/token";
};

configurable OAuth2RefreshTokenGrantConfig sheetOauthConfig = ?;
configurable string spreadsheetId = ?;
configurable string sheetName = ?;

configurable driveListener:ListenerConfig config = ?; 
listener http:Listener httpListener = new(8090);
listener driveListener:Listener webhookListener = new(config, httpListener);

@display { label: "Google Drive New File to Google Sheets Row" }
service driveListener:DriveService on webhookListener {
    
    remote function onFileCreate(driveListener:Change changeInfo ) returns error? {
      string fileID = changeInfo?.fileId.toString();
        string fileName = changeInfo?.file?.name.toString();
        string time = changeInfo?.time.toString();
        string mimeType = changeInfo?.file?.mimeType.toString();
        string[] headerArray = ["FileID", "File Name", "Time", "Mime type"];
        sheets:Client spreadsheetClient = check new ({auth: {
            clientId: sheetOauthConfig.clientId,
            clientSecret: sheetOauthConfig.clientSecret,
            refreshToken: sheetOauthConfig.refreshToken,
            refreshUrl: sheetOauthConfig.refreshUrl
        }});
        sheets:Row headers = check spreadsheetClient->getRow(spreadsheetId, sheetName, HEADER_ROW);
        if (headers.values.length() == 0) {
            check spreadsheetClient->appendRowToSheet(spreadsheetId, sheetName, headerArray);
        }
        string[] values = [fileID, fileName, time, mimeType];
        check spreadsheetClient->appendRowToSheet(spreadsheetId, sheetName, values);
        log:printInfo("Row appended successfully");
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