import ballerina/http;
import ballerina/log;
import ballerina/websub;
import ballerinax/github.webhook as webhook;
import ballerinax/twilio;

// Github configuration parameters
@display {
    kind: "OAuthConfig",
    provider: "GitHub",
    label: "Set Up GitHub Connection"
}
configurable http:BearerTokenConfig & readonly gitHubTokenConfig = ?;

@display {
    kind: "ConnectionField",
    connectionRef: "gitHubTokenConfig",
    provider: "GitHub",
    operationName: "getUserRepositoryList",
    label: "GitHub Repository URL"
}
configurable string & readonly githubRepoUrl = ?;

@display {
    kind: "WebhookURL",
    label: "Set Up Callback URL for GitHub Webhook"
}
configurable string & readonly githubCallbackUrl = ?;

@display {label: "Issue Assignee's User Name"}
configurable string & readonly issueAssigneeGithubUsername = ?;

// Twilio configuration parameters
@display {label: "Twilio Account SID"}
configurable string & readonly twilioAccountSid = ?;

@display {label: "Twilio Auth Token"}
configurable string & readonly twilioAuthToken = ?;

@display {label: "SMS Sender's Phone Number"}
configurable string & readonly fromNumber = ?;

@display {label: "SMS Recipient's Phone Number"}
configurable string & readonly toNumber = ?;

// Keys related to the issue assigned
const string ISSUE_URL = "html_url";
const string ISSUE_TITLE = "title";

listener webhook:Listener githubListener = new (8090);

@websub:SubscriberServiceConfig {
    target: [webhook:HUB, githubRepoUrl + "/events/*.json"],
    callback: githubCallbackUrl + "/subscriber",
    httpConfig: {auth: gitHubTokenConfig}
}
service /subscriber on githubListener {
    remote function onIssuesAssigned(webhook:IssuesEvent event) returns error? {
        webhook:Issue issueInfo = event.issue;
        if (issueInfo.assignee?.login == issueAssigneeGithubUsername) {
            string message = "Github new issue assigned! \n";
            string[] issueKeys = [ISSUE_URL, ISSUE_TITLE];
            foreach var issueKey in issueKeys {
                if (issueInfo.hasKey(issueKey)) {
                    message += issueKey + " : " + issueInfo.get(issueKey).toString() + "\n";
                }
            }

            twilio:Client twilioClient = check new ({
                accountSId: twilioAccountSid,
                authToken: twilioAuthToken
            });
            twilio:SmsResponse sendSmsResponse = check twilioClient->sendSms(fromNumber, toNumber, message);
            log:printInfo("SMS for new issue assigned sent successfully!");
        }
    }
}
