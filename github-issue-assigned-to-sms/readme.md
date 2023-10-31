# GitHub Issue Assigned to SMS Notification
## Use case
It is important to follow up with GitHub repositories as soon as an issue is assigned.
You may want to be on alert of issues assigned to you in a certain GitHub repository.
Any time an issue is assigned, an SMS message will automatically be sent to you.
This sample can be used to send an SMS when an issue is assigned to you.

## Prerequisites
* GitHub account
* Recipient Phone Number

### Configure Github webhook with the URL of the service
* You can install webhooks on an organization or on a specific repository.
* To set up a webhook, go to the settings page of your repository or organization. From there, click Webhooks, then Add webhook.
* Webhooks require a few configuration options before you can make use of them
[More information on setting up a webhook for GitHub Async trigger](https://github.com/ballerina-platform/asyncapi-triggers/blob/main/asyncapi/github/Module.md#step-5-configure-github-webhook-with-the-url-of-the-service)

## Configuration
Create a file called `Config.toml` at the root of the project.

### Config.toml
```
[<ORG_NAME>.github_issue_assigned_to_sms]
toMobile = "<TO_MOBILE>"
githubUsername = "<GITHUB_ISSUE_ASSIGNEE_USERNAME>"

[<ORG_NAME>.github_issue_assigned_to_sms.gitHubListenerConfig]
secret = "<SECRET>"
```

* TO_MOBILE - Recipient mobile number in international format. For example +94777123456.
* GITHUB_ISSUE_ASSIGNEE_USERNAME - GitHub username for assignee.
* SECRET - This secret will be used in registering webhook

## Testing
Run the Ballerina project created by the integration sample by executing `bal run` from the root.

You can check the SMS received to verify with information in the assigned GitHub issue.