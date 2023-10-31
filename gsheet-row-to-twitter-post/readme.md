# Google Sheets Row to Twitter Post
## Use case
Update a Twitter post when date specified for that twitter messages matches current date.

## Prerequisites
* Google Cloud Platform account
* Twitter account

### Setting up Google Cloud Platform account
Create a Google account and create a connected app by visiting [Google cloud platform APIs and Services](https://console.cloud.google.com/apis/dashboard). 

1. Click Library from the left side menu.
2. In the search bar enter Google Sheets.
3. Then select Google Sheets API and click Enable button.
4. Complete OAuth Consent Screen setup.
5. Click Credential tab from left side bar. In the displaying window click Create Credentials button
Select OAuth client Id.
6. Fill the required field. Add https://developers.google.com/oauthplayground to the Redirect URI field.
7. Get clientId and secret. Put it on the config(Config.toml) file.
8. Visit https://developers.google.com/oauthplayground/ 
    Go to settings (Top right corner) -> Tick 'Use your own OAuth credentials' and insert Oauth ClientId and secret.Click close.
9. Then,Complete Step1 (Select and Authotrize API's)
10. Make sure you select https://www.googleapis.com/auth/drive & https://www.googleapis.com/auth/spreadsheets Oauth scopes.
11. Click Authorize API's and You will be in Step 2.
12. Exchange Auth code for tokens.
13. Copy Access token and Refresh token. Put it on the config(Config.toml) file.

### Setup Twitter Configurations
1. Visit [Twitter](https://developer.twitter.com/en) and create a Twitter Developer Account.
2. Create a app in developer portal and obtain the following credentials:
    *   Api Key
    *   Api Secret
    *   Access Token
    *   AccessToken Secret

### Creating Spreadsheet with data

1. Structure of the table

    | Date        | Tweet message |
    |-------------|---------------|
    | 2022-02-11  | Sample Tweet1 |
    | 2022-03-11  | Sample Tweet2 |
    | 2022-02-20  | Sample Tweet3 |

2. How to get spreadsheet ID 
  Your spreadsheet url will look like below. Extract the spreadsheetID from the url. 
  https://docs.google.com/spreadsheets/d/<spreadsheetID>/edit#gid=0 
3. In the sheets toolbar located at the bottom of the window, you will see a tab for each sheet you have. You can get worksheet name from there

## Configuration
Create a file called `Config.toml` at the root of the project.

### Config.toml 

```
[<ORG_NAME>.gsheet_row_to_twitter_post]
lastRowToExecute = <LAST_ROW_TO_EXECUTE>
spreadsheetId = "<GSHEET_SPREADSHEET_ID>"
worksheetName = "<GSHEET_WORKSHEET_NAME>"

[<ORG_NAME>.gsheet_row_to_twitter_post.GSheetOAuthConfig]
clientId = "<GSHEET_CLIENT_ID>"
clientSecret = "<GSHEET_CLIENT_SECRET>"
refreshToken = "<GSHEET_REFRESH_TOKEN>"
refreshUrl = "<GSHEET_REFRESH_URL>"

[<ORG_NAME>.gsheet_row_to_twitter_post.twitterClientConfig]
apiKey = "<TWITTER_API_KEY>"
apiSecret = "<TWITTER_API_SECRET>"
accessToken = "<TWITTER_ACCESS_TOKEN>"
accessTokenSecret = "<TWITTER_ACCESS_TOKEN_SECRET>"
```
> Note: Here GSHEET_REFRESH_URL is https://www.googleapis.com/oauth2/v3/token

## Testing
Run the Ballerina project created by the integration sample by executing bal run from the root.

Once successfully executed, You can check the Twitter to verify that when date in Google sheet row matches current date.
