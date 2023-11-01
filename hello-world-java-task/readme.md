# Hello World Java

Sample for Hello World task. Print "Hello World"

### Prerequisites
1. Fork the repositoy

## Getting started

Please refer to the Choreo documentation under the [Develop an Application with Buildpacks](https://wso2.com/choreo/develop-components/deploy-an-application-with-buildpacks) to learn how to deploy the application.

1. Select `Manual Task` Card from Component Creation Wizard
2. Select `Java` as the buildpack. Fill as follow according to selected Buildpack.

    | **Field**             | **Description**                               |
    |-----------------------|-----------------------------------------------|
    |Name           | Hello World Java Task              |
    |Description    | Hello World Java Task       |
    | **GitHub Account**    | Your account                                  |
    | **GitHub Repository** | choreo-samples |
    | **Branch**            | **`main`**                               |
    | **Buildpack**      | Java|
    | **Select Go Project Directory**       | hello-world-java-task |
    | **Select Language Version**              | 8 |

3. Click Create. Once the component creation is complete, you will see the component overview page.
4. Deploy the created component

Here, we have specify the entrypoint in  the `Procfile`

## Execute the Sample Locally

Navigate to the Go application directory

```bash
cd hello-world-java-task
```

Run the mvn command

```shell
mvn clean install
```

Execute jar file
```
java -cp target/sample-app-1.0-SNAPSHOT.jar com.sample.app.App
```