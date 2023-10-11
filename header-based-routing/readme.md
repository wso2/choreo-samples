Use template (Header Based Routing) to route requests depending on the HTTP header value.

## Use case
When the service is invoked with a header in a request, it returns data according to the header value provided in the request. This template can be used to route requests depending on the HTTP header value.

## Prerequisites
* Pull the template from central  
`bal new -t choreo/header_based_routing <newProjectName>`

## Run the template
Run the Ballerina project created by the service template by executing `bal run` from the root.

Once successfully executed, Listener will be started at port 8090. Then you need to invoke the service using the following curl command
```
$ curl http://localhost:8090/route -H "x-item:employee"
```
Now service will be invoked and returns extracted data as  
```
{"id":"1", "firstName":"Andy", "lastName":"Cook", "departmentId":"1", "title":"Manager"}
```
