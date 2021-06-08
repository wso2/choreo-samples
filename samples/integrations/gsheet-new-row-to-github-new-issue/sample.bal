import ballerina/log;
import ballerina/regex;
import ballerinax/github;
import ballerina/http;
import ballerinax/googleapis.sheets.'listener as sheetsListener;

// Github configuration parameters
@display {
    kind: "OAuthConfig",
    provider: "GitHub",
    label: "Set Up GitHub Connection"
}
configurable http:BearerTokenConfig & readonly gitHubTokenConfig = ?;

// Google sheets configuration parameters
@display {
    kind: "OAuthConfig",
    provider: "Google Sheets",
    label: "Set Up Google Sheets Connection"
}
configurable http:OAuth2RefreshTokenGrantConfig & readonly sheetOAuthConfig = ?;

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

listener sheetsListener:Listener gSheetListener = new ({
    port: 8090,
    spreadsheetId: spreadsheetId
});

service / on gSheetListener {
    remote function onAppendRow(sheetsListener:GSheetEvent event) returns error? {
        if (event?.eventInfo?.worksheetName == worksheetName) {
            (int|string|float)[][]? newValues = event?.eventInfo["newValues"];

            if !(newValues is ()) {
                github:Client githubClient = check new ({accessToken: gitHubTokenConfig.token});

                string repositoryOwner = newValues[0][0].toString();
                string repositoryName = newValues[0][1].toString();
                string commaSeparatedLabelList = newValues[0][4].toString();
                string[] labelList = regex:split(commaSeparatedLabelList, ",");
                string commaSeparatedAssigneeList = newValues[0][5].toString();
                string[] assigneeList = regex:split(commaSeparatedAssigneeList, ",");

                github:CreateIssueInput createIssueInput = {
                    title: newValues[0][2].toString(),
                    body: newValues[0][3].toString(),
                    labelNames: labelList,
                    assigneeNames: assigneeList
                };
                github:Issue createdIssue = check githubClient->createIssue(createIssueInput, repositoryOwner, 
                repositoryName);
                log:printInfo("Issue Created Successfully!. Issue ID: " + createdIssue.id.toString());
            }
        }
    }
}
