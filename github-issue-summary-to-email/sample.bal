import ballerina/http;
import ballerina/log;
import ballerinax/github;
import wso2/choreo.sendemail as email;

// Github client configuration parameters
@display {
    provider: "GitHub",
    label: "Set Up GitHub Connection"
}
configurable http:BearerTokenConfig gitHubTokenConfig = ?;

@display {
    label: "GitHub Repository Name"
}
configurable string repositoryName = ?;

@display {label: "Github Repository Owner"}
configurable string repositoryOwner = ?;

// Email configuration parameters 
@display {label: "Email Receiver Address"}
configurable string recipientAddress = ?;

public function main() returns error? {

    github:Client githubClient = check new ({
        auth: {
            token: gitHubTokenConfig.token
        }
    });

    stream<github:User,github:Error?> collaborators = check githubClient->getCollaborators(repositoryOwner, repositoryName);
    log:printInfo("Started compiling the report");

    string assigneeSummary = "";

    check collaborators.forEach(function (github:User user ){
        string query = "repo:" + repositoryOwner + "/" + repositoryName + " is:issue assignee:" + user.login;
        github:SearchResult|github:Error issuesForAssignee = githubClient-> search(query, github:SEARCH_TYPE_ISSUE, 1);
        if issuesForAssignee is github:SearchResult {
            string userName = user?.name ?: "Unknown Name";
            assigneeSummary += string `${userName} : ${issuesForAssignee.issueCount} ${"\n"}`;
        } else {
            log:printError("Error while searching issues of an assignee.",'error = issuesForAssignee);
        }
    });

    string query1 = "repo:" + repositoryOwner + "/" + repositoryName + " is:issue is:open";
    github:SearchResult|github:Error openIssues = githubClient-> search(query1, github:SEARCH_TYPE_ISSUE, 1);
    if openIssues is github:Error {
        log:printError("Error while searching open issues.", 'error = openIssues);
    }
    int totalOpenIssueCount = openIssues is github:SearchResult? openIssues.issueCount : 0;

    string query2 = "repo:" + repositoryOwner + "/" + repositoryName + " is:issue is:closed";
    github:SearchResult|github:Error closedIssues = githubClient-> search(query2, github:SEARCH_TYPE_ISSUE, 1);
    if closedIssues is github:Error {
        log:printError("Error while searching closed issues.", 'error = closedIssues);
    }
    int totalClosedIssueCount = closedIssues is github:SearchResult? closedIssues.issueCount :0;

    string issueSummary = string `ISSUE SUMMARY REPORT${"\n\n"}Repository Name: ${repositoryName}
        ${"\n"}Total Issues Open: ${totalOpenIssueCount} ${"\n"}Total Issues Closed: ${totalClosedIssueCount}
        ${"\n\n"}Issue Count by Assignee: ${"\n"}${assigneeSummary} ${"\n"}`;
    email:Client emailClient = check new ();
    string sendEmailResponse = check emailClient->sendEmail(recipientAddress, "Git Issue Summary", issueSummary);
    log:printInfo("Email sent successfully \n " + sendEmailResponse);
}
