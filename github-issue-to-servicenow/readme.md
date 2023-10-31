# GitHub New Issue to ServiceNow Record
## Use case
It is important to be aware of the issues which are created in the GitHub repositories to take necessary actions. ServiceNow is an important tool in IT management. Update the `incident` table in ServiceNow with new GitHub issues will be helpful to track the issues easily. By using this integration sample, we can insert a new record in `incident` table of ServiceNow when a new issue is created in a specific GitHub repository.

## Prerequisites
* GitHub account
* ServiceNow account

### Setting up ServiceNow Configurations
1. Visit [ServiceNow](https://developer.servicenow.com/dev.do) and create a ServiceNow Developer Account. 
2. Create a ServiceNow instance and obtain the following credentials:
    *   ServiceNow instance URL
    *   Username
    *   Password

### Configure Github webhook with the URL of the service
* You can install webhooks on an organization or on a specific repository.
* To set up a webhook, go to the settings page of your repository or organization. From there, click Webhooks, then Add webhook.
* Webhooks require a few configuration options before you can make use of them
[More information on setting up a webhook for GitHub Async trigger](https://github.com/ballerina-platform/asyncapi-triggers/blob/main/asyncapi/github/Module.md#step-5-configure-github-webhook-with-the-url-of-the-service)

## Configuration
Create a file called `Config.toml` at the root of the project.

## Config.toml
```
serviceNowURL = "<YOUR_SERVICENOW_INSTANCE_URL>"

[<ORG_NAME>.github_issue_to_servicenow.serviceNowConfig]
username = "<USERNAME_OF_YOUR_SERVICENOW_INSTANCE>"
password = "<PASSWORD_OF_YOUR_SERVICENOW_INSTANCE>"

[<ORG_NAME>.github_issue_to_servicenow.gitHubListenerConfig]
webhookSecret = "<SECRET>"
```

## Testing
Run the Ballerina project created by the integration sample by executing `bal run` from the root.

Once successfully executed, new record will be added to `incident` table in ServiceNow each time when a GitHub issue is created.
