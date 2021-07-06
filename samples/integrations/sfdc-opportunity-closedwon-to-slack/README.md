# Template: Salesforce Opportunity update to Slack
When an opportunity in Salesforce is updated to `Closed Won`, send a notification in a given Slack Channel  <br>

It is important to follow up with the updates for your opportunities in Salesforce as soon as they are added to increase the efficiency of your sales team. 

Most importantly when you won a deal!!! 

For constant communication your organization might be using a dedicated Slack Channel for new Salesforce updates. Using this template you can send notification to your sales team's Slack Channel whenever an opportunity is WON to celebrate with the team.  

## Use this template to
- To get real time updates on `Won` Opportunities to proceed on next steps
- Get away from manually tracking the changes in your Salesforce account. 

## What you need
- A Salesforce Account
- A Slack Account

## How to set up
- Import the template.
- Allow access to the Salesforce account.
- Select the repository.
- Allow access to the Slack account.
- Select the channel.
- Set up the template. 

# Developer Guide

<p align="center">
<img src="./docs/images/closedwon_diagram.png?raw=true" alt="Github-Slack Integration template overview"/>
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
* Ballerina connectors for Salesforce and Slacks which will be automatically downloaded when building the application for the first time

## configuration
### Setup Salesforce Configurations
* Create a Salesforce account and create a connected app by visiting [Salesforce](https://www.salesforce.com). 
* Salesforce username, password and the security token that will be needed for initializing the listener. 

  For more information on the secret token, please visit [Reset Your Security Token](https://help.salesforce.com/articleView?id=user_security_token.htm&type=5).
  Once you obtained all configurations, Replace values in the `Config.toml` file with your data.
  
* [Select Objects](https://developer.salesforce.com/docs/atlas.en-us.change_data_capture.meta/change_data_capture/cdc_select_objects.htm) for Change Notifications in the User Interface of Salesforce account.
### Setup Slack Configurations
Go to your Slack app and obtain Slack `User OAuth Token` starting with `xoxp-` under `OAuth & Permissions` in App settings. 

Add `User OAuth Token` as `slack_token` and Slack Channel 

### Config.toml 

#### ballerinax/slack related configurations 

```
sfdcBaseURL = "<SALESFORCE_ACCOUNT_DOMAIN_URL>"
sfdcUsername = "<SALESFORCE_USERNAME>"
sfdcPassword = "<SALESFORCE_PASSWORD>"
sfdcClientId = "<SALESFORCE_CLIENT_ID>"
sfdcClientSecret = "<SALESFORCE_CLIENT_SECRET>"
sfdcRefreshToken = "<SALESFORCE_REFRESH_TOKEN>"
```
#### ballerinax/slack related configurations  

```
slackChannelName = "<Slack Channel Name>"  
slackToken = "<Slack App User Token>" 
```
## Running the Template

1. First you need to build the integration template and create the executable binary. Run the following command from the root directory of the integration template. 
`$ bal build`. 

2. Then you can run the integration binary with the following command. 
`$ bal run /target/bin/sfdc_oppotunity_closedwon_to_slack.jar`. 

Successful listener startup will print following in the console.
```
>>>>
[2020-09-25 11:10:55.552] Success:[/meta/handshake]
{ext={replay=true, payload.format=true}, minimumVersion=1.0, clientId=1mc1owacqlmod21gwe8arhpxaxxm, supportedConnectionTypes=[Ljava.lang.Object;@21a089fc, channel=/meta/handshake, id=1, version=1.0, successful=true}
<<<<
>>>>
[2020-09-25 11:10:55.629] Success:[/meta/connect]
{clientId=1mc1owacqlmod21gwe8arhpxaxxm, advice={reconnect=retry, interval=0, timeout=110000}, channel=/meta/connect, id=2, successful=true}
<<<<
```

3. Now you can update the `Stage` of a `Opportunity` in Salesforce and observe that integration template runtime has received the event notification for opportunity updated to `Closed Won`.

4. You can go to slack channel and verify the message receiving. Following is a sample message 

![Sample Slack Notification](./docs/images/closed_won.png?raw=true)
 