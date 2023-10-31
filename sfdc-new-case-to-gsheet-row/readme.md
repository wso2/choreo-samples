# Salesforce New Case to Google Sheets Row
## Use case
This integration sample helps to create a spreadsheet for each new case in salesforce. There is a listener in the
sample. It listens to the changes that happen for a case record in salesforce. If there is a new case created in the salesforce then this sample fetches all data of that case record and creates a spreadsheet with the case information.

## Prerequisites
* Netsuite account
* Google cloud platform account

### Setting up Salesforce account
1. Create a Salesforce account and create a connected app by visiting [Salesforce](https://www.salesforce.com).
2. Obtain the following parameters:
* Salesforce Username
* Salesforce Password with security token
* [Select Objects](https://developer.salesforce.com/docs/atlas.en-us.change_data_capture.meta/change_data_capture/cdc_select_objects.htm) for Change Notifications in the User Interface of Salesforce account.

3. For more information on obtaining Security token, visit
   [Salesforce help documentation](https://help.salesforce.com/articleView?id=sf.user_security_token.htm&type=5)
   or follow the
   [Setup tutorial](https://medium.com/creme-de-la-crm/salesforce-how-to-abcs-g-bfa592792649).

### Setting up Google Cloud Platform Account
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
13. Copy `access token` and `refresh token`.

## Configuration
Create a file called `Config.toml` at the root of the project.

#### Config.conf
```
[<ORG_Name>.sfdc_new_case_to_gsheet]
spreadsheetId = "<SPREADSHEET_ID>"
worksheetName = "<WORKSHEET_NAME>"
salesforceBaseUrl ="<SF_BASE_URL>"

[<ORG_Name>.sfdc_new_case_to_gsheet.salesforceListenerConfig]
username = "<SF_USERNAME>"
password = "<SF_PASSWORD>"

[<ORG_Name>.sfdc_new_case_to_gsheet.salesforceClientConfig]
clientId = "<SF_CLIENT_ID>"
clientSecret = "<SF_CLIENT_SECRET>"
refreshUrl = "<SF_REFERSH_URL>"
refreshToken = "<SF_REFRESH_TOKEN>"


[<ORG_Name>.sfdc_new_case_to_gsheet.GSheetOauthConfig]
clientId = "<GSHEET_CLIENT_ID>"
clientSecret = "<GSHEET_CLIENT_SECRET>"
refreshUrl = "<GSHEET_REFERSH_URL>"
refreshToken = "<GSHEET_REFRESH_TOKEN>"

```
> Here   
    * GSHEET_REFERSH_URL : https://www.googleapis.com/oauth2/v3/token  
    * SF_REFERSH_URL : https://login.salesforce.com/services/oauth2/token

## Testing
Run the Ballerina project created by the integration sample by executing `bal run` from the root.

Now You can check for new Google sheet rows on Salesforce new cases. 


