# Template: GitHub new release to Slack Channel message
When a new release is done in GitHub, send a message to a Slack channel. <br>

It is important to be updated with a particular software development tool that you or your team are using in the 
day-to-day development process and get notified immediately on a new release of it. There can be a Slack channel 
followed by a development community or a team that uses that specific tool. This template makes it easier to provide 
such notification by allowing to send a message to a targeted Slack channel when there is a new release in a specific 
GitHub repository.

This template can be used to send a message to a selected Slack channel when a new release is done in a specific 
repository in GitHub.

## Use this template to
- Send a Channel message to a Slack channel which is created for developers who use a Git repository.
- Send a Channel message to a Slack channel which is followed by the contributors of a Git repository.

## What you need
- A Github Account
- A Slack workspace with admin privileges

## How to set up
- Import the template.
- Allow access to the Github account.
- Select the repository.
- Allow access to Slack account.
- Select the channel.
- Set up the template. 

# Developer Guide

<p align="center">
<img src="./docs/images/template_flow.png?raw=true" alt="Github-Slack Integration template overview"/>
</p>

## Supported Versions

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
   <td>GitHub REST API Version
   </td>
   <td>V3
   </td>
  </tr>
  <tr>
   <td>Slack Event API
   </td>
   <td>
   </td>
  </tr>
</table>

## Pre-requisites
* Download and install [Ballerina](https://ballerinalang.org/downloads/).
* Slack workspace with admin privileges
* GitHub account

## Account Configuration
### Configuration steps for GitHub account
1. First obtain a [Personal Access Token (PAT)](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) or the [GitHub OAuth App Token](https://docs.github.com/en/developers/apps/creating-an-oauth-app).
2. To create the GitHub topic name, you need to create a github repository where you want to get information of new 
releases to the Slack message.
3. Create the GitHub topic name according to the given format. Replace the `GITHUB_USER_NAME` and `REPOSITORY_NAME` using 
your `user name` and `repository name` respectively.
  
```
https://github.com/<GITHUB_USER_NAME>/<REPOSITORY_NAME>/events/*.json"
```
4. Select any value as the github secret.
5. For setting up a GitHub callback URL you can install [ngrok](https://ngrok.com/docs) and expose a local web server to 
the internet.
6. Then start the `ngork` with `webhook:Listener` service port (8080 in this case) by using the command `./ngrok http 8080`
7. Set the callback URL according to the given format. 
```
<public_url_obtained_by_ngrok>/subscriber
```
  (eg: https://ea0834f44458.ngrok.io/subscriber)

8. Use the above obtained values to set github_accessToken, github_secret, github_topic and github_callbackUrl in the 
config(Config.toml) file.

### Configuration steps for Slack account
1. Create a Slack app which connects to your development workspace. More information on this can be found [here](https://api.slack.com/start).
2. Obtain an OAuth token for the app visiting `OAuth & Permissions` tab in app `Features`.
3. Generate an OAuth token linking the specific workspace, providing the necessary scopes.
![Creating Slack OAuth token](docs/images/slack_token.png?raw=true)

## Template Configuration

1. Create a new channel or obtain the name of an already existing channel.
2. Obtain all the above necessary configurations.
3. Once you obtained all configurations, Create `Config.toml` in root directory.
4. Replace the necessary fields in the `Config.toml` file with your data.

## Config.toml 

```
[<ORG_NAME>.github_release_to_slack]
slackChannelName=""
slackAuthToken=""
gitHubCallbackUrl=""
githubRepoURL="

[<ORG_NAME>.github_release_to_slack.gitHubTokenConfig]
token=""
```

## Running the Template

1. First you need to build the integration template and create the executable binary. Run the following command from the 
root directory of the integration template. 
`$ bal build`. 

2. Then you can run the integration binary with the following command. 
`$  bal run target/bin/github_release_to_slack_channel-0.1.0.jar`. 

3. Now you can add new release to the specific GitHub repository and observe that integration template runtime has 
received the event notification for new release.

4. You can check the Slack channel to verify that new message is received. 
