# Template: Slack new message to Twilio SMS.
When a message is sent to a specific slack channel, This template sends a SMS to a phone number using Twilio.

We can use track new incoming messages for a specific slack channel using this.

## Use this template to
- Forward messages in specifc slack channel as a Twilio SMS.

## What you need
- A Slack Account
- A Twilio Account

## How to set up
- Import the template.
- Allow access to the Slack account.
- Select the workspace & channel. 
- Enter Twilio credentials.
- Enter phone numbers.
- Set up the template.

# Developer Guide
<p align="center">
<img src="./docs/images/template_flow.png?raw=true" alt="Slack-Twilio Integration template overview"/>
</p>

## Supported Versions
<table>
  <tr>
   <td>Ballerina Language Version
   </td>
   <td>Swan Lake Alpha 5
   </td>
  </tr>
  <tr>
   <td>Java Development Kit (JDK)
   </td>
   <td>11
   </td>
  </tr>
  <tr>
   <td>Slack Event API
   </td>
   <td>
   </td>
  </tr>
  <tr>
   <td>Twilio Basic API Version
   </td>
   <td>2010-04-01 
   </td>
  </tr>
</table>

## Pre-requisites
* Download and install [Ballerina](https://ballerinalang.org/downloads/).
* Slack account.
* Twilio account with sms capable phone number.

## Account Configuration
### Configuration steps for Slack account

1. Create a Slack app which connects to your development workspace. More information on this can be found [here](https://api.slack.com/start).
2. Obtain an OAuth token for the app visiting `OAuth & Permissions` tab in app `Features`.
3. Generate an OAuth token linking the specific workspace, providing the necessary scopes.
![Creating Slack OAuth token](docs/images/slack_token.png?raw=true)
4. Create your own slack app and enable Event Subscription in your slack app settings.
5. Subscribe to the events that you are planning to listen and save changes.
6. Obtain verification token from the Basic Information section of your Slack App

### Configuration steps for Twilio account

1.  To use Twilio service, you need to provide the following:

       - Account SId
       - Auth Token

## Template Configuration

1. Install & start Ngrok on port 8090(8090 is used in this template)
2. Run the template.
3. When service is up & running, Enter the ngrok callback url under event subscriptions in slack.
<img src="./docs/images/event_subscription.png?raw=true" alt="Slack-Twilio Event Subscription"/>

## Config.toml 
```
[<ORG_NAME>.slack_new_message_to_twilio_sms]
accountSId = "<ACCOUNT_SID>"
authToken = "<AUTH_TOKEN>"
fromMobile= <SAMPLE_FROM_MOBILE>"
toMobile = "<SAMPLE_TO_MOBILE>"
verificationToken = "<SLACK_VERIFICATION_TOKEN>"
channelId = "<SLACK_CHANNEL_ID>"

```

## Running the Template
1. First you need to build the integration template and create the executable binary. Run the following command from the 
root directory of the integration template. 
    ```
    $ bal build. 
    ```

2. Then you can run the integration binary with the following command. 
    ```
    $ bal run /target/bin/slack_new_message_to_twilio_sms.jar. 
    ```

3. Now you can send a message to a specific channel and check for triggered SMS.
