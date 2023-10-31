# Salesforce New Hot Lead to Slack Channel Message
## Use case
It is important to follow up with `Hot` leads as soon as they are added to increase the efficiency of your sales team. 
For constant communication your organization might use a dedicated Slack Channel for new Salesforce updates. Using this 
sample you can send notification to your sales team's Slack Channel whenever a new `Hot` lead is created. 

## Prerequisites
* Salesforce Account 
* Slack Account

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

    Once you obtained all configurations, Replace "" in the `Config.toml` file with your data. For the `sfdcPassword` insert
    the combination of your Salesforce account password with the security token received
6. [Select Objects](https://developer.salesforce.com/docs/atlas.en-us.change_data_capture.meta/change_data_capture/cdc_select_objects.htm) for Change Notifications in the User Interface of Salesforce account.

### Setting up Slack account
1. Create a Slack app which connects to your development workspace. More information on this can be found [here](https://api.slack.com/start).
2. Obtain a User OAuth token for the app visiting `OAuth & Permissions` tab in app `Features`.
3. Generate an OAuth token linking the specific workspace, providing the necessary scopes.

## Template Configuration
Create a file called `Config.toml` at the root of the project.

### Config.toml
```
[<ORG_NAME>.sfdc_hot_lead_to_slack]
salesforceBaseUrl = "<SALESFORCE_BASE_URL>"
slackChannelName = "<SLACK_CHANNEL_NAME>"  
slackToken = "<SLACK_APP_USER_TOKEN>" 

[<ORG_NAME>.sfdc_hot_lead_to_slack.salesforceListenerConfig]
username = "<SALESFORCE_USERNAME>"
password = "<SALESFORCE_PASSWORD>"

[<ORG_NAME>.sfdc_hot_lead_to_slack.salesforceOAuthConfig]
clientId = "<SALESFORCE_CLIENT_ID>"
clientSecret = "<SALESFORCE_CLIENT_SECRET>"
refreshToken = "<SALESFORCE_REFRESH_TOKEN>"
refreshUrl = "<SALESFORCE_REFRESH_URL>"
```
> Note: Here SALESFORCE_REFRESH_URL is https://login.salesforce.com/services/oauth2/token

## Testing
Run the Ballerina project created by the integration sample by executing `bal run` from the root.
You can check for Slack notification on successful creation of Salesforce Hot lead.
