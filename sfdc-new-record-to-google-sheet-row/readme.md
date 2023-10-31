# Salesforce New Record to Google Sheets Row
## Use case
For more successful growth of a business, continuous awareness on the changes of your Salesforce account is crucial. 
Using this sample user can maintain the Salesforce records in a Google Sheet allowing easy and organized access to 
the important data. Using this sample user can get newly added records into a selected Google Sheet realtime. 
User can select the SObject he/she needs to maintain a seperate Google Sheet and every new record of that SObject will 
be added into the Sheet.

## Prerequisites
* Salesforce Account 
* Slack Account

### Setting up Salesforce account
1. Visit [Salesforce](https://www.salesforce.com/) and create a Salesforce Account.
2. Create a connected app and obtain the following credentials:
    *   Base URL (Endpoint)
    *   Access Token
    *   Client ID
    *   Client Secret
    *   Refresh Token
    *   Refresh Token URL
3. When you are setting up the connected app, select the following scopes under Selected OAuth Scopes:
    *   Access and manage your data (api)
    *   Perform requests on your behalf at any time (refresh_token, offline_access)
    *   Provide access to your data via the Web (web)
4. Provide the client ID and client secret to obtain the refresh token and access token. For more information on obtaining OAuth2 credentials, go to [Salesforce documentation](https://help.salesforce.com/articleView?id=remoteaccess_authenticate_overview.htm).
5.  Salesforce username, password and the security token that will be needed for initializing the listener. 
    For more information on the secret token, please visit [Reset Your Security Token](https://help.salesforce.com/articleView?id=user_security_token.htm&type=5).
    
    Once you obtained all configurations, Replace `""` in the `Config.toml` file with your data. For the `sfdcPassword` insert the combination of your Salesforce account password with the security token received 
6. [Select Objects](https://developer.salesforce.com/docs/atlas.en-us.change_data_capture.meta/change_data_capture/cdc_select_objects.htm) for Change Notifications in the User Interface of Salesforce account.

### Setting up Google Sheets account
Create a Google account and create a connected app by visiting [Google cloud platform APIs and Services](https://console.cloud.google.com/apis/dashboard). 

1. Click Library from the left side menu.
2. In the search bar enter Google Sheets.
3. Then select Google Sheets API and click Enable button.
4. Complete OAuth Consent Screen setup.
5. Click Credential tab from left sidebar. In the displaying window click `Create Credentials` button and select `OAuth client Id`.
6. Fill the required field. Add https://developers.google.com/oauthplayground to the Redirect URI field.
7. Get clientId and secret. Put it on the config(Config.toml) file.
8. Visit https://developers.google.com/oauthplayground/ 
    Go to settings (Top right corner) -> Tick 'Use your own OAuth credentials' and insert Oauth ClientId and secret.Click close.
9. Then,Complete Step1 (Select and Authorize API's)
10. Make sure you select https://www.googleapis.com/auth/drive & https://www.googleapis.com/auth/spreadsheets Oauth scopes.
11. Click Authorize API's, and You will be in Step 2.
12. Exchange Auth code for tokens.
13. Copy Access token and Refresh token. Put it on the config(Config.toml) file.

## Template Configuration
Create a file called `Config.toml` at the root of the project.

### Config.toml
```
[<ORG_NAME>.sfdc_new_record_to_google_sheet_row]
salesforceBaseUrl = "<SALESFORCE_BASE_URL>"
salesforceObject = "<SALESFORCE_OBJECT_NAME>"
spreadsheetId = "<GSHEET_SPREADSHEET_ID>"
worksheetName = "<GSHEET_WORKSHEET_NAME>"

[<ORG_NAME>.sfdc_new_record_to_google_sheet_row.salesforceOAuthConfig]
clientId = "<SALESFORCE_CLIENT_ID>"
clientSecret = "<SALESFORCE_CLIENT_SECRET>"
refreshUrl = "<SALESFORCE_REFRESH_URL>"
refreshToken = "<SALESFORCE_REFRESH_TOKEN>"

[<ORG_NAME>.sfdc_new_record_to_google_sheet_row.salesforceListenerConfig]
username = "<SALESFORCE_USERNAME>"
password = "<SALESFORCE_PASSWORD>"

[<ORG_NAME>.sfdc_new_record_to_google_sheet_row.GSheetOAuthConfig]
clientId = "<GSHEET_CLIENT_ID>"
clientSecret = "<GSHEET_CLIENT_SECRET>"
refreshUrl = "<GSHEET_REFRESH_URL>"
refreshToken = "<GSHEET_REFRESH_TOKEN>"
``` 
> Here   
    * GSHEET_REFERSH_URL : https://www.googleapis.com/oauth2/v3/token  
    * SALESFORCE_REFRESH_URL : https://login.salesforce.com/services/oauth2/token


## Testing
Run the Ballerina project created by the integration sample by executing `bal run` from the root.

Now you can add new record in Salesforce Object and observe that integration sample runtime has received the event 
notification for new record creation. You can check the Google Sheet to verify that new record is added to the 
specified Sheet. 
