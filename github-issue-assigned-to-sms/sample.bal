import ballerina/http;
import ballerina/log;
import wso2/choreo.sendsms;
import ballerinax/trigger.github;

// Github configuration parameters
@display {
    label: "GitHub Listener Configuration",
    description: "The configuration of the GitHub listener"
}
configurable github:ListenerConfig gitHubListenerConfig = ?;
@display {
    label: "GitHub Issue Assignee Username",
    description: "The GitHub username of the issue assignee"
}
configurable string githubUsername = ?;

// Sendsms configuration parameters
@display {
    label: "Recepient Mobile No",
    description: "The recepient mobile number in international format. For example +94777123456"
}
configurable string toMobile = ?;

listener http:Listener httpListener = new(8090);
listener github:Listener gitHubListener = new (gitHubListenerConfig, httpListener);

@display { label: "GitHub Issue Assigned to SMS Notification" }
service github:IssuesService on gitHubListener {
    remote function onAssigned(github:IssuesEvent payload) returns error? {
        if payload.issue.assignee?.login == githubUsername {
            string message = string `Github new issue assigned! ${"\n"}Issue Url: ${payload.issue.html_url}`;
            sendsms:Client smsClient = check new ();
            string sendSmsResponse = check smsClient->sendSms(toMobile, message);
            log:printInfo("Sms sent successfully! Message status: " + sendSmsResponse);
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
