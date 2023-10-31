# Responds with the Hello World message
## Use case
When the service is invoked, it returns `Hello World` string. This sample can be used to respond with `Hello World` once service invoked.

## Run the sample
Run the Ballerina project created by the service sample by executing `bal run` from the root.

Once successfully executed, Listener will be started at port 9090. Then you need to invoke the service using the following curl command
```
$ curl http://localhost:8090/hello/greeting
```
Now service will be invoked and returns the message as `Hello World`
