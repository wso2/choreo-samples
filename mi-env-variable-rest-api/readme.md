# MI REST API with Environment Variables

Simple REST API that returns calls Petstore endpoint and gives the response. The Petstore endpoint is configurable via an environment variable. 

## Deploying on Choreo
1. Creating component
    - Fork this repository
    - Login to [Choreo console](https://console.choreo.dev/)
    - Navigate to create a `Service` component.
    - Provide a name and description for the component.
    - Authorize and select the GitHub details.
    - Select the `GitHub Account` and the forked repository for `GitHub Repository`.
    - Select the `Branch` as `main`.
    - Select `WSO2 MI` as `Buildpack`.
    - Select `mi-env-variable-rest-api` as the `WSO2 MI Project Directory`.
    - Click on "Create" to create the component.
2. Building and deploying the component
    - Once the component is created, add below environment variable to the component.
        - `PET_STORE_ENDPOINT` for `Name` and `https://petstore3.swagger.io/api/v3` for `Value`
    - Build and deploy the component.

## Testing
Once the component is deployed, go to the Choreo Test console and use the Swagger console to try out the API.
