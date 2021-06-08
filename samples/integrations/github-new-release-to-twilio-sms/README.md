# Template: GitHub New Release to Twilio SMS
When a new release is made in Github, send a Twilio sms.

It is important to be updated with a particular software development tool that you or your team are using in the day-to-day development process and get notified immediately on a new release of it. It is important to follow up with Github repositories as soon as they are released. There maybe a specific person who wanted to be on alert of new releases of a certain Github repository. Any time a new release is made in Github, a SMS message will automatically send to the specific person of interest via Twilio. 

This template can be used to send a Twilio SMS message to a given mobile number when a new release is made in a specific GitHub repository.

## Use this template to
- Send a Twilio SMS message to a specific number when a release is made in a GitHub repository.

## What you need
- A GitHub Account
- A Twilio Account

## How to set up
- Import the template.
- Allow access to the GitHub account.
- Select the repository.
- Allow access to the Twilio account.
- Provide the Twilio Account SID and Auth Token.
- Provide the number we want to send the SMS from.
- Provide the number we want to send the SMS to.
- Set up the template. 

# Developer Guide
<p align="center">
<img src="./docs/images/template_flow.png?raw=true" alt="Github-Google Sheet Integration template overview"/>
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
   <td>Twilio Basic API Version
   </td>
   <td>2010-04-01 
   </td>
  </tr>
</table>

## Pre-requisites
* Download and install [Ballerina](https://ballerinalang.org/downloads/).
* GitHub account.
* Twilio account with sms capable phone number.
* Ballerina connectors for Github and Twilio which will be automatically downloaded when building the application for the first time.


## Account Configuration
### Configuration steps for GitHub account
1. First obtain a [Personal access token](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) or [GitHub OAuth App token](https://docs.github.com/en/developers/apps/creating-an-oauth-app).
2. Next you need to create a Github repository where you want to get new release events from.
3. Set the github repository URL in the following format. Replace the `<Github-User-Name>` with the username of the Github account &
`<Repository-Name-To-Get-Release-Events>` with the name of the repository you created.
    ```
    https://github.com/<Github-User-Name>/<Repository-Name-To-Get-Release-Events>
    ```
4. Then you can optionally add a github secret for signature validation.
5. To setup a github callback URL, you can install [ngrok](https://ngrok.com/download) and [expose a local web server to 
the internet](https://ngrok.com/docs).
6. Then start the ngork with webhook:Listener service port (8080 in this example) by using the command ./ngrok http 8080 
and obtain a public URL which expose your local service to the internet.
7. Set the github callback URL which is in the format 
    ```
    <public-url-obtained-by-ngrok>/<name-of-the-websub-service>
    ```
    (eg: https://ea0834f44458.ngrok.io/subscriber)
8. Add the accessToken, githubTopic, githubSecret and githubCallback to the config(Config.toml) file.

### Configuration steps for Twilio account

1. Create a [Twilio developer account](https://www.twilio.com/). 
2. Create a Twilio project with SMS capabilities.
3. Obtain the Account Sid and Auth Token from the project dashboard.
4. Obtain the phone number from the project dashboard and set as the value of the `fromMobile` variable in the `Config.toml`.
5. Give a mobile number where the SMS should be send as the value of the `toMobile` variable in the `Config.toml`.
6. Once you obtained all configurations, Replace "" in the `Config.toml` file with your data.

## Template Configuration
1. Create a Twilio account with sms capabilities.
2. Obtain all the above necessary configurations.
3. Once you obtained all configurations, Create `Config.toml` in root directory.
4. Replace the necessary fields in the `Config.toml` file with your data.

## Config.toml 
```
[<ORG_NAME>.github_new_release_to_twilio_sms]
githubRepoURL = "<GITHUB_REPO_URL>"
gitHubCallbackUrl = "<GITHUB_CALLBACK_URL>"
accountSid = "<TWILIO_ACCOUNT_SID>"
authToken = "<TWILIO_AUTH_TOKEN>"
fromMobile = "<TWILIO_FROM_MOBILE>"
toMobile = "<TWILIO_TO_MOBILE>"

[<ORG_NAME>.github_new_release_to_twilio_sms.gitHubTokenConfig]
token = "<GITHUB_PAT_OR_OAUTH_TOKEN>"
```

## Running the Template
1. First you need to build the integration template and create the executable binary. Run the following command from the 
root directory of the integration template. 
    ```
    $ bal build. 
    ```

2. Then you can run the integration binary with the following command. 
    ```
    $ bal run /target/bin/github_new_release_to_twilio_sms.jar. 
    ```

3. Now you can make a new release in Github Account and observe that integration template runtime has received the event 
notification for the new release.

4. You can check the SMS received to verify that information about the new github release. 

