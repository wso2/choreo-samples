import ballerina/http;
import ballerinax/googleapis.sheets;

# Represents standard SCIM data format of a user.
# 
# + addresses - Addresses of the user
# + emails - Email Addresses of the user
# + ims - IM of the user
# + meta - Meta infomation
# + name - User given name and family name
# + password - Password of the User
# + phoneNumbers - User contact numbers
# + profileUrl - URL of the profile
# + schemas - SCIM schemas
# + userName - Username of the user
public type SCIMUser record {
    json[] addresses?;
    string[] emails?;
    string[] ims?;
    json meta;
    json name?;
    string password?;
    json[] phoneNumbers?;
    string profileUrl?;
    string[] schemas;
    string userName;
};

# Represents OAuth2 refresh token grant configurations for OAuth2 authentication.
# 
# + clientId - Client ID of the client authentication
# + clientSecret - Client secret of the client authentication
# + refreshToken - Refresh token for the token endpoint
# + refreshUrl - Refresh URL
type OAuth2RefreshTokenGrantConfig record {
    string clientId;
    string clientSecret;
    string refreshToken;
    string refreshUrl = sheets:REFRESH_URL;
};

// Google sheets configuration parameters.
configurable OAuth2RefreshTokenGrantConfig gSheetAuthConfig = ?;
configurable string spreadsheetId = ?;
configurable string worksheetName = ?;

public sheets:Client sheetsEndpoint = check new ({
    auth: {
        refreshUrl: sheets:REFRESH_URL, 
        refreshToken: gSheetAuthConfig.refreshToken, 
        clientId: gSheetAuthConfig.clientId, 
        clientSecret: gSheetAuthConfig.clientSecret
    }
});

# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {
     # This endpoint will be called when the user is created in the Identity server.
     #
     # + payload - This parameter contains user details.
     # + return - Return a string with success message or error.
     resource function post .(@http:Payload SCIMUser payload) returns string|error {
        // Fetch user information.
        string userName = payload.userName;
        string password = payload.password ?: "";
        string[] email = payload.emails ?: [""];
        json[] phoneNumbers = payload.phoneNumbers ?: [{"value":""}];
        string number = check phoneNumbers[0].value;

        // Get all the sheets available in the particular book.
        sheets:Sheet[] getSheetsResponse = check sheetsEndpoint->getSheets(spreadsheetId);

        // Check whether the sheet already exists or not.
        // If the sheet name does not exist, push titles and values to the sheet.
        if !getSheetsResponse.toString().includes(worksheetName) {
            _ = check sheetsEndpoint->addSheet(spreadsheetId, worksheetName);
            check sheetsEndpoint->appendRowToSheet(spreadsheetId, worksheetName, ["UserName", "Password", "Email", "PhoneNumber"]);
            check sheetsEndpoint->appendRowToSheet(spreadsheetId, worksheetName, [userName, password, email[0], number]);
        }
        // If the sheet exists, push the values.
        else {
            check sheetsEndpoint->appendRowToSheet(spreadsheetId, worksheetName, [userName, password, email[0], number]);
        }
        return "User has been successfully Created!..";
    }

    # This endpoint will be called when the user is updated in the Identity server.
    #
    # + payload - This parameter contains user details.
    # + return - Return a string with success message or error.
    resource function put .(@http:Payload SCIMUser payload) returns string|error {
        // Fetch user information in the PUT request.
        string userName = payload.userName;
        string password = payload.password ?: "";
        string[] email = payload.emails ?: [""];
        json[] phoneNumbers = payload.phoneNumbers ?: [{"value":""}];
        string number = check phoneNumbers[0].value;

        // Get values of the Username column and finding the row number.
        sheets:Column getColumnResponse = check sheetsEndpoint->getColumn(spreadsheetId, worksheetName, "A");
        (int|string|decimal)[] values = getColumnResponse.values;
        int row = check values.indexOf(userName, 0).ensureType(int);
        //Update the selected row.
        check sheetsEndpoint->createOrUpdateRow(spreadsheetId, worksheetName, row + 1, [userName, password, email[0], number]);

        return "User has been successfully updated!..";
    }

    # This endpoint will be called when the user is deleted in the Identity server.
    #
    # + userName - This parameter contains user details.
    # + return - Return a string with success message or error.
    resource function delete [string userName]() returns string|error {
        // Get values of the Username column and finding the row number.
        sheets:Column getColumnResponse = check sheetsEndpoint->getColumn(spreadsheetId, worksheetName, "A");
        (int|string|decimal)[] values = getColumnResponse.values;
        int row = check values.indexOf(userName, 0).ensureType(int);
        // Delete the selected row.
        check sheetsEndpoint->deleteRowsBySheetName(spreadsheetId, worksheetName, row + 1, 1);
        return "User has been successfully deleted!..";
    }
}
