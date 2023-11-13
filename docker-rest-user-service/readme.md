# Choreo Sample REST API - User Store

### Use the following commands to create BYOI component

- Select Create Component with `Service` type.
- Provide component name and description.
- Select `Deploy an image from a Container Registry` as the source.
- Select `User Service` tile and create component.

### Use the following endpoint configuration when creating endpoints for the component:

- Endpoint Yaml - [endpoints.yaml](.choreo/endpoints.yaml)
- OpenAPI - [openapi.yaml](docs/openapi.yaml)


### Use the following configuration when creating this component in Choreo:

- Build Pack: **Dockerfile**
- Dockerfile Path: `docker-rest-user-service/Dockerfile`
- Docker Context Path: `docker-rest-user-service`

The [endpoints.yaml](.choreo/endpoints.yaml) file contains the endpoint configurations that are used by the Choreo to expose the service.

### Run the service locally

```shell
go run main.go
```

### Generate API definitions

Generated using Go annotations https://github.com/swaggo/swag

1. Download swag CLI tool by running: 
    ```shell
    go install github.com/swaggo/swag/cmd/swag@v1.8.11
    ```
2. Run the following command to generate the API definitions:
    ```shell
    swag fmt && swag init
    ```

### Service Configurations (optional)

Refer [config.go](internal/config/config.go) file for the available configurations.

For more information on how to configure a service in Choreo, refer [Manage Configurations and Secrets](https://wso2.com/choreo/docs/deploy/devops/configs-and-secrets/) documentation.

#### Load initial data ( optional )

1. Set environment variable by navigating to Choreo Deploy page `INIT_DATA_PATH=configs/initial_data.json`
2. Mount the file contents of `configs/initial_data.json` in the path specified in step 1.

See [initial_data.json](configs/initial_data.json) for a sample file.

