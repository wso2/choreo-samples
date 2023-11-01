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

## Deploy Application in Choreo

1. Fork this repository.
2. Create a `Service` component in Choreo with Docker Buildpack.
3. Use the following config when creating this component in Choreo:
    - Dockerfile: `<repository-url>/dotnet-greeter/Dockerfile`
    - Docker context: `<repository-url>/dotnet-greeter/`

    Make sure to replace `<repository-url>` with your repository URL.
4. Deploy the component.

## Testing the Application

Invoke the following endpoint to test the application. Make sure to change the `<endpoint-url>` to the URL of the deployed component.

```
curl -X GET <endpoint-url>/greeter/greet?name=John
```
