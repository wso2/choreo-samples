import wso2/choreo.sendemail;
import ballerinax/googleapis.sheets;
import ballerina/http;
import ballerina/log;
import ballerinax/zoom;

type OAuth2RefreshTokenGrantConfig record {
    string clientId;
    string clientSecret;
    string refreshToken;
    string refreshUrl = "https://www.googleapis.com/oauth2/v3/token";
};

configurable http:BearerTokenConfig zoomOAuthConfig = ?;

configurable OAuth2RefreshTokenGrantConfig sheetOAuthConfig = ?;

configurable string spreadsheetId = ?;

configurable string workSheetName = ?;

public function main() returns error? {

    sheets:Client gSheetClient = check new ({
        auth: {
            clientId: sheetOAuthConfig.clientId,
            clientSecret: sheetOAuthConfig.clientSecret,
            refreshToken: sheetOAuthConfig.refreshToken,
            refreshUrl: sheetOAuthConfig.refreshUrl
        }
    });
    sheets:Range gsheetData = check gSheetClient->getRange(spreadsheetId, workSheetName, "$A$1:$YY", valueRenderOption = sheets:FORMULA);
    foreach int i in 1 ..< gsheetData.values.length() {
        (int|string|decimal)[] gsheetRow = gsheetData.values[i];
        string meetingTopic = check gsheetRow[0].ensureType(string);
        zoom:MeetingDetails body = {
            topic: meetingTopic,
            agenda: check gsheetRow[1].ensureType(),
            start_time: check gsheetRow[2].ensureType(),
            duration: check gsheetRow[3].ensureType(),
            timezone: check gsheetRow[4].ensureType()
        };
        zoom:Client zoomClient = check new ({auth: zoomOAuthConfig});
        zoom:CreateMeetingResponse createdMeeting = check zoomClient->createMeeting("me", body);
        zoom:GetMeetingInvitationResponse meetingInvitation = check zoomClient->getMeetingInvitation(createdMeeting.id);

        string invitationString = check meetingInvitation?.invitation.ensureType();

        string streamUrl = check gsheetRow[5].ensureType();
        string streamKey = check gsheetRow[6].ensureType();
        string liveStreamingPageURL = check gsheetRow[7].ensureType();

        if streamUrl != "" && streamKey != "" && liveStreamingPageURL != "" {
            zoom:UpdateMeetingLiveStreamDetailsRequest liveStreamDetailsUpdate = {
                page_url: liveStreamingPageURL,
                stream_key: streamKey,
                stream_url: streamUrl
            };
            _ = check zoomClient->updateMeetingLiveStream(createdMeeting.id, liveStreamDetailsUpdate);
            invitationString += "Streaming Details. \r\n\r\nLive Streaming URL : " + streamUrl + ". " +
                                "\r\nLive Streaming Key : " + streamKey + ". \r\nLive Streaming Page : "
                                + liveStreamingPageURL + "\r\n\r\n";
        }
        string meetingParticipantList = check gsheetRow[8].ensureType();

        sendemail:Client sendemailEndpoint = check new ();
        _ = check sendemailEndpoint->sendEmail(meetingParticipantList, meetingTopic, invitationString);
        log:printInfo("Successfully scheduled the meeting and sent invitations. Meeting Id : " + createdMeeting.id.toString());
    }
}
