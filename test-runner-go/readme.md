Use template (Test Runner Go) to write and execute automated tests against applications hosted in Choreo or any 3rd party services.

## Use case

When the test runner component is triggered manually, it will run a job to execute automated tests implemented by the developer. Test results and logs can be viewed from the Choreo console.

## Prerequisites

- Go 1.x installed in your local machine.

## Run the template

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
