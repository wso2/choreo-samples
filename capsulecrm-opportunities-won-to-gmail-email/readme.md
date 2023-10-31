# CapsuleCRM Opportunities Won to Gmail Email
## Use case
At the execution of this sample, the detailed summary of all the new opportunities won in CapsuleCRM 
within a particular day will be sent as a Gmail email. 

## Prerequisites
* CapsuleCRM account
* Gmail account

### Setting up CapsuleCRM account
1. Visit [Capsule CRM](https://capsulecrm.com) and create a Capsule CRM account.
2. Obtain tokens by following [this guide](https://developer.capsulecrm.com/v2/overview/authentication)

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
[<ORG_NAME>.capsulecrm_opportunities_won_to_gmail_email]
recipientAddress= "<GMAIL_RECIPIENT_ADDRESS>"
senderAddress = "<GMAIL_SENDER_ADDRESS>"

[<ORG_NAME>.capsulecrm_opportunities_won_to_gmail_email.capsulecrmAuthConfig]
token = "<CAPSULECRM_ACCESS_TOKEN>"

[<ORG_NAME>.capsulecrm_opportunities_won_to_gmail_email.gmailOAuthConfig]
clientId = "<GMAIL_CLIENT_ID>"
clientSecret = "<GMAIL_CLIENT_SECRET>"
refreshUrl = "<GMAIL_GMAIL_REFRESH_URL>"
refreshToken = "<GMAIL_REFRESH_TOKEN>"
```

### Template Configuration
1. Obtain the `recipientAddress` and `senderAddress`. 
2. The `recipientAddress` is the email address of the recipient.
3. The `senderAddress` is the email address of the sender.
4. Once you obtained all configurations, Create `Config.toml` in root directory.
5. Replace the necessary fields in the `Config.toml` file with your data.

## Testing
Run the Ballerina project created by the integration sample by executing `bal run` from the root.

The detailed summary of all the new opportunities won in CapsuleCRM within a particular day will be sent as a Gmail email. 
