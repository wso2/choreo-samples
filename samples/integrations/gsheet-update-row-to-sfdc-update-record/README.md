# Template: Update Google Sheet Row to Update Salesforce Record
When Google Sheet rows are updated, update custom Salesforce objects.<br>

When there is a need to store our data specific to bussiness quicky, we can use the Google Sheetsas a quick . But if
we want to store it in a reliable way, we can use Salesforce custom objects. Now, you don't need to waste time copying 
and pasting the data from Google Sheet to Salesforce. In such cases we can use an integration between Google Sheetes and 
Salesforce to make this task easier
 
This template is used for the scenario that once a specific column is updated in a Google Sheet, an objedct is updated 
in the Salesforce.

## Use this template to
- Simultaneously update data inside Salesforce object once the data about that object is changed in GSheet.

## What you need
- A Google Cloud Platform Account
- A Salesfrce Account

## How to set up
- Import the template.
- Allow access to the Google Sheet.
- Select Google Sheet and the Worksheet name.
- Allow access to Salesforce account.
- Set up the template and run.

# Developer Guide
<p align="center">
<img src="./docs/images/template_update_gsheet_rows_to_sfdc_sobjects.png?raw=true" alt="GSheet-Salesforce Integration template overview"/>
</p>

## Supported versions
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
   <td>Google Sheet API
   </td>
   <td>v4
   </td>
  </tr>
  <tr>
   <td>Salesforce API 
   </td>
   <td>v48.0
   </td>
  </tr>
</table>

## Pre-requisites
* Download and install [Ballerina](https://ballerinalang.org/downloads/).
* A Google Cloud Platform Account
* A Salesforce account.
* Ballerina connectors for Google Sheets, Google Drive and Salesforce which will be automatically downloaded when building the application for the first time.

## Account Configuration

### Configuration steps for Google sheets account

1. Create a Google account and create a connected app by visiting [Google cloud platform APIs and Services](https://console.cloud.google.com/apis/dashboard). 
2. Click `Library` from the left side menu.
3. In the search bar enter Google Sheets.
4. Then select Google Sheets API and click `Enable` button.
5. Complete OAuth Consent Screen setup.
6. Click `Credential` tab from left side bar. In the displaying window click `Create Credentials` button
Select OAuth client Id.
7. Fill the required field. Add https://developers.google.com/oauthplayground to the Redirect URI field.
8. Get clientId and secret. Put it on the config(Config.toml) file.
9. Visit https://developers.google.com/oauthplayground/ 
    Go to settings (Top right corner) -> Tick 'Use your own OAuth credentials' and insert Oauth ClientId and secret.Click close.
10. Then,Complete Step1 (Select and Authotrize API's)
11. Make sure you select https://www.googleapis.com/auth/drive & https://www.googleapis.com/auth/spreadsheets Oauth scopes.
12. Click `Authorize API's` and You will be in Step 2.
13. Exchange Auth code for tokens.
14. Copy `Access token` and `Refresh token`. Put it on the config(`Config.toml`) file.
15. Obtain the relevant refresh URLs for each API and include them in the `Config.toml` file.

### Configuration steps for Salesforce account
1. Create a connected app and obtain the following credentials:
    *   Base URL (Endpoint)
    *   Client ID
    *   Client Secret
    *   Refresh Token
    *   Refresh Token URL
2. When you are setting up the connected app, select the following scopes under Selected OAuth Scopes:
    *   Access and manage your data (api)
    *   Perform requests on your behalf at any time (refresh_token, offline_access)
    *   Provide access to your data via the Web (web)
3. Provide the client ID and client secret to obtain the refresh token and access token. For more information on 
obtaining OAuth2 credentials, go to [Salesforce documentation](https://help.salesforce.com/articleView?id=remoteaccess_authenticate_overview.htm).
4. Include them inside the `Config.toml` file.

## Template Configuration
1. Create new spreadsheet
2. Enable the app script trigger if we want to listen to internal changes of a spreadsheet. Follow the following steps 
   to enable the trigger.
    1. Open the Google sheet that you want to listen to internal changes.
    2. Navigate to `Tools > Script Editor`.
    3. Name your project. (Example: Name the project `GSheet_Ballerina_Trigger`)
    4. Remove all the code that is currently in the Code.gs file, and replace it with this:
        ```
        function atChange(e){
            if (e.changeType == "REMOVE_ROW") {
                saveDeleteStatus(1);
            }
        }

        function atEdit(e){
            var source = e.source;
            var range = e.range;

            var a = range.getRow();
            var b = range.getSheet().getLastRow();
            var previousLastRow = Number(getValue());
            var deleteStatus = Number(getDeleteStatus());
            var eventType = "edit";

            if ((a == b && b != previousLastRow) || (a == b && b == previousLastRow && deleteStatus == 1)) {
                eventType = "appendRow";
            }
            else if ((a != b) || (a == b && b == previousLastRow && deleteStatus == 0)) {
                eventType = "updateRow";
            }
            
            var formData = {
                    'spreadsheetId' : source.getId(),
                    'spreadsheetName' : source.getName(),
                    'worksheetId' : range.getSheet().getSheetId(),
                    'worksheetName' : range.getSheet().getName(),
                    'rangeUpdated' : range.getA1Notation(),
                    'startingRowPosition' : range.getRow(),
                    'startingColumnPosition' : range.getColumn(),
                    'endRowPosition' : range.getLastRow(),
                    'endColumnPosition' : range.getLastColumn(),
                    'newValues' : range.getValues(),
                    'lastRowWithContent' : range.getSheet().getLastRow(),
                    'lastColumnWithContent' : range.getSheet().getLastColumn(),
                    'previousLastRow' : previousLastRow,
                    'eventType' : eventType,
                    'eventData' : e
            };
            var payload = JSON.stringify(formData);

            var options = {
                'method' : 'post',
                'contentType': 'application/json',
                'payload' : payload
            };

            UrlFetchApp.fetch('<BASE_URL>/onEdit/', options);

            saveValue(range.getSheet().getLastRow());
            saveDeleteStatus(0);
        }

        var properties = PropertiesService.getScriptProperties();

        function saveValue(lastRow) {
            properties.setProperty('PREVIOUS_LAST_ROW', lastRow);
        }

        function getValue() {
            return properties.getProperty('PREVIOUS_LAST_ROW');
        }

        function saveDeleteStatus(deleteStatus) {
            properties.setProperty('DELETE_STATUS', deleteStatus);
        }

        function getDeleteStatus() {
            return properties.getProperty('DELETE_STATUS');
        }
       ```
        We’re using the UrlFetchApp class to communicate with other applications on the internet.

    5. Replace the <BASE_URL> section with the base URL where your listener service is running. (Note: You can 
       use [ngrok](https://ngrok.com/docs) to expose your web server to the internet. Example: 'https://7745640c2478.ngrok.io/onChange/')
    6. Navigate to the `Triggers` section in the left menu of the editor.
    7. Click `Add Trigger` button.
    8. Then make sure you 'Choose which function to run' is `atChange` then 'Select event source' is `From spreadsheet` 
       then 'Select event type' is  `On change` then click Save!.
    9. This will prompt you to authorize your script to connect to an external service. Click “Review Permissions” and 
       then “Allow” to continue.
    10. Repeat the same process, add a new trigger this time choose this 'Choose which function to run' is `atEdit` 
        then 'Select event source' is `From spreadsheet` then 'Select event type' is  `On edit` then click Save!.
    11. Your triggers will now work as you expect, if you go edit any cell and as soon as you leave that cell this 
        trigger will run, and it will hit your endpoint with the data!
3. Make sure the GSheet callback URL is in the following format (In the app script).

    ```
    <BASE_URL>/onEdit
    ``` 
    Here the `<BASE_URL>` is the endpoint url where the GSheet listener is running.
    (eg: https://ea0834f44458.ngrok.io/onEdit)
4. Once you obtained all configurations, Create `Config.toml` in root directory.
5. Replace the necessary fields in the `Config.toml` file with your data.

## Config.toml 
```
[<ORG_NAME>.gsheet_update_row_to_sfdc_update_record]
sfdcBaseURL = "<SALESFORCE_BASE_URL>"
sfdcObject = "<SALESFORCE_OBJECT>"
spreadsheetId = "<GSHEET_SPREADSHEET_ID>"
worksheetName = "<GSHEET_WORKSHEET_NAME>"
sfdcClientId = "<SALESFORCE_CLIENT_ID>"
sfdcClientSecret = "<SALESFORCE_CLIENT_SECRET>"
sfdcRefreshToken = "<SALESFORCE_REFRESH_TOKEN>"

[<ORG_NAME>.gsheet_update_row_to_sfdc_update_record.sheetOAuthConfig]
clientId = "<GSHEET_CLIENT_ID>"
clientSecret = "<GSHEET_CLIENT_SECRET>"
refreshUrl = "<GSHEET_REFRESH_URL>"
refreshToken = "<GSHEET_REFRESH_TOKEN>"

```

## Running the template
1. First you need to build the integration template and create the executable binary. Run the following command from the 
   root directory of the integration template. 
`$ bal build`. 

2. Then you can run the integration binary with the following command. 
`$ target/bin/gsheet_update_row_to_sfdc_update_record.jar`. 

Successful listener startup will print following in the console.
```
[ballerina/http] started HTTP/WS listener 0.0.0.0:8090
```
3. Now you can update a row in Google Sheet and observe if integration template runtime has 
   logged the status of the response.

4. You can check the Salesforce account  to verify if  the record is updated. 
