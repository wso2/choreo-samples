# Google Sheets Row Update to Gmail Message
## Use case
When there are multiple tasks to perform by one person it becomes overwhelming how about the state where you have to
send emails to each and every person you update a specific column in a Google sheet?. This sample integrates
Gmail and Google Sheets will be perfect choices for handling this scenario. You can send a Gmail automatically to a
person at that same instant you update your Google Sheet. This sample would be useful for people like accountants,
finance officers, bankers, and others who involve in similar tasks. This sample is used for the scenario that
once a specific column is updated in a Google Sheet, a Gmail is sent to the specified email address of that person.
The use-case involved in this specific sample is updating the bonus amount of a person and at that instance, an
email is sent.

## Prerequisites
* Google cloud platform account
* Gmail account

### Setting up Gmail account
Create a Google account and create a connected app by visiting [Google cloud platform APIs and Services](https://console.cloud.google.com/apis/dashboard).

1. Click `Library` from the left sidebar.
2. In the search bar enter Gmail.
3. Then select Gmail API and click `Enable` button.
4. Complete OAuth Consent Screen setup.
5. Click the `Credential` tab from the left sidebar. In the displaying window click the `Create Credentials` button
6. Select OAuth client Id.
7. Fill the required field. Add https://developers.google.com/oauthplayground to the Redirect URI field.
8. Get `client ID` and `client secret`. Put it on the config(Config.toml) file.
9. Visit https://developers.google.com/oauthplayground/. Go to Settings (Top right corner) -> Tick 'Use your own OAuth credentials' and insert OAuth client ID and client secret. Click close.
10. Then, Complete step 1 (Select and Authorize APIs)
11. Make sure you select https://mail.google.com/ OAuth scope.
12. Click `Authorize APIs` and You will be in step 2.
13. Exchange Auth code for tokens.
14. Copy `Access token` and `Refresh token`. Put it on the config(`Config.toml`) file.
15. Obtain the relevant `Refresh URL` (For example: https://oauth2.googleapis.com/token) for the Gmail API and include it in the `Config.toml` file.

## Configuration
Create a file called `Config.toml` at the root of the project.

### Config.toml
```
[<ORG_NAME>.gsheet_row_update_to_gmail]
spreadsheetId = "<SPREADSHEET_ID>"
worksheetName = "<WORKSHEET_NAME>"
recipientAddress= "<RECIPIENT_ADDRESS>"
senderAddress = "<SENDER_ADDRESS>"

[<ORG_NAME>.gsheet_row_update_to_gmail.gmailOAuthConfig]
clientId = "<CLIENT_ID>"
clientSecret = "<CLIENT_SECRET>"
refreshUrl = "<GMAIL_REFRESH_URL>"
refreshToken = "<REFRESH_TOKEN>"
```
> Note: Here GMAIL_REFRESH_URL is https://oauth2.googleapis.com/token

### Configuration steps for Google App Script Trigger
We need to enable the app script trigger if we want to listen to internal changes of a spreadsheet. Follow the following steps to enable the trigger.

1. Open the Google sheet that you want to listen to internal changes.
2. Navigate to `Extensions > Apps Script`.
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

        UrlFetchApp.fetch('<BASE_URL>', options);

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

5. Replace the <BASE_URL> section with the base URL where your listener service is running. (**!!! NOTE:** Locally, you can use [ngrok](https://ngrok.com/docs) to expose your web server to the internet. Example: 'https://7745640c2478.ngrok.io'. In Choreo, you can obtain this callback URL after App deployment.)
6. Navigate to the `Triggers` section in the left menu of the editor.
7. Click `Add Trigger` button.
8. Then make sure you 'Choose which function to run' is `atChange` then 'Select event source' is `From spreadsheet` then 'Select event type' is  `On change` then click Save!.
9. This will prompt you to authorize your script to connect to an external service. Click “Review Permissions” and then “Allow” to continue.
10. Repeat the same process, add a new trigger this time choose this 'Choose which function to run' is `atEdit` then 'Select event source' is `From spreadsheet` then 'Select event type' is  `On edit` then click Save!.
11. Your triggers will now work as you expect, if you go edit any cell and as soon as you leave that cell this trigger will run, and it will hit your endpoint with the data!

### Template Configuration
1. Create a new spreadsheet
2. Enable the App Script trigger by following the above steps.
3. Obtain the `spreadsheetId` and `workSheetName` of the Google sheet you are interested in listening. 

    **!!! NOTE:** Spreadsheet ID is available in the spreadsheet URL "https://docs.google.com/spreadsheets/d/" + <SPREADSHEET_ID> + "/edit#gid=" + <WORKSHEET_ID>
4. Once you obtained all configurations, Create `Config.toml` in root directory.
5. Replace the necessary fields in the `Config.toml` file with your data.

## Testing
Run the Ballerina project created by the integration sample by executing `bal run` from the root.

So once a row is updated in Google sheet, a new Gmail email will be sent. You can check the Gmail of the receiver to verify the information received. 
