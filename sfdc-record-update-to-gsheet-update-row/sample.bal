import ballerina/http;
import ballerina/log;
import ballerinax/googleapis.sheets as sheets;
import ballerinax/salesforce as sfdc;
import ballerinax/trigger.salesforce as sfdcListener;

type GsheetCellValueType int|string|decimal;

type GSheetOAuth2Config record {
    string clientId;
    string clientSecret;
    string refreshToken;
    string refreshUrl = "https://www.googleapis.com/oauth2/v3/token";
};

type SalesforceOAuth2Config record {
    string clientId;
    string clientSecret;
    string refreshToken;
    string refreshUrl = "https://login.salesforce.com/services/oauth2/token";
};

// Salesforce listener configuration parameters
type ListenerConfig record {
    string username;
    string password;
};

// Constants
const string CHANNEL_PREFIX = "/data/";
const string EVENT_POSTFIX = "ChangeEvent";
const string BASE_URL = "/services/data/v48.0/sobjects/";
const string SOBJECT_ID = "Id";
const int HEADINGS_ROW = 1;

configurable ListenerConfig salesforceListenerConfig = ?;
configurable SalesforceOAuth2Config salesforceOAuthConfig = ?;
configurable string salesforceBaseUrl = ?;
configurable string salesforceObject = ?;

configurable GSheetOAuth2Config GSheetOAuthConfig = ?;
configurable string spreadsheetId = ?;
configurable string worksheetName = ?;

listener sfdcListener:Listener sfdcEventListener = new ({
    username: salesforceListenerConfig.username,
    password: salesforceListenerConfig.password,
    channelName: CHANNEL_PREFIX + salesforceObject + EVENT_POSTFIX
});

@display { label: "Salesforce Record Update to Google Sheets Row Update" }
service sfdcListener:RecordService on sfdcEventListener {
    remote function onUpdate(sfdcListener:EventData payload) returns error? {
        string sObjectId = payload?.metadata?.recordId ?: "";
        string path = string `${BASE_URL}${salesforceObject}/${sObjectId}`;
        sfdc:Client sfdcClient = check new ({
            baseUrl: salesforceBaseUrl,
            auth: {
                clientId: salesforceOAuthConfig.clientId,
                clientSecret: salesforceOAuthConfig.clientSecret,
                refreshToken: salesforceOAuthConfig.refreshToken,
                refreshUrl: salesforceOAuthConfig.refreshUrl
            }
        });
        // Get relevent sobject information
        map<json> sobjectInfo = <map<json>>check sfdcClient->getRecord(path);

        // Initialize values to obtain updated record information
        string updatedRecordId = "";
        string updatedColumn = "";
        int updatedRow = 0;
        int columnCounter = 0;
        int rowCounter = 1;

        // Populate column names, values for GSheet
        string[] columnNames = [];
        GsheetCellValueType[] values = [];
        foreach [string, json] [key, value] in sobjectInfo.entries() {
            columnNames.push(key);
            values.push(value.toString());

            // Find the column with SObject Ids
            if key == SOBJECT_ID {
                updatedRecordId = value.toString();
                updatedColumn = getColumnLetter(columnCounter);
            }
            columnCounter = columnCounter + 1;
        }

        sheets:Client gSheetClient = check new ({
            auth: {
                clientId: GSheetOAuthConfig.clientId,
                clientSecret: GSheetOAuthConfig.clientSecret,
                refreshToken: GSheetOAuthConfig.refreshToken,
                refreshUrl: GSheetOAuthConfig.refreshUrl
            }
        });        
        sheets:Row headers = check gSheetClient->getRow(spreadsheetId, worksheetName, HEADINGS_ROW);
        if headers.values.length() == 0 {
            check gSheetClient->appendRowToSheet(spreadsheetId, worksheetName, columnNames);
        }

        sheets:Column updatedColumnData = check gSheetClient->getColumn(spreadsheetId, worksheetName,
            updatedColumn);
        foreach (int|string|decimal) item in updatedColumnData.values {
            if item == updatedRecordId {
                updatedRow = rowCounter;
            }
            rowCounter = rowCounter + 1;
        }

        check gSheetClient->createOrUpdateRow(spreadsheetId, worksheetName, updatedRow, values);

        log:printInfo(string `Record with Id  ${updatedRecordId} updated successfully!`);
    }

    remote function onCreate(sfdcListener:EventData payload) returns error? {
        return;
    }

    remote function onDelete(sfdcListener:EventData payload) returns error? {
        return;
    }

    remote function onRestore(sfdcListener:EventData payload) returns error? {
        return;
    }
}

isolated function getColumnLetter(int position) returns string {
    string[] columnNames =
    [ "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W",
        "X","Y","Z"];
    if (position >= columnNames.length()) {
        string a = getColumnLetter((position / columnNames.length()) - 1);
        string b = getColumnLetter(position % columnNames.length());
        return a.concat("", b);
    }
    return columnNames[position];
}

service /ignore on new http:Listener(8090) {
}
