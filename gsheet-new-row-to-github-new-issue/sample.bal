import ballerina/http;
import ballerina/log;
import ballerina/regex;
import ballerinax/github;
import ballerinax/trigger.google.sheets;

// Google sheets configuration parameters
configurable string spreadsheetId = ?;
configurable string worksheetName = ?;

// Github configuration parameters
configurable http:BearerTokenConfig gitHubOAuthConfig = ?;

listener http:Listener httpListener = new(8090);
listener sheets:Listener gSheetListener = new({
    spreadsheetId: spreadsheetId
}, httpListener);

@display { label: "Google Sheets New Row to GitHub New Issue" }
service sheets:SheetRowService on gSheetListener {
    remote function onAppendRow(sheets:GSheetEvent payload) returns error? {
        if (payload?.worksheetName == worksheetName) {
            (int|string|float)[][]? newValues = payload?.newValues;
            if newValues is () || newValues.length() == 0 || newValues[0].length() < 5 {
                return ();
            }
            (int|string|float)[][] newValuesArray = <(int|string|float)[][]>newValues;

            github:Client githubClient = check new ({
                auth: {
                    token: gitHubOAuthConfig.token
                }
            });

            string repositoryOwner = newValuesArray[0][0].toString();
            string repositoryName = newValuesArray[0][1].toString();
            string title = newValuesArray[0][2].toString();
            string body = newValuesArray[0][3].toString();
            string commaSeparatedLabelList = newValuesArray[0][4].toString();
            string commaSeparatedAssigneeList = newValuesArray[0][5].toString();
            string[] labelNames = regex:split(commaSeparatedLabelList, ",");
            string[] assigneeNames = regex:split(commaSeparatedAssigneeList, ",");

            github:CreateIssueInput createIssueInput = {
                title,
                body,
                labelNames,
                assigneeNames
            };

            github:Issue createdIssue = check githubClient->createIssue(createIssueInput, repositoryOwner,
                repositoryName);
            log:printInfo("Issue Created Successfully!. Issue ID: " + createdIssue.id.toString());
        }
    }

    remote function onUpdateRow(sheets:GSheetEvent payload) returns error? {
        return;
    }
}

service /ignore on httpListener {}
