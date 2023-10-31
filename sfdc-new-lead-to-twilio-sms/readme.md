# Salesforce New Lead to Twilio SMS
# Use case
A customer can use Twilio to send internal notifications to a specific person of interest, based on the new lead 
information in Salesforce. It is important to follow up with leads as soon as they are added in Salesforce. 
There maybe a specific person who wanted to be on alert of new Salesforce leads. Any time you create a new lead 
in Salesforce, an SMS message will automatically send to the specific person via Twilio. This sample can be used to 
send a Twilio SMS message containing all the defined fields in lead SObject to a given mobile number when a new lead is 
created in Salesforce.

## Prerequisites
* Google Cloud platform account
* Twilio account

### Setting up Salesforce account
1. Create a Salesforce account and create a connected app by visiting [Salesforce](https://www.salesforce.com). 
2. This sample demonstrates on capturing events using the Event Listener of Ballerina Salesforce Connector. As mentioned below to listen to a certain event users need to select Objects for Change Notifications in the user interface in his/her Salesforce instance.
https://developer.salesforce.com/docs/atlas.en-us.change_data_capture.meta/change_data_capture/cdc_select_objects.htm
3. Salesforce username, password will be needed for initializing the listener. 
4. Once you obtained all configurations, Replace "" in the `Config.toml` file with your data.
5. [Select Objects](https://developer.salesforce.com/docs/atlas.en-us.change_data_capture.meta/change_data_capture/cdc_select_objects.htm) for Change Notifications in the User Interface of Salesforce account.


### Setting up Twilio account
1. Create a [Twilio developer account](https://www.twilio.com/). 
2. Create a Twilio project with SMS capabilities.
3. Obtain the Account Sid and Auth Token from the project dashboard.
4. Obtain the phone number from the project dashboard and set as the value of the `twFromMobile` variable in the `Config.toml`.
5. Give a mobile number where the SMS should be sent as the value of the `twToMobile` variable in the `Config.toml`.
6. Once you obtained all configurations, Replace "" in the `Config.toml` file with your data.

## Configuration
Create a file called `Config.toml` at the root of the project.

### Config.toml 

```
[<ORG_NAME>.sfdc_new_lead_to_twilio_sms]
fromNumber = "<TWILIO_FROM_MOBILE>"
toNumber = "<TWILIO_TO_MOBILE>"

[<ORG_NAME>.sfdc_new_lead_to_twilio_sms.salesforceListenerConfig]
username = "<SALESFORCE_USERNAME>"
password = "<SALESFORCE_PASSWORD>"

[<ORG_NAME>.sfdc_new_lead_to_twilio_sms.twilioClientConfig]
accountSId = "<TWILIO_ACCOUNT_SID>"
authToken = "<TWILIO_AUTH_TOKEN>"

```
Phone numbers must be provided in E.164 format: +<country code><number>, for example: +16175551212

### Template Configuration
1. Create a push topic in salesforce developer console.
2. Create a Twilio account with sms capabilities.
3. Obtain all the above necessary configurations.
4. Once you obtained all configurations, Create `Config.toml` in root directory.
5. Replace the necessary fields in the `Config.toml` file with your data.

## Testing
Run the Ballerina project created by the integration sample by executing `bal run` from the root.

You can check the SMS received to verify that information about the new lead created.

