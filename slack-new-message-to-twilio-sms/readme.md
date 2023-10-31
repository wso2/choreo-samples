# Slack Channel New Message to Twilio SMS
## Use case
We can use track new incoming messages for a specific Slack channel using this.

## Prerequisites
* Slack Account
* Twilio Account

### Setting up Slack account

1. Create a Slack app which connects to your development workspace. More information on this can be found [here](https://api.slack.com/start).
2. Obtain an OAuth token for the app visiting `OAuth & Permissions` tab in app `Features`.
3. Generate an OAuth token linking the specific workspace, providing the necessary scopes. (Ex. incoming-webhook, channels:history)
4. Create your own Slack app and enable Event Subscription in your Slack app settings. (Request URL Ex: <PUBLIC_URL>/slack/events)
5. Subscribe to the events that you are planning to listen and save changes. (Ex: message.channels)
6. Obtain verification token from the Basic Information section of your Slack App
7. Add the created Slack app to the Slack channel

### Setting up Twilio account

1.  To use Twilio service, you need to provide the following:

       - Account SId
       - Auth Token

## Configuration
Create a file called `Config.toml` at the root of the project

## Config.toml 
```
[<ORG_NAME>.slack_new_message_to_twilio_sms]
fromMobile= <SAMPLE_FROM_MOBILE>"
toMobile = "<SAMPLE_TO_MOBILE>"
verificationToken = "<SLACK_VERIFICATION_TOKEN>"
channelId = "<SLACK_CHANNEL_ID>"

[<ORG_NAME>.slack_new_message_to_twilio_sms.twilioClientConfig]
accountSId = "<ACCOUNT_SID>"
authToken = "<AUTH_TOKEN>"
```
Phone numbers must be provided in E.164 format: +<country code><number>, for example: +16175551212
Channel ID must be obtianed by the channel URL or using below steps.
  1. Click on your channel name <#channel name>
  2. Scroll down the drop down ot the bottom
  3. Copy the channel ID.
 
## Testing
Run the Ballerina project created by the integration sample by executing `bal run` from the root.

You can check for Twilio SMS once new Slack message is received.
