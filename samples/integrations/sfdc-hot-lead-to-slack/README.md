# Template: Salesforce new `Hot` Lead to Slack
When a `hot` lead in Salesforce is created, send a notification in a given Slack Channel  <br>

It is important to follow up with `Hot` leads as soon as they are added to increase the efficiency of your sales team. 
For constant communication your organization might use a dedicated Slack Channel for new Salesforce updates. Using this 
template you can send notification to your sales team's Slack Channel whenever a new `Hot` lead is created. 

## What you need
- A Salesforce Account
- A Slack Account

## How to set up
- Import the template.
- Allow access to the Salesforce account.
- Select the repository.
- Allow access to Slack account.
- Select the channel.
- Set up the template. 

# Developer Guide

<p align="center">
<img src="./docs/images/new_hot_lead.png?raw=true" alt="Github-Slack Integration template overview"/>
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
   <td>Salesforce API	
   </td>
   <td>v48.0
   </td>
  </tr>
</table>

## Pre-requisites
* Download and install [Ballerina](https://ballerinalang.org/downloads/).
* Slack workspace with admin priviledges
* Ballerina connectors for Salesforce and Slacks which will be automatically downloaded when building the application 
for the first time

## Account Configuration
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
5.  Salesforce username, password and the security token that will be needed for initializing the listener. 
    For more information on the secret token, please visit [Reset Your Security Token](https://help.salesforce.com/articleView?id=user_security_token.htm&type=5).

    Once you obtained all configurations, Replace "" in the `Config.toml` file with your data. For the `sfdcPassword` insert 
    the combination of your Salesforce account password with the security token received 

6. [Select Objects](https://developer.salesforce.com/docs/atlas.en-us.change_data_capture.meta/change_data_capture/cdc_select_objects.htm) for Change Notifications in the User Interface of Salesforce account.
    
### Configuration steps for Slack account
1. Create a Slack app which connects to your development workspace. More information on this can be found [here](https://api.slack.com/start).
2. Obtain an User OAuth token for the app visiting `OAuth & Permissions` tab in app `Features`.
3. Generate an OAuth token linking the specific workspace, providing the necessary scopes.
![Creating Slack OAuth token](docs/images/slack_token.png?raw=true)

## Template Configuration

1. Create a new channel or obtain the name of an already existing channel.
2. Obtain all the above necessary configurations.
3. Once you obtained all configurations, Create `Config.toml` in root directory.
4. Replace the necessary fields in the `Config.toml` file with your data.

### Config.toml 

#### ballerinax/sfdc listener  and slack releated configurations

```
[<ORG_NAME>.sfdc_hot_lead_to_slack]
sfdcUsername = "<Salesforce username>"
sfdcPassword = "<Salesforce password>" 
sfdcBaseURL = "<Salesforce Base URL>"
slackChannelName = "<Slack Channel Name>"  
slackToken = "<Slack App User Token>" 

sfdcClientId = "<Salesforce clientId >"
sfdcClientSecret = "<Salesforce clientSecret >"
sfdcRefreshToken = "<Salesforce refresh Token >"

```

## Running the Template

1. First you need to build the integration template and create the executable binary. Run the following command from the 
root directory of the integration template. 
`$ bal build`. 

2. Then you can run the integration binary with the following command. 
`$  bal run target/bin/github_release_to_slack_channel-0.1.0.jar`. 

3. Now you can add new release to the specific GitHub repository and observe that integration template runtime has 
received the event notification for new release.

4. You can check the Slack channel to verify that new message is received. 
