# Add Customers to ActiveCampaign Automations for New PayPal Successful Sales
## Use case
At the execution of this sample, it will add the customer details of a successful sale in Paypal to an ActiveCampaign automation.

## Prerequisites
* PayPal account
* ActiveCampaign account

### Setting up PayPal account
1. Visit [PayPal](https://www.paypal.com/lk/home) and create a Paypal account.
2. Obtain tokens by following [this guide](https://developer.paypal.com/api/rest/authentication/)

### Setting up ActiveCampaign account
1. Visit [ActiveCampaign](https://app.hubspot.com/) and create a HubSpot Developer account
2. Obtain tokens by following [this guide](https://developers.hubspot.com/docs/api/oauth-quickstart-guide) 

## Configuration
Create a file called `Config.toml` at the root of the project.

### Config.toml 

```
[<ORG_NAME>.paypal_new_sales_to_activecampaign_automations]
paypalOrderId = "<PAYPAL_ORDER_ID>"
paymentSourceToken = "<PAYPAL_TOKENIZED_PAYMENT_SOURCE>"
paypalServiceUrl = "<PAYPAL_SERVICE_URL>"
activeCampaignApiToken = "<ACTIVECAMPAIGN_API_TOKEN>"
activeCampaignServiceurl = "<ACTIVECAMPAIGN_SERVICE_URL>"
activeCampaignAutomationId = "<ACTIVECAMPAIGN_AUTOMATION_ID>"

[<ORG_NAME>.paypal_new_sales_to_activecampaign_automations.paypalOauthConfig]
token = "<PAYPAL_ACCESS_TOKEN>"

```

### Template Configuration
1. Obtain the `paypalOrderId` and `paymentSourceToken`
2. The `paypalServiceUrl` is `https://api-m.sandbox.paypal.com` for sandbox accounts and `https://api-m.paypal.com` for live account.
3. The `activeCampaignServiceurl`can be found as `Account Name` in the settings page.
4. Obtain the relevent OAuth tokens for `Paypal` and `ActiveCampaign`
5. Once you obtained all configurations, Create `Config.toml` in root directory.
6. Replace the necessary fields in the `Config.toml` file with your data.

## Testing
Run the Ballerina project created by the integration sample by executing `bal run` from the root.

The email of the customer if his order is completed will be added to the specified ActiveCampaign automation.
