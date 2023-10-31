# JSON Transformation
## Use case
When the service is invoked with JSON data, it returns extracted and manipulated data in JSON format. This sample can be used to transform the structure of the JSON request. 

## Run the sample
Run the Ballerina project created by the service sample by executing `bal run` from the root.

Once successfully executed, Listener will be started at port 8090. Then you need to invoke the service using the following curl command
```
$ curl http://localhost:8090/. -d '{ "name": {"firstName": "Mitchel", "lastName": "Marsh"}, "address": {"streetAddress": "Lotus street", "city": "New York"}, "additionalInfo": {"dateOfBirth": "20-02-1995"}}' -H "Content-Type:application/json"
```
Now service will be invoked and returns data in JSON format as
```
{"name":"Mitchel Marsh", "address":"Lotus street,New York", "dob":"20-02-1995"}
```
