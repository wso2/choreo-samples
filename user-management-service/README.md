# Go User Management Service

## Repository File Structure

The below table gives a brief overview of the important files in the user management service.
Note: The following file paths are relative to the path /user-management-service

| Filepath               | Description                                                                                                                                                          |
| ---------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| main.go                | The Go-based Greeter service code.                                                                                                                                   |
| .choreo/component.yaml | Choreo-specific configuration that provides information about how Choreo exposes the service.                                                                        |
| openapi.yaml           | OpenAPI contract of the greeter service. This is needed to publish our service as a managed API. This openapi.yaml file is referenced by the .choreo/endpoints.yaml. |

### Prerequisites
1. Fork the repositoy

## Deploy Application

Please refer to the Choreo documentation under the [Develop a REST API](https://wso2.com/choreo/docs/develop-components/develop-services/develop-a-rest-api/#step-1-create-a-service-component-from-a-dockerfile) section to learn how to deploy the application.

You can select either Docker or Go as buildpacks. Fill as follow according to selected Buildpack.

1. Select `Service` Card from Component Creation Wizard
2. Select `Go` as the buildpack. Fill as follow according to selected Buildpack.

    | **Field**             | **Description**                               |
    |-----------------------|-----------------------------------------------|
    |Name           | User Management Service              |
    |Description    | user management service        |
    | **GitHub Account**    | Your account                                  |
    | **GitHub Repository** | choreo-samples |
    | **Branch**            | **`main`**                               |
    | **Buildpack**      | `Go` |
    | **Select Go Project Directory**       | user-management-service |
    | **Language Version**              | 1.x |

3. Click Create. Once the component creation is complete, you will see the component overview page.
4. Wait till the component build is finished
5. Click Configure and Deploy btn and fill the generated configuration form.
6. Deploy the component.

## Execute the Sample Locally

Navigate to the Go application directory

```bash
cd user-management-service
```

Run the service

```shell
go run main.go
```
