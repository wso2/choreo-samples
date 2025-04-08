# Petstore API Proxy from GitHub Repository

## Use case

This sample demonstrates how to create a proxy for a Petstore API using a GitHub repository. The API proxy component will forward requests to the actual Petstore API, allowing you to manage and monitor the API traffic.

The Petstore API provides endpoints to manage pet information, store inventory, and user data. By creating a proxy for this API, you can add additional layers of security, rate limiting, and analytics.

The following steps will guide you through the process of creating and deploying the Petstore API proxy component in Choreo:

1. **Create the API Proxy**: Create the API proxy using the provided sample values.
2. **Configure and Deploy the API Proxy**: Configure the necessary settings and deploy the API proxy to make it available for use.
4. **Test the API Proxy**: Use the OpenAPI Console in Choreo to test the API proxy and ensure it is functioning correctly.

## Run the sample in Choreo

### Prerequisites

- A valid Choreo account with available resource quota.

### Create the API Proxy

1. Go to [https://console.choreo.dev/](https://console.choreo.dev) and sign in. This opens the project home page.
2. Click **Create** button in the Component Listing section. Choose **API Proxy** component type.
3. Select **Use Public GitHub Repository** option.
4. Enter a unique name and a description for the proxy component. Use following sample values for this sample component.

| Field                  | Value                                                |
|------------------------|------------------------------------------------------|
| Public Repository URL  | https://github.com/wso2/choreo-samples               |
| Branch                 | main                                                 |
| Component Directory    | petstore-api-proxy-from-github                       |
| Context                | /petstore-api-proxy                                  |
| Version                | v1.0                                                 |
| Target                 | https://petstore3.swagger.io/api/v3                  |
| Component Display Name | Petstore API Proxy                                   |
| Component Name         | petstore-api-proxy                                   |
| Description            | A proxy service for managing pet store data          |

5. Click **Create**. After creating the component, you will be directed to the build page where you can monitor the initial build progress. Please wait for the build to finish.

### Configure and Deploy the API Proxy

1. Navigate to the **Deploy** page of the API proxy.
2. Click **Configure and Deploy** button.
3. Select **External** as API Access Mode.
4. Click **Deploy**.

## Test the API Proxy

1. Navigate to the **Test -> OpenAPI Console** page of the API proxy.
2. Use the in-built OpenAPI Console to test the API proxy.
