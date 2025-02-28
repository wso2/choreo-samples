## GitHub Events to Email Webhook Integration

Webhook to send GitHub events to an email address.

## Deploying in Choreo
1. Create Webhook Component
    - Login to [Choreo](https://console.choreo.dev/)
    - Navigate to create a `Webhook` component
    - Provide a name and description for the component
    - Provide `https://github.com/wso2/choreo-samples` as the `Public Repository URL`
    - Select the `Branch` as `main`
    - Select `Ballerina` as `Buildpack`
    - Select `github-event-to-email-webhook` as the `Ballerina Project Directory`
    - Click on "Create" to create the component
2. Build and deploy the component
    - The component will be automatically built upon creation.
    - Configure the following environment variables:
        - `gitWebhookSecret` - Add a secret value to be used for the GitHub webhook
        - `toEmail` - Email address to send the GitHub events to
        Make sure the copy the `Invoke URL` of the component given in the `Configuration` panel.
    - Deploy the component

## Configuring the GitHub Webhook
1. Go to the GitHub repository and navigate to `Settings > Webhooks > Add webhook`
2. Add the `Invoke URL` of the component as the `Payload URL`
3. Add the secret value configured in the component as the `Secret`

## Testing the Component
1. Create a new issue in the GitHub repository
2. Add a label to the issue
3. Check the email address to see the email sent by the component
