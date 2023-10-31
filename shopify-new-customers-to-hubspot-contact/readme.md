# Shopify New Customers to HubSpot Create/Update Contact
## Use case
At the execution of this sample, all the new customers in Shopify within a particular day will be added 
to your HubSpot account as new contacts.

## Prerequisites
* Shopify account
* HubSpot account

### Setting up Shopify account
1. Visit [Shopify](https://www.shopify.com) and create a Shopify account.
2. Obtain tokens by following [this guide](https://help.shopify.com/en/manual/apps/custom-apps)

### Setting up HubSpot account
1. Visit [HubSpot](https://app.hubspot.com/) and create a HubSpot Developer account
2. Obtain tokens by following [this guide](https://developers.hubspot.com/docs/api/oauth-quickstart-guide) 

## Configuration
Create a file called `Config.toml` at the root of the project.

### Config.toml 

```
[<ORG_NAME>.shopify_new_customers_to_hubspot_contact]
shopifyServiceUrl = "<SHOPIFY_SERVICE_URL>"

[<ORG_NAME>.shopify_new_customers_to_hubspot_contact.shopifyAuthConfig]
xShopifyAccessToken = "<SHOPIFY_ACCESS_TOKEN>"

[<ORG_NAME>.shopify_new_customers_to_hubspot_contact.hubspotOauthConfig]
token = "<HUBSPOT_ACCESS_TOKEN>"

```

### Template Configuration
1. Obtain the `shopifyServiceUrl`. 
2. The `shopifyServiceUrl` is `https://{store_name}.myshopify.com`. Replace the `{store_name}` with the name of the Shopify store.
3. Obtain the relevent OAuth tokens for `Shopify` and `HubSpot`
4. Once you obtained all configurations, Create `Config.toml` in root directory.
5. Replace the necessary fields in the `Config.toml` file with your data.

## Testing
Run the Ballerina project created by the integration sample by executing `bal run` from the root.

All the new customers in Shopify within a particular day will be added to your Mailchimp subscriber list(audience) as new members(contacts).
