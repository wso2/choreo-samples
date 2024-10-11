# Dynamic Endpoint Pass-through Service
## Use-case
Make a passthrough call to another endpoint url that needs to be specified dynamically


## Deploy in Choreo
1. Create the greeting service component
     - Fork this repository
     - Login to [Choreo](https://wso2.com/choreo/)
     - Select an existing `Project` or create a new one
     - Navigate to create a `Service` component
     - Provide a name and description for the component
     - Authorize and select the GitHub details
     - Select the `GitHub Account` and the forked repository for `GitHub Repository`
     - Select the `Branch` as `main`
     - Select `Ballerina` as `Buildpack`
     - Select `greeting-service` as the `Ballerina Project Directory`
     - Click on "Create" to create the component
2. Build and deploy the greeting service component
     - After the service is deployed successfully copy its Endpoint URL
3. Create the dynamic endpoint passthrough service component
     - Navigate back to the same `Project` the previous component was created in
     - Navigate to create a `Service` component
     - Provide a name and description for the component
     - Authorize and select the GitHub details
     - Select the `GitHub Account` and the forked repository for `GitHub Repository`
     - Select the `Branch` as `main`
     - Select `Ballerina` as `Buildpack`
     - Select `dynamic-endpoint-service` as the `Ballerina Project Directory`
     - Click on "Create" to create the component
4. Build and deploy the dynamic endpoint passthrough service component
     - In the Configuration section add the Endpoint URL that was copied in step 2 to as the value for `invoke_url`

## Testing the Choreo Component
Once the dynamic endpoint passthrough service component is deployed, go to the Choreo Test console and use the Swagger console to try out the API.


## Run and Test Locally

To run the program locally, you need to follow these steps:

1. Open your terminal or command prompt and navigate to the `greeting-service` project directory.
2. Follow the instructions in the `readme.md` file in that directory to run the service
3. In a separate terminal or command prompt navigate to the `dynamic-endpoint-passthrough` project directory.
3. Execute the following command to run the service:

```bash
bal run -- -Cinvoke_url=http://localhost:8090
```


> NOTE: In this case, we are providing a value to the configurable variable `invoke_url`. The endpoint URL for the greeting service is specified as `http://localhost:8090`.

Once the program is running, you can test it by sending a POST request to the endpoint http://localhost:9090/greeting?name=<value>. To test, you can use the following cURL command in a separate terminal window:

```bash
curl 
     -H "Content-Type: application/json" \
     http://localhost:9090/greeting\?name\=john
```
