Use template (MFTG New Message to MFTG client) to mark successfully received messages as unread.

## Use case
This template will mark successfully received messages as unread. This uses MFTG Trigger to obtain newly received messages and uses MFTG Client to mark them as unread. 

## Prerequisites
* Pull the template from central  
`bal new -t choreo/mftg_trigger_to_mftg_client <newProjectName>`
* MFT Gateway account (by Aayu Technologies)


### Setting up MFTG webhook
1. Visit [MFT Gateway - Webhook Integration](https://console.mftgateway.com/integration/webhook)
2. Enable `Webhook integrations` ,add `WebhookURL` (Use the public URL of the started service as the Webhook URL)
3. Select `Stations` and add/update the webhook.

This will add a subscription to the MTF Gateway event API and the ballerina service functions will be triggered once an event is fired.

Note:
- Add a trailing / to the public URL if its not present.
- Use ngrok to obtain a public URL for localhost instances.

## Configuration
Create a file called `Config.toml` at the root of the project.

### Config.toml 
```
[<ORG_NAME>.mftg_trigger_to_mftg_client]
username = "<USERNAME>"
password = "<PASSWORD>"
as2From = "<AS2_FROM>"
```

## Testing
Run the Ballerina project created by the integration template by executing `bal run` from the root.
