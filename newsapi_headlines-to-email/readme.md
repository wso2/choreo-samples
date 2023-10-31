# News API Headlines to Email
## Use case
This integration sample helps to send email with BBC top headlines news.

## Pre-requisites
* News API Account

### Setup News API Configurations
1. Visit [News API](https://newsapi.org/register) and create a News API Account.
2. Create a account in News API and obtain the API Key.

## Configuration
Create a file called `Config.toml` at the root of the project.

### Config.toml 

```
[<ORG_NAME>.newsapi_headlines_to_email]
emailAddress = "<EMAIL_ADDRESS>"

[<ORG_NAME>.newsapi_headlines_to_email.apiKeyConfig]
apiKey = "<NEWSAPI_API_KEY>"
```

## Testing
Run the Ballerina project created by the integration sample by executing `bal run` from the root.

Once successfully executed, BBC top headlines are fetched and sent as email to recipient.  
