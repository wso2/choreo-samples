Use template (Salesforce New Lead to Google Sheets Row) to add Google Sheet row upon new lead addition in Salesforce.

## Use case
At the execution of this template, each time new lead is added in salesforce, Google Sheets Spreadsheet row will be 
added containing all the defined fields in lead SObject.

## Prerequisites
* Pull the template from central  
  `bal new -t choreo/sfdc_lead_to_gsheet_row <newProjectName>`
* Google Cloud platform account
* Salesforce account

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
    
    Once you obtained all configurations, Replace "" in the `Config.toml` file with your data. For the `sfdcPassword` insert the combination of your Salesforce account password with the security token received 
6. [Select Objects](https://developer.salesforce.com/docs/atlas.en-us.change_data_capture.meta/change_data_capture/cdc_select_objects.htm) for Change Notifications in the User Interface of Salesforce account.

### Setting up Google sheets account
1. Create a Google account and create a connected app by visiting [Google cloud platform APIs and Services](https://console.cloud.google.com/apis/dashboard). 
2. Click `Library` from the left side menu.
3. In the search bar enter Google Sheets.
4. Then select Google Sheets API and click `Enable` button.
5. Complete OAuth Consent Screen setup.
6. Click `Credential` tab from left sidebar. In the displaying window click `Create Credentials` button. Select OAuth client ID.
7. Fill the required fields. Add https://developers.google.com/oauthplayground to the Redirect URI field.
8. Get `clientId` and `clientSecret`. Put it on the config(Config.toml) file.
9. Visit https://developers.google.com/oauthplayground/. Go to settings (Top right corner) -> Tick 'Use your own OAuth credentials' and insert Oauth ClientId and clientSecret. Click close.
10. Then, Complete Step1 (Select and Authorize API's)
11. Make sure you select https://www.googleapis.com/auth/drive & https://www.googleapis.com/auth/spreadsheets Oauth scopes.
12. Click `Authorize API's` and You will be in Step 2.
13. Exchange Auth code for tokens.
14. Copy `Access token` and `Refresh token`. Put it on the config(`Config.toml`) file.
15. Obtain the relevant `Refresh URL` (For example: https://www.googleapis.com/oauth2/v3/token) for the Google Sheets API and include it in the `Config.toml` file.

## Configuration
Create a file called `Config.toml` at the root of the project.

### Config.toml 

```
[<ORG_NAME>.sfdc_lead_to_gsheet_row]
sfdcBaseUrl = "<SALESFORCE_BASE_URL>"
spreadsheetId = "<GSHEET_SPREADSHEET_ID>"
worksheetName = "<GSHEET_WORKSHEET_NAME>"

[<ORG_NAME>.sfdc_lead_to_gsheet_row.salesforceListenerConfig]
username = "<SALESFORCE_USERNAME>"
password = "<SALESFORCE_PASSWORD>"

[<ORG_NAME>.sfdc_lead_to_gsheet_row.salesforceOAuthConfig]
clientId = "<SALESFORCE_CLIENT_ID>"
clientSecret = "<SALESFORCE_CLIENT_SECRET>"
refreshToken = "<SALESFORCE_REFRESH_TOKEN>"
refreshUrl = "<SALESFORCE_REFRESH_URL>"

[<ORG_NAME>.sfdc_lead_to_gsheet_row.GSheetOAuthConfig]
clientId = "<GSHEET_CLIENT_ID>"
clientSecret = "<GSHEET_CLIENT_SECRET>"
refreshUrl = "<GSHEET_REFRESH_URL>"
refreshToken = "<GSHEET_REFRESH_TOKEN>"
```
> Here   
    * GSHEET_REFRESH_URL : https://www.googleapis.com/oauth2/v3/token  
    * SALESFORCE_REFRESH_URL : https://login.salesforce.com/services/oauth2/token


### Template Configuration
1. Obtain the `spreadsheetId` and `workSheetName` of the Google sheet you are interested in appending data. 

    **!!! NOTE:** Spreadsheet ID is available in the spreadsheet URL "https://docs.google.com/spreadsheets/d/" + <SPREADSHEET_ID> + "/edit#gid=" + <WORKSHEET_ID>
2. Once you obtained all configurations, Create `Config.toml` in root directory.
3. Replace the necessary fields in the `Config.toml` file with your data.

## Testing
Run the Ballerina project created by the integration template by executing `bal run` from the root.

So once a new Lead is added in Salesforce, new row will be appended with specified fields in Google sheet.
