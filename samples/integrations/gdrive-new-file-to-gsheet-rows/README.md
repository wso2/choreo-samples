# Template: Google Drive new files to Google sheet rows
When a new file is added in Google drive, add a row in google sheet with file's metadata.

This temaplate logs "FileID", "File Name", "Time", "Mime type" of the files in rows.

## Use this template to
- Add file's metadata as a row when a new file is added to Google drive.

## What you need
- A Google Account

## How to set up
- Import the template.
- Allow access to the Google account.
- Select the drive.
- Enter Sheet information.
- Set up the template.

# Developer Guide
<p align="center">
<img src="./docs/images/template_flow.png?raw=true" alt="Drive-Sheet Integration template overview"/>
</p>

## Supported Versions
<table>
  <tr>
   <td>Ballerina Language Version
   </td>
   <td>Swan Lake Alpha5
   </td>
  </tr>
  <tr>
   <td>Java Development Kit (JDK)
   </td>
   <td>11
   </td>
  </tr>
  <tr>
   <td>Google Drive API Version
   </td>
   <td>V3
   </td>
  </tr>
  <tr>
   <td>Google Sheets API Version
   </td>
   <td>V4 
   </td>
  </tr>
</table>

## Pre-requisites
* Download and install [Ballerina](https://ballerinalang.org/downloads/).
* Goole account.
* Twilio account with sms capable phone number.

## Account Configuration
### Configuration steps for Google account
1. Visit [Google API Console](https://console.developers.google.com), click **Create Project**, and follow the wizard to create a new project.
2. Go to **Credentials -> OAuth consent screen**, enter a product name to be shown to users, and click **Save**.
3. On the **Credentials** tab, click **Create credentials** and select **OAuth client ID**. 
4. Select an application type, enter a name for the application, and specify a redirect URI (enter https://developers.google.com/oauthplayground if you want to use 
[OAuth 2.0 playground](https://developers.google.com/oauthplayground) to receive the authorization code and obtain the 
access token and refresh token). 
5. Click **Create**. Your client ID and client secret appear. 
6. In a separate browser window or tab, visit [OAuth 2.0 playground](https://developers.google.com/oauthplayground), select the required Google Drive scopes, and then click **Authorize APIs**.
7. When you receive your authorization code, click **Exchange authorization code for tokens** to obtain the refresh token and access token.
8. Domain used in the callback URL needs to be registered in google console as a verified domain.
https://console.cloud.google.com/apis/credentials/domainverification
(If you are running locally, provide your ngrok url as to the domain verification)
Then you will be able to download a HTML file (e.g : google2c627a893434d90e.html). 
Copy the content of that HTML file & provide that as a config (`domainVerificationFileContent`) to Listener initialization.

* In case if you failed to verify or setup, Please refer the documentation for domain verification process 
https://docs.google.com/document/d/119jTQ1kpgg0hpNl1kycfgnGUIsm0LVGxAvhrd5T4YIA/edit?usp=sharing

### Configuration steps for Google sheets account

1. Visit Google account and create a connected app by visiting [Google cloud platform APIs and Services](https://console.cloud.google.com/apis/dashboard). 
2. Click Library from the left side menu.
3. In the search bar enter Google Sheets.
4. Then select Google Sheets API and click Enable button.
5. Complete OAuth Consent Screen setup.
6. Click Credential tab from left side bar. In the displaying window click Create Credentials button
Select OAuth client Id.
7. Fill the required field. Add https://developers.google.com/oauthplayground to the Redirect URI field.
8. Get clientId and secret. Put it on the config(Config.toml) file.
9. Visit https://developers.google.com/oauthplayground/ 
    Go to settings (Top right corner) -> Tick 'Use your own OAuth credentials' and insert Oauth ClientId and secret.Click close.
10. Then,Complete Step1 (Select and Authotrize API's)
11. Make sure you select https://www.googleapis.com/auth/drive & https://www.googleapis.com/auth/spreadsheets Oauth scopes.
12. Click Authorize API's and You will be in Step 2.
13. Exchange Auth code for tokens.
14. Copy Access token and Refresh token. Put it on the config(Config.toml) file.

## Template Configuration
1. Create new spreadsheet.
2. Rename the sheet if you want.
3. Get the ID of the spreadsheet.
Spreadsheet ID in the URL "https://docs.google.com/spreadsheets/d/" + `<spreadsheetId>` + "/edit#gid=" + `<worksheetId>` 
5. Get the work sheet name.
6. Once you obtained all configurations, Create `Config.toml` in root directory.
7. Replace the necessary fields in the `Config.toml` file with your data.

## Config.toml 
```
[<ORG_NAME>.gdrive_new_file_to_gsheet_rows]
driveClientId = "<CLIENT_ID>"
driveClientSecret = "<CLIENT_SECRET>"
driveRefreshToken = "<REFRESH_TOKEN>"

[<ORG_NAME>.gdrive_new_file_to_gsheet_rows.spreadsheetConfig]
clientId = "<CLIENT_ID>"
clientSecret = "<CLIENT_SECRET>"
refreshToken = "<REFRESH_TOKEN>"
refreshUrl = "<REFRESH_URL>"

## Running the Template
1. First you need to build the integration template and create the executable binary. Run the following command from the 
root directory of the integration template. 
    ```
    $ bal build. 
    ```

2. Then you can run the integration binary with the following command. 
    ```
    $ bal run /target/bin/<jarfile>.jar. 
    ```

3. Now you can add new file to google drive and check new rows in google sheet.

4. You can check the metadata in rows to verify the file added.
