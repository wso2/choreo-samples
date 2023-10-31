# Interzoid Currency Conversion Rate to Slack Channel Message
## Use case
It is important to have an idea about fluctuating currency conversion rates daily in a business. It helps to predict upcoming business opportunities or risks. 
Using this sample you can send notifications to a specified Slack Channel periodically about the requested currency conversion rate.

## Prerequisites
* Interzoid account
* Slack account

### Setting up Interzoid account
* Create a [Interzoid](https://www.interzoid.com/register) account. 
* Obtain the [API key](https://www.interzoid.com/manage-api-account) and add it as the `license` key.

### Setting up Slack account
* Go to your Slack app and obtain Slack `User OAuth Token` starting with `xoxp-` under `OAuth & Permissions` in App settings. 
* Add `User OAuth Token` as `slackAuthToken` and add intended Slack channel name for `slackChannelName`

## Configuration
Create a file called `Config.toml` at the root of the project.

### Config.toml 

```
[<ORG_NAME>.interzoid_currency_conversion_rate_to_slack_message]
fromCurrency = "<FROM_CURRENCY>"
toCurrency = "<TO_CURRENCY>"
authToken = "<SLACK_AUTH_TOKEN>"
channelName = "<SLACK_CHANNEL_NAME>"

[<ORG_NAME>.interzoid_currency_conversion_rate_to_slack_message.apiKeyConfig]
license = "<INTERZOID_API_KEY>"
```

## Testing
Run the Ballerina project created by the integration sample by executing `bal run` from the root.
Then you can check on the specified Slack channel for currency conversion rate.
