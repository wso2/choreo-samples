# GitHub New Release to Twitter Post
## Use case
It is important to be updated with a particular software development tool that you or your team are using in the day-to-day development process and get notified immediately on a new release of it. It is important to follow up with Github repositories as soon as they are released. There maybe a specific person who wanted to be on alert of new releases of a certain Github repository. Any time a new release is made or updated in Github, a twitter post is updated. 

## Prerequisites
* GitHub account.
* Twitter account.

### Setting up Twitter Configurations
1. Visit [Twitter](https://developer.twitter.com/en) and create a Twitter Developer Account.
2. Create a app in developer portal and obtain the following credentials:
    *   Api Key
    *   Api Secret
    *   Access Token
    *   AccessToken Secret

### Configure Github webhook with the URL of the service
* You can install webhooks on an organization or on a specific repository.
* To set up a webhook, go to the settings page of your repository or organization. From there, click Webhooks, then Add webhook.
* Webhooks require a few configuration options before you can make use of them. [More information on setting up a webhook for GitHub Async trigger](https://github.com/ballerina-platform/asyncapi-triggers/blob/main/asyncapi/github/Module.md#step-5-configure-github-webhook-with-the-url-of-the-service)

## Configuration
Create a file called `Config.toml` at the root of the project.

## Config.toml
```
[<ORG_NAME>.github_new_release_to_twitter_post.twitterClientConfig]
apiKey = "<TWITTER_API_KEY>"
apiSecret = "<TWITTER_API_SECRET>"
accessToken = "<TWITTER_ACCESS_TOKEN>"
accessTokenSecret = "<TWITTER_ACCESS_TOKEN_SECRET>"

[<ORG_NAME>.github_new_release_to_twitter_post.gitHubListenerConfig]
secret = "<SECRET>"
```

## Testing
Run the Ballerina project created by the integration sample by executing bal run from the root.

Once successfully executed, New tweet will be posted in Twitter each time when a new GitHub release is done.
