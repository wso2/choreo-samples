# Twilio New SMS to Gmail Message
## Use case
There are day-to-day scenarios where we come across surveys or competitions which are initiated with the use of SMS voting. 
This integration sample allows you to start such kind of scenario instantly.<br>

## Prerequisites
* Google cloud account
* Twilio account

### Setting up Twilio account
1. For setting up a callback URL in  Twilio, you can install [ngrok](https://ngrok.com/docs) and expose a local web server to the internet.
2. Then start the `ngork` with `webhook:TwilioEventListener` service port (8090 in this case) by using the command `./ngrok http 8090`
3. Navigate to Phone Numbers->Manage Numbers->Active Numbers in Twilio console. Select the number.
4. Set the callback URL in Twilio account.

### Setting up Google Gmail account
Create a Google account and create a connected app by visiting [Google cloud platform APIs and Services](https://console.cloud.google.com/apis/dashboard). 

1. Click `Library` from the left side bar.
2. In the search bar enter Gmail.
3. Then select Google Gmail API and click Enable button.
4. Complete OAuth Consent Screen setup.
5. Click `Credential` tab from left side bar. In the displaying window click `Create Credentials` button
Select OAuth client Id.
6. Fill the required field. Add https://developers.google.com/oauthplayground to the Redirect URI field.
7. Get client ID and client secret. Put it on the config(Config.toml) file.
8. Visit https://developers.google.com/oauthplayground/ 
    Go to settings (Top right corner) -> Tick 'Use your own OAuth credentials' and insert Oauth client ID and client secret. 
    Click close.
9. Then,Complete step 1 (Select and Authorize APIs)
10. Select the required Gmail API scopes from the list of APIs. 
    (Minimum scope required for this sample https://www.googleapis.com/auth/gmail.send)
11. Click `Authorize APIs` and You will be in step 2.
12. Exchange Auth code for tokens.
13. Copy `access token` and `refresh token`. Put it on the config(Config.toml) file.

## Configuration
Create a file called `Config.toml` at the root of the project.

### Config.toml 
```
[<ORG_NAME>.twilio_new_sms_to_gmail_inbox]
recipient = "<RECIPIENT>"
sender = "<SENDER>"
subject = "<SUBJECT>"

[<ORG_NAME>.twilio_new_sms_to_gmail_inbox.gmailOauthConfig]
clientId = "<CLIENT_ID>"
clientSecret = "<CLIENT_SECRET>"
refreshToken = "<REFRESH_TOKEN>"
refreshUrl = "<REFRESH_URL>"
```
> Note: Here REFRESH_URL is "https://oauth2.googleapis.com/token"

#### Template Configuration
1. Create a Google account and Twilio account.
2. Setup ngrok, copy callback url in Twilio.
3. Extract Gmail credentials as explained above.
4. Add it inside Config.toml.
5. Run the sample.

## Testing
Run the Ballerina project created by the integration sample by executing `bal run` from the root.

Now you can send new message to the specific Twilio account and observe that integration sample runtime has received the event notification upon receiving new message. You can check the Gmail inbox to verify the email received.
 