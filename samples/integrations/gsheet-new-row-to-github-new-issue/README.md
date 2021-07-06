# Template: Google Sheets New Row to Github New Issue
When a new row with issue information is appended in Google sheet, create a new Github issue.

We can make our day-to-day information organized and represented in a generic format with the help of Google Sheets. By 
using this integration, we can organize and automatically create a new Github issue using the row information in a corresponding Google Sheet which will contain information about Github issues. We can easily keep track of new issues and interact using Google sheets.

This template can be used to create a new issue in a Github repository when a new row with the issue information are appended to a Google sheet.

## Use this template to
- Create new Github issue using the issue information in the corresponding new row of a Google sheet.

## What you need
- A GitHub Account
- A Google Cloud Platform Account

## How to set up
- Import the template.
- Allow access to the GitHub account.
- Select the repository.
- Allow access to the Google account.
- Enable Google App Script Trigger.
- Set up the template. 

# Developer Guide
<p align="center">
<img src="./docs/images/template_flow.png?raw=true" alt="Github-Google Sheet Integration template overview"/>
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
   <td>Google Sheets API Version
   </td>
   <td>V4
   </td>
  </tr>
  <tr>
   <td>GitHub REST API Version
   </td>
   <td>V3
   </td>
  </tr>
</table>

## Pre-requisites
* Download and install [Ballerina](https://ballerinalang.org/downloads/).
* Google Cloud Platform account
* GitHub account

## Account Configuration
### Configuration steps for GitHub account
1. First obtain a [Personal access token](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) or [GitHub OAuth App token](https://docs.github.com/en/developers/apps/creating-an-oauth-app).
2. Next you need to create a Github repository where you want to create new issues from the google spreadsheet.
3. Add the Github accessToken to the config(Config.toml) file.

### Configuration steps for Google Sheets account

We need to enable the app script trigger if we want to listen to internal changes of a spreadsheet. Follow the following steps to enable the trigger.

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

5. Replace the <BASE_URL> section with the base URL where your listener service is running. (Note: You can use [ngrok](https://ngrok.com/docs) to expose your web server to the internet. Example: 'https://7745640c2478.ngrok.io/onEdit/')
6. Navigate to the `Triggers` section in the left menu of the editor.
7. Click `Add Trigger` button.
8. Then make sure you 'Choose which function to run' is `atChange` then 'Select event source' is `From spreadsheet` then 'Select event type' is  `On change` then click Save!.
9. This will prompt you to authorize your script to connect to an external service. Click “Review Permissions” and then “Allow” to continue.
10. Repeat the same process, add a new trigger this time choose this 'Choose which function to run' is `atEdit` then 'Select event source' is `From spreadsheet` then 'Select event type' is  `On edit` then click Save!.
11. Your triggers will now work as you expect, if you go edit any cell and as soon as you leave that cell this trigger will run and it will hit your endpoint with the data!

## Template Configuration
1. Create new spreadsheet. (With the ordered columns `Repository Owner`, `Repository Name`, `Issue Title`, `Issue Content`, `Issue Label List`, `Issue Assignee List` as headings. List should be provided as comma separated values)
   <p align="center">
    <img src="./docs/images/sheet_headings.png?raw=true" alt="Salesforce-Google Sheet Integration template overview"/>
   </p>	
2. Enable the App Script trigger.
3. Setup the GSheet listener service port.
4. Setup the GSheet callback URL of the App Script in the following format 

    ```
    <BASE_URL>/onEdit
    ``` 
    Here the `<BASE_URL>` is the endpoint url where the GSheet listener is running.
    (eg: https://ea0834f44458.ngrok.io/onEdit)
5. Setup the GSheet spreadsheetId.
6. Setup the GSheet worksheetName.
7. Obtain the Github PAT or OAuth access token from the Github repository where you want to create new issues.
8. Once you obtained all configurations, Create `Config.toml` in root directory.
9. Replace the necessary fields in the `Config.toml` file with your data.

## Config.toml 
```
[<ORG_NAME>.gsheet_new_row_to_github_new_issue]
githubAccessToken = "<GITHUB_PAT_OR_OAUTH_TOKEN>"
port = <GSHEET_PORT>
spreadsheetId = "<GSHEET_SPREADSHEET_ID>"
workSheetName = "<GSHEET_WORKSHEET_NAME>"
```

## Running the Template
1. First you need to build the integration template and create the executable binary. Run the following command from the 
root directory of the integration template. 
`$ bal build`. 

2. Then you can run the integration binary with the following command. 
`$ bal run /target/bin/gsheet_new_row_to_github_new_issue.jar`. 

3. Now you can add a new row with Github issue information in Google sheets and observe that integration template runtime has received the event 
notification for new rows.

4. You can check the Github repository to verify that the new issue is created. 
