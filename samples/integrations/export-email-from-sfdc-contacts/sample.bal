import ballerina/log;
import ballerina/time;
import ballerinax/azure_storage_service.blobs as azure_blobs;
import ballerinax/sfdc;

// Salesforce configuration parameters
@display {label: "Salesforce Client ID"}
configurable string & readonly sfdcClientId = ?;

@display {label: "Salesforce Client Secret"}
configurable string & readonly sfdcClientSecret = ?;

@display {label: "Salesforce Refresh Token"}
configurable string & readonly sfdcRefreshToken = ?;

@display {label: "Salesforce Endpoint URL"}
configurable string & readonly sfdcBaseUrl = ?;

@display {label: "Salesforce Account Name"}
configurable string & readonly salesforceAccountName = ?;

@display {label: "Salesforce Account Industry"}
configurable string & readonly accountIndustry = ?;

@display {label: "Salesforce Account Billing City"}
configurable string & readonly billingCity = ?;

// Azure storage configuration parameters
@display {label: "Azure Storage Authorization Method (SAS or accessKey)"}
configurable string & readonly authorizationMethod = ?;

@display {label: "Azure Storage Access Key or SAS"}
configurable string & readonly accessKeyOrSAS = ?;

@display {label: "Azure Storage Account Name"}
configurable string & readonly accountName = ?;

@display {label: "Azure Storage Container Name"}
configurable string & readonly containerName = ?;

// Constants
const string BLOCK_BLOB = "BlockBlob";
const string AUTHORIZATION_ERROR_MSG = "Invalid Authorization method";
const string UPLOAD_SUCCESS_MSG = " uploaded successfully";
const string SFDC_REFRESH_URL = "https://login.salesforce.com/services/oauth2/token";

public function main() returns error? {
    string[] emailList = [];
    string query = string `SELECT Email FROM Contact WHERE AccountId IN (SELECT Id From Account WHERE Name = '${
    salesforceAccountName}' AND Industry = '${accountIndustry}' AND BillingCity = '${billingCity}')`;

    sfdc:Client baseClient = check new ({
        baseUrl: sfdcBaseUrl,
        clientConfig: {
            clientId: sfdcClientId,
            clientSecret: sfdcClientSecret,
            refreshToken: sfdcRefreshToken,
            refreshUrl: SFDC_REFRESH_URL
        }
    });
    sfdc:SoqlResult result = check baseClient->getQueryResult(query);
    foreach json item in result.records {
        json emailAddress = item["Email"];
        if !(emailAddress is ()) {
            emailList.push(emailAddress.toString());
        }
    }

    if (emailList.length() >= 1) {
        time:Utc currentTime = time:utcNow();
        string queryTime = time:utcToString(currentTime);
        string fileName = string `File-${queryTime}.csv`;
        azure_blobs:BlobClient blobClient = check new ({
            accessKeyOrSAS: accessKeyOrSAS,
            accountName: accountName,
            authorizationMethod: check getAuthMethod(authorizationMethod)
        });
        var putBlobResult = check blobClient->putBlob(containerName, fileName, BLOCK_BLOB, 
        emailList.toString().toBytes());
        log:printInfo(fileName + UPLOAD_SUCCESS_MSG);
    }
}

isolated function getAuthMethod(string authorizationMethod) returns (azure_blobs:SAS|azure_blobs:ACCESS_KEY)|error {
    match authorizationMethod {
        "SAS" => {
            return azure_blobs:SAS;
        }
        "accessKey" => {
            return azure_blobs:ACCESS_KEY;
        }
    }
    return error(AUTHORIZATION_ERROR_MSG);
}
