# Google Calendar New Event to Asana Task
## Use case

Using this sample, you can create tasks in Asana, when a new event is created in Google Calendar.

## Prerequisites
* Google account
* Asana account

### Setting up Google account
1. Visit [Google API Console](https://console.developers.google.com), click **Create Project**, and follow the wizard to create a new project.
2. Go to **Credentials -> OAuth consent screen**, enter a product name to be shown to users, and click **Save**.
3. On the **Credentials** tab, click **Create credentials** and select **OAuth client ID**.
4. Select an application type, enter a name for the application, and specify a redirect URI (enter https://developers.google.com/oauthplayground if you want to use
   [OAuth 2.0 playground](https://developers.google.com/oauthplayground) to receive the authorization code and obtain the
   access token and refresh token).
5. Click **Create**. Your client ID and client secret appear.
6. In a separate browser window or tab, visit [OAuth 2.0 playground](https://developers.google.com/oauthplayground), select the required Google Calendar scopes, and then click **Authorize APIs**.
7. When you receive your authorization code, click **Exchange authorization code for tokens** to obtain the refresh token and access token.

### Setting up Asana account

* Create [Asana Account](https://asana.com/create-account)
* Obtaining tokens
   1. Log into [Asana Account](https://app.asana.com/-/login)
   2. Token can be obtained from [Developer app console](https://app.asana.com/0/developer-console) by creating an app and get an access token. 

## Configuration
Create a file called `Config.toml` at the root of the project.

### Config.toml
```
[<ORG_NAME>.gcalendar_new_event_to_asana_new_task.config]
clientId = "<CLIENT_ID>"
clientSecret = "<CLIENT_SECRET>"
refreshToken = <"REFRESH_TOKEN>"
refreshUrl = "<REFRESH_URL>

[<ORG_NAME>.gcalendar_new_event_to_asana_new_task]
asanaToken = "<BEARER_TOKEN>"
workspace = "<WORKSPACE_ID>"
```

## Testing
Run the Ballerina project created by the integration sample by executing `bal run` from the root.