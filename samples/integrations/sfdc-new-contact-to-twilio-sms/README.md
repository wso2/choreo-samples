# Template: Salesforce new Contact to Twilio SMS
When a new `Contact` is added in Salesforce, send a Twilio SMS to a specific number.<br>

A customer can use Twilio to send internal notifications to a specific person based on the new contact information in 
Salesforce. There might be a specific person who needs to be alerted once a new contact is added in Salesforce. Once a 
new contact is created in Salesforce, a Twilio SMS containing all the defined fields in contact SObject will be sent. 
Any time you create a new contact in Salesforce, an SMS message will automatically send to the specific person via Twilio.

This template is used for the scenario that once a contact is created in Salesforce, Twilio SMS containing all the 
defined fields in contact SObject will be sent.

## Use this template to
- Send Twilio SMS to a specific mobile number when a new Contact is created in Salesforce.

## What you need
- A Salesforce Account
- A Twilio Account 

## How to set up
- Import the template.
- Allow access to Salesforce account.
- Provide Salesforce push topic.
- Allow access to the Twilio account.
- Provide the Twilio Account SID and Auth Token.
- Provide the number we want to send SMS from.
- Provide the number we want to send the SMS to.
- Set up the template. 

# Developer Guide
<p align="center">
<img src="./docs/images/template_flow.png?raw=true" alt="Salesforce-Twilio Integration template overview"/>
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
* Twilio account with SMS capable phone number.
* Ballerina connectors for Salesforce and Twilio which will be automatically downloaded when building the application for the first time.

## Account Configuration
### Configuration steps for Salesforce account
1. Create a Salesforce account and create a connected app by visiting [Salesforce](https://www.salesforce.com). 
2. Salesforce username, password will be needed for initializing the listener. 
3. Once you obtained all configurations, Replace relevant places in the `Config.toml` file with your data.
4. [Select Objects](https://developer.salesforce.com/docs/atlas.en-us.change_data_capture.meta/change_data_capture/cdc_select_objects.htm) for Change Notifications in the User Interface of Salesforce account.

### Configuration steps for Twilio account
1. Create a [Twilio developer account](https://www.twilio.com/). 
2. Obtain the Account SID and Auth Token from the project dashboard.
3. Obtain the phone number from the project dashboard and set as the value of the `fromNumber` variable in the `Config.toml`.
4. Give a mobile number where the SMS should be send as the value of the `toNumber` variable in the `Config.toml`.
5. Once you obtained all configurations, Replace relevant places in the `Config.toml` file with your data.

## Config.toml 
```
[<ORG_NAME>.sfdc_new_contact_to_twilio_sms]
sfdcUsername = "<SALESFORCE_USERNAME>"  
sfdcPassword = "<SALESFORCE_PASSWORD>"  
twilioAccountSid = "<TWILIO_ACCOUNT_SID>"  
twilioAuthToken = "<TWILIO_AUTH_TOKEN>"  
fromNumber = "<TWILIO_FROM_MOBILE_NUMBER>"  
toNumber = "<TWILIO_TO_MOBILE_NUMBER>"  
```

## Running the template
1. First you need to build the integration template and create the executable binary. Run the following command from the root directory of the integration template. 
`$ bal build`. 

2. Then you can run the integration binary with the following command. 
`$ bal run  bal run target/bin/sfdc_new_contact_to_twilio_sms.jar`. 

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
3. Now you can create a new contact in Salesforce Account and observe that integration template runtime has received the event notification for the created contact.

4. You can check the SMS received to verify that information about the contact creation is received. 
