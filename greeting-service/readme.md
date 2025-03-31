# Greetings 1111
## Use case
When the service is invoked with a message, the service will respond with a record including that message received via an HTTP GET.

## Run the sample
Run the Ballerina project created by the service sample by executing `bal run` from the root.

Once successfully executed, Listener will be started at port 8090. Then you need to invoke the service using the following curl command
```
$ curl http://localhost:8090?name=John
```
Now service will be invoked and returns record as  
testing
```
 {
     from: "Choreo"
     to: "John"
     message: "Welcome to Choreo!"
   }
```
