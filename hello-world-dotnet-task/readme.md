# Hello World task in .NET

Sample for Hello World task. Print "Hello World" when run dotnet run

### Prerequisites
1. Fork the repositoy

## Getting started

Please refer to the Choreo documentation under the [Develop an Application with Buildpacks](https://wso2.com/choreo/develop-components/deploy-an-application-with-buildpacks) to learn how to deploy the application.

1. Select `Manual Task` Card from Component Creation Wizard
2. Select `.NET` as the buildpack. Fill as follow according to selected Buildpack.

    | **Field**             | **Description**                               |
    |-----------------------|-----------------------------------------------|
    |Name           | Hello World Dotnet Task              |
    |Description    | Hello World Dotnet Task       |
    | **GitHub Account**    | Your account                                  |
    | **GitHub Repository** | choreo-samples |
    | **Branch**            | **`main`**                               |
    | **Buildpack**      | .NET |
    | **Select .NET Project Directory**       | hello-world-dotnet-task |
    | **Select Language Version**              | 7.x |

3. Click Create. Once the component creation is complete, you will see the component overview page.
4. Deploy the created component
5. Trigger and test the task
   - Once the deployed, navigate to `Execute` page.
   - Click `Run Now` to execute.
   - Check logs by clicking on the execution of the executions list.
