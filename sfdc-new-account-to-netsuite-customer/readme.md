# Salesforce New Account to NetSuite New Customer
## Use case
This integration sample helps to create a new customer in Netsuite for each new account in salesforce. 
There is a listener in the sample. It listens any new account creation events in salesforce. 
If there is a newly created account in the salesforce then this sample fetch the data of that account record and 
create a new customer record in the NetSuite.

## Prerequisites
* Netsuite account
* Salesforce account

### Setting up Salesforce account
1. Create a Salesforce account and create a connected app by visiting [Salesforce](https://www.salesforce.com). 
2. Obtain the following parameters:
* Salesforce Username
* Salesforce Password with security token
* [Select Objects](https://developer.salesforce.com/docs/atlas.en-us.change_data_capture.meta/change_data_capture/cdc_select_objects.htm) for Change Notifications in the User Interface of Salesforce account.

3. For more information on obtaining Security token, visit
[Salesforce help documentation](https://help.salesforce.com/articleView?id=sf.user_security_token.htm&type=5)
or follow the
[Setup tutorial](https://medium.com/creme-de-la-crm/salesforce-how-to-abcs-g-bfa592792649).

### Setting up NetSuite account
1. Visit [NetSuite](https://www.netsuite.com) and create an Account.
2. Enable the SuiteTalk Webservice features of the account (Setup->Company->Enable Features).
3. Obtain the SuiteTalk Base URL, which contains the account ID under the company URLs (Setup->Company->Company
   Information).
   E.g., https://<ACCOUNT_ID>.suitetalk.api.netsuite.com
4. Create an integration application (Setup->Integration->New), enable TBA code grant and scope, and obtain the
   following credentials:
    * Client ID
    * Client Secret
5. Obtain the below credentials by following the token based authorization in the [NetSuite documentation](https://system.na0.netsuite.com/app/help/helpcenter.nl?fid=book_1559132836.html&vid=_BLm3ruuApc_9HXr&chrole=17&ck=9Ie2K7uuApI_9PHO&cktime=175797&promocode=&promocodeaction=overwrite&sj=7bfNB5rzdVQdIKGhDJFE6knJf%3B1590725099%3B165665000).
    * Access Token
    * Access Token Secret

## Configuration
Create a file called `Config.toml` at the root of the project.

### Config.toml
``` 
[<ORG_Name>.sfdc_new_account_to_netsuite_customer.salesforceListenerConfig]
username = "<SF_USERNAME>"
password = "<SF_PASSWORD>"

[<ORG_Name>.sfdc_new_account_to_netsuite_customer.netsuiteClientConfig]
accountId = "<NS_ACCOUNT_ID>"
consumerId = "<NS_CONSUMER_ID>"
consumerSecret = <NS_CONSUMER_SECRET>
token = "<NS_TOKEN>"
tokenSecret = "<NS_TOKEN_SECRET>"
baseURL = "<NS_BASE_URL>"

[choreo.sfdc_new_account_to_netsuite_customer.salesforceOAuthConfig]
clientId = "<SF_CLIENT_ID>"
clientSecret = "<SF_CLIENT_SECRET>"
refreshUrl = "<SF_REFRESH_URL>"
refreshToken = "<SF_REFRESH_TOKEN>"

[<ORG_Name>.sfdc_new_account_to_netsuite_customer]
netsuiteSubsidiaryID = "<NS_SUBSIDIARY_ID>"
salesforceBaseUrl="<SF_BASE_URL>"
```
## Testing
Run the Ballerina project created by the integration sample by executing `bal run` from the root.

You can check for Netsuite new customer on successful creation of Salesforce account.
