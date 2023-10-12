import ballerina/http;
import ballerina/log;
import ballerinax/googleapis.calendar;
import ballerinax/trello;
import ballerinax/trigger.google.calendar as calendarListener;

// Google Calendar configuration parameters
configurable calendarListener:ListenerConfig config = ?;

// Trello configuration parameters
configurable string trelloApiKey = ?;
configurable string trelloApiToken = ?;
configurable string trelloListId = ?;

listener http:Listener httpListener = new(8090);
listener calendarListener:Listener calendarListener = new(config, httpListener);

@display { label: "Google Calendar Event to Trello Card" }
service calendarListener:CalendarService on calendarListener {
    remote function onNewEvent(calendarListener:Event payload) returns error? {
        log:printInfo(string `New Google Calendar event ${payload?.summary ?: ""} received`);
        string summary = payload?.summary ?: "";
        calendar:Time? 'start = payload?.'start;
        calendar:Time? end = payload?.end;
        string startTime = 'start?.dateTime ?: "undefined";
        string endTime = end?.dateTime ?: "undefined";
        string message = string `New event is created on Google Calendar: ${summary}. The event starts on ${startTime} and ends on ${endTime}`;

        trello:Client trelloClient = check new trello:Client({
            key: trelloApiKey,
            token: trelloApiToken
        });
        trello:Cards card = {
            name: "New Event Created",
            desc: message,
            due: startTime,
            idList: trelloListId
        };

        http:Response|error cardInfo = trelloClient->addCards(card);
        if cardInfo is error {
            log:printError(cardInfo.message(), cardInfo);
            return;
        } else {
            json|http:ClientError jsonPayload = cardInfo.getJsonPayload();
            if jsonPayload is json {
                map<json> jsonPayloadMap = check jsonPayload.ensureType();
                string cardId = check jsonPayloadMap.get("id").ensureType(string);
                log:printInfo(string `Trello card ${cardId} created successfully!`);
            } else {
                log:printError(jsonPayload.message(), jsonPayload);
                return;
            }
        } 
    }
    
    remote function onEventDelete(calendarListener:Event payload) returns error? {
       //Not Implemented
    }

    remote function onEventUpdate(calendarListener:Event payload) returns error? {
        //Not Implemented
    }
}

service /ignore on httpListener {}
