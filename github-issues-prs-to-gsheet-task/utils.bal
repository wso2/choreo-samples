import ballerinax/github;
import ballerinax/googleapis.sheets;
import ballerina/log;

// Convert stream of Issues to an array of Issues
function convertIssueStreamToArray(stream<github:Issue, github:Error?> streamInput) returns github:Issue[]|error {
    github:Issue[] outputArray = [];
    _ = check streamInput.forEach(function(github:Issue r) {
        outputArray.push(r);
    });
    return outputArray;
}

// Convert stream of PullRequests to an array of PullRequests
function convertPullRequestStreamToArray(stream<github:PullRequest, github:Error?> streamInput) returns github:PullRequest[]|error {
    github:PullRequest[] outputArray = [];
    _ = check streamInput.forEach(function(github:PullRequest r) {
        outputArray.push(r);
    });
    return outputArray;
}

// Process and write data to the Google Sheet
function createRepoSheet(RepoData repoData) {
    do {
        github:Repository repo = repoData.repo;
        github:PullRequest[] prs = repoData.prs;
        github:Issue[] issues = repoData.issues;
        github:Issue[] openIssues = getOpenIssues(issues);
        github:PullRequest[] openPRs = getOpenPRs(prs);

        // prepare data as a 2D array
        string[][] rangeData = [
            ["Repo Name", repoData.name],
            ["Repo URL", repo.url ?: ""],
            ["Fork Count", repo.forkCount.toString()],
            ["Last Updated", repo.updatedAt.toString()],
            [],
            ["Total Issues", issues.length().toString()],
            ["Open Issues", openIssues.length().toString()],
            ["Closed Issues", (issues.length() - openIssues.length()).toString()],
            ["Total PRs", prs.length().toString()],
            ["Open PRs", openPRs.length().toString()],
            ["Closed PRs", (prs.length() - openPRs.length()).toString()],
            [],
            ["Open Issues"]
        ];

        // Iterate through open issues and add them to rangeData
        foreach github:Issue issue in openIssues {
            rangeData.push([issue.title ?: "", issue.url ?: ""]);
        }

        rangeData.push([], ["Open PRs"]);
        // Iterate through open pull requests and add them to rangeData
        foreach github:PullRequest pr in openPRs {
            rangeData.push([pr.title ?: "", pr.url ?: ""]);
        }

        string a1Notation = "A1:B" + (rangeData.length().toString());

        sheets:Range range = {a1Notation: a1Notation, values: rangeData};

        // write to the sheet
        check spreadsheetClient->setRange(GOOGLE_SHEET_ID, GITHUB_REPO_NAME, range);

    } on fail var e {
        log:printError("An error occurred while processing the repo: " + repoData.name, e);
    }

}

// Get open issues
function getOpenIssues(github:Issue[] issues) returns github:Issue[] {
    github:Issue[] openIssues = [];
    foreach github:Issue issue in issues {
        if (issue.state == github:ISSUE_OPEN) {
            openIssues.push(issue);
        }
    }
    return openIssues;
}

// Get open PRs
function getOpenPRs(github:PullRequest[] prs) returns github:PullRequest[] {
    github:PullRequest[] openPRs = [];
    foreach github:PullRequest pr in prs {
        if (pr.state == github:PULL_REQUEST_OPEN) {
            openPRs.push(pr);
        }
    }
    return openPRs;
}
