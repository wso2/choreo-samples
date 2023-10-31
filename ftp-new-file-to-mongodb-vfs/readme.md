# VFS
## Use case
This is a sample to demonstrate how to listen to a folder in a remote FTP location, pick up files from it and reliably process them. The sample keeps polling files from the `collector` folder in FTP server. After receiving the file, the sample will read the file content and do the processing. If the processing is successful, the file will get transferred from the `collector` folder to the `success` folder, otherwise it will get moved to the `failure` folder. Here under processing a file, the sample will insert a record into a given MongoDB database.

## Prerequisites
* Access for a FTP Server
* Access for a MongoDB database

## Configuration

Create a file called `Config.toml` at the root of the project.

```
[<ORG_NAME>.ftp_new_file_to_mongodb_vfs]
mongoUrl = "<URL>"
mongoDatabaseName = "<DATABASE_NAME>"
mongoCollectionName = "<COLLECTION_NAME>"

ftpHost = "<HOST>"
ftpPort = <PORT>
ftpUsername = "<USERNAME>"
ftpPassword = "<PASSWORD>"

ftpCollectorFolderPath = "<COLLECTOR_FOLDER_PATH>"
ftpSuccessFolderPath="<SUCCESS_FOLDER_PATH>"
ftpFailureFolderPath="<FAILURE_FOLDER_PATH>"
ftpPollingInterval = <POLLING_INTERVAL>
```

## Run the sample

1. Create `collector` folder in FTP location, and configure it as `ftpCollectorFolderPath` configurable
2. In the same way create `success` and `failure` folders and configure the paths
3. Configure Mongo DB credentials
4. Run the Ballerina project created by the service sample by executing `bal run` from the root   
5. Place/Upload a `.csv` file (fist line should contain csv headers) into `collector` folder

Sample will pickup the file, process the content and create Mongo DB records. After the processing, check Mongo DB database for records inserted. File should get moved to `success` folder.
