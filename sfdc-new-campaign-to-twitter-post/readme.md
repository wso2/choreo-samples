# Salesforce New Campaign to Twitter Post
## Use case
This integration sample helps to post a Tweet in Twitter for each new campaigns in salesforce. It listens the changes happens for a case record in salesforce. At the execution of this sample, each time new campaign is added in salesforce, Twitter post is created with details. 

## Pre-requisites
* Google Cloud Platform Account
* Twitter Developer Account

### Setup Salesforce Configurations
1. Visit [Salesforce](https://www.salesforce.com/) and create a Salesforce Account.
2.  Salesforce username, password and the security token that will be needed for initializing the listener. 
    For more information on the secret token, please visit [Reset Your Security Token](https://help.salesforce.com/articleView?id=user_security_token.htm&type=5).
    
    Once you obtained all configurations, Replace "" in the `Config.toml` file with your data. For the `sfdcPassword` insert the combination of your Salesforce account password with the security token received 
3. [Select Objects](https://developer.salesforce.com/docs/atlas.en-us.change_data_capture.meta/change_data_capture/cdc_select_objects.htm) for Change Notifications in the User Interface of Salesforce account.


### Setup Twitter Configurations
1. Visit [Tiwtter](https://developer.twitter.com/en) and create a Twitter Developer Account.
2. Create a app in developer portal and obtain the following credentials:
    *   Api Key
    *   Api Secret
    *   Access Token
    *   AccessToken Secret

## Configuration
Create a file called `Config.toml` at the root of the project.

### Config.toml 

```
[<ORG_NAME>.sfdc_new_campaign_to_twitter_post.salesforceListenerConfig]
sfdcUsername = "<SALESFORCE_USERNAME>"
sfdcPassword = "<SALESFORCE_PASSWORD>"
[<ORG_NAME>.sfdc_new_campaign_to_twitter_post.twitterClientConfig]
apiKey = "<TWITTER_API_KEY>"
apiSecret = "<TWITTER_API_SECRET>"
accessToken = "<TWITTER_ACCESS_TOKEN>"
accessTokenSecret = "<TWITTER_ACCESS_TOKEN_SECRET>"
```

## Testing
Run the Ballerina project created by the integration sample by executing `bal run` from the root.

Once successfully executed, New tweet will be posted in Twitter each time when a new Salesforce campaign created.
