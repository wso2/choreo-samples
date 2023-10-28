# Go Greeter Service

## Repository File Structure

The below table gives a brief overview of the important files in the greeter service.\
Note: The following file paths are relative to the path /go/greeter

| Filepath               | Description                                                                                                                                                          |
| ---------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| main.go                | The Go-based Greeter service code.                                                                                                                                   |
| Dockerfile             | Choreo uses the Dockerfile to build the container image of the application.                                                                                          |
| .choreo/endpoints.yaml | Choreo-specific configuration that provides information about how Choreo exposes the service.                                                                        |
| openapi.yaml           | OpenAPI contract of the greeter service. This is needed to publish our service as a managed API. This openapi.yaml file is referenced by the .choreo/endpoints.yaml. |

## Deploy Application

Please refer to the Choreo documentation under the [Develop a REST API](https://wso2.com/choreo/docs/develop-components/develop-services/develop-a-rest-api/#step-1-create-a-service-component-from-a-dockerfile) section to learn how to deploy the application.

#### Use the following config when creating this component in Choreo:

- Dockerfile: `go/greeter/Dockerfile`
- Docker context: `go/greeter/`

## Execute the Sample Locally

Navigate to the Go application directory

```bash
cd choreo-sample-apps/go/greeter
```

Run the service

```shell
go run main.go
```
