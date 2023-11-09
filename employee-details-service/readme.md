# Employee Details Service

## Introduction
This is a simple integration scenario developed using Ballerina. This service allows you to retrieve details for a list of employees. It internally calls the employee details endpoint, aggregates the results, and sends back a response.

## Deploy in Choreo
1. Create a component
     - Fork this repository
     - Login to [Choreo](https://wso2.com/choreo/)
     - Navigate to create a `Service` component
     - Provide a name and description for the component
     - Authorize and select the GitHub details
     - Select the `GitHub Account` and the forked repository for `GitHub Repository`
     - Select the `Branch` as `main`
     - Select `Ballerina` as `Buildpack`
     - Select `employee-details-service` as the `Ballerina Project Directory`
     - Click on "Create" to create the component
2. Build and deploy the component
     - Once the component is created, add the following environment variables:
          - `hrEndpoint` - The endpoint URL of the HR service
     - Deploy the component

## Testing the Choreo Component
Once the component is deployed, go to the Choreo Test console and use the Swagger console to try out the API.

Or 

Once the program is running, you can test it by sending a POST request to the endpoint http://<endpoint_url>/employees. To test, you can use the following cURL command in a separate terminal window:

```bash
curl -X POST \
     -H "Content-Type: application/json" \
     -d '{"employeeIds": [1, 2, 3]}' \
     http://<endpoint_url>/employees
```
Make sure to replace `<endpoint_url>` with the actual endpoint URL of the deployed service.


## Run and Test Locally

To run the program locally, you need to follow these steps:

1. Make sure you are in the project directory that contains this Ballerina program.
2. Open your terminal or command prompt in that project directory.
3. Execute the following command:

```bash
bal run -- -ChrEndpoint=https://samples.choreoapps.dev/company/hr
```


> NOTE: In this case, we are providing a value to the configurable variable `hrEndpoint`. The endpoint URL for the HR service is specified as `https://samples.choreoapps.dev/company/hr`.

Once the program is running, you can test it by sending a POST request to the endpoint http://localhost:9090/employees. To test, you can use the following cURL command in a separate terminal window:

```bash
curl -X POST \
     -H "Content-Type: application/json" \
     -d '{"employeeIds": [1, 2, 3]}' \
     http://localhost:9090/employees
```
