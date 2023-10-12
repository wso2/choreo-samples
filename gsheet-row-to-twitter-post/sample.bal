import ballerina/log;
import ballerina/time;
import ballerinax/googleapis.sheets as sheets;
import ballerinax/twitter;

// Types
type OAuth2RefreshTokenGrantConfig record {
    string clientId;
    string clientSecret;
    string refreshToken;
    string refreshUrl = "https://www.googleapis.com/oauth2/v3/token";
};

type TwitterClientConfig record {
    string apiKey;
    string apiSecret;
    string accessToken;
    string accessTokenSecret;
};

// Twitter configuration parameters
configurable TwitterClientConfig twitterClientConfig = ?;

// Google sheets configuration parameters
configurable OAuth2RefreshTokenGrantConfig GSheetAuthConfig = ?;
configurable int maxNumOfRowsToScan = ?;
configurable string spreadsheetId = ?;
configurable string sheetName = ?;

public function main() returns error? {
    sheets:Client spreadsheetClient = check new ({
        auth: {
            clientId: GSheetAuthConfig.clientId,
            clientSecret: GSheetAuthConfig.clientSecret,
            refreshToken: GSheetAuthConfig.refreshToken,
            refreshUrl: GSheetAuthConfig.refreshUrl
        }
    });

    twitter:Client twitterClient = check new ({
        apiKey: twitterClientConfig.apiKey,
        apiSecret: twitterClientConfig.apiSecret,
        accessToken: twitterClientConfig.accessToken,
        accessTokenSecret: twitterClientConfig.accessTokenSecret
    });

    string todayDate = string:substring(time:utcToString(time:utcNow()), 0, 10);
    int rowCount = 1;
    while (rowCount <= maxNumOfRowsToScan) {
        sheets:Row row = check spreadsheetClient->getRow(spreadsheetId, sheetName, rowCount);
        if row.values.length() != 0 {
            if todayDate == row.values[0].toString() {
                string? dateOfPost = row.values[0].toString();
                string? message = row.values[1].toString();
                if dateOfPost is string && message is string {
                    twitter:Tweet result = check twitterClient->tweet(message);
                    log:printInfo("Twitter post created Successfully. Tweet ID: " + result.id.toString());
                }
            }
        }
        rowCount = rowCount + 1;
    }
}
