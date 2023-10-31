# Salesforce Campaign Emails to Azure Blob Storage
## Use case
Scheduled export of email addresses belonging to a specific Account, Industry or Geography for a specific Marketing Campaign to a CSV and store it in Azure Blob storage

## Prerequisites
* Salesforce Account.
* Azure Storage Account.

### Setting up Salesforce account
1. Create a connected app and obtain the following credentials:
    *   Base URL (Endpoint)
    *   Client ID
    *   Client Secret
    *   Refresh Token
    *   Refresh Token URL
2. When you are setting up the connected app, select the following scopes under Selected OAuth Scopes:
    *   Access and manage your data (api)
    *   Perform requests on your behalf at any time (refresh_token, offline_access)
    *   Provide access to your data via the Web (web)
3. Provide the client ID and client secret to obtain the refresh token and access token. For more information on 
obtaining OAuth2 credentials, go to [Salesforce documentation](https://help.salesforce.com/articleView?id=remoteaccess_authenticate_overview.htm).
4. Include them inside the `Config.toml` file.
5. Obtain the Campaign ID for a Salesforce Campaign in Marketing.

### Setting up Azure Storage account

1. Copy one of the Access Keys from the Azure Portal and add it to Config.toml file as accessKeyOrSAS.
2. Add azure storage account name to Config.toml file as accountName.
3. Create a container and add the name of the container to Config.toml file as containerName.

## Configuration
Create a file called `Config.toml` at the root of the project.

### Config.toml 
```
[<ORG_NAME>.sample_sfdc_marketing_campaign_emails_to_csv]
sfdcClientId = "<SFDC_CLIENT_ID>"
sfdcClientSecret = "<SFDC_CCLIENT_SECRET>"
sfdcRefreshToken = "<SFDC_C_REFRESH_URL>"
sfdcBaseUrl = "<SFDC_BASE_URL>"
salesforceAccountName = "<SFDC_ACCOUNT_NAME>"
accountIndustry = "<INDUSTRY>"
billingCity = <BILLIING_CITY>
accessKeyOrSAS = "<BLOB_ACCOUNT_SAS_KEY>"
accountName = "<BLOB_ACCOUNT_NAME>"
containerName = "<BLOB_CONTAINER_NAME>"
authorizationMethod = "<BLOB_AUTHORIZATION_METHOD>"
```

## Testing
Run the Ballerina project created by the integration sample by executing `bal run` from the root.

Now you can add a new Contact to the Marketing Campaign and observe if integration sample will add a  new CSV file.
