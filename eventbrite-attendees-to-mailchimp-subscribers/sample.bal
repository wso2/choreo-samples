import ballerina/http;
import ballerina/log;
import ballerina/regex;
import ballerina/time;
import ballerinax/eventbrite;
import ballerinax/mailchimp;

// Eventbrite configuration parameters
configurable http:BearerTokenConfig eventbriteAuthConfig = ?;
configurable string eventbriteEventId = ?;

// Mailchimp configuration parameters
configurable string mailchimpServiceUrl = ?;
configurable http:CredentialsConfig mailchimpAuthConfig = ?;
configurable string mailchimpAudienceName = ?;

eventbrite:Client eventbriteClient = check new ({ auth: eventbriteAuthConfig });
mailchimp:Client mailchimpClient = check new ({ auth: mailchimpAuthConfig }, mailchimpServiceUrl);

public function main() returns error? {
    string dateOriginTime = string:concat(regex:split(time:utcToString(time:utcNow()), "T")[0], "T00:00:00Z");

    eventbrite:AttendeesByEvent attendeesByEvent = check eventbriteClient->listAttendeesByEvent(eventbriteEventId, 
        changedSince = dateOriginTime);
    eventbrite:Attendee[]? attendees = attendeesByEvent?.attendees;

    if attendees is () {
        log:printInfo("Eventbrite event attendees not found.");
        return;
    } 

    if attendees.length() == 0 {
        log:printInfo("No recent Eventbrite event attendees found.");
        return;
    } 

    string? audienceId = ();
    mailchimp:SubscriberLists audiences = check mailchimpClient->getLists();
    foreach mailchimp:SubscriberList3 audience in audiences.lists {
        if audience.name == mailchimpAudienceName {
            audienceId = audience.id;
            break;
        }
    }

    if audienceId is () {
        log:printInfo("Input Mailchimp audience name doesn't exist.");
        return;
    }

    foreach eventbrite:Attendee attendee in attendees {
        string? attendeeId = attendee?.id;

        if attendeeId is () {
            continue;
        }

        map<json> attendeeInfo = <map<json>> attendee.toJson();
        if !attendeeInfo.hasKey("profile") {
            log:printInfo("Eventbrite attendee details not found for attendee with ID : " + attendeeId);
            continue;
        }

        map<json> attendeeProfile = <map<json>> attendeeInfo.get("profile");

        mailchimp:AddListMembers1 contact = {
            email_address: check attendeeProfile.get("email").ensureType(),
            status: "subscribed",
            merge_fields: {
                "FNAME": check attendeeProfile.get("first_name").ensureType(),
                "LNAME": check attendeeProfile.get("last_name").ensureType()
            }
        };
        mailchimp:ListMembers2 contactList = check mailchimpClient->postListsIdMembers(audienceId, contact);
        log:printInfo("New Mailchimp subscriber added successfully! MD5 hash of the new subscribers email " +
            "address : " + contactList.id.toString());
    }
}
