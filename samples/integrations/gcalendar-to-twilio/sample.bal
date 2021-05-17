import ballerina/http;
import ballerinax/twilio;
import ballerinax/googleapis.calendar as calendar;
import ballerinax/googleapis.calendar.'listener as CalendarListener;


@display { kind: "OAuthConfig", provider: "Google Calendar",
            label: "Set up Google Calendar connection" }
configurable http:OAuth2RefreshTokenGrantConfig & readonly calendarOauthConfig = ?;

@display { kind: "WebhookURL", label: "Set up Choreo application invocation URL"}
configurable string & readonly CHOREO_APP_INVOCATION_URL = ?;

@display { kind: "ConnectionField", connectionRef: "calendarOauthConfig", provider: "Google Calendar", 
            operationName: "getCalenders", label: "Google Calendar"}
configurable string & readonly calendarId = ?;

@display { label: "Twilio Account SID" }
configurable string & readonly accountSId = ?;

@display { label: "Twilio Auth Token" }
configurable string & readonly authToken = ?;

@display { label: "SMS Sender's Phone Number" }
configurable string & readonly fromMobile = ?;

@display { label: "SMS Recipient's Phone Number" }
configurable string & readonly toMobile = ?;

calendar:CalendarConfiguration calendarConfiguration = {
    oauth2Config: calendarOauthConfig
};

listener CalendarListener:Listener calendarListener = new (8090, calendarConfiguration, calendarId, CHOREO_APP_INVOCATION_URL);

service /calendar on calendarListener {
    remote function onNewEvent(calendar:Event event) returns error? {
        string? summary = event?.summary;
        string startTime = event?.end.toString();
        string endTime = event?.'start.toString();
        string message = "New event is created : starts  on " + startTime + " ends on " + endTime;
        if(summary is string) {
            message = "New event is created : " + summary + "  starts on " + startTime + " ends on " + endTime;
        }
        twilio:Client twilioClient = new ({
            accountSId: accountSId,
            authToken: authToken
        });
        var result = check twilioClient->sendSms(fromMobile, toMobile, message);
    }
}
