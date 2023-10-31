# Salesforce New Case to Google Sheets New Spreadsheet
## Use case
This integration sample helps to create a spreadsheet for each new cases in salesforce. There is a listner in the sample. 
It listens the changes happens for a case record in salesforce. If there is a new case created in the 
salesforce then this sample fetch all data of that case record and create a spreadsheet with the case information.  

## Prerequisites
* Salesforce account
* Google cloud platform account 

### Setting up Salesforce account

Create a Salesforce account and create a connected app by visiting [Salesforce](https://www.salesforce.com). 
Obtain the following parameters:

* Base URL (Endpoint)
* Client Id
* Client Secret
* Refresh Token
* Refresh URL

For more information on obtaining OAuth2 credentials, visit 
[Salesforce help documentation](https://help.salesforce.com/articleView?id=remoteaccess_authenticate_overview.htm) 
or follow the 
[Setup tutorial](https://medium.com/@bpmmendis94/obtain-access-refresh-tokens-from-salesforce-rest-api-a324fe4ccd9b).

Also, keep a note of your Salesforce username, password and the security token that will be needed for initializing the listener. 

For more information on the secret token, please visit [Reset Your Security Token](https://help.salesforce.com/articleView?id=user_security_token.htm&type=5).

[Select Objects](https://developer.salesforce.com/docs/atlas.en-us.change_data_capture.meta/change_data_capture/cdc_select_objects.htm) for Change Notifications in the User Interface of Salesforce account.

Now let's see how to add Google Sheet configurations

### Setting up Google Sheet account
Create a Google account and create a connected app by visiting [Google cloud platform APIs and Services](https://console.cloud.google.com/apis/dashboard). 

1. Click `Library` from the left side menu.
2. In the search bar enter Google Sheets.
3. Then select `Google Sheets API` and click `Enable` button.
4. Complete OAuth Consent Screen setup (Add required mais as a test user ).
5. Click Credential tab from left side bar. In the displaying window click Create Credentials button
Select OAuth client Id.
6. Fill the required field. (Add https://developers.google.com/oauthplayground/ to the Redirect URI field if you want 
to use [OAuth 2.0 Playground.](https://developers.google.com/oauthplayground/) for accesstoken generation).
7. You can get credentials using `Credentials` tab in left side bar. 
8. Generate access token and refresh token using these credentials ( You can use [OAuth 2.0 Playground.](https://developers.google.com/oauthplayground/) to generate them.)

Get more details about createing OAuth 2.0 client credentials,  [visit here](https://developers.google.com/sheets/api/guides/authorizing)

Obtain the following parameters:

* Client Id
* Client Secret
* Refresh Token
* Refresh URL

## Configuration
Create a file called `Config.toml` at the root of the project.

#### Config.conf
```
[<ORG_Name>.sfdc_new_case_to_gsheet]
salesforceBaseUrl = "<Salesforce Account Domain URL>"

[<ORG_Name>.sfdc_new_case_to_gsheet.salesforceListenerConfig]
username = "<Salesforce Username>"
password = "<Salesforce Password>"

[<ORG_Name>.sfdc_new_case_to_gsheet.salesforceClientConfig]
clientId = "<Salesforce client Id>"
clientSecret = "<Salesforce client secrets>"
refreshUrl = "<Salesforce refresh URL>"
refreshToken = "<Salesforce refresh token>"

[<ORG_Name>.sfdc_new_case_to_gsheet.GSheetOauthConfig]
clientId = "<Sheet client Id>"
clientSecret = "<Sheet client secret>"
refreshUrl = "<Sheet refresh URL>"
refreshToken = "<Sheet refresh token>"

```
> Here   
    * Sheet refresh URL : https://www.googleapis.com/oauth2/v3/token  
    * Salesforce refresh URL : https://login.salesforce.com/services/oauth2/token


## Testing
Run the Ballerina project created by the integration sample by executing `bal run` from the root.

Now you can create a new Salesforce Case and observe that integration sample runtime has received the event notification for the created Salesforce Case. Also you can check the Google drive , there will be a new spreadsheet with Case Number as the spreadsheet name . 
