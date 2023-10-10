import ballerina/http;
import ballerina/log;
import ballerinax/trigger.google.sheets;
import ballerinax/zoho.people;

type ZohoPeopleOAuthConfig record {|
    string clientId;
    string clientSecret;
    string refreshToken;
    string refreshUrl = "https://accounts.zoho.com/oauth/v2/token";
|};

configurable string spreadsheetId = ?;
configurable string worksheetName = ?;

configurable ZohoPeopleOAuthConfig zohoPeopleOAuthConfig = ?;

listener http:Listener httpListener = new (8090);
listener sheets:Listener gSheetListener = new ({spreadsheetId}, httpListener);

service sheets:SheetRowService on gSheetListener {
    remote function onAppendRow(sheets:GSheetEvent payload) returns error? {
        if worksheetName == payload?.worksheetName {
            (int|string|float)[][]? newValues = payload?.newValues;
            // This is to check whether the new row contains correct number of values to create attendance.
            if newValues is () || newValues.length() == 0 || newValues[0].length() < 2 {
                return ();
            }
            people:Client peopleEndpoint = check new ({
                auth: {
                    ...zohoPeopleOAuthConfig
                }
            });

            string dateFormat = "dd/MM/yyyy HH:mm:ss";
            string empId = newValues[0][0].toString();
            string checkIn = newValues[0][1].toString();
            string checkOut = "";
            if newValues[0].length() > 2 {
                checkOut = newValues[0][2].toString();
            }

            people:AttendanceEntry[]|error createAttendanceResponse = peopleEndpoint->createAttendance(dateFormat,
                                                                                    checkIn = checkIn,
                                                                                    checkOut = checkOut,
                                                                                    empId = empId);
            if createAttendanceResponse is error {
                log:printError("Error occured while create attendance for check-in", createAttendanceResponse);
            } else {
                string message = string `Successfully created the attendence for Employee ID ${empId} in Zoho People.`;
                log:printInfo(message);
            }
        }
    }
    remote function onUpdateRow(sheets:GSheetEvent payload) returns error? {
        //Not Implemented
    }
}

service /ignore on httpListener {
}
