# Department API Proxy from GitHub Repository

## Use case

This sample demonstrates how to create a proxy for a Department API using a GitHub repository. The API proxy component will forward requests to the actual Department API, allowing you to manage and monitor the API traffic.

The Department API provides endpoints to manage department information. By creating a proxy for this API, you can add additional layers of security, rate limiting, and analytics.

The following steps will guide you through the process of creating and deploying the Department API proxy component in Choreo:

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
| Component Directory    | department-api-proxy-from-github                     |
| Context                | /department-api-proxy                                |
| Version                | v1.0                                                 |
| Target                 | https://samples.choreoapps.dev/company/hr            |
| Component Display Name | Department API Proxy                                 |
| Component Name         | department-api-proxy                                 |
| Description            | A proxy service for managing department data         |

5. Click **Create**. After creating the component, you will be directed to the build page where you can monitor the initial build progress. Please wait for the build to finish.

### Configure and Deploy the API Proxy

1. Navigate to the **Deploy** page of the API proxy.
2. Click **Configure and Deploy** button. 
3. Select **External** as API Access Mode.
4. Click **Deploy**.

## Test the API Proxy

1. Navigate to the **Test -> OpenAPI Console** page of the API proxy.
2. Use the in-built OpenAPI Console to test the API proxy.
