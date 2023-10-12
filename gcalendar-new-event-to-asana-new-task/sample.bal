import ballerina/http;
import ballerina/log;
import ballerinax/asana;
import ballerinax/trigger.google.calendar as calendarListener;

@display {label: "Calendar Listener Config", description: "Calendar Listener Config"}
configurable calendarListener:ListenerConfig config = ?;
configurable string asanaToken = ?;
configurable string workspace = ?;

listener http:Listener httpListener = new (8090);
listener calendarListener:Listener webhookListener = new (config, httpListener);

@display { label: "Google Calendar New Event to Asana Task" }
service calendarListener:CalendarService on webhookListener {

    remote function onNewEvent(calendarListener:Event payload) returns error? {
        asana:Client asanaClient = check new ({
            auth: {token: asanaToken}
        });

        asana:TasksBody task = {
            data: {
                name: payload?.summary ?: "",
                notes: payload?.description ?: "",
                workspace: workspace
            }
        };
        asana:InlineResponse2017 result = check asanaClient->createTask(task);
        log:printInfo("Task created successfully", taskId = result?.data?.gid);
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
