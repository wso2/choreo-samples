# Go UDP Service

This sample shows how you can deploy server-client services utilizing UDP for communication. The setup underscores the utilization of lightweight, connectionless data exchange between these components within a networked context.

## Steps to Deploy in Choreo

### Deploy the server

1. Create a new Service component with following parameters
   - Build Pack: `Dockerfile`
   - Dockerfile path: `go/udp-service/Dockerfile.server`
   - Build Context: `go/udp-service`
2. Deploy the component
3. Navigate to the **Overview** page of the component and copy the endpoint address with the Project visibility.

### Deploy the client

1. Create a new Manual Trigger component with following parameters
   - Build Pack: `Dockerfile`
   - Dockerfile path: `go/udp-service/Dockerfile.client`
   - Build Context: `go/udp-service`
2. Navigate to the **Configs & Secrets** page of the component and add the following environment variables as the `ConfigMap` with a custom config name.

   - `SERVER_ADDRESS`: `<server-address>`

   Use the address copied from the server component (Step 3) as the value for `SERVER_ADDRESS` environment variable.
   Example: udp-server-3192360657:5000

3. Deploy the component and run it by clicking the **Run Once** button.

Refer https://wso2.com/choreo/docs/devops-and-ci-cd/manage-configurations-and-secrets/ for more information on how to add configs and secrets to a component.

### Run the sample locally

1. Start the server
   ```
   go run ./server
   ```
2. Start the client

   ```
   SERVER_ADDRESS=localhost:5050 go run ./client
   ```

Refer https://wso2.com/choreo/docs/develop-components/develop-services/develop-a-service/ for more information on how to develop and deploy a service component.
