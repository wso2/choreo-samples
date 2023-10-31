# GitHub New Commit to Google Sheets Row
## Use case
We can make our day-to-day information organized and represented in a generic format with the help of Google Sheets. By 
using this integration, we can organize and automatically set up a Google Sheet which will contain information about 
commits made in a specific GitHub repository. This sample can be used to create new rows in a Google Sheet when new commits are made and pushed.

## Prerequisites
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

## Configuration
Create a file called `Config.toml` at the root of the project.

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
* GSHEET_SPREADSHEET_ID - Spreadsheet ID in the URL.
    ```
    https://docs.google.com/spreadsheets/d/ + <spreadsheetId> + /edit#gid= + <worksheetId>
    ```
* GSHEET_WORKSHEET_NAME - Google Sheets worksheet name.
* GITHUB_REPO_URL - Set the GitHub repository URL in the following format. Replace the `<Github-User-Name>` with 
the username of the GitHub account & `<Repository-Name-To-Get-Issue-Assigned-Events>` with the name of the repository you created.
    ```
    https://github.com/<Github-User-Name>/<Repository-Name-To-Get-Issue-Assigned-Events>
    ```
* GITHUB_CALLBACK_URL - To set up a GitHub callback URL, you can install 
[ngrok](https://ngrok.com/download) and [expose a local webserver to the internet](https://ngrok.com/docs). 
Then start the Ngrok with webhook: Listener service port (8090 in this example) by using the command `./ngrok http 8090`
and obtain a public URL that exposes your local service to the internet. (eg: https://ea0834f44458.ngrok.io).
* GSHEET_REFRESH_TOKEN - Refresh token generated in Google OAuth playground using a client ID and client secret.
* GSHEET_CLIENT_ID - Google cloud platform account client ID.
* GSHEET_CLIENT_SECRET - Google cloud platform account client secret.
* GSHEET_REFRESH_URL - Google cloud platform refresh URL. Here REFRESH_URL for Google Sheets API is `https://www.googleapis.com/oauth2/v3/token`.

## Testing
Run the Ballerina project created by the integration sample by executing `bal run` from the root.

Now for every new commit in specific repo, new row will be added in the sheet specified.
