import ballerina/http;
import ballerina/regex;
import ballerina/xmldata;
import ballerinax/googleapis.sheets;

// Constants
const NAMESPACE_KEY = "@xmlns:sf";
const NOTIFICATION_ID = "Message ID";
const EMPTY_STRING = "";
const SF_NAMESPACE_REGEX = "sf:";
const HEADER_ROW = 1;

type OAuth2RefreshTokenGrantConfig record {
    string clientId;
    string clientSecret;
    string refreshToken;
    string refreshUrl = "https://www.googleapis.com/oauth2/v3/token";
};

// Google sheet configuration parameters
configurable OAuth2RefreshTokenGrantConfig sheetOAuthConfig = ?;
configurable string spreadsheetId = ?;
configurable string worksheetName = ?;

service / on new http:Listener(8090) {
    resource function post subscriber(http:Caller caller, http:Request request) returns error? {
        xml payload = check request.getXmlPayload();
        xmlns "http://soap.sforce.com/2005/09/outbound" as notification;
        json notificationIdObject = check xmldata:toJson(payload/**/<notification:Id>);
        json contactInfoObject = check xmldata:toJson(payload/**/<notification:sObject>/<*>);
        string[] infoArray = [];
        string[] headerArray = [];
        string idString = let var id = notificationIdObject.Id.Id
            in id is json ? id.toString() : EMPTY_STRING;
        infoArray.push(idString);
        headerArray.push(NOTIFICATION_ID);
        json[] contactInfoArray = <json[]>contactInfoObject;
        foreach json item in contactInfoArray {
            map<json> itemMap = <map<json>>item;
            _ = itemMap.removeIfHasKey(NAMESPACE_KEY);
            foreach [string, json] [key, value] in itemMap.entries() {
                infoArray.push(value.toString());
                string replacedString = regex:replaceFirst(key, SF_NAMESPACE_REGEX, EMPTY_STRING);
                headerArray.push(replacedString);
            }
        }

        sheets:Client spreadsheetClient = check new ({auth: {
            clientId: sheetOAuthConfig.clientId,
            clientSecret: sheetOAuthConfig.clientSecret,
            refreshToken: sheetOAuthConfig.refreshToken,
            refreshUrl: sheetOAuthConfig.refreshUrl
        }});
        sheets:Row headers = check spreadsheetClient->getRow(spreadsheetId, worksheetName, HEADER_ROW);
        if headers.values.length() == 0 {
            check spreadsheetClient->appendRowToSheet(spreadsheetId, worksheetName, headerArray);
        }
        check spreadsheetClient->appendRowToSheet(spreadsheetId, worksheetName, infoArray);
        xml ack = xml `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:out="http://soap.sforce.com/2005/09/outbound">
                            <soapenv:Header/>
                            <soapenv:Body>
                                <out:notificationsResponse>
                                    <out:Ack>true</out:Ack>
                                </out:notificationsResponse>
                            </soapenv:Body>
                        </soapenv:Envelope>`;
        check caller->respond(ack);
    }
}
