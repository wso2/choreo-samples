# Google Sheets New Row to GitHub New Issue
## Use case
It is important to make day-to-day information organized and represented in a generic format with the help of Google Sheets. By 
using this integration, we can organize and automatically create a new GitHub issue using the row information in a corresponding Google Sheet which will contain information about GitHub issues. 
We can easily keep track of new issues and interact using Google sheets. This sample can be used to create a new issue in a GitHub repository when a new row with the issue information are appended to a Google sheet.

## Prerequisites
* A GitHub Account
* A Google Cloud Platform Account

## Configuration
Create a file called `Config.toml` at the root of the project.

### Config.toml
```
[<ORG_NAME>.gsheet_new_row_to_github_new_issue]
spreadsheetId = "<GSHEET_SPREADSHEET_ID>"
workSheetName = "<GSHEET_WORKSHEET_NAME>"

[<ORG_NAME>.gsheet_new_row_to_github_new_issue.gitHubOAuthConfig]
token = "<GITHUB_PAT_OR_OAUTH_TOKEN>"
```
* GITHUB_PAT_OR_OAUTH_TOKEN - obtain a [Personal access token](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) or [GitHub OAuth App token](https://docs.github.com/en/developers/apps/creating-an-oauth-app).
* GSHEET_SPREADSHEET_ID - GSheet spreadsheetId
* GSHEET_WORKSHEET_NAME - GSheet worksheetName

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
1. Create new spreadsheet. (With the ordered columns `Repository Owner`, `Repository Name`, `Issue Title`, `Issue Content`, `Issue Label List`, `Issue Assignee List` as headings. List should be provided as comma separated values)
2. Enable the App Script trigger by following the above steps.
3. Obtain the `spreadsheetId` and `workSheetName` of the Google sheet you are interested in listening. 

    **!!! NOTE:** Spreadsheet ID is available in the spreadsheet URL "https://docs.google.com/spreadsheets/d/" + <SPREADSHEET_ID> + "/edit#gid=" + <WORKSHEET_ID>
4. Obtain a [GitHub Personal access token](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) or [GitHub OAuth App token](https://docs.github.com/en/developers/apps/creating-an-oauth-app).
5. Once you obtained all configurations, Create `Config.toml` in root directory.
6. Replace the necessary fields in the `Config.toml` file with your data.

## Testing
Run the Ballerina project created by the integration sample by executing `bal run` from the root.

Upon successfully adding a row, You can check the GitHub repository to verify that the new issue is created.

**!!! NOTE:** This sample logic assumes that you provide all the new row values at once. The default behaviour of the Google sheets trigger is that it gets trigered as soon as you leave the cell after inserting a value in that cell. You must append the whole row including all the values for each column. If you don't want to enter a value in a certain cell, keep it empty. But make sure to copy paste the whole row at once.
