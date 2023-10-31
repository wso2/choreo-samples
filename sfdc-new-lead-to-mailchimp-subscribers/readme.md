# Salesforce New Lead to Mailchimp Subscribers List
## Use case
It is important to follow up with new leads as soon as they are added, to increase the efficiency of your sales team. Add new leads to Mailchimp subscribers list will help you to send them marketing emails or to run campaigns when ever required. This sample will help to add new Salesforce leads to Mailchimp subscribers list when ever they newly added to Salesforce.

## Prerequisites
* Salesforce account 
* Mailchimp account

### Setting up Salesforce account

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
5.  Salesforce username, password and the security token that will be needed for initializing the listener.
    For more information on the secret token, please visit [Reset Your Security Token](https://help.salesforce.com/articleView?id=user_security_token.htm&type=5).

    Once you obtained all configurations, Replace "" in the `Config.toml` file with your data. For the `password` under `sfdcListenerConfig`, insert the combination of your Salesforce account password with the security token received
6. [Select Objects](https://developer.salesforce.com/docs/atlas.en-us.change_data_capture.meta/change_data_capture/cdc_select_objects.htm) for Change Notifications in the User Interface of Salesforce account.

### Setting up Mailchimp account
1. Visit [Mailchimp](https://mailchimp.com) and create a Mailchimp account.
2. Navigate to the [API Keys section](https://us1.admin.mailchimp.com/account/api/) of your Mailchimp account.
3. If you already have an API key listed and you’d like to use it for your application, simply copy it. Otherwise, click Create a Key and give it a descriptive name that will remind you which application it’s used for.

## Template Configuration
1. Obtain the `mailchimpServiceUrl` and Mailchimp `audienceName`. 
2. The `mailchimpServiceUrl` is `https://<dc>.api.mailchimp.com/3.0/`. The <dc> part of the URL corresponds to the data center for your account. For example, if the data center for your account is us6, all API endpoints for your account are available relative to https://us6.api.mailchimp.com/3.0/.
There are a few ways to find your data center. It’s the first part of the URL you see in the API keys section of your account; if the URL is https://us6.mailchimp.com/account/api/, then the data center subdomain is `us6`. It’s also appended to your API key in the form key-dc; if your API key is `0123456789abcdef0123456789abcde-us6`, then the data center subdomain is `us6`.
3. The `audienceName` will be your Mailchimp subscriber list name.
4. Once you obtained all configurations, Create `Config.toml` in root directory.
5. Replace the necessary fields in the `Config.toml` file with your data.

### Config.toml
```
[<ORG_NAME>.sfdc_new_lead_to_mailchimp_subscribers]
salesforceBaseUrl = "<SALESFORCE_BASE_URL>"
audienceName = "<MAILCHIMP_SUBSCRIBER_LIST_AUDIENCE_NAME>"
mailchimpServiceUrl = "<MAILCHIMP_SERVICE_URL>"

[<ORG_NAME>.sfdc_new_lead_to_mailchimp_subscribers.sfdcListenerConfig]
username = "<SALESFORCE_USERNAME>"
password = "<SALESFORCE_PASSWORD>"

[<ORG_NAME>.sfdc_new_lead_to_mailchimp_subscribers.salesforceOAuthConfig]
clientId = "<SALESFORCE_CLIENT_ID>"
clientSecret = "<SALESFORCE_CLIENT_SECRET>"
refreshToken = "<SALESFORCE_REFRESH_TOKEN>"
refreshUrl = "<SALESFORCE_REFRESH_URL>"

[<ORG_NAME>.sfdc_new_lead_to_mailchimp_subscribers.mailchimpConfig]
username = "<MAILCHIMP_USERNAME>"
password = "<MAILCHIMP_PASSWORD>"
```
> Note: Here SALESFORCE_REFRESH_URL is https://login.salesforce.com/services/oauth2/token by default.

## Testing
Run the Ballerina project created by the integration sample by executing `bal run` from the root.
When a new lead is added in Salesforce, that lead will be added to your Mailchimp subscribers list(audience) as new member(contact).
