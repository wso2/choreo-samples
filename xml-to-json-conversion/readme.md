Use template (XML to JSON Conversion) to convert an XML request to JSON.

## Use case
When the service is invoked with XML data, it returns data in JSON format. This template can be used to convert provided XML request to JSON response.

## Prerequisites
* Pull the template from central  
`bal new -t choreo/xml_to_json_conversion <newProjectName>`

## Run the template
Run the Ballerina project created by the service template by executing `bal run` from the root.

Once successfully executed, Listener will be started at port 8090. Then you need to invoke the service using the following curl command. 
```
$ curl http://localhost:8090/convert -d "<h:Store id = \"AST\" xmlns:h=\"http://www.test.com\"><h:street>Main</h:street><h:city>94</h:city></h:Store>" -H "Content-Type:application/xml"
```
Now service will be invoked and returns data in JSON format as 
```
{"h:Store":{"h:street":"Main", "h:city":"94", "@xmlns:h":"http://www.test.com", "@id":"AST"}}
```
