import ballerina/http;
import ballerina/log;
import ballerinax/googleapis.calendar;
import ballerinax/trigger.google.calendar as calendarListener;
import ballerinax/twilio;

configurable calendarListener:ListenerConfig config = ?;
configurable string accountSId = ?;
configurable string authToken = ?;
configurable string fromMobile = ?;
configurable string toMobile = ?;

listener http:Listener httpListener = new (8090);
listener calendarListener:Listener webhookListener = new (config, httpListener);

@display { label: "Google Calendar Event to Twilio SMS" }
service calendarListener:CalendarService on webhookListener {

    remote function onNewEvent(calendarListener:Event payload) returns error? {
        log:printInfo("Calendar event received successfully!");
        string summary = payload?.summary ?: "";
        calendar:Time? 'start = payload?.'start;
        calendar:Time? end = payload?.end;
        string startTime = 'start?.dateTime ?: ('start?.date ?: "");
        string endTime = end?.dateTime ?: (end?.date ?: "");
        string message = string `New event is created : ${summary} starts on ${startTime} ends on ${endTime}`;

        twilio:Client twilioClient = check new ({
            twilioAuth: {
                accountSId: accountSId,
                authToken: authToken
            }
        });
        _ = check twilioClient->sendSms(fromMobile, toMobile, message);
        log:printInfo("SMS sent successfully!");
    }
    remote function onEventUpdate(calendarListener:Event payload) returns error? {
        //Not Implemented
    }
    remote function onEventDelete(calendarListener:Event payload) returns error? {
        //Not Implemented
    }
}

service /ignore on httpListener {
}
