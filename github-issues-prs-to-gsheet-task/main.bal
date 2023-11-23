import ballerinax/github;
import ballerina/log;
import ballerinax/googleapis.sheets as sheets;

// Define configurable variables for storing sensitive information
configurable string GITHUB_PAT = ?;
configurable string GITHUB_USERNAME = ?;
configurable string GITHUB_REPO_NAME = ?;

configurable string GOOGLE_CLIENT_ID = ?;
configurable string GOOGLE_CLIENT_SECRET = ?;
configurable string REFRESH_TOKEN = ?;
configurable string GOOGLE_SHEET_ID = ?;

// Define the default sheet name
const DEFAULT_SHEET_NAME = "Sheet1";

// Define the GitHub and Google Sheets connection configurations
github:ConnectionConfig githubConfigs = {
    auth: {
        token: GITHUB_PAT
    }
};
sheets:ConnectionConfig spreadsheetConfig = {
    auth: {
        clientId: GOOGLE_CLIENT_ID,
        clientSecret: GOOGLE_CLIENT_SECRET,
        refreshUrl: sheets:REFRESH_URL,
        refreshToken: REFRESH_TOKEN
    }
};

// Create a Google Sheets client object using the connection configuration
sheets:Client spreadsheetClient = check new (spreadsheetConfig);

// Create a GitHub client object using the connection configuration
github:Client githubClient = check new (githubConfigs);

public function main() returns error? {

    log:printInfo("Fetching data from GitHub...");

    // Fetch the specified GitHub repository
    github:Repository repo = check githubClient->getRepository(GITHUB_USERNAME, GITHUB_REPO_NAME);

    // Create a data object to hold the repository information, including pull requests and issues
    RepoData repoData = {name: repo.name, repo: repo, prs: [], issues: []};

    // Fetch all open pull requests and issues for the repository
    do {
        stream<github:PullRequest, github:Error?> prs = check githubClient->getPullRequests(GITHUB_USERNAME, repo.name, github:PULL_REQUEST_OPEN);
        stream<github:Issue, github:Error?> issues = check githubClient->getIssues(GITHUB_USERNAME, repo.name);

        // Convert the pull requests and issues streams to arrays
        repoData.prs = check convertPullRequestStreamToArray(prs);
        repoData.issues = check convertIssueStreamToArray(issues);

    } on fail var e {
        log:printError("An error occurred while fetching data for the repository: " + repo.name + " " + e.message(),e);
    }

    log:printInfo("Data successfully fetched from GitHub.");
    log:printInfo("Writing data to Google Sheet...");

    // Rename the default sheet to the repository name
    do {
        check spreadsheetClient->renameSheet(GOOGLE_SHEET_ID, DEFAULT_SHEET_NAME, GITHUB_REPO_NAME);
    } on fail var e {
        log:printError("An error occurred while renaming the default sheet: " + e.message(),e);
    }

    // Process the repository data and write it to the Google Sheet
    createRepoSheet(repoData);

    log:printInfo("Data successfully written to Google Sheet.");
}
