# Data Mapping
## Use case
When the service is invoked with a data field, the service will respond by mapping data fields from one data structure to another. This sample can be used to map data fields from one data structure to another.

## Run the sample
Run the Ballerina project created by the service sample by executing `bal run` from the root.

Once successfully executed, Listener will be started at port 8090. Then you need to invoke the service using the following curl command
```
$ curl http://localhost:8090/summary/1
```
Now service will be invoked and returns data of employee for a given employee number
```
{"title":"Summarized Employee Information", "firstName":"Andy", "lastName":"Cook", "gender":"Male", "age":47}
```
