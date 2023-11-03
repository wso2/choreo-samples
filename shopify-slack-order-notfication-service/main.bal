import ballerinax/trigger.shopify;
import ballerinax/slack;
import wso2/choreo.sendemail;
import ballerina/log;


configurable string shopifyApiSecretKey = ?;
configurable string slackOauthToken = ?;
configurable string toEmail = ?;

slack:ConnectionConfig slackConfig = {
    auth: {
        token: slackOauthToken
    }
};

slack:Client slackClient = check new(slackConfig);

shopify:ListenerConfig listenerConfig = {
    apiSecretKey: shopifyApiSecretKey
};

sendemail:Client emailClient = check new ();

listener shopify:Listener shopifyListener = new(listenerConfig, 8090);

service shopify:OrdersService on shopifyListener {
    remote function onOrdersCreate(shopify:OrderEvent event) returns error? {

        string orderNumber = event?.name.toString();
        string currency = event?.presentment_currency.toString();
        string totalPrice = event?.total_price.toString();
        string message = "Order No: " + orderNumber + " Total Price: " + currency + totalPrice;
        slack:Message messageParams = {
            channelName: "orders",
            text: "New order! " + message
        };

        string _ = check slackClient->postMessage(messageParams);

        log:printInfo("Message sent: " + messageParams.text);
        string emailResponse = check emailClient->sendEmail(toEmail, subject = "New Order Created: " + orderNumber, body = "Check on the newly created order. " + message);
        log:printInfo("Email sent " + emailResponse);
    }
    remote function onOrdersCancelled(shopify:OrderEvent event) returns error? {

        string orderNumber = event?.name.toString();
        string currency = event?.presentment_currency.toString();
        string totalPrice = event?.total_price.toString();
        string message = "Order No: " + orderNumber + " Total Price: " + currency + totalPrice;
        slack:Message messageParams = {
            channelName: "orders",
            text: "Order Canceled! " + message
        };

        string _ = check slackClient->postMessage(messageParams);

        log:printInfo("Message sent: " + messageParams.text);
        string emailResponse = check emailClient->sendEmail(toEmail, subject = "Order Cancelled: " + orderNumber, body = "Check on the cancelled order. " + message);
        log:printInfo("Email sent " + emailResponse);
    }
    remote function onOrdersFulfilled(shopify:OrderEvent event) returns error? {
        // Write your logic here
    }
    remote function onOrdersPaid(shopify:OrderEvent event) returns error? {
        // Write your logic here
    }
    remote function onOrdersPartiallyFulfilled(shopify:OrderEvent event) returns error? {
        // Write your logic here
    }
    remote function onOrdersUpdated(shopify:OrderEvent event) returns error? {
        // Write your logic here
    }
}
