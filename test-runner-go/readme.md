# Test Runner Go Buildpack sample

## Use case

When the test runner component is triggered manually, it will run a job to execute automated tests implemented by the developer. Test results can be viewed from the Choreo console.

## Run the sample in Choreo

### Prerequisites

- A valid Choreo account with available resource quota.

Let's write some tests in Go and run those tests in Choreo.

### Create a test runner component using a Go buildpack

1. Go to [https://console.choreo.dev/](https://console.choreo.dev/cloud-native-app-developer) and sign in. This opens the project home page.
2. Click **Create** button in the Component Listing section. Choose **Test Runner** component type.
3. Enter a unique name and a description for the test runner component. For this guide, let's enter the following values:

   | Field       | Value                         |
   | ----------- | ----------------------------- |
   | Name        | Go Test Runner                |
   | Description | Test Runner implemented in Go |

4. Click **Github** tab and provide the required source repository details.

   | Field        | Value          |
   | ------------ | -------------- |
   | Organization | wso2           |
   | Repository   | choreo-samples |
   | Branch       | main           |

5. Choose the **Go** buildpack from the buildpack tiles.
6. Choose Project directory and Go version. For this example, let's consider the following values.

   | Field                | Value           |
   | -------------------- | --------------- |
   | Go Project Directory | /test-runner-go |
   | Language Version     | 1.x             |

7. Click **Create**. Once the component creation is complete, you will see the component overview page.

You have successfully created a Test Runner component using a Go buildpack. Now let's build and run the tests.

### Building the test runner component and executing the tests

1. Go to **Deploy** page from the left main menu.
2. Click **Deploy** to build and deploy the test runner component. If you want to provide additional configuration or secrets, use the **Configure and Deploy** option.
3. Once the deployment is successful, go to **Execute** page from the left main menu.
4. Choose the environment from the environment drop down and click **Run Now** button to trigger a test execution.
5. A new execution will be shown in the execution list and click on the execution list item to view the test results.

## Run the template locally

### Prerequisites

- Go 1.x

Run the go test suite using `go run main.go` command.

Once successfully executed, test cases will get executed and the logs will be shown.

```
go run main.go

Running tests...
Received JSON Data for Post ID 1:
{UserID:1 ID:1 Title:sunt aut facere repellat provident occaecati excepturi optio reprehenderit Body:quia et suscipit
suscipit recusandae consequuntur expedita et cum
reprehenderit molestiae ut ut quas totam
nostrum rerum est autem sunt rem eveniet architecto}
Received JSON Data for Post ID 2:
{UserID:1 ID:2 Title:qui est esse Body:est rerum tempore vitae
sequi sint nihil reprehenderit dolor beatae ea dolores neque
fugiat blanditiis voluptate porro vel nihil molestiae ut reiciendis
qui aperiam non debitis possimus qui neque nisi nulla}
PASS
```
