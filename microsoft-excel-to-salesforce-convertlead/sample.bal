import ballerina/log;
import ballerinax/microsoft.excel;
import ballerinax/salesforce.soap;

const STATUS_CONVERTED = "Converted";
const EMPTY_STRING = "";

configurable string excelClientId = ?;
configurable string excelClientSecret = ?;
configurable string excelRefreshToken = ?;
configurable string excelRefreshURL = ?;
configurable string workbookIdOrPath = ?;
configurable string worksheetName = ?;
configurable string tableName = ?;

configurable string salesforceBaseURL = ?;
configurable string salesforceClientId = ?;
configurable string salesforceClientSecret = ?;
configurable string salesforceRefreshToken = ?;
configurable string salesforceRefreshURL = ?;
configurable string convertedStatus = ?;

public function main() returns error? {

    excel:Client excelClient = check new ({
        auth: {
            clientId: excelClientId,
            clientSecret: excelClientSecret,
            refreshToken: excelRefreshToken,
            refreshUrl: excelRefreshURL
        }
    });

    soap:Client salesforceClient = check new ({
        baseUrl: salesforceBaseURL,
        auth: {
            clientId: salesforceClientId,
            clientSecret: salesforceClientSecret,
            refreshToken: salesforceRefreshToken,
            refreshUrl: salesforceRefreshURL
        }
    });

    excel:Row[] rowsResponse = check excelClient->listRows(workbookIdOrPath, worksheetName, tableName);
    foreach excel:Row row in rowsResponse {
        json[] values = row.values[0];
        string leadId = check values[1];
        string status = check values[2];
        if leadId != EMPTY_STRING && status != STATUS_CONVERTED {
            soap:ConvertedLead convertedResponse = check salesforceClient->convertLead({
                leadId: leadId,
                convertedStatus: convertedStatus
            });
            _ = check excelClient->updateRow(workbookIdOrPath, worksheetName, tableName, row.index,
            [[(), (), STATUS_CONVERTED, convertedResponse.accountId, convertedResponse.contactId, 
            convertedResponse?.opportunityId]]);
        }
    }
    log:printInfo("Leads converted successfully.");
}
