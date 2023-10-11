Use template (Salesforce Opportunity Update to Slack Channel Message) to send a notification in a given Slack Channel, When an opportunity in Salesforce is updated.

## Use case
It is important to follow up with the updates for your opportunities in Salesforce as soon as they are added to increase 
the efficiency of your sales team. For constant communication your organization might be using a dedicated Slack Channel 
for new Salesforce updates. Using this template you can send notification to your sales team's Slack Channel whenever 
any field of your existing opportunity is updated.  

## Prerequisites
* Pull the template from central  
  `bal new -t choreo/sfdc_opportunity_update_to_slack <newProjectName>`
* Salesforce Account
* Slack Account

### Setting up Salesforce account
* Create a Salesforce account and create a connected app by visiting [Salesforce](https://www.salesforce.com). 
* Salesforce username, password and the security token that will be needed for initializing the listener. 

  For more information on the secret token, please visit [Reset Your Security Token](https://help.salesforce.com/articleView?id=user_security_token.htm&type=5).
  Once you obtained all configurations, Replace "" in the `Config.toml` file with your data.

* [Select Objects](https://developer.salesforce.com/docs/atlas.en-us.change_data_capture.meta/change_data_capture/cdc_select_objects.htm) for Change Notifications in the User Interface of Salesforce account.

### Setting up Slack account
Go to your Slack app and obtain Slack `User OAuth Token` starting with `xoxp-` under `OAuth & Permissions` in App settings. 

Add `User OAuth Token` as `slackToken` and add intended Slack channel name for `slackChannelName`

## Template Configuration
Create a file called `Config.toml` at the root of the project.

### Config.toml 

```
[<ORG_NAME>.sfdc_opportunity_update_to_slack]
salesforceBaseUrl = "<SALESFORCE_BASE_URL>"
slackChannelName = "<SLACK_CHANNEL_NAME>"  
slackToken = "<SLACK_APP_USER_TOKEN>" 

[<ORG_NAME>.sfdc_opportunity_update_to_slack.salesforceListenerConfig]
username = "<SALESFORCE_USERNAME>"
password = "<SALESFORCE_PASSWORD>"

[<ORG_NAME>.sfdc_opportunity_update_to_slack.salesforceOAuthConfig]
clientId = "<SALESFORCE_CLIENT_ID>"
clientSecret = "<SALESFORCE_CLIENT_SECRET>"
refreshToken = "<SALESFORCE_REFRESH_TOKEN>"
refreshUrl = "<SALESFORCE_REFRESH_URL>"
```
> Note: Here SALESFORCE_REFRESH_URL is https://login.salesforce.com/services/oauth2/token


## Testing
Run the Ballerina project created by the integration template by executing `bal run` from the root.
You can check for Slack notification, When an opportunity in Salesforce is updated.
