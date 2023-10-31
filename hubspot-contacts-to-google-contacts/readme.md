# Hubspot Contacts to Google Contacts
## Use case
Using this sample, you can sync your contacts from Hubspot to Google Contacts.

## Prerequisites
* Google account
* Hubspot account

### Setting up Google account
1. Visit [Google API Console](https://console.developers.google.com), click **Create Project**, and follow the wizard to create a new project.
2. Go to **Credentials -> OAuth consent screen**, enter a product name to be shown to users, and click **Save**.
3. On the **Credentials** tab, click **Create credentials** and select **OAuth client ID**. 
4. Select an application type, enter a name for the application, and specify a redirect URI (enter https://developers.google.com/oauthplayground if you want to use 
[OAuth 2.0 playground](https://developers.google.com/oauthplayground) to receive the authorization code and obtain the 
access token and refresh token). 
5. Click **Create**. Your client ID and client secret appear. 
6. In a separate browser window or tab, visit [OAuth 2.0 playground](https://developers.google.com/oauthplayground), select the required Google People API scopes, and then click **Authorize APIs**.
7. When you receive your authorization code, click **Exchange authorization code for tokens** to obtain the refresh token and access token.

### Setting up Hubspot developer account
1. Visit https://developers.hubspot.com and create a developer account.
2. Create a [private app](https://developers.hubspot.com/docs/api/private-apps) and obtain your Access token.

## Config.toml 
```
[<ORG_NAME>.hubspot_contacts_to_google_contacts]
gPeopleClientId = ""
gPeopleClientSecret = ""
gPeopleRefreshToken = ""
hubspotAccessToken = ""
```

## Testing
1. Run the Ballerina project created by the integration sample by executing `bal run` from the root. 

2. Now you can check your Google Contacts to verify if the new contacts are added.
