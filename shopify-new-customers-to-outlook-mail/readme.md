# Send Welcome Email using MS Outlook to New Shopify Customers
## Use case
At the execution of this sample, each new customers in Shopify created within last five minutes period will receive welcome emails 
from Microsoft Outlook account. The content for the email is extracted from Microsoft OneDrive account.

## Prerequisites
* Shopify account
* Microsoft Outlook account
* Microsoft OneDrive account

### Setting up Shopify account
1. Visit [Shopify](https://www.shopify.com) and create a Shopify account.
2. Obtain tokens by following [this guide](https://help.shopify.com/en/manual/apps/custom-apps)

### Setting up Microsoft Outlook account
1. Visit [Microsoft Outlook](https://outlook.live.com/owa/) and signup to Microsoft Outlook account
2. Obtain tokens by following [this guide](https://docs.microsoft.com/en-us/graph/auth-v2-user#authentication-and-authorization-steps) 

### Setting up Microsoft OneDrive account
1. Visit [Microsoft OneDrive](https://www.microsoft.com/en-ww/microsoft-365/onedrive/online-cloud-storage) and signup to Microsoft OneDrive account
2. Obtain tokens by following [this guide](https://docs.microsoft.com/en-us/graph/auth-v2-user#authentication-and-authorization-steps)

## Configuration
Create a file called `Config.toml` at the root of the project.

### Config.toml 
```
[<ORG_NAME>.shopify_new_customers_to_outlook_mail]
shopifyServiceUrl = "<SHOPIFY_SERVICE_URL>"
flyerFilePath = "<ONEDRIVE_FILE_PATH>"

[<ORG_NAME>.shopify_new_customers_to_outlook_mail.shopifyAuthConfig]
xShopifyAccessToken = "<SHOPIFY_ACCESS_TOKEN>"

[<ORG_NAME>.shopify_new_customers_to_outlook_mail.microsoftOutlookOAuthConfig]
clientId = "<OUTLOOK_CLIENT_ID>"
clientSecret = "<OUTLOOK_CLIENT_SECRET>"
refreshUrl = "<OUTLOOK_REFRESH_URL>"
refreshToken = "<OUTLOOK_REFRESH_TOKEN>"

[<ORG_NAME>.shopify_new_customers_to_outlook_mail.microsoftOneDriveOAuthConfig]
clientId = "<ONEDRIVE_CLIENT_ID>"
clientSecret = "<ONEDRIVE_CLIENT_SECRET>"
refreshUrl = "<ONEDRIVE_REFRESH_URL>"
refreshToken = "<ONEDRIVE_REFRESH_TOKEN>"

```

### Template Configuration
1. Obtain the `shopifyServiceUrl`. 
2. The `shopifyServiceUrl` is `https://{store_name}.myshopify.com`. Replace the `{store_name}` with the name of the Shopify store.
3. Obtain the relevent OAuth tokens for `Shopify`, `Microsoft OneDrive` and `Microsoft Outlook` configurations.
4. Once you obtained all configurations, Create `Config.toml` in root directory.
5. Replace the necessary fields in the `Config.toml` file with your data.

## Testing
Run the Ballerina project created by the integration sample by executing `bal run` from the root.

All the new customers in Shopify store within a five minutes period will receive a welcome email from an Microsoft Outlook account.
