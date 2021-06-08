import ballerina/http;
import ballerina/log;
import ballerina/websub;
import ballerinax/github.webhook;
import ballerinax/googleapis.sheets as sheets;

// GitHub configuration parameters
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
configurable string & readonly gitHubRepoUrl = ?;

@display {
    kind: "WebhookURL",
    label: "Set Up Callback URL for GitHub Webhook"
}
configurable string & readonly gitHubCallbackUrl = ?;

// Google sheets configuration parameters
@display {
    kind: "OAuthConfig",
    provider: "Google Sheets",
    label: "Set Up Google Sheets Connection"
}
configurable http:OAuth2RefreshTokenGrantConfig & readonly sheetOauthConfig = ?;

@display {
    kind: "ConnectionField",
    connectionRef: "sheetOauthConfig",
    provider: "Google Sheets",
    operationName: "getAllSpreadsheets",
    label: "Spreadsheet Name"
}
configurable string & readonly spreadsheetId = ?;

@display {
    kind: "ConnectionField",
    connectionRef: "sheetOauthConfig",
    provider: "Google Sheets",
    operationName: "getSheetList",
    label: "Worksheet Name"
}
configurable string & readonly worksheetName = ?;

const ISSUE_LINK = "Issue Link";
const ISSUE_NUMBER = "Issue Number";
const ISSUE_TITLE = "Issue Title";
const ISSUE_USER = "Issue Creator";
const ISSUE_CREATED_AT = "Issue Created At";
const HEADINGS_ROW = 1;

// Initialize the Github listener
listener webhook:Listener githubListener = new (8090);

@websub:SubscriberServiceConfig {
    target: [webhook:HUB, gitHubRepoUrl + "/events/*.json"],
    callback: gitHubCallbackUrl + "/subscriber",
    httpConfig: {auth: gitHubTokenConfig}
}
service /subscriber on githubListener {
    remote function onIssuesOpened(webhook:IssuesEvent event) returns error? {
        string[] headerValues = [ISSUE_LINK, ISSUE_NUMBER, ISSUE_TITLE, ISSUE_USER, ISSUE_CREATED_AT];

        sheets:Client spreadsheetClient = check new ({oauthClientConfig: sheetOauthConfig});

        sheets:Row headers = check spreadsheetClient->getRow(spreadsheetId, worksheetName, HEADINGS_ROW);
        if (headers.values.length() == 0) {
            check spreadsheetClient->appendRowToSheet(spreadsheetId, worksheetName, headerValues);
        }

        (int|string|decimal)[] values = [event.issue.html_url, event.issue.number, event.issue.title, event.issue.user.
        login, event.issue.created_at];
        check spreadsheetClient->appendRowToSheet(spreadsheetId, worksheetName, values);
        log:printInfo("New row appended successfully!");
    }
}
