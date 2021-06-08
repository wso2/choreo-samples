import ballerina/http;
import ballerina/log;
import ballerinax/googleapis.drive;
import ballerinax/googleapis.drive.'listener as listen;
import ballerinax/googleapis.sheets;

const int HEADER_ROW = 1;

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
    label: "Set Up Choreo Application Invocation URL"
}
configurable string & readonly CHOREO_APP_INVOCATION_URL = ?;
string address = CHOREO_APP_INVOCATION_URL + "/events";

@display {label: "Folder ID"}
configurable string & readonly folderId = ?;

@display {
    kind: "OAuthConfig",
    provider: "Google Sheets",
    label: "Set Up Google Sheets Connection"
}
configurable http:OAuth2RefreshTokenGrantConfig & readonly sheetOauthConfig = ?;

@display {
    kind: "ConnectionField",
    connectionRef: "sheetOauthConfig",
    provider: "Google Sheets",
    operationName: "getAllSpreadsheets",
    label: "Spreadsheet Name"
}
configurable string & readonly spreadsheetId = ?;

@display {
    kind: "ConnectionField",
    connectionRef: "sheetOauthConfig",
    provider: "Google Sheets",
    operationName: "getSheetList",
    label: "Worksheet Name"
}
configurable string & readonly sheetName = ?;

// Drive client configuration
drive:Configuration config = {clientConfig: {
        clientId: driveClientId,
        clientSecret: driveClientSecret,
        refreshToken: driveRefreshToken,
        refreshUrl: drive:REFRESH_URL
    }};

// Drive listener configuration
listen:ListenerConfiguration configuration = {
    port: 8090,
    callbackURL: address,
    domainVerificationFileContent: domainVerificationFileContent,
    clientConfiguration: config,
    specificFolderOrFileId: folderId
};

listener listen:Listener gDrivelistener = new (configuration);

service / on gDrivelistener {
    remote function onFileCreate(listen:Change changeInfo) returns error? {
        string fileID = changeInfo?.fileId.toString();
        string fileName = changeInfo?.file?.name.toString();
        string time = changeInfo?.time.toString();
        string mimeType = changeInfo?.file?.mimeType.toString();
        string[] headerArray = ["FileID", "File Name", "Time", "Mime type"];
        sheets:Client spreadsheetClient = check new ({oauthClientConfig: sheetOauthConfig});
        sheets:Row headers = check spreadsheetClient->getRow(spreadsheetId, sheetName, HEADER_ROW);
        if (headers.values.length() == 0) {
            check spreadsheetClient->appendRowToSheet(spreadsheetId, sheetName, headerArray);
        }
        string[] values = [fileID, fileName, time, mimeType];
        check spreadsheetClient->appendRowToSheet(spreadsheetId, sheetName, values);
        log:printInfo("Row appended successfully");
    }
}
