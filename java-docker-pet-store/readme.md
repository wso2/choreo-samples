# Swagger Petstore Sample

This is the java project for a simplified version of the [pet store sample](https://github.com/swagger-api/swagger-petstore) hosted at https://petstore3.swagger.io.

## Repository File Structure

The below table gives a brief overview of the important files in the service.\
Note: The following file paths are relative to the path /java/pet-store/

| Filepath               | Description                                                                                                                                                  |
| ---------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| src/main               | The Java based service code.                                                                                                                                 |
| Dockerfile             | Choreo uses the Dockerfile to build the container image of the application.                                                                                  |
| .choreo/endpoints.yaml | Choreo-specific configuration that provides information about how Choreo exposes the service.                                                                |
| openapi.yaml           | OpenAPI contract of the service. This is needed to publish our service as a managed API. This openapi.yaml file is referenced by the .choreo/endpoints.yaml. |

## Deploy Application

Please refer to the Choreo documentation under the [Develop a REST API](https://wso2.com/choreo/docs/develop-components/develop-services/develop-a-rest-api/#step-1-create-a-service-component-from-a-dockerfile) section to learn how to deploy the application.

## Use the following build config when creating this component in Choreo:

- Build Pack: **Dockerfile**
- Dockerfile Path: `java-docker-pet-store/Dockerfile`
- Docker Context Path: `java-docker-pet-store`

The [endpoints.yaml](.choreo/endpoints.yaml) file contains the endpoint configurations that are used by the Choreo to expose the service.


### Execute the sample locally
Navigate to the Java application directory.
To run the server, run this command:

```
mvn package jetty:run
```

This will start Jetty embedded on port 8080.
