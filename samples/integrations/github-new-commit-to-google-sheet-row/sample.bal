import ballerina/http;
import ballerina/log;
import ballerina/websub;
import ballerinax/googleapis.sheets as sheets;
import ballerinax/github.webhook as webhook;

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
    argRef: "spreadsheetId",
    provider: "Google Sheets",
    operationName: "getSheetList",
    label: "Worksheet Name"
}
configurable string & readonly worksheetName = ?;

// Spreadsheet header constants
const string COMMIT_AUTHOR_NAME = "Commit Author Name";
const string COMMIT_AUTHOR_EMAIL = "Commit Author Email";
const string COMMIT_MESSAGE = "Commit Message";
const string COMMIT_URL = "Commit URL";
const string REPOSITORY_NAME = "Repository Name";
const string REPOSITORY_URL = "Repository URL";
const int HEADINGS_ROW = 1;

listener webhook:Listener githubListener = new (8090);

@websub:SubscriberServiceConfig {
    target: [webhook:HUB, gitHubRepoUrl + "/events/*.json"],
    callback: gitHubCallbackUrl + "/subscriber",
    httpConfig: {auth: gitHubTokenConfig}
}
service /subscriber on githubListener {
    remote function onPush(webhook:PushEvent event) returns error? {
        string[] headerValues = [COMMIT_AUTHOR_NAME, COMMIT_AUTHOR_EMAIL, COMMIT_MESSAGE, COMMIT_URL, REPOSITORY_NAME, 
        REPOSITORY_URL];

        sheets:Client spreadsheetClient = check new ({oauthClientConfig: sheetOauthConfig});

        sheets:Row headers = check spreadsheetClient->getRow(spreadsheetId, worksheetName, HEADINGS_ROW);
        if (headers.values.length() == 0) {
            check spreadsheetClient->appendRowToSheet(spreadsheetId, worksheetName, headerValues);
        }

        foreach var item in event.commits {
            (int|string|decimal)[] values = [item.author.name, item.author.email, item.message, item.url, event.
            repository.name, event.repository.url];
            check spreadsheetClient->appendRowToSheet(spreadsheetId, worksheetName, values);
        }
        log:printInfo("Github new commits appended successfully!");
    }
}
