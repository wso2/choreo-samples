import ballerina/http;
import ballerina/log;
import ballerinax/googleapis.calendar;
import ballerinax/googleapis.calendar.'listener as CalendarListener;
import ballerinax/twilio;

@display {
    kind: "OAuthConfig",
    provider: "Google Calendar",
    label: "Set Up Google Calendar Connection"
}
configurable http:OAuth2RefreshTokenGrantConfig & readonly calendarOauthConfig = ?;

@display {
    kind: "WebhookURL",
    label: "Set Up Choreo application invocation URL"
}
configurable string & readonly CHOREO_APP_INVOCATION_URL = ?;
final string callbackUrl = CHOREO_APP_INVOCATION_URL + "/calendar/events";

@display {
    kind: "ConnectionField",
    connectionRef: "calendarOauthConfig",
    provider: "Google Calendar",
    operationName: "getCalenders",
    label: "Google Calendar ID"
}
configurable string & readonly calendarId = ?;

@display {label: "Twilio Account SID"}
configurable string & readonly accountSId = ?;

@display {label: "Twilio Auth Token"}
configurable string & readonly authToken = ?;

@display {label: "SMS Sender's Phone Number"}
configurable string & readonly fromMobile = ?;

@display {label: "SMS Recipient's Phone Number"}
configurable string & readonly toMobile = ?;

calendar:CalendarConfiguration calendarConfiguration = {oauth2Config: calendarOauthConfig};

listener CalendarListener:Listener calendarListener = new (8090, calendarConfiguration, calendarId, callbackUrl);

service /calendar on calendarListener {
    remote function onNewEvent(calendar:Event event) returns error? {
        string summary = event?.summary ?: "";
        calendar:Time? 'start = event?.'start;
        calendar:Time? end = event?.end;
        string startTime = 'start?.dateTime ?: ('start?.date ?: "");
        string endTime = end?.dateTime ?: (end?.date ?: "");
        string message = "New event is created : " + summary + " starts on " + startTime + " ends on " + endTime;

        twilio:Client twilioClient = check new ({
            accountSId: accountSId,
            authToken: authToken
        });
        twilio:SmsResponse response = check twilioClient->sendSms(fromMobile, toMobile, message);
        log:printInfo("SMS sent successfully!");
    }
}
