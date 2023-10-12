import ballerina/log;
import ballerina/time;
import ballerinax/hubspot.crm.contact as hubspotContact;
import ballerinax/shopify.admin as shopify;

type HubSpotErrorDetail record {
    string status?;
    string message;
    string correlationId?;
    string category?;
};

// Shopify configuration parameters
configurable string shopifyServiceUrl = ?;
configurable shopify:ApiKeysConfig shopifyAuthConfig = ?;

// HubSpot configuration parameters
configurable string hubspotAccessToken = ?;

public function main() returns error? {
    shopify:Client shopifyClient = check new (shopifyAuthConfig, serviceUrl = shopifyServiceUrl);

    hubspotContact:Client hubSpotClient = check new hubspotContact:Client({auth: {token: hubspotAccessToken}});

    string dateOriginTime = time:utcToString(time:utcAddSeconds(time:utcNow(), -86400.0));
    string currentTime = time:utcToString(time:utcNow());

    shopify:CustomerList customerList =
        check shopifyClient->getCustomers(createdAtMin = dateOriginTime, createdAtMax = currentTime);

    shopify:Customer[] customers = customerList?.customers ?: [];
    foreach shopify:Customer customer in customers {
        hubspotContact:SimplePublicObjectInput contact = {
            properties: {
                "email": customer?.email ?: "",
                "firstname": customer?.first_name,
                "lastname": customer?.last_name,
                "phone": customer?.phone
            }
        };
        hubspotContact:SimplePublicObject|error creationStatus = hubSpotClient->create(contact);
        if creationStatus is hubspotContact:SimplePublicObject {
            log:printInfo(string `New HubSpot contact added successfully!`, contactId = creationStatus.id);
        } else {
            var detail = creationStatus.detail();
            HubSpotErrorDetail errorDetail = check detail.get("body").ensureType();

            if errorDetail.category == "CONFLICT" {
                string existingContactId = extractConactId(errorDetail.message);
                hubspotContact:SimplePublicObject updateStatus = check hubSpotClient->update(existingContactId, contact);
                log:printInfo(string `HubSpot contact updated successfully!`, contactId = updateStatus.id);
            } else {
                log:printError(string `Failed to add/update contact`, creationStatus);
            }
        }
    }
}

function extractConactId(string errorMessage) returns string {
    int lastIndex = errorMessage.lastIndexOf(" ") ?: 0;
    return errorMessage.substring(lastIndex + 1);
}
