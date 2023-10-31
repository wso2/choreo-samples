# Test Runner Javascript Buildpack sample

## Use case

When the test runner component is triggered manually, it will run a job to execute automated tests implemented by the developer. Test results can be viewed from the Choreo console.

## Run the sample in Choreo

### Prerequisites

- A valid Choreo account with available resource quota.

Let's write some tests in Javascript and run those tests in Choreo.

### Create a test runner component using a Go buildpack

1. Go to [https://console.choreo.dev/](https://console.choreo.dev/cloud-native-app-developer) and sign in. This opens the project home page.
2. Click **Create** button in the Component Listing section. Choose **Test Runner** component type.
3. Enter a unique name and a description for the test runner component. For this guide, let's enter the following values:

   | Field       | Value                                 |
   | ----------- | ------------------------------------- |
   | Name        | Javascript Test Runner                |
   | Description | Test Runner implemented in Javascript |

4. Click **Github** tab and provide the required source repository details.

   | Field        | Value          |
   | ------------ | -------------- |
   | Organization | wso2           |
   | Repository   | choreo-samples |
   | Branch       | main           |

5. Choose the **NodeJS** buildpack from the buildpack tiles.
6. Choose Project directory and NodeJS version. For this example, let's consider the following values.

   | Field                | Value                   |
   | -------------------- | ----------------------- |
   | Go Project Directory | /test-runner-javascript |
   | Language Version     | 18.x.x                  |

7. Click **Create**. Once the component creation is complete, you will see the component overview page.

You have successfully created a Test Runner component using a NodeJS buildpack. Now let's build and run the tests.

### Building the test runner component and executing the tests

1. Go to **Deploy** page from the left main menu.
2. Click **Deploy** to build and deploy the test runner component. If you want to provide additional configuration or secrets, use the **Configure and Deploy** option.
3. Once the deployment is successful, go to **Execute** page from the left main menu.
4. Choose the environment from the environment drop down and click **Run Now** button to trigger a test execution.
5. A new execution will be shown in the execution list and click on the execution list item to view the test results.

## Prerequisites

- Javascript (NodeJS) installed in your local machine.

## Run the sample in local machine

Run the go test suite using `npm run start` command.

Once successfully executed, test cases will get executed and the logs will be shown.

```
npm run start

> test-runner@1.0.0 start
> npx mocha index.js



  API Tests
    ✔ Test 1: Ensure the API response matches the expected values (358ms)


  1 passing (360ms)
```
