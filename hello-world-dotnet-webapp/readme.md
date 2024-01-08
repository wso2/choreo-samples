# Hello World Web Application in .NET

Sample for Hello World web app.

### Prerequisites
1. Fork the repositoy

## Getting started

Please refer to the Choreo documentation under the [Develop an Application with Buildpacks](https://wso2.com/choreo/develop-components/deploy-an-application-with-buildpacks) to learn how to deploy the application.

1. Select `Web Application` Card from Component Creation Wizard
2. Select `.NET` as the buildpack. Fill as follow according to selected Buildpack.

    | **Field**             | **Description**                               |
    |-----------------------|-----------------------------------------------|
    |Name           | Hello World WebApp              |
    |Description    | Hello World WebApp        |
    | **GitHub Account**    | Your account                                  |
    | **GitHub Repository** | choreo-samples |
    | **Branch**            | **`main`**                               |
    | **Buildpack**      | .NET |
    | **Select Go Project Directory**       | hello-world-dotnet-webapp |
    | **Language Version**              | 8.x |
    | **Port** | 5000|

3. Click Create. Once the component creation is complete, you will see the component overview page.
4. Deploy the created component

## Execute the Sample Locally

Navigate to the Go application directory

```bash
cd hello-world-dotnet-webapp
```

Run the service

```shell
dotnet watch
```