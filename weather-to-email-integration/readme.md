# Weather to Email Integration

This integration allows you to send weather updates to an email address.

## Deploying in Choreo

1. Create a `Manual Task` component
    - Fork this repository
    - Login to [Choreo](https://wso2.com/choreo/)
    - Navigate to create a `Manual Task` component
    - Provide a name and description for the component
    - Authorize and select the GitHub details
    - Select the `GitHub Account` and the forked repository for `GitHub Repository`
    - Select the `Branch` as `main`
    - Select `Ballerina` as `Buildpack`
    - Select `weather-to-email-integration` as the `Ballerina Project Directory`
    - Click on "Create" to create the component
2. Build and deploy the component
    - Once the component is created, add the following environment variables:
        - `email` - Email address to send the weather updates to
        - `apiKey` - OpenWeatherMap API key
        - `latitude` - Latitude of the location to get weather updates for
        - `longitude` - Longitude of the location to get weather updates for
    - Deploy the component.

## Testing the Component

Run the component and check the email address to see the email sent by the component.