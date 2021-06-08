# Template: Twilio data to a Gmail Inbox
When new SMS is received to a Twilio account, email is sent to a specified email address via Gmail.

There are day-to-day scenarios where we come across surveys or competitions which are initiated with the use of SMS voting. This integration template allows you to start such kind of scenario instantly.<br>

## Use this template to
- Receive gmail email on sms received.

## What you need
- A Twilio Account
- A Google Cloud Platform Account

## How to set up
- Import the template.
- Allow access to Twilio account.
- Provide account SID and AUTH_TOKEN
- Allow access to the Google account.
- Set up the template. 

# Developer Guide
<p align="center">
<img src="./docs/images/template_flow.png" alt="Twilio-Gmail Integration template overview"/>
</p>

## Supported Versions
<table>
  <tr>
   <td>Ballerina Language Version
   </td>
   <td>Swan Lake Alpha 5
   </td>
  </tr>
  <tr>
   <td>Java Development Kit (JDK)
   </td>
   <td>11
   </td>
  </tr>
  <tr>
   <td>Twilio REST API Version
   </td>
   <td>2010-04-01
   </td>
  </tr>
  <tr>
   <td>Gmail API Version
   </td>
   <td>V1
   </td>
  </tr>
</table>

## Pre-requisites
* Download and install [Ballerina](https://ballerinalang.org/downloads/).
* Google Cloud Platform account
* Twilio account.

## Account Configuration
### Configuration steps for Twilio account
1. From the created Twilio account, obtain the `Account SID`.
2. For setting up a callback URL in  Twilio, you can install [ngrok](https://ngrok.com/docs) and expose a local web server to 
the internet.
3. Then start the `ngork` with `webhook:TwilioEventListener` service port (8090 in this case) by using the command `./ngrok http 8090`
4. Navigate to Phone Numbers->Manage Numbers->Active Numbers in Twilio console. Select the number.
5. Set the callback URL in Twilio account according to the given format. 
```
<public_url_obtained_by_ngrok>/<name_of_websub_service>
```
<div><img src="./docs/images/webhook_callback.png" alt="Set Webhook callback URL"/></div>

5. Use the above obtained values to set twilioAuthToken and callbackUrl in the 
config(Config.toml) file.

### Configuration steps for Google Gmail account
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
    (Minimum scope required for this template https://www.googleapis.com/auth/gmail.send)
11. Click `Authorize APIs` and You will be in step 2.
12. Exchange Auth code for tokens.
13. Copy `access token` and `refresh token`. Put it on the config(Config.toml) file.


## Template Configuration
1. Create a Google account and Twilio account.
2. Setup ngrok, copy callback url as described above and register in Twilio.
3. Get 'twilioAuthToken' from the Console.
4. Put both configs in the Config.toml.
5. Extract Gmail credentials as explained above.
6. Put it inside Config.toml.
7. Run the template.

### Config.toml 
```
[<ORG_NAME>.twilio_new_sms_to_gmail_inbox]
twilioAuthToken = "<TWILIO_AUTH_TOKEN>"  
callbackUrl = "<CALLBACK_URL>"  
recipient = "<RECIPIENT>"
sender = "<SENDER>"
subject = "<SUBJECT>"

[<ORG_NAME>.twilio_new_sms_to_gmail_inbox.gmailOauthConfig]
clientId = "<CLIENT_ID>"
clientSecret = "<CLIENT_SECRET>"
refreshToken = "<REFRESH_TOKEN>"
refreshUrl = "<REFRESH_URL>"
```

## Running the Template
1. First you need to build the integration template and create the executable binary. Run the following command from the 
root directory of the integration template. 
`$ bal build`. 

2. Then you can run the integration binary with the following command. 
`$  bal run target/bin/twilio_new_sms_to_gmail_inbox.jar`. 

3. Now you can send new message to the specific Twilio account and observe that 
integration template runtime has received the event notification upon receiving new message.

4. You can check the Gmail inbox to verify the email received.
 