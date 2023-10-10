Use template (Service Chaining) to link two endpoints to get the details of an employee profile.

## Use-case
When the service is invoked with an employee Id, it returns data obtained from two different endpoints as a summary about an employee. This template can be used to link two endpoints to get the details of an employee profile.

## Prerequisites
* Pull the template from central  
`bal new -t choreo/service_chaining <newProjectName>`

## Run the template
Run the Ballerina project created by the service template by executing `bal run` from the root.

Once successfully executed, Listener will be started at port 8090. Then you need to invoke the service using the following curl command
```
$ curl http://localhost:8090/employee/1
```
Now service will be invoked and returns data of employee for a given employee number
```
{"name":"Andy Cook", "title":"Manager", "department":"Finance"}
```
