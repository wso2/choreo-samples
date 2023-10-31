# GitHub New Release to Slack Channel Message
## Use case
It is important to be updated with a particular software development tool that you or your team are using in the
day-to-day development process and get notified immediately on a new release of it. There can be a Slack channel
followed by a development community or a team that uses that specific tool. This sample makes it easier to provide
such notification by allowing to send a message to a targeted Slack channel when there is a new release in a specific
GitHub repository. This sample can be used to send a message to a selected Slack channel when a new release is done in a specific
repository in GitHub.

## Prerequisites
* GitHub account
* Slack workspace with admin privileges

### Setting up Slack account

1. Create a Slack app that connects to your development workspace. More information on this can be found [here](https://api.slack.com/start).
2. Obtain an OAuth token for the app visiting `OAuth & Permissions` tab in app `Features`.
3. Generate an OAuth token linking the specific workspace, providing `chat:write` and `channels:read` scopes in 'User Token Scopes'.
   ![Creating Slack OAuth token](docs/images/slack_token.png?raw=true)

### Configure Github webhook with the URL of the service
* You can install webhooks on an organization or on a specific repository.
* To set up a webhook, go to the settings page of your repository or organization. From there, click Webhooks, then Add webhook.
* Webhooks require a few configuration options before you can make use of them
[More information on setting up a webhook for GitHub Async trigger](https://github.com/ballerina-platform/asyncapi-triggers/blob/main/asyncapi/github/Module.md#step-5-configure-github-webhook-with-the-url-of-the-service)

## Configuration
Create a file called `Config.toml` at the root of the project.

## Config.toml

```
[<ORG_NAME>.github_release_to_slack]
slackChannelName="<SLACK_CHANNEL_NAME>"
slackAuthToken="<SLACK_AUTH_TOKEN>"

[<ORG_NAME>.github_release_to_slack.gitHubListenerConfig]
secret = "<SECRET>"
```

* SLACK_CHANNEL_NAME - Name of the channel created on Slack
* SLACK_AUTH_TOKEN - Authentication token generated
* SECRET - This secret will be used in registering webhook

## Testing
Run the Ballerina project created by the integration sample by executing `bal run` from the root.

Upon successful configuration, Slack message will be sent on each GitHub release.
