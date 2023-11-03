# Shopify Slack Order Notification Service

Integrating Shopify with Slack and email notifications to streamline order processes and enhance the overall customer experience.

## Prerequisites

1. Shopify Partner Account. (You can create one [here](https://www.shopify.com/partners)).
2. [Slack](https://slack.com/) subscription.
3. [Ballerina](https://ballerina.io/) (Version 2201.7.1 is preferred).

## Obtaing Configuration Values
Need to obtain below secret values form your Shopify store and Slack.

1. **Admin API access token from Shopify store app:** Create an app in your Shopify store with `read-order` permission and save the  **Admin API access token**.
2. **API secret key from Shopify store app:** Obtain an **API secret key** from the same app.
3. **Bot OAuth token form Slack app:** Create a Slack app via [Slack API](https://api.slack.com/) with `channels:write`, `channels:read`, `chat:write`, and `chat:write.public` scopes and obtained the **Bot OAuth token**.

A slack channel named **orders** should be created.

## Deploying in Choreo

1. **Fork the Repository:** [choreo-examples repository](https://github.com/wso2/choreo-examples.git).

2. **Create Event-triggered integration Component in Choreo:** 
- Log into Choreo, navigate to **Create a New Component** page in your Choreo Project and select **Event-Triggered Integration**.
- Fill out general details, name and description.
- Authorize the **Github** as the vesrion control vendor.
- Point your forked repository and provide `integrations/ballerina/shopify-slack-order-notfication-service` as the project path.
- Select **Ballerina** as the build preset and **External** as the Access Mode.
- Select **Custom** as the trigger type.
- Select **Push** as the trigger category.

3. **Configure and Deploy**:
Navigate to **Deployment** page of the component and click on **Configure and deploy**.

    Provide config values -
    - **shopifyApiSecretKey** - Provide **API secret key from Shopify store app**.
    - **slackOauthToken** - Provide **Bot OAuth token form Slack app**.
    - **toEmail** - Provide an email address to receive notifications.

Deploy the component.

4. Obtain the **Invoke URL**.

## Creating Shopify Webhooks

To create Shopify webhooks, use the [Shopify Webhook API](https://shopify.dev/docs/api/admin-rest/2023-04/resources/webhook#post-webhooks).

1. Create webhook for `orders/create`.
    
    Use the curl command below to create the webook for order creation.
    ```bash
    % curl -d '{"webhook":{"address":"{invoke_url}","topic":"orders/create","format":"json"}}' \
    -X POST "https://{developer_store_url}/admin/api/2023-04/webhooks.json" \
    -H "X-Shopify-Access-Token: {access_token}" \
    -H "Content-Type: application/json"
    ```
    Make sure to replace,
    -  `{invoke_url}` with **Invoke URL** obtained from Choreo. 
    - `{developer_store_url}` with the your Shopify developer store URL.
    - `{access_token}` with the **Admin API access token** obtained from Shopify store app.



2. Create webhook for `orders/cancelled`.
    
    Use the curl command below to create the webook for orider canellation.
    ```bash
    % curl -d '{"webhook":{"address":"{invoke_url}","topic":"orders/create","format":"json"}}' \
    -X POST "https://{developer_store_url}/admin/api/2023-04/webhooks.json" \
    -H "X-Shopify-Access-Token: {access_token}" \
    -H "Content-Type: application/json"
    ```
    Make sure to replace,
    -  `{invoke_url}` with **Invoke URL** obtained from Choreo. 
    - `{developer_store_url}` with the your Shopify developer store URL.
    - `{access_token}` with the **Admin API access token** obtained from Shopify store app.

## Testing the Integration

Create an order in the Shopify development store and observe the **orders** Slack channel and the email inbox. Similarly order cancellation can be testsed by cancelling an active order.
