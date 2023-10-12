Use template (Message Aggregator) to send multiple requests to the backend, collects responses, and distill them into a single response.

## Use-case
When the service is invoked with an array of employee Ids, it returns data obtained from employees corresponding to those employee Ids provided in the request. This template can be used to send multiple requests to the backend, collects responses, and distills them into a single response.

## Prerequisites
* Pull the template from central  
`bal new -t choreo/scatter_gather <newProjectName>`

## Run the template
Run the Ballerina project created by the service template by executing `bal run` from the root.

Once successfully executed, Listener will be started at port 8090. Then you need to invoke the service using the following curl command
```
$ curl http://localhost:8090/employees -d '{"employeeIds": [1,2]}' -H "Content-Type:application/json"
```
Now service will be invoked and returns details of employees for interested employees
```
{"employeeDetails":[{"id":"1", "firstName":"Andy", "lastName":"Cook", "departmentId":"1", "title":"Manager"}, {"id":"2", "firstName":"Jim", "lastName":"Smith", "departmentId":"2", "title":"Software Engineer"}]}
```
