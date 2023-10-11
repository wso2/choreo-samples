Use template (GraphQL Service) to respond with a greetings message for a GraphQL query with input name received via an HTTP POST.

## Use case
When the service is invoked with a GraphQL query specifying the input name, the service will respond with a greetings message including the input name specified in the GraphQL query received via an HTTP POST. The sample implementation shows a simple GraphQL endpoint that has a single field (i.e. "greeting") with an input value (i.e. "name") in the root Query type, which returns a string (i.e. greetings message) or an error. The input parameters in the resource function becomes the input values of the corresponding GraphQL field. In this GraphQL schema, the `greeting` field of `Query` type has a `name` input value, which accepts string values.

## Prerequisites
* Pull the template from central  
`bal new -t choreo/graphql_service <newProjectName>`

## Run the template
Run the Ballerina project created by the service template by executing `bal run` from the root.

Once successfully executed, Listener will be started at port 8090. Then you need to invoke the service using the following curl command
```
$ curl -X POST -H "Content-type: application/json" -d '{ "query": "{ greeting(name: \"John\") }" }' 'http://localhost:8090'
```
The GraphQL query used: { greeting(name: "John") }.
Now service will be invoked and returns the greetings message as  
```
{"data":{"greeting":"Hello, John"}}
```
