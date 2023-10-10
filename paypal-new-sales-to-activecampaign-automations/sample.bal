import ballerina/http;
import ballerina/log;
import ballerinax/activecampaign;
import ballerinax/paypal.orders as paypal;

// Paypal configuration parameters
configurable string paypalOrderId = ?;
configurable string paymentSourceToken = ?;
configurable string paypalServiceUrl = ?;
configurable http:BearerTokenConfig paypalOauthConfig = ?;

// ActiveCampaign configuration parameters
configurable string activeCampaignApiToken = ?;
configurable string activeCampaignServiceurl = ?;
configurable string activeCampaignAutomationId = ?;

public function main() returns error? {
    paypal:Client paypalClient = check new ({auth: paypalOauthConfig}, paypalServiceUrl);
    activecampaign:Client activeCampaignClient = check new activecampaign:Client({apiToken: activeCampaignApiToken}, activeCampaignServiceurl);
    paypal:CaptureOrderRequest payload = {
        token: {
            id: paymentSourceToken,
            'type: "BILLING_AGREEMENT"
        }
    };
    paypal:CapturedPaymentDetails payment = check paypalClient->captureOrder(paypalOrderId, payload);

    string payementStatus = payment?.status is () ? "" : check payment?.status.ensureType();
    if payementStatus == "COMPLETED" {
        activecampaign:ContactListResponse contactList = check activeCampaignClient->getContacts(paypalOrderId);
        activecampaign:ContactRead[] contacts = contactList.contacts ?: [];

        foreach activecampaign:ContactRead contact in contacts {
            if contact.email == payment?.payer?.email_address {
                activecampaign:AddContactAutomationRequest contactAutomation = {
                    contactAutomation: {
                        contact: check contact.id.ensureType(),
                        automation: activeCampaignAutomationId
                    }
                };
                activecampaign:ContactAutomationResponse|error creationStatus = activeCampaignClient->addContactToAutomation(contactAutomation);
                if creationStatus is error {
                    log:printError("Failed to add customer to automation", creationStatus);
                    return;
                }
                log:printInfo(string `Customer added to active campaign automation successfully!`, contactAutomationId = creationStatus.contactAutomation?.id);
            }
        }
    } else {
        log:printError(string `Paypal payment is not completed. Payment status: ${payementStatus}`);
    }
}
