Use template (JWT Handling) to read fields from a JWT and processes them.

## Use-case
When the service is invoked with a JWT token, it checks the validity of the JWT token and returns the result. This template can be used to read fields from a JWT and processes them.

## Prerequisites
* Pull the template from central  
  `bal new -t choreo/jwt_handling <newProjectName>`

## Run the template
Run the Ballerina project created by the service template by executing `bal run` from the root.

Once successfully executed, Listener will be started at port 8090. Then you need to invoke the service using the following curl command
```
$ curl -X POST http://localhost:8090/extract?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwiaXNzIjoiSm9obiBEb2UiLCJleHAiOjE1MTYyMzkwMjJ9.HtKM7eaXUiCop41qola71X6johzzeUrDN3e8CdJliUw
```
Now service will be invoked and check the validity of the JWT token and return the result

