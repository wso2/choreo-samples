# Template: Google Calendar new event to Twilio SMS
When a new event is created in Google Calendar, send a Twilio SMS.

We can make our day-to-day events organized with the help of Google Calendar and Twilio. By using this integration, we can automatically send SMS to anyone about the new the event. 

## Use this template to
- Send Twilio SMS on new Google Calendar event.

## What you need
- Google account
- Twilio account

## How to set up
- Import the template.
- Allow access to the Google account.
- Select the calendar.
- Enter Twilio credentials.
- Enter phone numbers.
- Set up the template. 

# Developer Guide
<p align="center">
<img src="./docs/images/template_flow.png?raw=true" alt="Google Calendar - Twilio Integration template overview"/>
</p>

## Supported Versions
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
   <td>Google Calendar API Version
   </td>
   <td>V3
   </td>
  </tr>
  <tr>
   <td>Twilio API Version
   </td>
   <td>2010-04-01
   </td>
  </tr>
</table>

## Pre-requisites
* Download and install [Ballerina](https://ballerinalang.org/downloads/).
* Google account
* Twilio account

## Account Configuration
### Configuration steps for Google account
1. Visit [Google API Console](https://console.developers.google.com), click **Create Project**, and follow the wizard to create a new project.
2. Go to **Credentials -> OAuth consent screen**, enter a product name to be shown to users, and click **Save**.
3. On the **Credentials** tab, click **Create credentials** and select **OAuth client ID**. 
4. Select an application type, enter a name for the application, and specify a redirect URI (enter https://developers.google.com/oauthplayground if you want to use 
[OAuth 2.0 playground](https://developers.google.com/oauthplayground) to receive the authorization code and obtain the 
access token and refresh token). 
5. Click **Create**. Your client ID and client secret appear. 
6. In a separate browser window or tab, visit [OAuth 2.0 playground](https://developers.google.com/oauthplayground), select the required Google Calendar scopes, and then click **Authorize APIs**.
7. When you receive your authorization code, click **Exchange authorization code for tokens** to obtain the refresh token and access token.

### Configuration steps for Twilio account

1.  To use Twilio service, you need to provide the following:

       - Account SId
       - Auth Token

**Note** : There might be message delivery issues when trying to use this integration with Twilio trial accounts where users may see a message status of *Delivered*, even when the message did not successfully reach the destination mobile device.

Follow [Twilio Documentation](https://support.twilio.com/hc/en-us/articles/360038982313-SMS-messages-show-the-status-Delivered-but-aren-t-showing-up) for more information.

## Template Configuration

1. Once you obtained all configurations, Create `Config.toml` in root directory.
2. Replace the necessary fields in the `Config.toml` file with your data.

## Config.toml 
```
[<ORG_NAME>.gcalendar-to-twilio]

[ballerinax.gcalendar_to_twilio.calendarOauthConfig]
clientId = "<CLIENT_ID>"
clientSecret = "<CLIENT_SECRET>"
refreshToken = <"REFRESH_TOKEN>"
refreshUrl = "<REFRESH_URL>

[ballerinax.gcalendar_to_twilio]
accountSId = "<ACCOUNT_SID>"
authToken = "<AUTH_TOKEN>"
fromMobile= <SAMPLE_FROM_MOBILE>"
toMobile = "<SAMPLE_TO_MOBILE>"
calendarId = "<CALENDAR_ID>"

```
