# Xero Sales Invoices to Gmail
## Use casefor a week to customers as contacts on HubSpot
At the execution of this sample, all sales invoices created within the last week is sent to an email recipient as a Gmail.

## Prerequisites
* Xero account
* Gmail account

### Setting up Xero account
1. Visit [Xero](https://www.xero.com/au/login/) and create a HubSpot Developer account
2. Obtain tokens by following [this guide](https://developer.xero.com/documentation/guides/oauth2/auth-flow/#1-send-a-user-to-authorize-your-app) 

### Setting up Gmail account
Create a Google account and create a connected app by visiting [Google cloud platform APIs and Services](https://console.cloud.google.com/apis/dashboard).

1. Click `Library` from the left sidebar.
2. In the search bar enter Gmail.
3. Then select Gmail API and click `Enable` button.
4. Complete OAuth Consent Screen setup.
5. Click the `Credential` tab from the left sidebar. In the displaying window click the `Create Credentials` button
6. Select OAuth client Id.
7. Fill the required field. Add https://developers.google.com/oauthplayground to the Redirect URI field.
8. Get `client ID` and `client secret`. Put it on the config(Config.toml) file.
9. Visit https://developers.google.com/oauthplayground/. Go to Settings (Top right corner) -> Tick 'Use your own OAuth credentials' and insert OAuth client ID and client secret. Click close.
10. Then, Complete step 1 (Select and Authorize APIs)
11. Make sure you select https://mail.google.com/ OAuth scope.
12. Click `Authorize APIs` and You will be in step 2.
13. Exchange Auth code for tokens.
14. Copy `Access token` and `Refresh token`. Put it on the config(`Config.toml`) file.
15. Obtain the relevant `Refresh URL` (For example: https://oauth2.googleapis.com/token) for the Gmail API and include it in the `Config.toml` file.

## Configuration
Create a file called `Config.toml` at the root of the project.

### Config.toml 

```
[<ORG_NAME>.xero_sales_invoices_to_gmail]
recipientEmailAddress = "<RECIPIENT_EMAIL_ADDRESS>"
senderEmailAddress = "<SENDER_EMAIL_ADDRESS>"
xeroTenantId = "<XERO_TENENT_ID>"

[<ORG_NAME>.xero_sales_invoices_to_gmail.xeroAuthConfig]
token = "<XERO_ACCESS_TOKEN>"

[<ORG_NAME>.xero_sales_invoices_to_gmail.gmailOAuthConfig]
clientId = "<GMAIL_CLIENT_ID>"
clientSecret = "<GMAIL_CLIENT_SECRET>"
refreshUrl = "<GMAIL_REFRESH_URL>"
refreshToken = "<GMAIL_REFRESH_TOKEN>"

```

### Template Configuration
1. Add the `senderEmailAddress` and `recipientEmailAddress`. 
3. Obtain the relevent OAuth tokens for `Xero` and `Gmail`
4. Once you obtained all configurations, Create `Config.toml` in root directory.
5. Replace the necessary fields in the `Config.toml` file with your data.

## Testing
Run the Ballerina project created by the integration sample by executing `bal run` from the root.

All the new customers in Shopify within a particular day will be added to your Mailchimp subscriber list(audience) as new members(contacts).
