# GitHub Issues and PRs to Google Sheets Integration Task

This task allows you to retrieve the list of issues and pull requests for a GitHub repository and add them to a Google Sheet.

## Prerequisites
- GitHub PAT for the repsitory you want to retrieve issues and PRs from
- Google client credentials for the Google Sheet you want to add the issues and PRs to

## Deploying the Task in Choreo
1. Create a Manual Task Component
    - Fork this repository
    - Login to [Choreo](https://wso2.com/choreo/)
    - Navigate to create a `Manual Task` component
    - Provide a name and description for the component
    - Authorize and select the GitHub details
    - Select the `GitHub Account` and the forked repository for `GitHub Repository`
    - Select the `Branch` as `main`
    - Select `Ballerina` as `Buildpack`
    - Select `github-issues-prs-to-gsheet-task` as the `Ballerina Project Directory`
    - Click on "Create" to create the component
2. Build and deploy the component
    - Once the component is created, add the following environment variables:
        - `GITHUB_PAT` - The GitHub PAT for the repository
        - `GITHUB_USERNAME` - The GitHub username for the repository
        - `GITHUB_REPO_NAME` - The GitHub repository name
        - `GOOGLE_CLIENT_ID` - The Google client ID for the Google Sheet
        - `GOOGLE_CLIENT_SECRET` - The Google client secret for the Google Sheet
        - `GOOGLE_SHEET_ID` - The Google Sheet ID for the Google Sheet
        - `REFRESH_TOKEN` - The refresh token for the Google Sheet
    - Deploy the component

## Running the Task in Choreo
Once the component is deployed, go to the Choreo console and run the task. Check the Google Sheet to see the issues and PRs added.