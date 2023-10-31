# Error Handling
## Use case
When the service is invoked with data, it handles errors according to the option provided. This sample can be used to handle errors at different levels of granularitiesHandle errors at different levels of granularities.

## Run the sample
Run the Ballerina project created by the service sample by executing `bal run` from the root.

Once successfully executed, Listener will be started at port 8090. Then you need to invoke the service using the following curl command
```
$ curl -X POST http://localhost:8090/invoke?option=1
```
Now service will be invoked and handle errors according to the data provided  
