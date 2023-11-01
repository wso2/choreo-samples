# Sample Java REST API

## Repository File Structure

The below table gives a brief overview of the important files in the service.\
Note: The following file paths are relative to the path /java/rest-api/

| Filepath               | Description                                                                                                                                                  |
| ---------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| src/main               | The Java based service code.                                                                                                                                 |
| Dockerfile             | Choreo uses the Dockerfile to build the container image of the application.                                                                                  |
| .choreo/endpoints.yaml | Choreo-specific configuration that provides information about how Choreo exposes the service.                                                                |
| openapi.yaml           | OpenAPI contract of the service. This is needed to publish our service as a managed API. This openapi.yaml file is referenced by the .choreo/endpoints.yaml. |

### Prerequisites
1. Fork the repositoy

## Deploy Application

Please refer to the Choreo documentation under the [Develop an Application with Buildpacks](https://wso2.com/choreo/develop-components/deploy-an-application-with-buildpacks) to learn how to deploy the application.

1. Select `Service` Card from Component Creation Wizard
2. Select `Java` as the buildpack. Fill as follow according to selected Buildpack.

    | **Field**             | **Description**                               |
    |-----------------------|-----------------------------------------------|
    |Name           | Product Management Service              |
    |Description    | Product Management Service       |
    | **GitHub Account**    | Your account                                  |
    | **GitHub Repository** | choreo-samples |
    | **Branch**            | **`main`**                               |
    | **Buildpack**      | Java|
    | **Select Java Project Directory**       | product-management-service |
    | **Select Language Version**              | 17 |

3. Click Create. Once the component creation is complete, you will see the component overview page.
4. Deploy the created component

The [endpoints.yaml](.choreo/endpoints.yaml) file contains the endpoint configurations that are used by the Choreo to expose the service.



## Execute the Sample Locally

> NOTE: You need to have java 17 installed in your system or Docker and VS Code installed to
> open this in a dev container

Navigate to the Java application directory

```bash
cd choreo-sample-apps/java/rest-api
```

Build the project

```bash
$ ./mvnw clean install
```

Run the service

```bash
$ ./mvnw spring-boot:run
```
