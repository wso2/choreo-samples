# JSON Navigation
## Use case
When the service is invoked with JSON data, it returns extracts the data in JSON format. This sample can be used to navigate through the fields of a JSON object and extracts the data.

## Run the sample
Run the Ballerina project created by the service sample by executing `bal run` from the root.

Once successfully executed, Listener will be started at port 8090. Then you need to invoke the service using the following curl command
```
$ curl http://localhost:8090/phone_numbers -d '{"name":"Grade 1-A","teacher":{"name":"Katherine Peterson","phone-number":"+447458197233"},"students":[{"name":"Tom Johnson","phone-number":"+447422134277"},{"name":"Anne Stevenson","phone-number":"+447476488899"},{"name":"Jason David","phone-number":"+447466548798"}]}' -H "Content-Type:application/json"
```
Now service will be invoked and returns extracted data in JSON format as  
```
{"className":"Grade 1-A", "phone-numbers":["+447458197233", "+447422134277", "+447476488899", "+447466548798"]}
```
