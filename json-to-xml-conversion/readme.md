# JSON to XML Conversion
## Use case
When the service is invoked with JSON data, it returns data in XML format. This sample can be used to convert provided JSON request to an XML response. 

## Run the sample
Run the Ballerina project created by the service sample by executing `bal run` from the root.

Once successfully executed, Listener will be started at port 8090. Then you need to invoke the service using the following curl command
```
$ curl http://localhost:8090/convert -d '{ "Name": "John", "Grade": 12, "Marks": {"English" : "85", "IT" : "100"}}' -H "Content-Type:application/json"
```
Now service will be invoked and returns data in XML format as 
```
<Name>John</Name><Grade>12</Grade><Marks><English>85</English><IT>100</IT></Marks>
```