# CapsuleCRM Opportunities Lost to Slack Channel Message
## Use case
At the execution of this sample, the detailed summary of all the new opportunities lost in CapsuleCRM 
within a particular day will be sent as a Slack channel message. 

## Prerequisites
* CapsuleCRM account
* Slack account

### Setting up CapsuleCRM account
* Visit [Capsule CRM](https://capsulecrm.com) and create a Capsule CRM account.
* Obtain tokens by following [this guide](https://developer.capsulecrm.com/v2/overview/authentication)

### Setting up Slack account
* Create a Slack account.
  1. Visit https://slack.com/get-started#/createnew and create a Slack account.
* Obtain Slack User OAuth Token.
  1. Visit https://api.slack.com/apps and create a Slack App.
  2. In the `Add features and functionality` section, Click `Permissions`.
  3. Go to the `Scopes` section and add necessary OAuth scopes in `User Token Scopes` section. (For example: "channels:history", "channels:read", "channels:write", "chat:write", "emoji:read", files:read", "files:write", "groups:read", "reactions:read", "users:read", "users:read.email")
  4. Go back to `Basic Information` section of your Slack App. Then go to `Install your app` section and install the app to the workspace by clicking `Install to Workspace` button.
  5. Get your User OAuth token starting with `xoxp-` from the `OAuth & Permissions` section in App settings of your Slack App.

## Configuration
Create a file called `Config.toml` at the root of the project.

### Config.toml 

```
[<ORG_NAME>.capsulecrm_opportunities_lost_to_slack_channel_message]
channelName= "<SLACK_CHANNEL_NAME>"

[<ORG_NAME>.capsulecrm_opportunities_lost_to_slack_channel_message.capsulecrmAuthConfig]
token = "<CAPSULECRM_ACCESS_TOKEN>"

[<ORG_NAME>.capsulecrm_opportunities_lost_to_slack_channel_message.slackAuthConfig]
token = "<SLACK_USER_OAUTH_TOKEN>"
```

### Template Configuration
1. Obtain the `channelName`. 
2. The `channelName` is the name of the Slack channel.
3. Once you obtained all configurations, Create `Config.toml` in root directory.
4. Replace the necessary fields in the `Config.toml` file with your data.

## Testing
Run the Ballerina project created by the integration sample by executing `bal run` from the root.

The detailed summary of all the new opportunities lost in CapsuleCRM within a particular day will be sent as a Slack channel message. 
