# Google Drive New File to Twilio SMS
## Use case
We can use track google drive changes this way easily. For an example, If someones adds files to shared google drive, we
get notified via SMS. This sample can be configured to watch for whole drive or specific folder only.


## Prerequisites
* Google Account
* Twilio Account

### Setting up Google drive account
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

### Setting up Twilio account

To use Twilio service, you need to provide the following:

       - Account SId
       - Auth Token

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

## Testing
Run the Ballerina project created by the integration sample by executing `bal run` from the root. 

Now you can add new file to google drive and check for triggered SMS.
You can check the SMS received to verify that information about the new file added to the drive.

