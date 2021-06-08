# Template: Salesforce New Record to Google Sheet Row
When a new Salesforce record is created, add a new row to a Google Sheet.<br>

For more successfull growth of a business, continuous awareness on the changes of your Salesforce account is crucial. Using this templates user can maintain the Salesforce records in a Google Sheet allowing easy and organized access to the important data.<br> 

Using this template user can get newly added records into a selected Google Sheet realtime. User can select the SObject he/she needs to maintain a seperate Google Sheet and every new record of that SObject will be added into the Sheet.

## Use this template to
- Add new row to a Google Sheet when a new record is added, containing all the information available for that Salesforce Object.
- Get away from manually tracking your Salesforce account.

## What you need
- A Salesforce Account
- A Slack Account

## How to set up
- Import the template
- Allow access to the Salesforce account
- Select the repository
- Allow access to the Google account
- Select spreadsheet
- Select worksheet
- Set up the template.

# Developer Guide

<p align="center">
<img src="./docs/images/new_record.png?raw=true" alt="Salesforce-GSheet Integration template overview"/>
</p>

## Supported versions

<table>
  <tr>
   <td>Ballerina Language Version
   </td>
   <td>Swan Lake Alpha5
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
* Google Cloud Platform Account
* Ballerina connectors for Salesforce and Google Sheets which will be automatically downloaded when building the application for the first time


## configuration
### Setup Salesforce Configurations

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

### Setup Google Sheets Configurations
Create a Google account and create a connected app by visiting [Google cloud platform APIs and Services](https://console.cloud.google.com/apis/dashboard). 

1. Click Library from the left side menu.
2. In the search bar enter Google Sheets.
3. Then select Google Sheets API and click Enable button.
4. Complete OAuth Consent Screen setup.
5. Click Credential tab from left side bar. In the displaying window click `Create Credentials` button and select `OAuth client Id`.
6. Fill the required field. Add https://developers.google.com/oauthplayground to the Redirect URI field.
7. Get clientId and secret. Put it on the config(Config.toml) file.
8. Visit https://developers.google.com/oauthplayground/ 
    Go to settings (Top right corner) -> Tick 'Use your own OAuth credentials' and insert Oauth ClientId and secret.Click close.
9. Then,Complete Step1 (Select and Authotrize API's)
10. Make sure you select https://www.googleapis.com/auth/drive & https://www.googleapis.com/auth/spreadsheets Oauth scopes.
11. Click Authorize API's and You will be in Step 2.
12. Exchange Auth code for tokens.
13. Copy Access token and Refresh token. Put it on the config(Config.toml) file.

## Configuring the Integration Template

1. Create new spreadsheet.
2. Rename the sheet if you want.
3. Get the ID of the spreadsheet.  
![alt text](./docs/images/spreadsheet_id_example.jpeg?raw=true)
5. Get the sheet name
6. Once you obtained all configurations, Create `Config.toml` in root directory.
7. Replace "" in the `Config.toml` file with your data.

### Config.toml 

#### ballerinax/sfdc related configurations 

```
[<ORG_NAME>.sfdc_new_record_to_google_sheet_row]
sfdcClientId = "<SALESFORCE_CLIENT_ID>"
sfdcClientSecret = "<SALESFORCE_CLIENT_SECRET>"
sfdcRefreshToken = "<SALESFORCE_REFRESH_TOKEN>"
sfdcBaseUrl = "<SALESFORCE_BASE_URL>"
sfdcObject = "<SALESFORCE_OBJECT_NAME>"
```

#### ballerinax/googleapis_sheet related configurations  

```
[<ORG_NAME>.sfdc_new_record_to_google_sheet_row]
spreadsheetId = "<GSHEET_SPREADSHEET_ID>"
worksheetName = "<GSHEET_WORKSHEET_NAME>"

[<ORG_NAME>.sfdc_new_record_to_google_sheet_row.sheetOAuthConfig]
clientId = "<GSHEET_CLIENT_ID>"
clientSecret = "<GSHEET_CLIENT_SECRET>"
refreshUrl = "<GSHEET_REFRESH_URL>"
refreshToken = "<GSHEET_REFRESH_TOKEN>"
``` 

## Running the Template

1. First you need to build the integration template and create the executable binary. Run the following command from the root directory of the integration template. 
`$ bal build`. 

2. Then you can run the integration binary with the following command. 
`$ bal run /target/bin/sfdc_new_record_to_google_sheet_row.jar`. 

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

3. Now you can add new record in Salesforce Object and observe that integration template runtime has received the event notification for new record creation.

4. You can check the Google Sheet to verify that new record is added to the Specied Sheet. 
