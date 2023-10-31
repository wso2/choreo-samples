# Salesforce Record Update to Google Sheets Row Update
## Use case
It is tiresome to continuously go through Google Sheets and Salesforce to update them with data from your updated records. 
Automating this process would save the effort and time of Salesforce admins. We use spreadsheets to append new Salesforce 
records and track them easily to share across multiple stockholders. But manually updating the relevant row in a spreadsheet 
with the updated Salesforce record information is an annoying task. This sample can be used to update the relevant row 
in a specific Google Sheet with all the defined fields of a particular SObject, when a record is updated in Salesforce.

## Prerequisites
* Salesforce account
* Google Cloud Platform Account

### Setting up Salesforce account
1. Create a Salesforce account and create a connected app by visiting [Salesforce](https://www.salesforce.com). 
2. Salesforce username, password will be needed for initializing the listener. 
3. Once you obtained all configurations, Replace "" in the `Config.toml` file with your data.
4. [Select Objects](https://developer.salesforce.com/docs/atlas.en-us.change_data_capture.meta/change_data_capture/cdc_select_objects.htm) for Change Notifications in the User Interface of Salesforce account.

### Setting up Google sheets account

1. Create a Google account and create a connected app by visiting [Google cloud platform APIs and Services](https://console.cloud.google.com/apis/dashboard). 
2. Click Library from the left side menu.
3. In the search bar enter Google Sheets.
4. Then select Google Sheets API and click Enable button.
5. Complete OAuth Consent Screen setup.
6. Click Credential tab from left sidebar. In the displaying window click Create Credentials button
Select OAuth client ID.
7. Fill the required field. Add https://developers.google.com/oauthplayground to the Redirect URI field.
8. Get clientId and secret. Put it on the config(Config.toml) file.
9. Visit https://developers.google.com/oauthplayground/ 
    Go to settings (Top right corner) -> Tick 'Use your own OAuth credentials' and insert Oauth ClientId and secret.Click close.
10. Then,Complete Step1 (Select and Authorize API's)
11. Make sure you select https://www.googleapis.com/auth/drive & https://www.googleapis.com/auth/spreadsheets Oauth scopes.
12. Click Authorize API's, and You will be in Step 2.
13. Exchange Auth code for tokens.
14. Copy Access token and Refresh token. Put it on the config(Config.toml) file.

## Template Configuration
Create a file called `Config.toml` at the root of the project.

### Config.toml

```
[<ORG_NAME>.sfdc_record_update_to_gsheet_update_row]
salesforceBaseUrl = "<SALESFORCE_BASE_URL>"
salesforceObject = "<SALESFORCE_OBJECT_NAME>"
spreadsheetId = "<GSHEET_SPREADSHEET_ID>"
worksheetName = "<GSHEET_WORKSHEET_NAME>"

[<ORG_NAME>.sfdc_record_update_to_gsheet_update_row.salesforceOAuthConfig]
clientId = "<SALESFORCE_CLIENT_ID>"
clientSecret = "<SALESFORCE_CLIENT_SECRET>"
refreshUrl = "<SALESFORCE_REFRESH_URL>"
refreshToken = "<SALESFORCE_REFRESH_TOKEN>"

[<ORG_NAME>.sfdc_record_update_to_gsheet_update_row.salesforceListenerConfig]
username = "<SALESFORCE_USERNAME>"
password = "<SALESFORCE_PASSWORD>"

[<ORG_NAME>.sfdc_record_update_to_gsheet_update_row.GSheetOAuthConfig]
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

Now you can add update records in Salesforce account and observe that integration sample runtime has received the 
event notification for the new record update. You can check the Google Sheet to verify that the relevant record is 
updated in the specified sheet. 
