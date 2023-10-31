# Google Calendar Event to Twilio SMS
## Use case
We can make our day-to-day events organized with the help of Google Calendar and Twilio. By using this integration, 
we can automatically send SMS to anyone about the new the event.

## Prerequisites
* Google account
* Twilio account

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

### Setting up Twilio account

1.  To use Twilio service, you need to provide the following:

  - Account SId
  - Auth Token

**Note** : There might be message delivery issues when trying to use this integration with Twilio trial accounts where users may see a message status of *Delivered*, even when the message did not successfully reach the destination mobile device.

Follow [Twilio Documentation](https://support.twilio.com/hc/en-us/articles/360038982313-SMS-messages-show-the-status-Delivered-but-aren-t-showing-up) for more information.

## Configuration
Create a file called `Config.toml` at the root of the project.

### Config.toml
```
[<ORG_NAME>.gcalendar_to_twilio]
accountSId = "<ACCOUNT_SID>"
authToken = "<AUTH_TOKEN>"
fromMobile= <SAMPLE_FROM_MOBILE>"
toMobile = "<SAMPLE_TO_MOBILE>"
calendarId = "<CALENDAR_ID>"
```

## Testing
Run the Ballerina project created by the integration sample by executing `bal run` from the root.