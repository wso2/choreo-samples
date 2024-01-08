# .NET Greeter Service
Sample .NET service that exposes a REST API to greet a user.

## Repository File Structure

The below table gives a brief overview of the important files in the greeter service.\
Note: The following file paths are relative to the path /dotnet/greeter

| Filepath               | Description                                                                                                                                                          |
| ---------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Program.cs             | The .NET-based Greeter service code.                                                                                                                                 |
| Dockerfile             | Choreo uses the Dockerfile to build the container image of the application.                                                                                          |
| .choreo/endpoints.yaml | Choreo-specific configuration that provides information about how Choreo exposes the service.                                                                        |
| openapi.yaml           | OpenAPI contract of the greeter service. This is needed to publish our service as a managed API. This openapi.yaml file is referenced by the .choreo/endpoints.yaml. |

## Getting started

Please refer to the Choreo documentation under the [Develop an Application with Buildpacks](https://wso2.com/choreo/develop-components/deploy-an-application-with-buildpacks) to learn how to deploy the application.

1. Select `Service` Card from Component Creation Wizard
2. Select `.NET` as the buildpack. Fill as follow according to selected Buildpack.

    | **Field**             | **Description**                               |
    |-----------------------|-----------------------------------------------|
    | Name           | Greeting Service              |
    | Description    | greeting service       |
    | **GitHub Account**    | Your account                                  |
    | **GitHub Repository** | choreo-samples |
    | **Branch**            | **`main`**                               |
    | **Buildpack**      | .NET |
    | **Select Go Project Directory**       | dotnet-greeter |
    | **Select Language Version**              | 7.x |

3. Click Create. Once the component creation is complete, you will see the component overview page.
4. Deploy the created component

## Testing the Application

Invoke the following endpoint to test the application. Make sure to change the `<endpoint-url>` to the URL of the deployed component.

```
curl -X GET <endpoint-url>/greeter/greet?name=John
```
