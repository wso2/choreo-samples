# Prism Mock Service sample

## Use case

When you have an open API specification and you want to test your API without connecting to the actual service, you can use Prism Mock services component. This sample demonstrates how to create a mock service using existing Open API specification.

## Run the sample in Choreo

### Prerequisites

- A valid Choreo account with available resource quota.

### Create a Prism Mock Service component

1. Go to [https://console.choreo.dev/](https://console.choreo.dev) and sign in. This opens the project home page.
2. Click **Create** button in the Component Listing section. Choose **Service** component type, then choose **Prism Mock** buildpack.
3. Enter a unique name and a description for the Prism Mock Service component. For this guide, let's enter the following values:

| Field       | Value                                            |
| ----------- | ------------------------------------------------ |
| Name        | Pet Store Mock Service                           |
| Description | Mock Service for Pet Store API                   |
| Repository  | https://github.com/choreo-samples                |
| Branch      | main                                             |
| Project Path| /prism-mock-service                           |

4. Click **Create**. Once the component creation is complete, you will see the component overview page.

### Build the Prism Mock Service component

1. Navigate to the **Build** page of the component.
2. Click **Build Latest** button. This will build the component with the latest commit from the repository.
3. Once the build is complete, the build status will be displayed in the `Builds` table.

### Configure and Deploy the Prism Mock Service component

1. Navigate to the **Deploy** page of the component.
2. Click **Configure and Deploy** button. Click **Deploy**.

## Test the Prism Mock Service component

1. Navigate to the **Test --> OpenAPI Console** page of the component.
2. Use the swagger UI to test the mock service.

> **Note:**
> You can consume the prism mock service as a regular Choreo service from the internal marketplace or from the Developer Portal.
