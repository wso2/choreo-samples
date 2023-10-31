# Guaranteed Delivery
## Use case
When the HTTP service is invoked with a JSON payload as described, it compiles the JSON body into an ASB message and sends it to the specified queue. Then this will trigger the ASB Message service which listens to new messages from the queue. New record will be generated out of an extracted JSON from a triggered message and that record will be appended in a form on a row in Google sheet.

This sample can be used to demonstrate the Azure Service Bus capability on guaranteed message delivery.

## Prerequisites
* Azure account
* Google cloud platform account

### Setting up Azure account
1. Visit [Azure](https://portal.azure.com/#home) and create a Azure account.
2. Click `Create a resource` on home and search for `Service bus`.
3. Click `Create`, follow the instructions and finish the steps.
4. Create a queue on the service bus namespace.
5. Visit `Shared access policies` from the sidebar and obtain `connectionString`.

### Setting up Google Cloud Platform Account
Create a Google account and create a connected app by visiting [Google cloud platform APIs and Services](https://console.cloud.google.com/apis/dashboard).

1. Click `Library` from the left sidebar.
2. In the search bar enter Google Sheets.
3. Then select Google Sheets API and click Enable button.
4. Complete OAuth Consent Screen setup.
5. Click the `Credential` tab from the left sidebar. In the displaying window click the `Create Credentials` button
   Select OAuth client ID.
6. Fill the required field. Add https://developers.google.com/oauthplayground to the Redirect URI field.
7. Get client ID and client secret. Put it on the config(Config.toml) file.
8. Visit https://developers.google.com/oauthplayground/
   Go to Settings (Top right corner) -> Tick 'Use your own OAuth credentials' and insert OAuth client ID and client secret.
   Click close.
9. Then, Complete step 1 (Select and Authorize APIs)
10. Make sure you select https://www.googleapis.com/auth/drive & https://www.googleapis.com/auth/spreadsheets Oauth scopes.
11. Click `Authorize APIs` and You will be in step 2.
12. Exchange Auth code for tokens.
13. Copy `access token` and `refresh token`.
14. Here refresh URL for Google Sheets API is `https://www.googleapis.com/oauth2/v3/token`


## Run the sample
Run the Ballerina project created by the service sample by executing `bal run` from the root.

Once successfully executed, Listener will be started at port 8090. Then you need to invoke the service using the following curl command

```
$ curl -X POST \
  http://localhost:8090/store \
  -H 'content-type: application/json' \
  -d '{"id":"1", "name":"John"}'
```

Upon successful publishing the message to ASB, it will return 

```
{"id":"1", "name":"John"}
```

Verify the information in the specified Google sheet.