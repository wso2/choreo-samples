# Google Sheets New Row to Zoho People Attendance
## Use case
We can make our day-to-day information organized and represented in a generic format with the help of Google Sheets. Most companies use fingerprint systems to take the attendance of their employees. In such cases, they can append each attendance entry to a Google Sheet. By using this integration, we can automatically add the attendance entry in Zoho People when a new row is added to a Google Sheet which will contain information about the check-in and check-out details of each employee. It will make easy the process of keep tracking the attendance in Zoho People. This sample can be used to add the attendance entry in Zoho People when a new row is added to Google Sheets.

## Prerequisites
* Zoho People account
* Google cloud platform account

### Setting up Zoho People account
1. Visit [Zoho People](https://www.zoho.com/people/) and create a Zoho People account.
2. Register a client and get following credentials by referring [here](https://www.zoho.com/people/api/oauth-steps.html)
    *   Client ID
    *   Client Secret
    *   Refresh Token
    *   Refresh Token URL
3. When you are create the credentials choose the relevant scopes. [Scope details](https://www.zoho.com/people/api/scopes.html)
5. Once you obtained all configurations, Replace "" in the `Config.toml` file with your data.

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
[<ORG_NAME>.gsheet_new_row_to_zoho_people_attendance]
spreadsheetId = "<GSHEET_SPREADSHEET_ID>"
workSheetName = "<GSHEET_WORKSHEET_NAME>"

[<ORG_NAME>.gsheet_new_row_to_zoho_people_attendance.zohoPeopleOAuthConfig]
clientId = "<ZOHO_PEOPLE_CLIENT_ID>"
clientSecret = "<ZOHO_PEOPLE_CLIENT_SECRET>"
refreshToken = "<ZOHO_PEOPLE_REFRESH_TOKEN>"
refreshUrl = "<ZOHO_PEOPLE_REFRESH_URL>"

```
> Here   
    * ZOHO_PEOPLE_REFRESH_URL : https://accounts.zoho.com/oauth/v2/token

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
1. Create new spreadsheet.
   Format the sheet headers as below. So, 1st row should be like this.

   `Employee_ID  CheckIn  CheckOut`	
   **!!! NOTE:** When you append the values to sheet, `Employee_ID` should have the correct value and either one of `CheckIn`  or `CheckOut` should be there in the format of `dd/MM/yyyy HH:mm:ss`. `CheckIn`  and `CheckOut` both also can be in same row along with `Employee_ID`.

2. Enable the App Script trigger by following the above steps.
3. Obtain the `spreadsheetId` and `workSheetName` of the Google sheet you are interested in listening. 

    **!!! NOTE:** Spreadsheet ID is available in the spreadsheet URL "https://docs.google.com/spreadsheets/d/" + <SPREADSHEET_ID> + "/edit#gid=" + <WORKSHEET_ID>. In the sheets toolbar located at the bottom of the window, you will see a tab for each sheet you have. You can get `workSheetName` name from there.
4. Once you obtained all configurations, Create `Config.toml` in root directory.
5. Replace the necessary fields in the `Config.toml` file with your data.

## Testing
Run the Ballerina project created by the integration sample by executing `bal run` from the root.

So once new row is added with specified fields in Google sheet, new attendance will be added in Zoho People. 

 **!!! NOTE:** This sample logic assumes that you provide all the new row values at once. The default behaviour of the Google sheets trigger is that it gets trigered as soon as you leave the cell after inserting a value in that cell. You must append the whole row including all the values for each column. If you don't want to enter a value in a certain cell, keep it empty. But make sure to copy paste the whole row at once.
