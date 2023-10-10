import ballerina/http;
import ballerina/log;
import ballerina/regex;
import ballerina/time;
import ballerinax/mailchimp;
import ballerinax/shopify.admin;

// Shopify configuration parameters
configurable string shopifyServiceUrl = ?;
configurable admin:ApiKeysConfig shopifyAuthConfig = ?;

// Mailchimp configuration parameters
configurable string mailchimpServiceUrl = ?;
configurable http:CredentialsConfig mailchimpAuthConfig = ?;
configurable string audienceName = ?;

admin:Client shopifyClient = check new (shopifyAuthConfig, serviceUrl = shopifyServiceUrl);

mailchimp:Client mailchimpClient = check new ({ auth: mailchimpAuthConfig }, mailchimpServiceUrl);

public function main() returns error? {
    string dateOriginTime = string:concat(regex:split(time:utcToString(time:utcNow()),"T")[0],"T00:00:00.000000Z");
    string currentTime = time:utcToString(time:utcNow());

    admin:CustomerList customerList = 
        check shopifyClient->getCustomers(createdAtMin = dateOriginTime, createdAtMax = currentTime);

    admin:Customer[]? customers = customerList?.customers;
    if customers is admin:Customer[] {
        string? audienceId = ();
        mailchimp:SubscriberLists audiences = check mailchimpClient->getLists();
        foreach mailchimp:SubscriberList3 audience in audiences.lists {
            if audience.name == audienceName {
                audienceId = audience.id;
            }
        }
        if audienceId is string {
            foreach admin:Customer customer in customers {
                mailchimp:AddListMembers1 contact = {
                    email_address: customer?.email ?: "",
                    status: "subscribed",
                    merge_fields: {
                        "FNAME": customer?.first_name,
                        "LNAME": customer?.last_name
                    }
                };
                mailchimp:ListMembers2 contactList = check mailchimpClient->postListsIdMembers(audienceId, contact);
                log:printInfo("New Mailchimp subscriber added successfully!");
                log:printInfo("MD5 hash of the new subscribers email address : " + contactList.id.toString());
            }
        } 
    } 
}
