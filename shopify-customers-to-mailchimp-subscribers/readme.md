# Shopify New Customers to Mailchimp Subscribers
## Use case
At the execution of this sample, all the new customers in Shopify within a particular day will be added 
to your Mailchimp subscriber list(audience) as new members(contacts).

## Prerequisites
* Shopify account
* Mailchimp account

### Setting up Shopify account
1. Visit [Shopify](https://www.shopify.com) and create a Shopify account.
2. Obtain tokens by following [this guide](https://shopify.dev/apps/auth/oauth)

### Setting up Mailchimp account
1. Visit [Mailchimp](https://mailchimp.com) and create a Mailchimp account.
2. Navigate to the [API Keys section](https://us1.admin.mailchimp.com/account/api/) of your Mailchimp account.
3. If you already have an API key listed and you’d like to use it for your application, simply copy it. Otherwise, click Create a Key and give it a descriptive name that will remind you which application it’s used for.

## Configuration
Create a file called `Config.toml` at the root of the project.

### Config.toml 

```
[<ORG_NAME>.shopify_customers_to_mailchimp_subscribers]
shopifyServiceUrl = "<SHOPIFY_SERVICE_URL>"
mailchimpServiceUrl = "<MAILCHIMP_SERVICE_URL>"
audienceName = "<MAILCHIMP_SUBSCRIBER_LIST_AUDIENCE_NAME>"

[<ORG_NAME>.shopify_customers_to_mailchimp_subscribers.shopifyAuthConfig]
xShopifyAccessToken = "<SHOPIFY_ACCESS_TOKEN>"

[<ORG_NAME>.shopify_customers_to_mailchimp_subscribers.mailchimpAuthConfig]
username = "<MAILCHIMP_USERNAME>"
password = "<MAILCHIMP_PASSWORD>"
```

### Template Configuration
1. Obtain the `shopifyServiceUrl`, `mailchimpServiceUrl` and Mailchimp `audienceName`. 
2. The `shopifyServiceUrl` is `https://{store_name}.myshopify.com`. Replace the `{store_name}` with the name of the Shopify store.
3. The `mailchimpServiceUrl` is `https://<dc>.api.mailchimp.com/3.0/`. The <dc> part of the URL corresponds to the data center for your account. For example, if the data center for your account is us6, all API endpoints for your account are available relative to https://us6.api.mailchimp.com/3.0/.
There are a few ways to find your data center. It’s the first part of the URL you see in the API keys section of your account; if the URL is https://us6.mailchimp.com/account/api/, then the data center subdomain is `us6`. It’s also appended to your API key in the form key-dc; if your API key is `0123456789abcdef0123456789abcde-us6`, then the data center subdomain is `us6`.
4. The `audienceName` will be your Mailchimp subscriber list name.
5. Once you obtained all configurations, Create `Config.toml` in root directory.
6. Replace the necessary fields in the `Config.toml` file with your data.

## Testing
Run the Ballerina project created by the integration sample by executing `bal run` from the root.

All the new customers in Shopify within a particular day will be added to your Mailchimp subscriber list(audience) as new members(contacts).
