# Go gRPC Greeter

This example shows how a gRPC service and client can be deployed in Choreo. The example is written in
Go Language. The service is a simple greeter service that returns a greeting message. The client
is a simple application deployed as a manula trigger on Choreo that calls the greeter service and prints
the response.

## Steps to Deploy in Choreo

### Deploy the service
1. Select a project in Choreo or create a new one
2. Create a new service and give it a name
3. Select following for the server component
    - Repository name: Your forked sample apps reposiotory
    - branch: main
    - Build Preset: Dockerfile
    - Dockerfile path: go/grpc/Dockerfile.server
    - Build Context: go/grpc


### Deploy the client
1. Create a manual trigger component on the same project
2 Select following for the client component
    - Repository name: Your forked sample apps reposiotory
    - branch: main
    - Build Preset: Dockerfile
    - Dockerfile path: go/grpc/Dockerfile.client
    - Build Context: go/grpc
3. Once created, navigate to the deploy view and add the following environment variable
    - GREETER_SERVICE: < gRPC service url without the http:// part >
4. Deploy the client component
5. Once deployed, click Run Once on the environment card to run the client
6. Navigate to observe view to see the logs


### Local Development

- Open in VSCode with devcontainers
- Run `make ` to build server and the client
- Run `make serve` to run the server
- Run `make client` to run the client
