# Template: Google Drive new files to Twilio SMS
When a new file is added in Google drive, send a Twilio SMS to a specified number.

We can use track google drive changes this way easily. For an example, If someones adds files to shared google drive, we
get notified via SMS.

This template can be configured to watch for whole drive or specific folder only.

## Use this template to
- Send a Twilio SMS message to a specific number when a new file is added to Google drive.

## What you need
- A Google Account
- A Twilio Account

## How to set up
- Import the template.
- Allow access to the Google account.
- Select the drive.
- Enter Twilio credentials.
- Enter phone numbers.
- Set up the template.

# Developer Guide
<p align="center">
<img src="./docs/images/template_flow.png?raw=true" alt="Drive-Twilio Integration template overview"/>
</p>

## Supported Versions
<table>
  <tr>
   <td>Ballerina Language Version
   </td>
   <td>Swan Lake Alpha4
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
   <td>Twilio Basic API Version
   </td>
   <td>2010-04-01 
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

### Configuration steps for Twilio account

1.  To use Twilio service, you need to provide the following:

       - Account SId
       - Auth Token

## Template Configuration

1. Once you obtained all configurations, Create `Config.toml` in the directory with the file.
2. Replace the necessary fields in the `Config.toml` file with your data.

## Config.toml 
```
[<ORG_NAME>.gdrive_new_file_to_twilio_sms]
accountSid = ""
authToken = ""
fromNumber = ""
toNumber = ""
CHOREO_APP_INVOCATION_URL = ""
driveClientId = "<CLIENT_ID>"
driveClientSecret = "<CLIENT_SECRET>"
driveRefreshToken = "<REFRESH_TOKEN>"
```

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

3. Now you can add new file to google drive and check for triggered SMS.

4. You can check the SMS received to verify that information about the new file added to the drive.
