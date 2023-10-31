# SCIM user details to Google Sheets Row
## Use case
We can make our day-to-day information organized and represented in a generic format with the help of Google Sheets. By
using this integration, we can organize and automatically set up a Google Sheet which will contain information about
Users details which are created in the WSO2 identity server.

## Prerequisites
* WSO2 identity server running on the machine
* Google Cloud Platform account

### Setting up Google Cloud Platform Account
Create a Google account and create a connected app by visiting [Google cloud platform APIs and Services](https://console.cloud.google.com/apis/dashboard).

1. Click `Library` from the left sidebar.
2. In the search bar, enter `Google Sheets`.
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

### Create an identity provider with scim-choreo connector in the WSO2 identity server
[All the required steps to create an IDP with scim-choreo connector](https://github.com/wso2-incubator/identity-outbound-provisioning-choreo)

## Configuration
Create a file called `Config.toml` at the root of the project.

* GSHEET_SPREADSHEET_ID - Spreadsheet ID in the URL.
    ```
    https://docs.google.com/spreadsheets/d/ + <spreadsheetId> + /edit#gid= + <worksheetId>
    ```
* GSHEET_WORKSHEET_NAME - Google Sheets worksheet name.
* GSHEET_REFRESH_TOKEN - Refresh token generated in Google OAuth playground using a client ID and client secret.
* GSHEET_CLIENT_ID - Google cloud platform account client ID.
* GSHEET_CLIENT_SECRET - Google cloud platform account client secret.

## Testing
Run the Ballerina project created by the integration sample by executing `bal run` from the root.

Once successfully executed, New row will be added each time when user is created in the WSO2 identity server(with scim-choreo outbound provisioning).
