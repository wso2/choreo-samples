import ballerina/http;
import ballerina/log;
import ballerina/websub;
import ballerinax/github.webhook;
import ballerinax/googleapis.sheets as sheets;

@display { kind: "OAuthConfig", provider: "GitHub", label: "Set up GitHub connection" }
configurable http:BearerTokenConfig & readonly gitHubTokenConfig = ?;

@display { kind: "WebhookURL", label: "Set up callback URL for GitHub webhook"}
configurable string & readonly gitHubCallbackUrl = ?;

@display { kind: "ConnectionField", connectionRef: "gitHubTokenConfig", provider: "GitHub", operationName: "getUserRepositoryList", label: "GitHub Repository URL"}
configurable string & readonly githubRepoURL = ?;

@display { kind: "OAuthConfig", provider: "Google Sheets", label: "Set up Google Sheets connection" }
configurable http:OAuth2RefreshTokenGrantConfig & readonly sheetOauthConfig = ?;

@display { kind: "ConnectionField", connectionRef: "sheetOauthConfig", provider: "Google Sheets", operationName: "getAllSpreadsheets", label: "Spreadsheet Name"}
configurable string & readonly sheetId = ?;
@display { kind: "ConnectionField", connectionRef: "sheetOauthConfig", argRef: "sheetId", provider: "Google Sheets", operationName: "getSheetList", label: "Worksheet Name"}
configurable string & readonly workSheetName = ?;

const ISSUE_LINK = "Issue Link";
const ISSUE_NUMBER = "Issue Number";
const ISSUE_TITLE = "Issue Title";
const ISSUE_USER = "Issue Creater";
const ISSUE_CREATED_AT = "Issue Creted At";

listener webhook:Listener githubListener = new (8090);

@websub:SubscriberServiceConfig {
    target: [webhook:HUB, githubRepoURL + "/events/*.json"],
    callback: gitHubCallbackUrl,
    httpConfig: {
        auth: gitHubTokenConfig
    }
}
service /subscriber on githubListener {
    remote function onIssuesOpened(webhook:IssuesEvent event) returns error? {
        sheets:Client spreadsheetClient = check new ({
            oauthClientConfig: sheetOauthConfig
        });
        (string|int)[] values = [event.issue.html_url, event.issue.number, event.issue.title, event.issue.user.login, event.issue.created_at];
        var result = spreadsheetClient->appendRowToSheet(sheetId, workSheetName, values);
        if(result is error) {
            log:printError(result.message());
        } 
    }
}