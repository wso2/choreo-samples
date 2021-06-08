# Template: Add a row in Google Sheet when a record is updated in Salesforce

When a record is updated in Salesforce, add a new row in Google sheets.

It is tiresome to continuously go through Google Sheets and Salesforce to update them with data from your updated records. Automating this process would save the effort and time of Salesforce admins. We use spreadsheets to append new Salesforce records and track them easily to share across multiple stackholders. But manually adding a row in a spreadsheet with the updated Salesforce record information is an annoying task. 

This template can be used to add a new row in a specific Google Sheet with all the defined fields of a particular SObject, when a record is updated in Salesforce.

## Use this template to
- Add a new row in Google Sheet with the updated information, when a record is updated in Salesforce.

## What you need
- A Salesforce Account
- A Google Cloud Platform Account

## How to set up
- Import the template.
- Allow access to the Salesforce account.
- Select a push topic.
- Allow access to the Google account.
- Select spreadsheet.
- Select worksheet.
- Set up the template. 

# Developer Guide
<p align="center">
<img src="./docs/images/template_flow.png?raw=true" alt="Salesforce-GSheet Integration template overview"/>
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
   <td>Salesforce API 
   </td>
   <td>v48.0
   </td>
  </tr>
  <tr>
   <td>Google Sheets API Version
   </td>
   <td>V4
   </td>
  </tr>
</table>

## Pre-requisites
* Download and install [Ballerina](https://ballerinalang.org/downloads/).
* Salesforce account
* Google Cloud Platform Account
* Ballerina connectors for Salesforce and Google Sheets which will be automatically downloaded when building the application for the first time

## Account Configuration
### Configuration steps for Salesforce account

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

### Setup Google Sheets Configuration
Create a Google account and create a connected app by visiting [Google cloud platform APIs and Services](https://console.cloud.google.com/apis/dashboard). 

1. Create a Google account and create a connected app by visiting [Google cloud platform APIs and Services](https://console.cloud.google.com/apis/dashboard). 
2. Click Library from the left side menu.
3. In the search bar enter Google Sheets.
4. Then select Google Sheets API and click Enable button.
5. Complete OAuth Consent Screen setup.
6. Click Credential tab from left side bar. In the displaying window click Create Credentials button
Select OAuth client Id.
7. Fill the required field. Add https://developers.google.com/oauthplayground to the Redirect URI field.
8. Get clientId and secret. Put it on the config(Config.toml) file.
9. Visit https://developers.google.com/oauthplayground/ 
    Go to settings (Top right corner) -> Tick 'Use your own OAuth credentials' and insert Oauth ClientId and secret.Click close.
10. Then,Complete Step1 (Select and Authotrize API's)
11. Make sure you select https://www.googleapis.com/auth/drive & https://www.googleapis.com/auth/spreadsheets Oauth scopes.
12. Click Authorize API's and You will be in Step 2.
13. Exchange Auth code for tokens.
14. Copy Access token and Refresh token. Put it on the config(Config.toml) file.

## Configuring the Integration Template

1. Create new spreadsheet.
2. Rename the sheet if you want.
3. Get the ID of the spreadsheet.  
![alt text](docs/images/spreadsheet_id_example.jpeg?raw=true)
5. Get the sheet name
6. Once you obtained all configurations, Create `Config.toml` in root directory.
7. Replace "" in the `Config.toml` file with your data.

### Config.toml 

#### ballerinax/sfdc related configurations 

```
[ballerinax.sfdc_update_record_to_gsheet_new_row]
sfdcBaseURL = "<SALESFORCE_ACCOUNT_DOMAIN_URL>"
sfdcUsername = "<SALESFORCE_USERNAME>"
sfdcPassword = "<SALESFORCE_PASSWORD>"
sfdcObject = "<SALESFORCE_OBJECT_NAME>"
sfdcClientId = "<SALESFORCE_CLIENT_ID>"
sfdcClientSecret = "<SALESFORCE_CLIENT_SECRET>"
sfdcRefreshToken = "<SALESFORCE_REFRESH_TOKEN>"

```
#### ballerinax/googleapis.sheet related configurations  

```
[<ORG_NAME>.sfdc_update_record_to_gsheet_new_row]
spreadsheetId = "<GSHEET_SPREADSHEET_ID>"
worksheetName = "<GSHEET_WORKSHEET_NAME>"

[<ORG_NAME>.sfdc_update_record_to_gsheet_new_row.sheetOAuthConfig]
clientId = "<GSHEET_CLIENT_ID>"
clientSecret = "<GSHEET_CLIENT_SECRET>"
refreshUrl = "<GSHEET_REFRESH_URL>"
refreshToken = "<GSHEET_REFRESH_TOKEN>"
```

## Running the Template

1. First you need to build the integration template and create the executable binary. Run the following command from the root directory of the integration template. 
`$ bal build`. 

2. Then you can run the integration binary with the following command. 
`$ bal run target/bin/sfdc_update_record_to_gsheet_new_row.jar`. 

Successful listener startup will print following in the console.
```
>>>>
[2020-09-25 11:10:55.552] Success:[/meta/handshake]
{ext={replay=true, payload.format=true}, minimumVersion=1.0, clientId=1mc1owacqlmod21gwe8arhpxaxxm, supportedConnectionTypes=[Ljava.lang.Object;@21a089fc, channel=/meta/handshake, id=1, version=1.0, successful=true}
<<<<
>>>>
[2020-09-25 11:10:55.629] Success:[/meta/connect]
{clientId=1mc1owacqlmod21gwe8arhpxaxxm, advice={reconnect=retry, interval=0, timeout=110000}, channel=/meta/connect, id=2, successful=true}
<<<<
```

3. Now you can update a record in Salesforce Object and observe that integration template runtime has received the event notification for record update.

4. You can check the Google Sheet to verify that the updated record is added to the specified Sheet. 


