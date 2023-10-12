import ballerina/http;
import ballerina/log;
import ballerinax/trigger.github;
import ballerinax/twilio;

// Github configuration parameters
configurable github:ListenerConfig gitHubListenerConfig = ?;
configurable string issueAssigneeGithubUsername = ?;

// Twilio configuration parameters
configurable string TwilioAccountSID = ?;
configurable string TwilioAuthToken = ?;
configurable string fromNumber = ?;
configurable string toNumber = ?;

// Keys related to the issue assigned
final string[] & readonly issueKeys = ["html_url", "title"];

listener http:Listener httpListener = new(8090);
listener github:Listener gitHubListener = new (gitHubListenerConfig, httpListener);

@display { label: "GitHub Issue Assigned to Twilio SMS" }
service github:IssuesService on gitHubListener {
    remote function onAssigned(github:IssuesEvent payload) returns error? {
        github:Issue issueInfo = payload.issue;
        if issueInfo.assignee?.login == issueAssigneeGithubUsername {
            string message = "Github new issue assigned! \n";
            foreach string issueKey in issueKeys {
                if (issueInfo.hasKey(issueKey)) {
                    message += string `issueKey : ${issueInfo.get(issueKey).toString()}${"\n"}`;
                }
            }

            twilio:Client twilioClient = check new ({
                twilioAuth: {
                    accountSId: TwilioAccountSID,
                    authToken: TwilioAuthToken
                }
            });
            _ = check twilioClient->sendSms(fromNumber, toNumber, message);
            log:printInfo("SMS for new issue assigned sent successfully!");
        }
    }
    
    remote function onOpened(github:IssuesEvent payload ) returns error? {
      return;
    }
    remote function onClosed(github:IssuesEvent payload ) returns error? {
      return;
    }
    remote function onReopened(github:IssuesEvent payload ) returns error? {
      return;
    }
    remote function onUnassigned(github:IssuesEvent payload ) returns error? {
      return;
    }
    remote function onLabeled(github:IssuesEvent payload ) returns error? {
      return;
    }
    remote function onUnlabeled(github:IssuesEvent payload ) returns error? {
      return;
    }
}

service /ignore on httpListener {}
