# SMS Voting Survey to Google Sheets Summary
## Use case
There are day-to-day scenarios where we come across surveys or competitions which are initiated with the use of SMS voting. 
This integration sample allows you to start such kind of scenario instantly and obtain the voting results with the 
use of a Google Sheet. It listens to the incoming Twilio SMS (with a predefined sample) and increments a count in a 
Google Sheet. This can be used to update specific data in the Google Sheet. The practical use case we have implemented 
here is a scenario where `A survey to find out the best language for building microservices out of a set of given 
languages`. The users have to send an SMS in the predefined format `Vote <Language Name>` to a given Twilio number. 
The sample will update the count on each valid SMS receive.

## Prerequisites
* Twilio Account
* Google Cloud Platform Account

### Setting up Twilio account
1. For setting up a callback URL in  Twilio, you can install [ngrok](https://ngrok.com/docs) and expose a local web server to the internet.
2. Then start the `ngork` with `twilioListener:Listener` service port (8090 in this case) by using the command `./ngrok http 8090`
3. Set the callback URL in Twilio account

### Setting up Google Sheets account
Create a Google account and create a connected app by visiting [Google cloud platform APIs and Services](https://console.cloud.google.com/apis/dashboard). 

1. Click `Library` from the left side bar.
2. In the search bar enter Google Sheets.
3. Then select Google Sheets API and click Enable button.
4. Complete OAuth Consent Screen setup.
5. Click `Credential` tab from left side bar. In the displaying window click `Create Credentials` button
Select OAuth client Id.
6. Fill the required field. Add https://developers.google.com/oauthplayground to the Redirect URI field.
7. Get client ID and client secret. Put it on the config(Config.toml) file.
8. Visit https://developers.google.com/oauthplayground/ 
    Go to settings (Top right corner) -> Tick 'Use your own OAuth credentials' and insert Oauth client ID and client secret. 
    Click close.
9. Then,Complete step 1 (Select and Authorize APIs)
10. Make sure you select https://www.googleapis.com/auth/drive & https://www.googleapis.com/auth/spreadsheets Oauth scopes.
11. Click `Authorize APIs` and You will be in step 2.
12. Exchange Auth code for tokens.
13. Copy `access token` and `refresh token`. Put it on the config(Config.toml) file.

## Configuration
Create a file called `Config.toml` at the root of the project.

### Config.toml 
```
[<ORG_NAME>.twilio_sms_to_gsheet]
spreadsheetId = "<SPREADSHEET_ID>"  
workSheetName ="<WORKSHEET_NAME>" 

[<ORG_NAME>.twilio_sms_to_gsheet.sheetOauthConfig]
clientId = "<CLIENT_ID>"  
clientSecret = "<CLIENT_SECRET>"
refreshUrl = "https://www.googleapis.com/oauth2/v3/token"
refreshToken = "<REFRESH_TOKEN>"   
```

## Testing
Run the Ballerina project created by the integration sample by executing `bal run` from the root.

Now you can send new messages in the format `Vote <LANGUAGE_NAME>` to the specific Twilio account and observe that integration sample runtime has received the event notification upon receiving new message. You can check the Google Sheet to verify that how the count of each language is increased in the specified sheet.
 