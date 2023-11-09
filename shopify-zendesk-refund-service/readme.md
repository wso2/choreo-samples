# Shopify - Zendesk Refund Service
Streamlining Customer Support: Integrating Shopify with Zendesk

## Prerequisites
Shopify Partner Account
Zendesk Account
Ballerina (Version 2201.7.1 or higher is preferred)
Choreo Account


## Deploying in Choreo
### Create Service Component:
- Fork this repository.
- Login to Choreo: https://console.choreo.dev/.
- Navigate to create a Service component.
- Provide a name and description for the component.
- Authorize and select the GitHub details.
- Select the GitHub Account and the forked repository for GitHub Repository.
- Select the Branch as main.
- Select Ballerina as Buildpack.
- Select shopify-zendesk-refund-service as the Ballerina Project Directory.
- Click on "Create" to create the component.

### Build and deploy the component:

- Configure the following environment variables:
    - shopifyAccessToken - Replace with your Shopify API access token.
    - shopifyStoreName - Replace with your Shopify store name.
    - zendeskUsername - Replace with your Zendesk username (email).
    - zendeskPassword - Replace with your Zendesk password.
    - zendeskSubDomain - Replace with your Zendesk subdomain.
- Deploy the component.

## Testing the Component

### Send a refund request:

Use the following curl command to send a refund request:
```Bash
curl -X POST \
  -H 'Content-Type: application/json' \
  -d '{"userEmail": "customer@example.com", "orderId": "123456", "reason": "The product is not as described."}' \
  http://<service-endpoint>/refund
```
Replace `<service-endpoint>` with the endpoint URL of your deployed Choreo service.
Verify the refund:

- Check the Shopify order status to verify that the refund has been processed.
- Check the Zendesk ticket to verify that a ticket has been created for the refund request.

## Additional Notes

The service exposes an HTTP endpoint /refund that accepts a POST request with the following body parameters:
- userEmail: The email address of the customer requesting the refund.
- orderId: The ID of the Shopify order to be refunded.
- reason: The reason for the refund request.