# Template: Update Google Sheet to Send Gmail
When Google Sheet cell is updated, send a Gmail to the email address of that specific person.<br>

When there are multiple tasks to perform by one person it becomes overwhelming how about the state where you have to 
send emails to each and every person you update a specific column in a Google sheet?. This template which integrates 
Gmail and Google Sheets will be a perfect choice for handling this scenario. You can send a Gmail automatically to a 
person at that same instant you update your Google Sheet. This template would be useful for people like accountants, 
finance officers, bankers and others who involve in similar tasks.
 
This template which is used for the scenario that once a specific column is updated in a Google Sheet, a Gmail is sent 
to the specific email address of that person. The use-case involving in this specific template is updating the bonus 
amount of a person and at that instance an email is sent 

## Use this template to
- Send emails via Gmail, when Google Sheets rows are updated


## What you need
- A Google Cloud Platform Account

## How to set up
- Import the template.
- Allow access to the Google Sheet.
- Select Google Sheet and the Worksheet name.
- Allow access to Gmail account.
- Provide the email addresses to carbon copy, subject of the email, message body
- Set up the template and run.

# Developer Guide
<p align="center">
<img src="./docs/images/template_gsheet_update_row_to_gmail.png?raw=true" alt="GSheet-Gmail Integration template overview"/>
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
   <td>Google Sheet API
   </td>
   <td>v4
   </td>
  </tr>
  <tr>
   <td>Google Drive API
   </td>
   <td>v3
   </td>
  </tr>
  <tr>
   <td>Gmail API 
   </td>
   <td>v1
   </td>
  </tr>
</table>

## Pre-requisites
* Download and install [Ballerina](https://ballerinalang.org/downloads/).
* A Google Cloud Platform Account
* Ballerina connectors for Google Sheets, Google Drive and Gmail which will be automatically downloaded when building the application for the first time.

## Account Configuration
### Configuration of Google Sheets account, Google Drive account and Gmail account
Create a Google account and create a connected app by visiting [Google cloud platform APIs and Services](https://console.cloud.google.com/apis/dashboard). 

1. Click `Library` from the left side bar.
2. In the search bar enter Google Sheets/Google Drive/Gmail.
3. Then select Google Sheets/Google Drive/Gmail API and click `Enable` button.
4. Complete OAuth Consent Screen setup.
5. Click `Credential` tab from left side bar. In the displaying window click `Create Credentials` button
6. Select OAuth client Id.
7. Fill the required field. Add https://developers.google.com/oauthplayground to the Redirect URI field.
8. Get client ID and client secret. Put it on the config(Config.toml) file.
9. Visit https://developers.google.com/oauthplayground/ 
    Go to settings (Top right corner) -> Tick 'Use your own OAuth credentials' and insert Oauth client ID and client secret. 
    Click close.
10. Then,Complete step 1 (Select and Authorize APIs)
11. Make sure you select https://mail.google.com/, https://www.googleapis.com/auth/drive, 
    https://www.googleapis.com/auth/spreadsheets & https://www.googleapis.com/auth/drive OAuth scopes.
12. Click `Authorize APIs` and You will be in step 2.
13. Exchange Auth code for tokens.
14. Copy `access token` and `refresh token`. Put it on the `Config.toml` file under Google Sheet configuration.
15. Obtain the relevant refresh URLs for each API and include them in the `Config.toml` file.

## Template Configuration
1. Create new spreadsheet
2. Enable the app script trigger if we want to listen to internal changes of a spreadsheet. Follow the following steps 
   to enable the trigger.
    1. Open the Google sheet that you want to listen to internal changes.
    2. Navigate to `Tools > Script Editor`.
    3. Name your project. (Example: Name the project    `GSheet_Ballerina_Trigger`)
    4. Remove all the code that is currently in the Code.gs file, and   replace it with this:
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

            if ((a == b && b != previousLastRow) || (a == b && b ==     previousLastRow && deleteStatus == 1)) {
                eventType = "appendRow";
            }
            else if ((a != b) || (a == b && b == previousLastRow &&     deleteStatus == 0)) {
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
                    'lastColumnWithContent' : range.getSheet().getLastColumn    (),
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
        We’re using the UrlFetchApp class to communicate with other     applications on the internet.

    5. Replace the <BASE_URL> section with the base URL where your listener service is running. (Note: You can use [ngrok](https://ngrok.com/docs)  to expose your web server to the internet. Example: 'https://7745640c2478.ngrok.io/onEdit/')
    6. Navigate to the `Triggers` section in the left menu of the editor.
    7. Click `Add Trigger` button.
    8. Then make sure you 'Choose which function to run' is `atChange` then 'Select event source' is `From spreadsheet` then 'Select event type'    is  `On change` then click Save!.
    9. This will prompt you to authorize your script to connect to an   external service. Click “Review Permissions” and then “Allow” to  continue.
    10. Repeat the same process, add a new trigger this time choose this    'Choose which function to run' is `atEdit` then 'Select event source'  is `From spreadsheet` then 'Select event type' is  `On edit` then click  Save!.
    11. Your triggers will now work as you expect, if you go edit any cell and as soon as you leave that cell this trigger will run and it will hit your endpoint with the data!



3. Set up the GSheet callback URL in the following format.

    ```
    <BASE_URL>/onEdit/
    ``` 
    Here the `<BASE_URL>` is the endpoint url where the GSheet listener is running.
    (eg: https://ea0834f44458.ngrok.io/onEdit/)
4. Once you obtained all configurations, Create `Config.toml` in root directory.
5. Replace the necessary fields in the `Config.toml` file with your data.

## Config.toml 
```
[<ORG_NAME>.gsheet_row_update_to_gmail]
spreadsheetId = "<SPREADSHEET_ID>"
worksheetName = "<WORKSHEET_NAME>"
recipientAddress= "<RECIPIENT_ADDRESS>"
senderAddress = "<SENDER_ADDRESS>"

[<ORG_NAME>.gsheet_row_update_to_gmail.sheetOAuthConfig]
clientId = "<CLIENT_ID>"
clientSecret = "<CLIENT_SECRET>"
refreshUrl = "<GSHEET_REFRESH_URL>"
refreshToken = "<REFRESH_TOKEN>"

[<ORG_NAME>.gsheet_row_update_to_gmail.gmailOauthConfig]
clientId = "<CLIENT_ID>"
clientSecret = "<CLIENT_SECRET>"
refreshUrl = "<GMAIL_REFRESH_URL>"
refreshToken = "<REFRESH_TOKEN>"
```
## Running the template
1. First you need to build the integration template and create the executable binary. Run the following command from the 
   root directory of the integration template. 
`$ bal build`. 

2. Then you can run the integration binary with the following command. 
`$ target/bin/template_gsheet_update_row_to_gmail.jar`. 

3. Now you can update the bonus amount for a person in Google Sheet and observe if integration template runtime has 
   logged the status of the response.

4. You can check the Gmail of the receiver to verify that information about the bonus has received. 
