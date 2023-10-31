# Google Calendar Event to Microsoft Teams Channel Message
## Use case
Update your team on the events with the help of Google Calendar and Microsoft Teams. By using this integration, 
we can automatically send a message to a Microsoft Teams channel about the new event.

## Prerequisites
* Google account
* Microsoft Teams account

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

### Setting up Microsoft Teams account
1. Create a Microsoft 365 Work and School account
2. Create an Azure account to register an application in the Azure portal
3. Obtain tokens
   - Use [this](https://docs.microsoft.com/en-us/graph/auth-register-app-v2) guide to register an application with the Microsoft identity platform
4. Obtain the Team ID
   - Navigate to the team for which we require the id
   - Click on the (...) three dots present on the right side of the team name
   - From the flyout menu as displayed in the image below click on Get link to team

    <p>
    <img src="./docs/images/teams2.png?raw=true" alt="SFDC Campaign ID"/>
    </p>

5. Obtain the Channel ID 
   - Navigate to the channel for which we require the id
   - Click on the (...) three dots present on the right side of the channel name
   - From the flyout menu as displayed in the image below click on Get link to channel

    <p>
    <img src="./docs/images/teams3.png?raw=true" alt="SFDC Campaign ID"/>
    </p>

## Configuration
Create a file called `Config.toml` at the root of the project.

### Config.toml
```
[<ORG_NAME>.gcalendar_new_event_to_msteams_message]
teamId="<TEAM_ID>"
channelId="<CHANNEL_ID>"

[<ORG_NAME>.gcalendar_new_event_to_msteams_message.config]
clientId = "<CLIENT_ID>"
clientSecret = "<CLIENT_SECRET>"
refreshToken = "<REFRESH_TOKEN>"
refreshUrl = "<REFRESH_URL>"
calendarId= "<CALENDAR_ID>"
callbackURL="<CALLBACK_URL>"

[<ORG_NAME>.gcalendar_new_event_to_msteams_message.teamsOauthConfig]
clientId = "<CLIENT_ID>"
clientSecret = "<CLIENT_SECRET>"
refreshToken = "<REFRESH_TOKEN>"
refreshUrl = "<REFRESH_URL>"
```

## Testing
Run the Ballerina project created by the integration sample by executing `bal run` from the root.