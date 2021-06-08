# Template: GitHub new commit to Google Sheets row
When new commits are made and pushed in Github, append new rows to a Google Sheet.

We can make our day-to-day information organized and represented in a generic format with the help of Google Sheets. By 
using this integration, we can organize and automatically set up a Google Sheet which will contain information about 
commits made in a specific GitHub repository. 

This template can be used to create new rows in a Google Sheet when new commits are made and pushed.

## Use this template to
- Append new rows to a Google Sheet containing information about the new commits made and pushed to a GitHub repository.
- Get away from manually summarizing all the commits made for a particular GitHub repository of your choice.

## What you need
- A GitHub Account
- A Google Cloud Platform Account

## How to set up
- Import the template.
- Allow access to the GitHub account.
- Select the repository.
- Allow access to the Google account.
- Select spreadsheet.
- Select worksheet.
- Select the fields to include.
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
  <tr>
   <td>GitHub REST API Version
   </td>
   <td>V3
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
* Google Cloud Platform account
* GitHub account

## Account Configuration
### Configuration steps for GitHub account
1. First obtain a [Personal access token](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) or [GitHub OAuth App token](https://docs.github.com/en/developers/apps/creating-an-oauth-app).
2. Next you need to create a Github repository where you want to get new commits to the google spreadsheet.
3. Set the github repo URL in the following format. Replace the `<Github-User-Name>` with the username of the Github account &
`<Repository-Name-To-Get-Commits>` with the name of the repository you created.
    ```
    https://github.com/<Github-User-Name>/<Repository-Name-To-Get-Commits>
    ```
4. Then you can optionally add a github secret for signature validation.
5. To setup a github callback URL, you can install [ngrok](https://ngrok.com/download) and [expose a local web server to 
the internet](https://ngrok.com/docs).
6. Then start the ngork with webhook:Listener service port (8090 in this example) by using the command ./ngrok http 8090 
and obtain a public URL which expose your local service to the internet.
7. Set the github callback URL which is in the format 
    ```
    <public-url-obtained-by-ngrok>/<name-of-the-websub-service>
    ```
    (eg: https://ea0834f44458.ngrok.io/subscriber)
8. Add the accessToken, githubRepoURL and githubCallback to the config(Config.toml) file.

### Configuration steps for Google sheets account

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

## Template Configuration
1. Create new spreadsheet.
2. Rename the sheet if you want.
3. Get the ID of the spreadsheet.
Spreadsheet ID in the URL "https://docs.google.com/spreadsheets/d/" + `<spreadsheetId>` + "/edit#gid=" + `<worksheetId>` 
5. Get the work sheet name.
6. Once you obtained all configurations, Create `Config.toml` in root directory.
7. Replace the necessary fields in the `Config.toml` file with your data.

## Config.toml 
```
[<ORG_NAME>.github_new_commit_to_google_sheet_row]
spreadsheetId = "<GSHEET_SPREADSHEET_ID>"
worksheetName = "<GSHEET_WORKSHEET_NAME>"
githubRepoURL = "<GITHUB_REPO_URL>"
githubCallback = "<GITHUB_CALLBACK_URL>"

[<ORG_NAME>.github_new_commit_to_google_sheet_row.sheetOauthConfig]
clientId = "<GSHEET_CLIENT_ID>"
clientSecret = "<GSHEET_CLIENT_SECRET>"
refreshUrl = "<GSHEET_REFRESH_URL>"
refreshToken = "<GSHEET_REFRESH_TOKEN>"

[<ORG_NAME>.github_new_commit_to_google_sheet_row.gitHubTokenConfig]
token = "<GITHUB_PAT_OR_OAUTH_TOKEN>"
```

## Running the Template
1. First you need to build the integration template and create the executable binary. Run the following command from the 
root directory of the integration template. 
`$ bal build`. 

2. Then you can run the integration binary with the following command. 
`$ bal run /target/bin/github_new_commit_to_google_sheet_row.jar`. 

3. Now you can add new commits in Github Account and observe that integration template runtime has received the event 
notification for new commits on push.

4. You can check the Google Sheet to verify that new commits are added to the Specified Sheet. 
