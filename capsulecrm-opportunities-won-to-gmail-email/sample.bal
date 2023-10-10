import ballerina/http;
import ballerina/log;
import ballerina/regex;
import ballerina/time;
import ballerinax/capsulecrm;
import ballerinax/googleapis.gmail;

// Types
type OAuth2RefreshTokenGrantConfig record {
    string clientId;
    string clientSecret;
    string refreshToken;
    string refreshUrl = "https://oauth2.googleapis.com/token";
};

type MapAnydata map<anydata>;

// CapsuleCRM configuration parameters
configurable http:BearerTokenConfig capsulecrmAuthConfig = ?;

// Google gmail configuration parameters
configurable OAuth2RefreshTokenGrantConfig gmailOAuthConfig = ?;
configurable string recipientAddress = ?;
configurable string senderAddress = ?;

capsulecrm:Client capsulecrmClient = check new ({ auth: capsulecrmAuthConfig });

gmail:Client gmailClient = check new ({ 
    auth: {
        clientId: gmailOAuthConfig.clientId,
        clientSecret: gmailOAuthConfig.clientSecret,
        refreshToken: gmailOAuthConfig.refreshToken,
        refreshUrl: gmailOAuthConfig.refreshUrl
    }
});

public function main() returns error? {
    string dateOriginTime = string:concat(regex:split(time:utcToString(time:utcNow()),"T")[0],"T00:00:00Z");

    capsulecrm:Opportunities response = check capsulecrmClient->listOpportunities(dateOriginTime);
    capsulecrm:Opportunity[]? opportunities = response?.opportunities;

    if opportunities is () {
        log:printInfo("CapsuleCRM opportunities not found.");
        return;
    }

    if opportunities.length() == 0 {
        log:printInfo("CapsuleCRM opportunities are empty.");
        return;
    }

    string opportunityDetails = "\nDetailed Summary of New Opportunities Won!\n\n";

    foreach capsulecrm:Opportunity opportunity in opportunities {
        capsulecrm:NestedMilestone? milestone = opportunity.milestone;
        if milestone is () {
            continue;
        }
        string? name = milestone?.name;
        if name is () {
            continue;
        }
        if name == "Won" {
            map<anydata> opportunityInfoMap = check opportunity.cloneWithType(MapAnydata);
            string[] keys = opportunityInfoMap.keys();
            int position = 0;
            opportunityDetails += "\nNew Opportunity Name : " + (opportunity.name) + "\n";
            foreach var item in opportunityInfoMap {
                if (item.toString() != "") {
                    opportunityDetails += keys[position] + " : " + item.toString() + "\n";
                }
                position += 1;
            }
            opportunityDetails += "\n";
        }
    }
    log:printInfo(opportunityDetails);
    gmail:Message sendMessageResponse = check gmailClient->sendMessage({
        recipient: recipientAddress,
        sender: senderAddress,
        subject: "New Opportunities Won!",
        messageBody: opportunityDetails,
        contentType: "text/plain"
    });
    log:printInfo("Mail sent successfully! Message ID: ", messageId = sendMessageResponse?.id.toString());
}
