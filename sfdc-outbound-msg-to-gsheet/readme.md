# Salesforce Outbound Message to Google Sheets Row
## Use case
We can make our day-to-day information organized with the help of Google Sheets. But creating layouts and formatting a
sheet takes much more time than we think. By using this integration, we can organize and automatically set up a Google Sheet
which will contain information about exchanges Salesforce initiated with our callback endpoint. This sample can be used
to create a new row in a specific Google Sheet when a new Outbound Message is received from Salesforce.

## Prerequisites
* Salesforce Account
* Google Cloud Platform Account

### Setting up Salesforce account
1. Set up a new `Outbound Message` in Salesforce by visiting the `Service Setup` dropdown menu. More information on setting up
   outbound messages can be found [here](https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_om_outboundmessaging_setting_up.htm).
2. Set up a new `Workflow Rule`or select an already existing `Workflow Rule`. More information on this can
   be found [here](https://help.salesforce.com/articleView?id=sf.workflow_rules_new.htm&type=5).
3. Link the `Outbound Message` created in [1] to the `Workflow Rule`.

### Setting up Google Sheets account
Create a Google account and create a connected app by visiting [Google cloud platform APIs and Services](https://console.cloud.google.com/apis/dashboard).

1. Click `Library` from the left sidebar.
2. In the search bar enter Google Sheets.
3. Then select Google Sheets API and click Enable button.
4. Complete OAuth Consent Screen setup.
5. Click the `Credential` tab from the left sidebar. In the displaying window click the `Create Credentials` button
   Select OAuth client ID.
6. Fill the required field. Add https://developers.google.com/oauthplayground to the Redirect URI field.
7. Get client ID and client secret. Put it on the config(Config.toml) file.
8. Visit https://developers.google.com/oauthplayground/
   Go to Settings (Top right corner) -> Tick 'Use your own OAuth credentials' and insert OAuth client ID and client secret.
   Click close.
9. Then, Complete step 1 (Select and Authorize APIs)
10. Make sure you select https://www.googleapis.com/auth/drive & https://www.googleapis.com/auth/spreadsheets Oauth scopes.
11. Click `Authorize APIs` and You will be in step 2.
12. Exchange Auth code for tokens.
13. Copy `refresh token`. Put it on the config(Config.toml) file.

## Configuration
Create a file called `Config.toml` at the root of the project.

## Config.toml
```
[<ORG_Name>.sdfc_outbound_msg_to_gsheet]
spreadsheetId = "<SpreadSheet ID>"
worksheetName = "<Worksheet name>"

[<ORG_Name>.sdfc_outbound_msg_to_gsheet.sheetOAuthConfig]
clientId = "<Sheet client Id>"
clientSecret = "<Sheet client secret>"
refreshUrl = "<Sheet refresh URL>"
refreshToken = "<Sheet refresh token>"
``` 
> Note: Here Sheet refresh URL is https://www.googleapis.com/oauth2/v3/token

## Testing
Run the Ballerina project created by the integration sample by executing `bal run` from the root.

Now you can do actions that trigger the `Workflow Rule` that is linked to the `Outbound Message` and observe that
integration sample runtime has received the `POST` request to the callback URL specified in the outbound message.

You can check the Google Sheet to verify that a new row was added containing information in the outbound message. 

