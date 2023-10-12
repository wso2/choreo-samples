import ballerina/http;
import ballerina/log;
import ballerina/regex;
import ballerina/time;
import ballerinax/capsulecrm;
import ballerinax/slack;

// CapsuleCRM configuration parameters
@display {label: "CapsuleCRM Auth Configuration", description: "The authentication configuration of the CapsuleCRM client"}
configurable http:BearerTokenConfig capsulecrmAuthConfig = ?;

// Slack configuration parameters
@display {label: "Slack Auth Configuration", description: "The authentication configuration of the Slack client"}
configurable http:BearerTokenConfig slackAuthConfig = ?;
@display {label: "Slack Channel Name", description: "Name of the Slack channel"}
configurable string channelName = ?;

capsulecrm:Client capsulecrmClient = check new ({auth: capsulecrmAuthConfig});
slack:Client slackClient = check new ({auth: slackAuthConfig});

public function main() returns error? {
    string yesterdayMidnight = regex:split(time:utcToString(time:utcNow()), "T")[0].concat("T00:00:00Z");

    capsulecrm:Opportunities response = check capsulecrmClient->listOpportunities(yesterdayMidnight);
    capsulecrm:Opportunity[] opportunities = response?.opportunities ?: [];

    if opportunities.length() == 0 {
        return error("CapsuleCRM opportunities are empty.");
    }

    string text = "\nDetailed Summary of New Opportunities Lost!\n\n";

    foreach capsulecrm:Opportunity opportunity in opportunities {
        capsulecrm:NestedMilestone? milestone = opportunity.milestone;
        if milestone is () {
            log:printError(string `Milestone is empty in opportunity ${opportunity.name}`);
            continue;
        }
        string? milestoneName = milestone?.name;
        if milestoneName is () {
            log:printError(string `Milestone name is empty in opportunity ${opportunity.name}`);
            continue;
        }
        if milestoneName == "Lost" {
            log:printInfo(string `${opportunity.name} is a lost opportunity`);
            text += "\nNew Lost Opportunity Name : " + (opportunity.name) + "\n";
            foreach var ['key, value] in opportunity.entries() {
                string stringValue = value.toString();
                if stringValue != "" {
                    text += 'key + " : " + stringValue + "\n";
                }
            }
            text += "\n";
        } else {
            log:printInfo(string `${opportunity.name} is not a lost opportunity`);
        }
    }
    string threadId = check slackClient->postMessage({
        channelName,
        text
    });
    log:printInfo(string `Message with threadID ${threadId} posted in Slack channel ${channelName} successfully!`);
}
