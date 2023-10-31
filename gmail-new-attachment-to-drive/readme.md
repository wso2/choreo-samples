# Gmail New Attachment to Google Drive
## Use case
When there are files attached to emails it is difficult to trackdown them easily. File management purposes become a need
when they are valuable to the enterprise or a specific person and when there is need to reduce waste of time searching for attachments.
For this, there must be a proper way of managing file attachments in an email. This sample integrates Gmail with 
Google Drive to achieve that task with ease. Whenever you get an email via Gmail with an attachment, this sample will save the attachment file in Google Drive. By this way we can guarantee that the received attachment is saved in your google drive.

## Prerequisites
* Google Cloud Platform Account

### Setting up Google Drive account and Gmail account
Create a Google account and create a connected app by visiting [Google cloud platform APIs and Services](https://console.cloud.google.com/apis/dashboard). 

1. Click `Library` from the left side bar.
2. In the search bar enter Gmail/Google Drive
3. Then select Gmail/Google Drive API and click `Enable` button.
4. Complete OAuth Consent Screen setup.
5. Click `Credential` tab from left side bar. In the displaying window click `Create Credentials` button
6. Select OAuth client Id.
7. Fill the required field. Add https://developers.google.com/oauthplayground to the Redirect URI field.
8. Get client ID and client secret. Put it on the `Config.toml` file.
9. Visit https://developers.google.com/oauthplayground/ 
    Go to settings (Top right corner) -> Tick 'Use your own OAuth credentials' and insert Oauth client ID and client secret. 
    Click close.
10. Then,Complete step 1 (Select and Authorize APIs)
11. Make sure you select https://mail.google.com/, https://www.googleapis.com/auth/drive, & https://www.googleapis.com/auth/drive OAuth scopes.
12. Click `Authorize APIs` and You will be in step 2.
13. Exchange Auth code for tokens.
14. Copy `access token` and `refresh token`. Put it on the `Config.toml` file under Google Sheet configuration.
15. Obtain the relevant refresh URLs for each API and include them in the `Config.toml` file.

### Setting up Google API Console

1. Enable Cloud Pub/Sub API for your project which is created in [Google API Console](https://console.developers.google.com).

2. Obtain the project Id of your google project.

3. Obtain valid callback url for the pushEndpoint.

4. Finally, obtain an parent directory Id as your wish to be uploaded the files.

## Config.toml 
```
[<ORG_NAME>.gmail_new_attachment_to_drive]
project = "<Google Cloud Project ID>"
parentFolderId = "<PARENT_FOLDER>"
pushEndpoint = "<PUSH ENDPOINT URL>"
gDriveClientId = "<CLIENT_ID>"
gDriveClientSecret = "<CLIENT_SECRET>"
gDriveRefreshToken = "<REFRESH_TOKEN>"

[<ORG_NAME>.gmail_new_attachment_to_drive.gmailOauthConfig]
clientId = "<CLIENT_ID>"
clientSecret = "<CLIENT_SECRET>"
refreshUrl = "<GMAIL_REFRESH_URL>"
refreshToken = "<REFRESH_TOKEN>"
```
> Note: Here GMAIL_REFRESH_URL is `https://oauth2.googleapis.com/token`

## Testing
Run the Ballerina project created by the integration sample by executing `bal run` from the root.

Now you can aend a new email with an attachment and observe if integration sample runtime has logged the status of the response. You can check the Google Drive verify if a new file is created. 
