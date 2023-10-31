# Gmail New Attachment to Amazon S3
## Use case
When there are files attached to emails it is difficult to trackdown them easily. File management purposes become a need
when they are valuable to the enterprise or a specific person and when there is need to reduce waste of time searching for attachments.
For this, there must be a proper way of managing file attachments in an email. This sample integrates Gmail with 
Amazon S3 to achieve that task with ease. Whenever you get an email via Gmail with an attachment, this sample will save the attachment file in Amazon S3 bucket. By this way we can guarantee that the received attachment is saved in your Amazon S3 bucket.

## Prerequisites
* Google Cloud Platform Account

### Setting up Google Cloud Platform account
Create a Google account and create a connected app by visiting [Google cloud platform APIs and Services](https://console.cloud.google.com/apis/dashboard). 

1. Click `Library` from the left sidebar.
2. In the search bar enter Gmail.
3. Then select Gmail API and click `Enable` button.
4. Similarly enable the Cloud Pub/Sub API.
5. Complete OAuth Consent Screen setup.
6. Click the `Credential` tab from the left sidebar. In the displaying window click the `Create Credentials` button
7. Select OAuth client Id.
8. Fill the required field. Add https://developers.google.com/oauthplayground to the Redirect URI field.
9. Get `client ID` and `client secret`. Put it on the config(Config.toml) file.
10. Visit https://developers.google.com/oauthplayground/. Go to Settings (Top right corner) -> Tick 'Use your own OAuth credentials' and insert OAuth client ID and client secret. Click close.
11. Then, Complete step 1 (Select and Authorize APIs)
12. Make sure you select https://mail.google.com/, https://www.googleapis.com/auth/cloud-platform, and https://www.googleapis.com/auth/pubsub OAuth scopes.
13. Click `Authorize APIs` and You will be in step 2.
14. Exchange Auth code for tokens.
15. Copy `Access token` and `Refresh token`. Put it on the config(`Config.toml`) file.
16. Obtain the relevant `Refresh URL` (For example: https://oauth2.googleapis.com/token) for the Gmail API and include it in the `Config.toml` file.

## Configuration
Create a file called `Config.toml` at the root of the project.

### Config.toml 
```
[<ORG_NAME>.gmail_new_attachment_to_amazon_s3]
bucketName = "<AMAZON_S3_BUCKET_NAME>"

[<ORG_NAME>.gmail_new_attachment_to_amazon_s3.gmailConfig]
clientId = "<GMAIL_CLIENT_ID>"
clientSecret = "<GMAIL_CLIENT_SECRET>"
refreshUrl = "<GMAIL_REFRESH_URL>"
refreshToken = "<GMAIL_REFRESH_TOKEN>"
project = "<GOOGLE_CLOUD_PROJECT_ID>"
callbackURL = "<LISTENER_CALLBACK_URL>"

[<ORG_NAME>.gmail_new_attachment_to_amazon_s3.amazonS3Config]
accessKeyId = "<AMAZON_S3_ACCESS_KEY_ID>"
secretAccessKey = "<AMAZON_S3_SECRET_ACCESS_KEY>"
region = "<AMAZON_S3_REGION>"
```
> Note: Here GMAIL_REFRESH_URL is `https://oauth2.googleapis.com/token`.

### Template Configuration
1. Obtain the project ID of your Google Cloud project. Replace the `<GOOGLE_CLOUD_PROJECT_ID>` section with this ID.
2. Obtain the callback URL. Replace the `<LISTENER_CALLBACK_URL>` section with the URL where your listener service is running. (**!!! NOTE:** Locally, you can use [ngrok](https://ngrok.com/docs) to expose your web server to the internet. Example: 'https://7745640c2478.ngrok.io'. In Choreo, you can obtain this callback URL after App deployment.)
3. Obtain the Amazon S3 bucket name to store your files. Replace the `<AMAZON_S3_BUCKET_NAME>` section
4. Once you obtained all configurations, Create `Config.toml` in root directory.
5. Replace the necessary fields in the `Config.toml` file with your data.

## Testing
Run the Ballerina project created by the integration sample by executing `bal run` from the root.

Now you can send a new email with an attachment and observe if integration sample runtime has logged the status of the response. You can check the Amazon S3 bucket to verify that the the new attachment file is uploaded. 
