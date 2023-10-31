# Eventbrite Event Attendees to Mailchimp Subscribers
## Use case
At the execution of this sample, all the new event attendees in Evenbrite within a particular day will be added 
to your Mailchimp subscriber list(audience) as new members(contacts).

## Prerequisites
* Eventbrite account
* Mailchimp account

### Setting up Shopify account
1. Visit [Eventbrite](https://www.eventbrite.com/platform) and create a Eventbrite account.
2. Obtain tokens by following [this guide](https://www.eventbrite.com/platform/api#/introduction/authentication)

### Setting up Mailchimp account
1. Visit [Mailchimp](https://mailchimp.com) and create a Mailchimp account.
2. Navigate to the [API Keys section](https://us1.admin.mailchimp.com/account/api/) of your Mailchimp account.
3. If you already have an API key listed and you’d like to use it for your application, simply copy it. Otherwise, click Create a Key and give it a descriptive name that will remind you which application it’s used for.

## Configuration
Create a file called `Config.toml` at the root of the project.

### Config.toml 

```
[<ORG_NAME>.eventbrite_event_attendees_to_mailchimp_subscribers]
eventbriteEventId = "<EVENTBRITE_EVENT_ID>"
mailchimpServiceUrl = "<MAILCHIMP_SERVICE_URL>"
mailchimpAudienceName = "<MAILCHIMP_SUBSCRIBER_LIST_AUDIENCE_NAME>"

[<ORG_NAME>.eventbrite_event_attendees_to_mailchimp_subscribers.eventbriteAuthConfig]
token = "<EVENTBRITE_ACCESS_TOKEN>"

[<ORG_NAME>.eventbrite_event_attendees_to_mailchimp_subscribers.mailchimpAuthConfig]
username = "<MAILCHIMP_USERNAME>"
password = "<MAILCHIMP_PASSWORD>"
```

### Template Configuration
1. Obtain the `eventbriteEventId`, `mailchimpServiceUrl` and Mailchimp `mailchimpAudienceName`. 
2. The `eventbriteEventId` is available in the event URL `https://www.eventbrite.com/myevent?eid={eventbriteEventId}}`.
3. The `mailchimpServiceUrl` is `https://<dc>.api.mailchimp.com/3.0/`. The <dc> part of the URL corresponds to the data center for your account. For example, if the data center for your account is us6, all API endpoints for your account are available relative to https://us6.api.mailchimp.com/3.0/.
There are a few ways to find your data center. It’s the first part of the URL you see in the API keys section of your account; if the URL is https://us6.mailchimp.com/account/api/, then the data center subdomain is `us6`. It’s also appended to your API key in the form key-dc; if your API key is `0123456789abcdef0123456789abcde-us6`, then the data center subdomain is `us6`.
4. The `mailchimpAudienceName` will be your Mailchimp subscriber list name.
5. Once you obtained all configurations, Create `Config.toml` in root directory.
6. Replace the necessary fields in the `Config.toml` file with your data.

## Testing
Run the Ballerina project created by the integration sample by executing `bal run` from the root.

All the new event attendees in Evenbrite within a particular day will be added to your Mailchimp subscriber list(audience) as new members(contacts).
