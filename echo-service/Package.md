Use template (Echo Service) to respond with the same message received via an HTTP POST.

## Use case
When the service is invoked with a message, the service will respond with the same message received via an HTTP POST.

## Prerequisites
* Pull the template from central  
`bal new -t choreo/echo_service <newProjectName>`

## Run the template
Run the Ballerina project created by the service template by executing `bal run` from the root.

Once successfully executed, Listener will be started at port 8090. Then you need to invoke the service using the following curl command
```
$ curl http://localhost:8090/. -d "Hello World"
```
Now service will be invoked and returns the message as  
```
Hello World
```
