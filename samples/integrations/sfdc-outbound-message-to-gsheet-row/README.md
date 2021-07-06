# Template: Add Received Salesforce Outbound Message to Google Sheet row
When new Outbound Message is received from Salesforce, add new row to a Google Sheet.<br>

We can make our day-to-day information organized with the help of Google Sheets. But creating layouts and formatting a
sheet takes much more time than we think. By using this integration, we can organize and automatically set up a Google Sheet
which will contain information about exchanges Salesforce initiated with our callback endpoint.

This template can be used to create a new row in a specific Google Sheet when a new Outbound Message is received from 
Salesforce.

## Use this template to
- Add new row to a Google Sheet containing information in the Outbound Message received from Salesforce.
- Get away from manually tracking all the Outbound Messages received to the callback URL.

## What you need
- A Salesforce Account
- A Google Cloud Platform Account
- An `Outbound Message` which will be triggered by a `Workflow Rule`

## How to set up
- Import the template.
- Allow access to the Salesforce account.
- Select an outbound message.
- Set up a callback URL(webhook).
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
   <td>Google Sheets API Version
   </td>
   <td>V4
   </td>
  </tr>
</table>

## Pre-requisites
* Download and install [Ballerina](https://ballerinalang.org/downloads/).
* Salesforce account
* Google Cloud Platform account

## Account Configuration
### Setup Outbound Message in Salesforce console
1. Setup a new `Outbound Message` in Salesforce visiting `Service Setup` dropdown menu. More information on setting up 
outbound messages can be found [here](https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_om_outboundmessaging_setting_up.htm).
2. Setup a new `Workflow Rule`or select an already existing `Workflow Rule`. More information on this can
be found [here](https://help.salesforce.com/articleView?id=sf.workflow_rules_new.htm&type=5).
3. Link the `Outbound Message` created in [1] to the `Workflow Rule`.

###  Configuration steps for Google Sheets account
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
13. Copy `refresh token`. Put it on the config(Config.toml) file.

## Template Configuration
1. Create new spreadsheet.
2. Rename the sheet if you want.
3. Get the ID of the spreadsheet.  
![alt text](docs/images/spreadsheet_id_example.png?raw=true)
5. Get the worksheet name.
6. Once you obtained all configurations, Create `Config.toml` in root directory.
7. Replace the necessary fields in the `Config.toml` file with your data.

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

## Running the Template
1. First you need to build the integration template and create the executable binary. Run the following command from the 
root directory of the integration template. 
`$ bal build`. 

2. Then you can run the integration binary with the following command. 
`$  bal run target/bin/sdfc_outbound_msg_to_gsheet-0.1.0.jar`. 

3. Now you can do actions which trigger the `Workflow Rule` that is linked to the `Outbound Message` and observe that integration template runtime has 
received the `POST` request to the callback URL specified in the outbound message.

4. You can check the Google Sheet to verify that a new row added containing information in the outbound message. 
