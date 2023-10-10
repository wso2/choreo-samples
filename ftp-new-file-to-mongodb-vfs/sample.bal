import ballerina/ftp;
import ballerina/io;
import ballerina/log;
import ballerina/regex;
import ballerinax/mongodb;

configurable string mongoUrl = ?;
configurable string mongoDatabaseName = ?;
configurable string mongoCollectionName = ?;

configurable string ftpHost = ?;
configurable int ftpPort = ?;
configurable string ftpUsername = ?;
configurable string ftpPassword = ?;

configurable string ftpCollectorFolderPath = ?;
configurable string ftpSuccessFolderPath = ?;
configurable string ftpFailureFolderPath = ?;
configurable decimal ftpPollingInterval = ?;

listener ftp:Listener remoteServer = check new ({
    protocol: ftp:FTP,
    host: ftpHost,
    auth: {
        credentials: {
            username: ftpUsername,
            password: ftpPassword
        }
    },
    port: ftpPort,
    path: ftpCollectorFolderPath,
    pollingInterval: ftpPollingInterval,
    fileNamePattern: "(.*).csv"
});

final ftp:Client ftpEndpoint = check new ({
    protocol: ftp:FTP, 
    host: ftpHost, 
    port: ftpPort, 
    auth: {
        credentials: {
            username: ftpUsername, 
            password: ftpPassword
        }
    }
});

service on remoteServer {
    isolated remote function onFileChange(ftp:WatchEvent event) returns error? {
        mongodb:Client mongodbEndpoint = check new ({
            connection: {
                url: mongoUrl
            }
        });
        foreach ftp:FileInfo addedFile in event.addedFiles {
            log:printInfo(string `Received new file ${addedFile.path}`);
            string newFileName = addedFile.path.substring(addedFile.path.lastIndexOf("/") ?: 0, addedFile.path.length());
            do {
                stream<byte[] & readonly, io:Error?> fileContent = check ftpEndpoint->get(string `${ftpCollectorFolderPath}${newFileName}`);
                string[][] records = check retrieveRecordArray(fileContent);
                map<json>[] objectArray = convertToJsonObjectArray(records);

                foreach map<json> item in objectArray {
                    check mongodbEndpoint->insert(item, mongoCollectionName, mongoDatabaseName);
                }
                log:printInfo(string `All records from ${addedFile.path} added succesfully to MongoDB!`);
                ftp:Error? ftpTransferResponse = ftpEndpoint->rename(string `${ftpCollectorFolderPath}${newFileName}`, 
                    string `${ftpSuccessFolderPath}${newFileName}`);
                if ftpTransferResponse is ftp:Error {
                    log:printError(string `Moving file ${addedFile.path} to success folder failed`, ftpTransferResponse);
                    check ftpEndpoint->delete(string `${ftpCollectorFolderPath}${newFileName}`);
                    log:printInfo(string `File ${addedFile.path} deleted`);
                } else {
                    log:printInfo(string `File ${addedFile.path} moved to success folder`);
                }
                
            } on fail var e {
                // Move file to failure folder
                log:printError(string `Failed to insert data from ${addedFile.path}`, e);
                ftp:Error? ftpTransferResponse = ftpEndpoint->rename(string `${ftpCollectorFolderPath}${newFileName}`, 
                    string `${ftpFailureFolderPath}${newFileName}`);
                if ftpTransferResponse is ftp:Error {
                    log:printError(string `Moving file ${addedFile.path} to failure folder failed`, ftpTransferResponse);
                    ftp:Error? deletionResponse = ftpEndpoint->delete(string `${ftpCollectorFolderPath}${newFileName}`);
                    if deletionResponse is ftp:Error {
                        log:printError(string `File ${addedFile.path} deletion failed`);
                    } else {
                        log:printInfo(string `File ${addedFile.path} deleted`);
                    }
                } else {
                    log:printWarn(string `File ${addedFile.path} moved to failure folder`);
                }
            }
        }
        mongodbEndpoint->close(); 
    }
}

isolated function retrieveRecordArray(stream<byte[] & readonly, io:Error?> fileContent) returns string[][]|error {
    string[][] records = [];
    byte[] allBytes = [];
    check from byte[] chunks in fileContent
    do {
        allBytes.push(...chunks);
    };

    string stringFromByteContent = check string:fromBytes(allBytes);
    string[] rowsAsString = regex:split(stringFromByteContent, "\n");
    foreach string row in rowsAsString {
        string[] rowsAsArray = regex:split(row, ",");
        rowsAsArray = rowsAsArray.map(currentRecord => currentRecord.trim());
        records.push(rowsAsArray);
    }
    return records;
}

isolated function convertToJsonObjectArray(string[][] records) returns map<json>[] {
    string[] columns = records.shift();
    int columnCount = columns.length();
    map<json>[] objectArray = [];
    foreach string[] currentRecord in records {
        map<json> obj = {};
        foreach int index in 0 ..< columnCount {
            obj[columns[index]] = currentRecord[index];
        }
        objectArray.push(obj);
    }
    return objectArray;
}
