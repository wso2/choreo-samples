# Proxy from Github sample

## Use case

## Run the sample in Choreo

### Prerequisites

- A valid Choreo account with available resource quota.
- Github repository with a valid Open API definition.
- 

### Create a Github proxy comopnent

1. Go to [https://console.choreo.dev/](https://console.choreo.dev) and sign in. This opens the project home page.
2. Click **Create** button in the Component Listing section. Choose **Proxy** component type.
3. Select **Github** tab (selected by default).
4. Enter a unique name and a description for the proxy component. Use following sample values for this sample component.

| Field       | Value                                            |
| ----------- | ------------------------------------------------ |
| Name        | Pet service                                      |
| Description | Pet service proxy component                      |
| Repository  | https://github.com/choreo-samples                |
| Branch      | main                                             |
| Project Path| /pet-service                                     |

4. Click **Create**. Once the component creation is complete, you will see the component overview page.

### Update the API resources

### Configure and Deploy the proxy component

1. Navigate to the **Deploy** page of the component.
2. Click **Configure and Deploy** button. Click **Deploy**.

## Test the proxy component

1. Navigate to the **Test --> OpenAPI Console** page of the component.
2. Use the swagger UI to test the proxy.
