import ballerina/http;
import ballerina/io;
import ballerina/websub;
import ballerinax/github.webhook as webhook;
import ballerinax/twilio;

// Keys related to the issue assigned
const string ISSUE_URL = "html_url"; 
const string ISSUE_TITLE = "title";

// Github configuration parameters
@display { kind: "OAuthConfig", provider: "GitHub", label: "Set up GitHub connection" }
configurable http:BearerTokenConfig & readonly gitHubTokenConfig = ?;
@display { kind: "ConnectionField", connectionRef: "gitHubTokenConfig", provider: "GitHub", operationName: "getUserRepositoryList", label: "GitHub Repository URL"}
configurable string & readonly githubRepoURL = ?;
@display { kind: "WebhookURL", label: "Set up callback URL for GitHub webhook"}
configurable string & readonly githubCallback = ?;
@display { label: "Issue Assignee's User Name"}
configurable string & readonly issueAssigneeGithubUsername = ?;

// Twilio configuration parameters
@display { label: "Twilio Account SID" }
configurable string & readonly accountSId = ?;
@display { label: "Twilio Auth Token" }
configurable string & readonly authToken = ?;
@display { label: "SMS Sender's Phone Number" }
configurable string & readonly fromMobile = ?;
@display { label: "SMS Recipient's Phone Number" }
configurable string & readonly toMobile = ?;

// Initialize the Github Listener
listener webhook:Listener githubListener = new (8090);

@websub:SubscriberServiceConfig {
    target: [webhook:HUB, githubRepoURL + "/events/*.json"],
    callback: githubCallback,
    httpConfig: {
        auth: gitHubTokenConfig
    }
}
service /subscriber on githubListener {
    remote function onIssuesAssigned(webhook:IssuesEvent event) returns error? {
        webhook:Issue issueInfo = event.issue; 
        io:StringReader reader = new (event.issue.assignee.toJsonString());
        json issueAssignee = check reader.readJson();
        json login = check issueAssignee.login;
        if (login.toString() == issueAssigneeGithubUsername) {
            (string)[] issueKeys = [ISSUE_URL, ISSUE_TITLE];
            string message = "Github new issue assigned! \n";

            foreach var issueKey in issueKeys {
                if (issueInfo.hasKey(issueKey)) {
                    message = message + issueKey + " : " + issueInfo.get(issueKey).toString() + "\n";  
                }   
            }
            // Initialize the Twilio Client
            twilio:Client twilioClient = new ({
                accountSId: accountSId,
                authToken: authToken
            });
            var result = check twilioClient->sendSms(fromMobile, toMobile, message);
        }
    }
}
