# Send Marketing Email to Salesforce New Lead
## Use case
It is important to follow up with new leads as soon as they are added, to increase the efficiency of your sales team. Sending a proper marketing email with required detail will hook up them with you. This sample will help to send a marketing email via Gmail to new Salesforce lead when it is created in a specific Salesforce account.

## Prerequisites
* Salesforce account 
* Gmail account

### Setting up Salesforce account

1. Visit [Salesforce](https://www.salesforce.com/) and create a Salesforce Account.
2. Create a connected app and obtain the following credentials:
    *   Base URL (Endpoint)
    *   Access Token
    *   Client ID
    *   Client Secret
    *   Refresh Token
    *   Refresh Token URL
3. When you are setting up the connected app, select the following scopes under Selected OAuth Scopes:
    *   Access and manage your data (api)
    *   Perform requests on your behalf at any time (refresh_token, offline_access)
    *   Provide access to your data via the Web (web)
4. Provide the client ID and client secret to obtain the refresh token and access token. For more information on
   obtaining OAuth2 credentials, go to [Salesforce documentation](https://help.salesforce.com/articleView?id=remoteaccess_authenticate_overview.htm).
5.  Salesforce username, password and the security token that will be needed for initializing the listener.
    For more information on the secret token, please visit [Reset Your Security Token](https://help.salesforce.com/articleView?id=user_security_token.htm&type=5).

    Once you obtained all configurations, Replace "" in the `Config.toml` file with your data. For the `password` under `sfdcListenerConfig`, insert the combination of your Salesforce account password with the security token received.
6. [Select Objects](https://developer.salesforce.com/docs/atlas.en-us.change_data_capture.meta/change_data_capture/cdc_select_objects.htm) for Change Notifications in the User Interface of Salesforce account.

### Setting up Gmail account
Create a Google account and create a connected app by visiting [Google cloud platform APIs and Services](https://console.cloud.google.com/apis/dashboard).

1. Click `Library` from the left sidebar.
2. In the search bar enter Gmail.
3. Then select Gmail API and click `Enable` button.
4. Complete OAuth Consent Screen setup.
5. Click the `Credential` tab from the left sidebar. In the displaying window click the `Create Credentials` button
6. Select OAuth client Id.
7. Fill the required field. Add https://developers.google.com/oauthplayground to the Redirect URI field.
8. Get `client ID` and `client secret`. Put it on the config(Config.toml) file.
9. Visit https://developers.google.com/oauthplayground/. Go to Settings (Top right corner) -> Tick 'Use your own OAuth credentials' and insert OAuth client ID and client secret. Click close.
10. Then, Complete step 1 (Select and Authorize APIs)
11. Make sure you select https://mail.google.com/ OAuth scope.
12. Click `Authorize APIs` and You will be in step 2.
13. Exchange Auth code for tokens.
14. Copy `Refresh token`. Put it on the config(`Config.toml`) file.
15. Obtain the relevant `Refresh URL` (For example: https://oauth2.googleapis.com/token) for the Gmail API and include it in the `Config.toml` file.

## Configuration
Create a file called `Config.toml` at the root of the project.

### Config.toml
```
[<ORG_NAME>.marketing_email_to_sfdc_new_lead]
salesforceBaseUrl = "<SALESFORCE_BASE_URL>"

[<ORG_NAME>.marketing_email_to_sfdc_new_lead.sfdcListenerConfig]
username = "<SALESFORCE_USERNAME>"
password = "<SALESFORCE_PASSWORD>"

[<ORG_NAME>.marketing_email_to_sfdc_new_lead.salesforceOAuthConfig]
clientId = "<SALESFORCE_CLIENT_ID>"
clientSecret = "<SALESFORCE_CLIENT_SECRET>"
refreshToken = "<SALESFORCE_REFRESH_TOKEN>"
refreshUrl = "<SALESFORCE_REFRESH_URL>"

[<ORG_NAME>.marketing_email_to_sfdc_new_lead.gmailOAuthConfig]
clientId = "<CLIENT_ID>"
clientSecret = "<CLIENT_SECRET>"
refreshUrl = "<GMAIL_REFRESH_URL>"
refreshToken = "<REFRESH_TOKEN>"
```
> Note: Here SALESFORCE_REFRESH_URL is https://login.salesforce.com/services/oauth2/token and GMAIL_REFRESH_URL is https://oauth2.googleapis.com/token by default.

## Testing
Run the Ballerina project created by the integration sample by executing `bal run` from the root.
When a new lead is added in Salesforce, a marketing email will be sent to that lead's email address via gmail.
