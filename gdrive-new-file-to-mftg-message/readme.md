# Google Drive New File to MFTG Send Message
## Use case
This sample will send an AS2 message from a specified Station to Partner whenever a new file is uploaded to specified Google Drive. The file uploaded is used as the attachment in the AS2 message.

## Prerequisites
* Google Drive account
* MFT Gateway account (by Aayu Technologies)


### Setting up Google Drive account
1. Visit [Google API Console](https://console.developers.google.com), click **Create Project**, and follow the wizard to create a new project.
2. Go to **Credentials -> OAuth consent screen**, enter a product name to be shown to users, and click **Save**.
3. On the **Credentials** tab, click **Create credentials** and select **OAuth client ID**. 
4. Select an application type, enter a name for the application, and specify a redirect URI (enter https://developers.google.com/oauthplayground if you want to use 
[OAuth 2.0 playground](https://developers.google.com/oauthplayground) to receive the authorization code and obtain the 
access token and refresh token). 
5. Click **Create**. Your client ID and client secret appear. 
6. In a separate browser window or tab, visit [OAuth 2.0 playground](https://developers.google.com/oauthplayground), select the required Google Drive scopes, and then click **Authorize APIs**.
7. When you receive your authorization code, click **Exchange authorization code for tokens** to obtain the refresh token and access token.

## Configuration
Create a file called `Config.toml` at the root of the project.

### Config.toml 
```
[<ORG_NAME>.gdrive_new_file_to_mftg_message]
username = "<USERNAME>"
password = "<PASSWORD>"
as2From = "<AS2_FROM>"
as2To = "<AS2_TO>"

[<ORG_NAME>.gdrive_new_file_to_mftg_message.config]
clientId = "<CLIENT_ID>"
clientSecret = "<CLIENT_SECRET>"
refreshToken = "<REFRESH_TOKEN>"
refreshUrl = "<REFRESH_URL>"

> Note: Here REFRESH_URL for Google Drive API is `https://www.googleapis.com/oauth2/v3/token`

## Testing
Run the Ballerina project created by the integration sample by executing `bal run` from the root.

Now you can add new file to google drive and check for logs.