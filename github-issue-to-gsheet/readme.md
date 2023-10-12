Use template (GitHub New Issue to Google Sheets Row) to add a new Google Sheet row for a new GitHub issue.

## Use case
We can make our day-to-day information organized and represented in a generic format with the help of Google Sheets. By
using this integration, we can organize and automatically set up a Google Sheet which will contain information about
issues created in a specific GitHub repository. This template can be used to create a new row in a Google Sheet when a new Issue is opened on a specific GitHub repository.

## Prerequisites
* Pull the template from central  
  `bal new -t choreo/github_issue_to_gsheet <newProjectName>`
* GitHub Account
* Google Cloud Platform account

### Setting up Google Cloud Platform Account
Create a Google account and create a connected app by visiting [Google cloud platform APIs and Services](https://console.cloud.google.com/apis/dashboard).

1. Click `Library` from the left sidebar.
2. In the search bar enter Google Sheets.
3. Then select Google Sheets API and click Enable button.
4. Complete OAuth Consent Screen setup.
5. Click the `Credential` tab from the left sidebar. In the displaying window click the `Create Credentials` button
   Select OAuth client ID.
6. Fill the required field. Add https://developers.google.com/oauthplayground to the Redirect URI field.
7. Get client ID and client secret. Put it on the config(Config.toml) file.
8. Visit https://developers.google.com/oauthplayground/
   Go to Settings (Top right corner) -> Tick 'Use your own OAuth credentials' and insert OAuth client ID and client secret.
   Click close.
9. Then, Complete step 1 (Select and Authorize APIs)
10. Make sure you select https://www.googleapis.com/auth/drive & https://www.googleapis.com/auth/spreadsheets Oauth scopes.
11. Click `Authorize APIs` and You will be in step 2.
12. Exchange Auth code for tokens.
13. Copy `access token` and `refresh token`.

### Configure Github webhook with the URL of the service
* You can install webhooks on an organization or on a specific repository.
* To set up a webhook, go to the settings page of your repository or organization. From there, click Webhooks, then Add webhook.
* Webhooks require a few configuration options before you can make use of them
[More information on setting up a webhook for GitHub Async trigger](https://github.com/ballerina-platform/asyncapi-triggers/blob/main/asyncapi/github/Module.md#step-5-configure-github-webhook-with-the-url-of-the-service)

## Configuration
Create a file called `Config.toml` at the root of the project.

## Config.toml
```
[<ORG_NAME>.github_issue_to_gsheet]
spreadsheetId = "<GSHEET_SPREADSHEET_ID>"
worksheetName = "<GSHEET_WORKSHEET_NAME>"

[<ORG_NAME>.github_issue_to_gsheet.GSheetOAuthConfig]
clientId = "<GSHEET_CLIENT_ID>"
clientSecret = "<GSHEET_CLIENT_SECRET>"
refreshToken = "<GSHEET_REFRESH_TOKEN>"
refreshUrl = "<GSHEET_REFRESH_URL>"

[<ORG_NAME>.github_issue_to_gsheet.gitHubListenerConfig]
secret = "<SECRET>"
```

* GSHEET_SPREADSHEET_ID - Spreadsheet ID in the URL.
    ```
    https://docs.google.com/spreadsheets/d/ + <spreadsheetId> + /edit#gid= + <worksheetId>
    ```
* GSHEET_WORKSHEET_NAME - Google Sheets worksheet name.
* GSHEET_REFRESH_TOKEN - Refresh token generated in Google OAuth playground using a client ID and client secret.
* GSHEET_REFRESH_URL - Refresh Url to regenerate token. Here REFRESH_URL for Google Sheets API is `https://www.googleapis.com/oauth2/v3/token`.
* GSHEET_CLIENT_ID - Google cloud platform account client ID.
* GSHEET_CLIENT_SECRET - Google cloud platform account client secret
* SECRET - This secret will be used in registering webhook

## Testing
Run the Ballerina project created by the integration template by executing `bal run` from the root.

Once successfully executed, New row will be added each time when a GitHub issue is created.
