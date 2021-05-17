import ballerina/http;
import ballerina/websub;
import ballerinax/googleapis.sheets as sheets;
import ballerinax/github.webhook as webhook;

// Spreadsheet Header Constants
const string COMMIT_AUTHOR_NAME = "Commit Author Name";
const string COMMIT_AUTHOR_EMAIL = "Commit Author Email";
const string COMMIT_MESSAGE = "Commit Message";
const string COMMIT_URL = "Commit URL";
const string REPOSITORY_NAME = "Repository Name";
const string REPOSITORY_URL = "Repository URL";

// Github configuration parameters
@display { kind: "OAuthConfig", provider: "GitHub", label: "Set up GitHub connection" }
configurable http:BearerTokenConfig & readonly gitHubTokenConfig = ?;
@display { kind: "ConnectionField", connectionRef: "gitHubTokenConfig", provider: "GitHub", operationName: "getUserRepositoryList", label: "GitHub Repository URL"}
configurable string & readonly githubRepoURL = ?;
@display { kind: "WebhookURL", label: "Set up callback URL for GitHub webhook"}
configurable string & readonly githubCallback = ?;

// Google sheets configuration parameters
@display { kind: "OAuthConfig", provider: "Google Sheets", label: "Set up Google Sheets connection" }
configurable http:OAuth2RefreshTokenGrantConfig & readonly sheetOauthConfig = ?;
@display { kind: "ConnectionField", connectionRef: "sheetOauthConfig", provider: "Google Sheets", operationName: "getAllSpreadsheets", label: "Spreadsheet Name"}
configurable string & readonly spreadsheetId = ?;
@display { kind: "ConnectionField", connectionRef: "sheetOauthConfig", argRef: "spreadsheetId", provider: "Google Sheets", operationName: "getSheetList", label: "Worksheet Name"}
configurable string & readonly worksheetName = ?;

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
    remote function onPush(webhook:PushEvent event) returns error? {
        // Set Spreadsheet Headings
        (string)[] headerValues = [COMMIT_AUTHOR_NAME, COMMIT_AUTHOR_EMAIL, COMMIT_MESSAGE, COMMIT_URL, 
            REPOSITORY_NAME, REPOSITORY_URL];
        // Initialize the Google Sheets Client
        sheets:Client spreadsheetClient = check new ({
            oauthClientConfig: sheetOauthConfig
        });

        (int|string|float)[] headers = check spreadsheetClient->getRow(spreadsheetId, worksheetName, 1);
        if (headers == []) {
            var appendResult = check spreadsheetClient->appendRowToSheet(spreadsheetId, 
                worksheetName, headerValues);
        }

        foreach var item in event.commits {
            (int|string|float)[] values = [item.author.name, item.author.email, item.message, item.url, 
                event.repository.name, event.repository.url];
            var commitAppendResult = check spreadsheetClient->appendRowToSheet(spreadsheetId, 
                worksheetName, values);
        }                 
    }
}
