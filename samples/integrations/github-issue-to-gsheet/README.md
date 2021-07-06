# Template: GitHub New Issue to Google Sheets Row
When a new issue is opened in Github, add a new row to a Google Sheet.

We can make our day-to-day information organized and represented in a generic format with the help of Google Sheets. By 
using this integration, we can organize and automatically set up a Google Sheet which will contain information about 
issues created in a specific GitHub repository. 

This template can be used to create a new row in a Google Sheet when a new Issue is opened on a specific GitHub repository.

## Use this template to
- Add a new row to a Google Sheet containing information about the new issue created in a GitHub repository.
- Get away from manually summarizing all the issues created for a particular GitHub repository of your choice.

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
1. First obtain a [Personal Access Token (PAT)](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) or the [GitHub OAuth App Token](https://docs.github.com/en/developers/apps/creating-an-oauth-app).
2. To create the GitHub topic name, you need to create a github repository where you want to get information of new 
issues to the Google Sheet.
3. Create the GitHub topic name according to the given format. Replace the `GITHUB_USER_NAME` and `REPOSITORY_NAME` using 
your `user name` and `repository name` respectively.
  
```
https://github.com/<GITHUB_USER_NAME>/<REPOSITORY_NAME>/events/*.json"
```
4. Select any value as the github secret.
5. For setting up a GitHub callback URL you can install [ngrok](https://ngrok.com/docs) and expose a local web server to 
the internet.
6. Then start the `ngork` with `webhook:Listener` service port (8080 in this case) by using the command `./ngrok http 8080`
```
  <public-url-obtained-by-ngrok>
```
7. Set the callback URL according to the given format. 
```
<public_url_obtained_by_ngrok>/subscriber
```
(eg: https://ea0834f44458.ngrok.io/subscriber)

8. Use the above obtained values to set github_accessToken, github_secret, github_topic and github_callbackUrl in the 
config(Config.toml) file.

### Configuration steps for Google Sheets account
Create a Google account and create a connected app by visiting [Google cloud platform APIs and Services](https://console.cloud.google.com/apis/dashboard). 

1. Click `Library` from the left side bar.
2. In the search bar enter Google Sheets.
3. Then select Google Sheets API and click Enable button.
4. Complete OAuth Consent Screen setup.
5. Click `Credential` tab from left side bar. In the displaying window click `Create Credentials` button
Select OAuth client Id.
6. Fill the required field. Add https://developers.google.com/oauthplayground to the Redirect URI field.
7. Get client ID and client secret. Put it on the config(Config.toml) file.
8. Visit https://developers.google.com/oauthplayground/ 
    Go to settings (Top right corner) -> Tick 'Use your own OAuth credentials' and insert Oauth client ID and client secret. 
    Click close.
9. Then,Complete step 1 (Select and Authorize APIs)
10. Make sure you select https://www.googleapis.com/auth/drive & https://www.googleapis.com/auth/spreadsheets Oauth scopes.
11. Click `Authorize APIs` and You will be in step 2.
12. Exchange Auth code for tokens.
13. Copy `access token` and `refresh token`. Put it on the config(Config.toml) file.

## Template Configuration
1. Create new spreadsheet.
2. Rename the sheet if you want.
3. Get the ID of the spreadsheet.
![alt text](docs/images/spreadsheet_id_example.png?raw=true)
5. Get the work sheet name.

6. Once you obtained all configurations, Create `Config.toml` in root directory.
7. Replace the necessary fields in the `Config.toml` file with your data.

## Config.toml 
```
[<ORG_NAME>.github_new_issues_to_gsheet]
github_access_token = "<PAT_OR_OAUTH_TOKEN>"
github_secret = "<GITHUB_SECRET>"
github_topic = "<GITHUB_TOPIC>"
github_callback_url = "<CALLBACK_URL>"
sheets_spreadsheet_id = "<SPREADSHEET_ID>"
sheets_worksheet_name = "<WORKSHEET_NAME>"
sheets_refresh_token = "<REFRESH_TOKEN>"
sheets_client_id = "<CLIENT_ID>"
sheets_client_secret = "<CLIENT_SECRET>"
```
## Running the Template
1. First you need to build the integration template and create the executable binary. Run the following command from the 
root directory of the integration template. 
`$ bal build`. 

2. Then you can run the integration binary with the following command. 
`$  bal run target/bin/github_new_issues_to_gsheet-0.1.1.jar`. 

3. Now you can add new issues to the specific GitHub repository and observe that integration template runtime has 
received the event notification for new issue creation.

4. You can check the Google Sheet to verify that new issue is added to the specified sheet. 
