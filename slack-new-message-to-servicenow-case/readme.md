# Slack Channel New Message to ServiceNow Case
## Use case
We can create new ServiceNow cases for published messages in a specific Slack channel.

## Prerequisites
* Slack Account
* ServiceNow Account

### Setting up Slack account

1. Create a Slack app which connects to your development workspace. More information on this can be found [here](https://api.slack.com/start).
2. Obtain an OAuth token for the app visiting `OAuth & Permissions` tab in app `Features`.
3. Generate an OAuth token linking the specific workspace, providing the necessary scopes. (Ex. incoming-webhook, channels:history)
4. Create your own Slack app and enable Event Subscription in your Slack app settings. (Request URL Ex: <PUBLIC_URL>/slack/events)
5. Subscribe to the events that you are planning to listen and save changes. (Ex: message.channels)
6. Obtain verification token from the Basic Information section of your Slack App
7. Add the created Slack app to the Slack channel

### Setting up ServiceNow Configurations
1. Visit [ServiceNow](https://developer.servicenow.com/dev.do) and create a ServiceNow Developer Account. 
2. Create a ServiceNow instance and obtain the following credentials:
    *   ServiceNow instance URL
    *   Username
    *   Password

## Configuration
Create a file called `Config.toml` at the root of the project

## Config.toml 
```
[<ORG_NAME>.slack_new_message_to_servicenow_case]
slackVerificationToken = "<SLACK_VERIFICATION_TOKEN>"
slackChannelId = "<SLACK_CHANNEL_ID>"

[<ORG_NAME>.slack_new_message_to_servicenow_case.serviceNowConfig]
username = "<USERNAME_OF_YOUR_SERVICENOW_INSTANCE>"
password = "<PASSWORD_OF_YOUR_SERVICENOW_INSTANCE>"

## Testing
Run the Ballerina project created by the integration sample by executing `bal run` from the root.

You can check the cases in ServiceNow dashboard once new Slack message is received.
