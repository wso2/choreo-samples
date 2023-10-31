# Google Calendar Event to Trello Card
## Use case
Manage your personal tasks based on the events with the help of Google Calendar and Trello. By using this integration, 
we can automatically add a card to Trello containing information about the new event.

## Prerequisites
* Google account
* Trello account

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
8. Obtain the **Callback URL**
9. Obtain the **Calendar ID**
   - Open your Google Calendar app page using your Google account.
   - Navigate to your subscribed/available Google calendars list (usually bottom left side).
   - Hover over the calendar you wish to work on and click the three vertical dots that appear to the right – this will bring up a dropdown menu, click `Settings and sharing`.
   - A new page will open. Find the Calendar ID at the bottom under the `Integrate Calendar` section

### Setting up Trello account
1. Create a [Trello](https://trello.com) account
2. Obtain tokens
    - Use [this](https://developer.atlassian.com/cloud/trello/guides/rest-api/api-introduction/#authentication-and-authorization) guide to obtain the API key and generate a token related to your account.

## Configuration
Create a file called `Config.toml` at the root of the project.

### Config.toml
```
[gcalendar_new_event_to_trello_card]
trelloApiKey="<TRELLO_API_KEY>"
trelloApiToken="<TRELLO_API_TOKEN>"
trelloListId="<TRELLO_LIST_ID>"

[<ORG_NAME>.gcalendar_new_event_to_msteams_message.config]
clientId = "<CLIENT_ID>"
clientSecret = "<CLIENT_SECRET>"
refreshToken = "<REFRESH_TOKEN>"
refreshUrl = "<REFRESH_URL>"
calendarId= "<CALENDAR_ID>"
callbackURL="<CALLBACK_URL>"
```

## Testing
Run the Ballerina project created by the integration sample by executing `bal run` from the root.