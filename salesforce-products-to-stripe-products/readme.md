# Salesforce Products to Stripe Products
## Use Case

Using this sample you can migrate your data from Salesforce to Stripe at once to keep your products in Stripe up to date with Salesforce. 

## Pre-requisites
* A Salesforce account
* A Stripe account

## Account Configuration

### Configuration steps for Salesforce account

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

### Configuration steps for Stripe account

1. If you do not have a Stripe account, visit [Stripe](https://dashboard.stripe.com/login) and create a Stripe account
2. By default, your account’s secret keys can be used to perform any API request without restriction. You can find your keys on the API Keys page in the [Developers Dashboard](https://dashboard.stripe.com/test/apikeys). Alternatively, you can use [restricted API keys](https://stripe.com/docs/keys#limiting-access-with-restricted-api-keys) for granular permissions.
3. Provide obtained API Key as the token at HTTP client initialization. 

## Config.toml
```
salesforceBaseUrl = "<Salesforce Base URL>"
[stripeAuthConfig]
token = "<Stripe API Key>"
[salesforceOAuthConfig]
clientId = "<Salesforce Client ID>"
clientSecret = "<Salesforce Client Secret>"
refreshToken = "<Salesforce Refresh Token>"
refreshUrl = "<Salesforce Refresh URL>"

```

## Running the Template
1. Run the Ballerina project created by the integration sample by executing bal run from the root.

2. You can check the Stripe to verify whether the new products are added. 