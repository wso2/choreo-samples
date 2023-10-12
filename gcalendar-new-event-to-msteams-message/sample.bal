import ballerina/http;
import ballerina/log;
import ballerinax/googleapis.calendar;
import ballerinax/microsoft.teams;
import ballerinax/trigger.google.calendar as calendarListener;

type OAuth2RefreshTokenGrantConfig record {
    string clientId;
    string clientSecret;
    string refreshToken;
    string refreshUrl;
};

// Google Calendar configuration parameters
configurable calendarListener:ListenerConfig config = ?;

// Microsoft Teams configuration parameters
configurable OAuth2RefreshTokenGrantConfig MSTeamsOauthConfig = ?;
configurable string teamId = ?;
configurable string teamChannelId = ?;

listener http:Listener httpListener = new(8090);
listener calendarListener:Listener calendarListener = new(config, httpListener);

@display { label: "Google Calendar Event to Microsoft Teams Channel Message" }
service calendarListener:CalendarService on calendarListener {
    remote function onNewEvent(calendarListener:Event payload) returns error? {
        log:printInfo(string `New Google Calendar event ${payload?.summary ?: ""} received`);
        string summary = payload?.summary ?: "";
        calendar:Time? 'start = payload?.'start;
        calendar:Time? end = payload?.end;
        string startTime = 'start?.dateTime ?: "undefined";
        string endTime = end?.dateTime ?: "undefined";
        string message = string `New event is created on Google Calendar: ${summary}. The event starts on ${startTime} and ends on ${endTime}`;

        teams:Client teamsClient = check new ({ 
            auth: {
                clientId: MSTeamsOauthConfig.clientId,
                clientSecret: MSTeamsOauthConfig.clientSecret,
                refreshToken: MSTeamsOauthConfig.refreshToken,
                refreshUrl: MSTeamsOauthConfig.refreshUrl
            }
        });
        teams:Message messageObject = {
            body: {
                content: message
            }
        };
        teams:MessageData|error channelMessage =  teamsClient->sendChannelMessage(teamId, teamChannelId, messageObject);
        if channelMessage is error {
            log:printError(channelMessage.message(),channelMessage);
            return;
        }
        log:printInfo(string `Message ${channelMessage.id ?: ""} posted in Microsoft Teams Successfully`);    
    }
    
    remote function onEventDelete(calendarListener:Event payload) returns error? {
        //Not Implemented
    }

    remote function onEventUpdate(calendarListener:Event payload) returns error? {
        //Not Implemented
    }
}

service /ignore on httpListener {}
