# Echo Service
## Use case
When the service is invoked with a message, the service will respond with the same message received via an HTTP POST.

## Run the sample
Run the Ballerina project created by the service sample by executing `bal run` from the root.

Once successfully executed, Listener will be started at port 8090. Then you need to invoke the service using the following curl command
```
$ curl http://localhost:8090/. -d "Hello World"
```
Now service will be invoked and returns the message as  
```
Hello World
```
