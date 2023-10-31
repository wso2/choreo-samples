# Test Runner Java Buildpack sample

## Use case

When the test runner component is triggered manually, it will run a job to execute automated tests implemented by the developer. Test results and logs can be viewed from the Choreo console.

## Run the sample in Choreo

### Prerequisites

- A valid Choreo account with available resource quota.

Let's write some tests in Java and run those tests in Choreo.

### Create a test runner component using a Java buildpack

1. Go to [https://console.choreo.dev/](https://console.choreo.dev/cloud-native-app-developer) and sign in. This opens the project home page.
2. Click **Create** button in the Component Listing section. Choose **Test Runner** component type.
3. Enter a unique name and a description for the test runner component. For this guide, let's enter the following values:

   | Field       | Value                           |
   | ----------- | ------------------------------- |
   | Name        | Java Test Runner                |
   | Description | Test Runner implemented in Java |

4. Click **Github** tab and provide the required source repository details.

   | Field        | Value          |
   | ------------ | -------------- |
   | Organization | wso2           |
   | Repository   | choreo-samples |
   | Branch       | main           |

5. Choose the **Java** buildpack from the buildpack tiles.
6. Choose Project directory and Java version. For this example, let's consider the following values.

   | Field                | Value             |
   | -------------------- | ----------------- |
   | Go Project Directory | /test-runner-java |
   | Language Version     | 17                |

7. Click **Create**. Once the component creation is complete, you will see the component overview page.

You have successfully created a Test Runner component using a Java buildpack. Now let's build and run the tests.

### Building the test runner component and executing the tests

1. Go to **Deploy** page from the left main menu.
2. Click **Deploy** to build and deploy the test runner component. If you want to provide additional configuration or secrets, use the **Configure and Deploy** option.
3. Once the deployment is successful, go to **Execute** page from the left main menu.
4. Choose the environment from the environment drop down and click **Run Now** button to trigger a test execution.
5. A new execution will be shown in the execution list and click on the execution list item to view the test results.

## Run the sample locally

### Prerequisites

- Java (JDK) installed in your local machine.

Build the java test suite using `mvn clean install` command. Build artefacts will be located in `target/` directory.

Run the java test suite using `java -jar target/test-runner-1.0-SNAPSHOT-jar-with-dependencies.jar` command.

Once successfully executed, test cases will get executed and the logs will be shown.

```
java -jar target/test-runner-1.0-SNAPSHOT-jar-with-dependencies.jar

API call successful
Status code is 200
Title matches expected value
```
