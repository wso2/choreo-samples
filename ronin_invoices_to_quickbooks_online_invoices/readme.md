# Ronin Invoices to Quickbooks Online Invoices
## Use case
At the execution of this sample, the information from all the Ronin invoices updated within a particular day will be used 
to create new Quickbooks online invoices. 

## Prerequisites
* Ronin account
* Quickbooks account

### Setting up CapsuleCRM account
1. Visit [Ronin](https://www.roninapp.com) and create a Ronin account.
2. Obtain tokens by following [this guide](https://www.roninapp.com/api)

### Setting up Quickbooks Online account
1. Visit [Quickbooks](https://quickbooks.intuit.com/global/) and create a Quickbooks account.
2. Obtain tokens by following [this guide](https://developer.intuit.com/app/developer/qbo/docs/get-started/start-developing-your-app)

## Configuration
Create a file called `Config.toml` at the root of the project.

### Config.toml 

```
[<ORG_NAME>.ronin_invoices_to_quickbooks_online_invoices]
roninServiceUrl= "<RONIN_SERVICE_URL>"
quickbooksServiceUrl = "<QUICKBOOKS_SERVICE_URL>"
quickbooksRealmId = "<QUICKBOOKS_REALM_ID>"

[<ORG_NAME>.ronin_invoices_to_quickbooks_online_invoices.roninAuthConfig]
username = "<RONIN_API_TOKEN>"
password = "<RONIN_API_TOKEN>"

[<ORG_NAME>.ronin_invoices_to_quickbooks_online_invoices.quickbooksAuthConfig]
token = "<QUICKBOOKS_ACCESS_TOKEN>"
```

### Template Configuration
1. Obtain the `roninServiceUrl`, `quickbooksServiceUrl` and `quickbooksRealmId`. 
2. The `roninServiceUrl` is `https://{yourdomain}.roninapp.com`. Replace the `{yourdomain}` with your Ronin specific domain name.
3. The `quickbooksServiceUrl` can be replaced with the production base URL `https://quickbooks.api.intuit.com` or with sandbox base URL `https://sandbox-quickbooks.api.intuit.com`.
4. The `quickbooksRealmId` is also known as the company ID. This can be obtained while authorizing your app by following [this guide](https://developer.intuit.com/app/developer/qbo/docs/get-started/start-developing-your-app#authorize-your-app).
5. Once you obtained all configurations, Create `Config.toml` in root directory.
6. Replace the necessary fields in the `Config.toml` file with your data.

## Testing
Run the Ballerina project created by the integration sample by executing `bal run` from the root.

The the information from all the Ronin invoices updated within a particular day will be used 
to create new Quickbooks online invoices.
