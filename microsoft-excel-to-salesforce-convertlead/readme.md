# Microsoft Excel to Salesforce ConvertLead
## Use case
Using this sample you can convert Salesforce Lead from the IDs provided in Microsoft Excel worksheet rows. When you run the sample, given IDs will be converted as account, contact and opportunity objects and newly created object IDs will be updated in the same sheet.

## Pre-requisites
* A Microsoft OneDrive account
* A Salesforce account

## Account Configuration
### Configuration steps for Microsoft Excel account
1. Before you run the following steps, create an account in [OneDrive](https://onedrive.live.com). Next, sign into [Azure Portal - App Registrations](https://portal.azure.com/#blade/Microsoft_AAD_RegisteredApps/ApplicationsListBlade). You can use your personal or work or school account to register.

2. In the App registrations page, click **New registration** and enter a meaningful name in the name field.

3. In the **Supported account types** section, select **Accounts** in any organizational directory under personal Microsoft accounts (e.g., Skype, Xbox, Outlook.com). Click **Register** to create the application.
    
4. Copy the Application (client) ID (`<CLIENT_ID>`). This is the unique identifier for your app.
    
5. In the application's list of pages (under the **Manage** tab in left hand side menu), select **Authentication**.
    Under **Platform configurations**, click **Add a platform**.

6. Under **Configure platforms**, click **Web** located under **Web applications**.

7. Under the **Redirect URIs text box**, register the https://login.microsoftonline.com/common/oauth2/nativeclient url.
   Under **Implicit grant**, select **Access tokens**.
   Click **Configure**.

8. Under **Certificates & Secrets**, create a new client secret (`<CLIENT_SECRET>`). This requires providing a description and a period of expiry. Next, click **Add**.

9. Next, you need to obtain an access token and a refresh token to invoke the Microsoft Graph API.
First, in a new browser, enter the below URL by replacing the `<CLIENT_ID>` with the application ID. Here you can use `Files.ReadWrite` or `Files.ReadWrite.All` according to your preference. `Files.ReadWrite` will allow you to access to only your files and `Files.ReadWrite.All` will allow you to access all files you can access.

    ```
    https://login.microsoftonline.com/common/oauth2/v2.0/authorize?response_type=code&client_id=<CLIENT_ID>&redirect_uri=https://login.microsoftonline.com/common/oauth2/nativeclient&scope=Files.ReadWrite offline_access
    ```

10. This will prompt you to enter the username and password for signing into the Azure Portal App.

11. Once the username and password pair is successfully entered, this will give a URL as follows on the browser address bar.

    `https://login.microsoftonline.com/common/oauth2/nativeclient?code=xxxxxxxxxxxxxxxxxxxxxxxxxxx`

12. Copy the code parameter (`xxxxxxxxxxxxxxxxxxxxxxxxxxx` in the above example) and in a new terminal, enter the following cURL command by replacing the `<CODE>` with the code received from the above step. The `<CLIENT_ID>` and `<CLIENT_SECRET>` parameters are the same as above.

    ```
    curl -X POST --header "Content-Type: application/x-www-form-urlencoded" --header "Host:login.microsoftonline.com" -d "client_id=<CLIENT_ID>&client_secret=<CLIENT_SECRET>&grant_type=authorization_code&redirect_uri=https://login.microsoftonline.com/common/oauth2/nativeclient&code=<CODE>&scope=Files.ReadWrite offline_access" https://login.microsoftonline.com/common/oauth2/v2.0/token
    ```

    The above cURL command will provide the refresh token.

    The `workbookIdOrPath` is workbook ID or file path (with the `.xlsx` extension from root. If you have a file in root directory with name of `Work.xlsx`, you need to pass `workbookIdOrPath` as `Work.xlsx`). Make sure you create a workbook in Microsoft OneDrive and pass the correct `workbookIdOrPath` before using the connector.

### Configuration steps for Salesforce account

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

## Template Configuration
1. Create new workbook.
2. Rename the sheet if you want.
3. Get the ID or path of the worksheet.
4. Create a table in the following format and get the table name.

    | Lead Name | Lead ID | Status | Account ID | Contact ID | Opportunity ID |
    |-----------|---------|--------|------------|------------|----------------|
    | Alice     | xxx     |        |            |            |                |
    | Bob       | xxx     |        |            |            |                |
    |           |         |        |            |            |                |

5. Once you obtained all configurations, Create `Config.toml` in root directory.
6. Replace the necessary fields in the `Config.toml` file with your data.

## Config.toml 
```
[<ORG_NAME>.microsoft_excel_to_salesforce_convertlead]
excelClientId = "<Excel Client ID>"
excelClientSecret = "<Excel Client Secret>"
excelRefreshURL = "<Excel Refresh URL>"
excelRefreshToken = "<Excel Refresh Token>"
workbookIdOrPath = "<Workbook ID or Path>"
worksheetName = "<Worksheet Name>"
tableName = "<Table Name>"
salesforceBaseURL = "<Salesforce Base URL>"
salesforceClientId = "<Salesforce Client ID>"
salesforceClientSecret = "<Salesforce Client Secrets>"
salesforceRefreshToken = "<Salesforce Refresh Token>"
```
## Running the Template
1. Run the Ballerina project created by the integration sample by executing bal run from the root.

2. You can check the Salesforce to verify whether Lead is converted. 
