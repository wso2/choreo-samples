import ballerinax/shopify.admin as shopifyAdmin;
import ballerinax/zendesk.support as zenSupport;
import ballerina/http;
import wso2/choreo.sendemail;
import ballerina/log;

configurable string shopifyAccessToken = ?;
configurable string shopifyStoreName = ?;
configurable string zendeskUsername = ?;
configurable string zendeskPassword = ?;
configurable string zendeskSubDomain = ?;

// shopify client
shopifyAdmin:ApiKeysConfig shopifyConfig = {
    xShopifyAccessToken: shopifyAccessToken
};
shopifyAdmin:Client shopifyClient = check new (shopifyConfig, "https://" + shopifyStoreName + ".myshopify.com");

// zendesk client
zenSupport:ConnectionConfig zendeskConfig = {
    auth: {
        username: zendeskUsername,
        password: zendeskPassword
    }
};
zenSupport:Client zendeskClient = check new (zendeskConfig, serviceUrl = "https://" + zendeskSubDomain + ".zendesk.com");

// email client
sendemail:Client emailClient = check new ();

// helper function to prepare HTTP response
function createResponse(int statusCode, string|json payload) returns http:Response {
    http:Response response = new;
    response.statusCode = statusCode;
    response.setPayload(payload);
    return response;
}

service /refund on new http:Listener(8090) {
    resource function post .(string userEmail, string orderId, http:Request reason) returns string|error|http:Response {

        // validate order
        shopifyAdmin:OrderObject|error orderDetail = shopifyClient->getOrder(orderId);
        if (orderDetail is error) {
            log:printError("Failed to get order details", err = orderDetail.toString());
            return createResponse(http:STATUS_NOT_FOUND, "Failed to get order details");
        } else if (orderDetail["order"]["financial_status"] !== "paid") {
            return createResponse(http:STATUS_BAD_REQUEST, "Order is not paid");
        } else {

            // initiate a refund
            shopifyAdmin:RefundLineItemObject[] refundLineItems = [];
            shopifyAdmin:LineItem[] orderLineItems = orderDetail["order"]["line_items"] ?: [];
            foreach shopifyAdmin:LineItem lineItem in orderLineItems {
                shopifyAdmin:RefundLineItemObject refundLineItem = {
                    line_item_id: lineItem["id"],
                    quantity: lineItem["quantity"]
                };
                refundLineItems.push(refundLineItem);
            }
            shopifyAdmin:CreateRefund createRefund = {
                refund: {
                    note: check reason.getTextPayload(),
                    refund_line_items: refundLineItems
                }
            };
            shopifyAdmin:RefundObject|error refund = shopifyClient->createRefundForOrder(orderId, createRefund);
            if (refund is error) {
                log:printError("Failed to create refund request", err = refund.toString());
                return createResponse(http:STATUS_INTERNAL_SERVER_ERROR, "Failed to create refund request");
            } else {

                // create Zendesk ticket
                zenSupport:TicketResponse|error ticket = zendeskClient->createTicket({
                    ticket: {
                        subject: "Shopify Refund Request",
                        comment: {
                            body: "Refund request for Shopify order:" + orderId + " by user:" + userEmail + ". Reason: "
                            + check reason.getTextPayload() + ". Refund Id: " + refund["refund"]["id"].toString()
                        }
                    }
                });
                if (ticket is error) {
                    log:printError("Failed to create zendesk ticket", err = ticket.toString());
                    return createResponse(http:STATUS_INTERNAL_SERVER_ERROR, "Failed to create zendesk ticket");
                } else {

                    string emailBody = "Your refund request has been received" + "\nOrder ID: " + orderId + "\nTicket ID: " + ticket["ticket"]["id"].toString() +
                    "\nRefund ID: " + refund["refund"]["id"].toString();

                    string _ = check emailClient->sendEmail(userEmail, "Refund Requested", emailBody);

                    // respond with reference IDs
                    json payload = {
                        orderId: orderId,
                        ticketId: ticket["ticket"]["id"],
                        refundId: refund["refund"]["id"]
                    };
                    return createResponse(http:STATUS_OK, payload);
                }
            }
        }
    }
}
