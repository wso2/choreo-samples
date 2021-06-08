# Template: Export a list of email addresses belonging to contacts of a specific Account, Industry or Geography for a Marketing Campaign
Scheduled export of email addresses belonging to a specific Account, Industry or Geography for a specific Marketing Campaign to a CSV and store it in Azure Blob storage<br>

## Use this template to
- Export a CSV file which contains the emails of email Addresses belonging to a Marketing Campaign in Salesforce and save it to Azure Blob storage.

## What you need
- A Salesforce Account.
- An Azure Storage Account.

## How to set up
- Import the template.
- Allow access to Salesforce Account.
- Allow access to Azure Storage Account.
- Setup the time to trigger the template.
- Run the template.

# Developer Guide
<p align="center">
<img src="./docs/images/template_sfdc_marketing_campaign_emails_to_csv.png?raw=true" alt="SFDC-CSV Integration template overview"/>
</p>

## Supported versions
<table>
  <tr>
   <td>Ballerina Language Version
   </td>
   <td>Swan Lake Alpha5
   </td>
  </tr>
  <tr>
   <td>Java Development Kit (JDK) 
   </td>
   <td>11
   </td>
  </tr>
  <tr>
   <td>Salesforce API 
   </td>
   <td>v48.0
   </td>
  </tr>
  <tr>
   <td>Salesforce API 
   </td>
   <td>v48.0
   </td>
  </tr>
</table>

## Pre-requisites
* Download and install [Ballerina](https://ballerinalang.org/downloads/).
* A Salesforce account.
* Ballerina connector for Salesforce which will be automatically downloaded when building the application for the first time.

## Account Configuration
### Configuration of Salesforce account
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
5. Obtain the Campaign ID for a Salesforce Campaign in Marketing > Campaigns tab as shown below.
    <p>
    <img src="./docs/images/salesforce_campaign_id.png?raw=true" alt="SFDC Campaign ID"/>
    </p>

### Configuration of Azure Storage account

1. Copy one of the Access Keys from the Azure Portal and add it to Config.toml file as accessKeyOrSAS.
2. Add azure storage account name to Config.toml file as accountName.
3. Create a container and add the name of the container to Config.toml file as containerName.


## Config.toml 
```
[<ORG_NAME>.template_sfdc_marketing_campaign_emails_to_csv]
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

## Running the template
1. First you need to build the integration template and create the executable binary. Run the following command from the 
   root directory of the integration template. 
`$ bal build`. 

2. Then you can run the integration binary with the following command. 
`$ target/bin/template_sfdc_marketing_campaign_emails_to_csv.jar`. 

3. Now you can add a new Contact to the Marketing Campaign and observe if integration template will add a  new CSV file.
