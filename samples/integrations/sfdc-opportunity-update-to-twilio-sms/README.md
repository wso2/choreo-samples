# Template: Salesforece Opportunity Update to Twilio SMS

When an opportunity is updated in Salesforce, send Twilio sms.

Updated and accurate opportunities drive precise forecasts. A customer can use Twilio to send internal notifications to 
a specific person of interest, based on the opportunity update information in Salesforce. 
It is important to follow up with opportunities as soon as they are updated in Salesforce. There maybe a specific 
person who wanted to be on alert of updated Salesforce opportunities. Any time you update an opportunity in Salesforce, 
a SMS message will automatically send to the specific person via Twilio.

This template can be used to send a Twilio SMS message containing all 
the defined fields in opportunity SObject to a given mobile number when an opportunity is updated in Salesforce.

## Use this template to
- Send a Twilio SMS message when an opportunity is updated in Salesforce.

## What you need
- A Twilio Account
- A Salesforce Account

## How to set up
- Import the template.
- Allow access to Salesforce account.
- Provide the Salesforce push topic.
- Allow access to the Twilio account.
- Provide the Twilio Account SID and Auth Token.
- Provide the number we want to send the SMS from.
- Provide the number we want to send the SMS to.
- Set up the template. 

# Developer Guide

<p align="center">
<img src="./docs/images/template_flow.png?raw=true" alt="Github-Slack Integration template overview"/>
</p>

## Supported versions

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
  <tr>
   <td>Twilio Basic API
   </td>
   <td>2010-04-01
   </td>
  </tr>
</table>


## Pre-requisites
* Download and install [Ballerina](https://ballerinalang.org/downloads/).
* A Salesforce account.
* Twilio account with sms capable phone number.
* Ballerina connectors for Salesforce and Twilio which will be automatically downloaded when building the application for the first time.


## Account Configuration

### Configuration steps for Salesforce account
1. Create a Salesforce account and create a connected app by visiting [Salesforce](https://www.salesforce.com). 
2. This sample demonstrates on capturing events using the Event Listener of Ballerina Salesforce Connector. As mentioned below to listen to a certain event users need to select Objects for Change Notifications in the user interface in his/her Salesforce instance.
https://developer.salesforce.com/docs/atlas.en-us.change_data_capture.meta/change_data_capture/cdc_select_objects.htm
3. Salesforce username, password will be needed for initializing the listener. 
4. Once you obtained all configurations, Replace "" in the `Config.toml` file with your data.
5. [Select Objects](https://developer.salesforce.com/docs/atlas.en-us.change_data_capture.meta/change_data_capture/cdc_select_objects.htm) for Change Notifications in the User Interface of Salesforce account.

### Configuration steps for Twilio account

1. Create a [Twilio developer account](https://www.twilio.com/). 
2. Create a Twilio project with SMS capabilities.
3. Obtain the Account Sid and Auth Token from the project dashboard.
4. Obtain the phone number from the project dashboard and set as the value of the `twFromMobile` variable in the `Config.toml`.
5. Give a mobile number where the SMS should be send as the value of the `twToMobile` variable in the `Config.toml`.
6. Once you obtained all configurations, Replace "" in the `Config.toml` file with your data.

## Template Configuration

1. Create a push topic in salesforce developer console.
2. Create a Twilio account with sms capabilities.
3. Obtain all the above necessary configurations.
4. Once you obtained all configurations, Create `Config.toml` in root directory.
5. Replace the necessary fields in the `Config.toml` file with your data.

### Config.toml 

```
[<ORG_NAME>.sfdc_opportunity_update_to_twilio_sms]
sfdcUsername = "<SALESFORCE_USERNAME>"
sfdcPassword = "<SALESFORCE_PASSWORD>"
twilioAccountSid = "<TWILIO_ACCOUNT_SID>"
twilioAuthToken = "<TWILIO_AUTH_TOKEN>"
fromNumber = "<TWILIO_FROM_MOBILE>"
toNumber = "<TWILIO_TO_MOBILE>"
```

## Running the template

1. First you need to build the integration template and create the executable binary. Run the following command from the root directory of the integration template. 

    `$ bal build`. 

2. Then you can run the integration binary with the following command. 

    `$ bal run /target/bin/sfdc_opportunity_update_to_twilio_sms.jar`. 

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

3. Now you can update an opportunity in Salesforce Account and observe that integration template runtime has received the event notification for the updated opportunity.

4. You can check the SMS received to verify that information about the opportunity update is received. 
