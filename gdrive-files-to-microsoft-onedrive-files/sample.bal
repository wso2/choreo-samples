import ballerina/log;
import ballerinax/googleapis.drive;
import ballerinax/microsoft.onedrive;

configurable string gDriveClientId = ?;
configurable string gDriveClientSecret = ?;
configurable string gDriveRefreshToken = ?;
configurable string gDriveFolderId = ?;

configurable string oneDriveClientId = ?;
configurable string oneDriveClientSecret = ?;
configurable string oneDriveRefreshToken = ?;
configurable string oneDriveRefreshURL = ?;
configurable string oneDrivePath = ?;

configurable boolean filesOverridable = ?;

public function main() returns error? {

    drive:Client gDriveEndpoint = check new ({
        auth: {
            clientId: gDriveClientId,
            clientSecret: gDriveClientSecret,
            refreshToken: gDriveRefreshToken,
            refreshUrl: drive:REFRESH_URL
        }
    });

    onedrive:Client onedriveEndpoint = check new ({
        auth: {
            clientId: oneDriveClientId,
            clientSecret: oneDriveClientSecret,
            refreshToken: oneDriveRefreshToken,
            refreshUrl: oneDriveRefreshURL
        }
    });

    string gDriveQuery = string `'${gDriveFolderId}' in parents and trashed = false`;
    stream<drive:File> filesInGDrive = check gDriveEndpoint->getAllFiles(gDriveQuery);

    foreach drive:File file in filesInGDrive {
        string? fileName = file?.name;
        string? fileId = file?.id;
        boolean writable = false;

        if fileName !is string || fileId !is string {
            log:printError("File name or ID not found");
            continue;
        }
        if !filesOverridable {
            boolean|error isExistingFile = checkIfFileExistsInOneDrive(fileName, onedriveEndpoint);
            if isExistingFile is error {
                log:printError("Searching files in Microsoft OneDrive failed!", isExistingFile);
                continue;
            }
            writable = !isExistingFile;
        }
        if filesOverridable || writable {
            drive:FileContent|error fileContent = gDriveEndpoint->getFileContent(fileId);
            if fileContent is error {
                log:printError("Retrieving file from Google Drive failed!", fileContent);
                continue;
            }
            onedrive:DriveItemData|error uploadFileToFolderByPath = onedriveEndpoint->
                    uploadFileToFolderByPath(oneDrivePath, fileName, fileContent?.content,
                    fileContent?.mimeType);
            if uploadFileToFolderByPath is error {
                log:printError("Uploading file to Microsoft OneDrive failed!", uploadFileToFolderByPath);
                continue;
            }
            log:printInfo(string `File ${fileName} uploaded successfully!`);
        }
    }
}

isolated function checkIfFileExistsInOneDrive(string fileName, onedrive:Client onedriveEndpoint) returns boolean|error {
    stream<onedrive:DriveItemData, onedrive:Error?> searchDriveItems = check onedriveEndpoint->searchDriveItems(
        fileName);
    record {|onedrive:DriveItemData value;|}? next = check searchDriveItems.next();
    return next !is ();
}

