# Salesforce New Campaign to AWS SES Email
## Use case
At the execution of this sample, each time new campaign is added in salesforce, AWS SES email will be 
added containing all the defined fields in campaign SObject.

## Prerequisites
* Salesforce account
* AWS account

### Setting up Salesforce account
1. Visit [Salesforce](https://www.salesforce.com/) and create a Salesforce account.
2.  Salesforce username, password and the security token that will be needed for initializing the listener. 
    For more information on the secret token, please visit [Reset Your Security Token](https://help.salesforce.com/articleView?id=user_security_token.htm&type=5).
    
    Once you obtained all configurations, Replace "" in the `Config.toml` file with your data. For the Salesforce `password` insert the combination of your Salesforce account password with the security token received 
3. [Select Objects](https://developer.salesforce.com/docs/atlas.en-us.change_data_capture.meta/change_data_capture/cdc_select_objects.htm) for Change Notifications in the User Interface of Salesforce account.

### Setting up AWS SES account
1. Visit [AWS](https://aws.amazon.com) and create an AWS SES account.
2. Obtain tokens by following this [guide](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html)

## Configuration
Create a file called `Config.toml` at the root of the project.

### Config.toml 

```
[<ORG_NAME>.sfdc_new_campaign_to_aws_ses_email]
senderEmail = "<AWS_SENDER_EMAIL>"
receiverEmail = "<AWS_RECEIVER_EMAIL>"

[<ORG_NAME>.sfdc_new_campaign_to_aws_ses_email.salesforceListenerConfig]
username = "<SALESFORCE_USERNAME>"
password = "<SALESFORCE_PASSWORD>"

[<ORG_NAME>.sfdc_new_campaign_to_aws_ses_email.awsCredentialsConfig]
accessKeyId = "<AWS_ACCESS_KEY_ID>"
secretAccessKey = "<AWS_SECRET_ACCESS_KEY>"
```

### Template Configuration
1. Obtain the `senderEmail` and `receiverEmail`. 
2. Once you obtained all the configurations, Create `Config.toml` in root directory.
3. Replace the necessary fields in the `Config.toml` file with your data.

## Testing
Run the Ballerina project created by the integration sample by executing `bal run` from the root.

So once a new Campaign is added in Salesforce, new AWS SES email will be sent.
