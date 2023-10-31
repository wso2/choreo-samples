# GSheet Row to Zoom Meeting
## Use Case

Add your meeting details in a Google Sheet and let us schedule the meeting and send the invitation to participants. 

When creating a scheduled non-recurring zoom meeting, zoom does not provide any option to add participants. Meeting hosts have to manually share the invitation to the intended participants. Using this sample you can schedule any number of meetings at a time while sending the invitations to the participants automatically as soon as new row with corresponding information is appended to the Google sheet.  Users are also get an opportunity add custom live stream details which can also be shared automatically with all the participants along with the invitation email.

## Prerequisites
* Google Cloud Platform account
* Zoom account

### Setting up Google Cloud Platform account
Create a Google account and create a connected app by visiting [Google cloud platform APIs and Services](https://console.cloud.google.com/apis/dashboard). 

1. Click Library from the left side menu.
2. In the search bar enter Google Sheets.
3. Then select Google Sheets API and click Enable button.
4. Complete OAuth Consent Screen setup.
5. Click Credential tab from left side bar. In the displaying window click Create Credentials button select OAuth client Id.
6. Fill the required field. Add https://developers.google.com/oauthplayground to the Redirect URI field.
7. Get clientId and secret. Put it on the config(Config.toml) file.
8. Visit https://developers.google.com/oauthplayground/ 
    Go to settings (Top right corner) -> Tick 'Use your own OAuth credentials' and insert Oauth ClientId and secret.Click close.
9. Then,Complete Step1 (Select and Authotrize API's)
10. Make sure you select https://www.googleapis.com/auth/drive & https://www.googleapis.com/auth/spreadsheets Oauth scopes.
11. Click Authorize API's and You will be in Step 2.
12. Exchange Auth code for tokens.
13. Copy Access token and Refresh token. Put it on the config(Config.toml) file.

### Setting up Zoom account

1. If you don’t yet have a Zoom account, create your new account by clicking the ‘Sign Up’ link here: https://marketplace.zoom.us/. Once you activate your account, you’ll be ready to join as a Developer account.
2. Create an OAuth2.0 app by visiting [Zoom App Marketplace](https://marketplace.zoom.us/develop/create). Then provide app related information and get client credentials. Please follow the steps in [here](https://marketplace.zoom.us/docs/guides/build/oauth-app) to create and publish a zoom app successfully. 
3. Generate access token and refresh token for your Zoom app following the authorization code flow. Follow the detailed steps given [here](https://marketplace.zoom.us/docs/guides/auth/oauth)
    - Please note that to set live stream details meeting host need to have a Pro license. 
5. Copy the credentials obtained from above steps 2 and 3 and copy them in Config.toml
    - Please note that once you stop the deployment of the sample you need to provide new refresh token for the next run. 

## Configurations 

### Sample Format of the Google Sheet

To configure the content of your Zoom meeting please prepare your Google sheet in following format. 

<p align="center">
<img src="./docs/images/gsheet_format.png?raw=true" alt="Google Sheet Template"/>
</p>

* Start time should be given in `yyyy-MM-dd`T`HH:mm:ss` format and specify the timezone ID in the `Timezone` field. You can find the timezones given by Zoom [here](https://marketplace.zoom.us/docs/api-reference/other-references/abbreviation-lists#timezones).
* Provide duration in minutes
* To set custom streaming details users need to have Pro account. If you does not own a Pro account or not planning to live stream your meeting please keep those fields empty. 
* Please provide the email addresses of intended participants as a comma separated list under the `Participant List` column. 


### Config.toml 

Create a file called `Config.toml` at the root of the project.

```
[<ORG_NAME>.gsheet-row-to-zoom-to-email]
spreadsheetId = "<GSHEET_SPREADSHEET_ID>"
workSheetName = "<GSHEET_WORKSHEET_NAME>"

[<ORG_NAME>.gsheet-row-to-zoom-to-email.zoomAuthConfig]
token = "<ZOOM_ACCESS_TOKEN>"

[<ORG_NAME>.gsheet-row-to-zoom-to-email.GSheetOAuthConfig]
clientId = "<GSHEET_CLIENT_ID>"
clientSecret = "<GSHEET_CLIENT_SECRET>"
refreshToken = "<GSHEET_REFRESH_TOKEN>"
refreshUrl = "<GSHEET_REFRESH_URL>"
```
> Note: Here GSHEET_REFRESH_URL is https://www.googleapis.com/oauth2/v3/token

## Testing
Run the Ballerina project created by the integration sample by executing `bal run` from the root.

Once successfully executed, you will receive a SMS notification on new Spotify releases by your favorite artist.