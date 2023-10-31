# Pass-through Service
## Use-case
When forwarding, the request is made using the same HTTP method that was used to invoke the passthrough resource

## Run the sample
Run the Ballerina project created by the service sample by executing `bal run` from the root.

Once successfully executed, Listener will be started at port 8090. Then you need to invoke the service using the following curl command.
```
$ curl -d '{json}' -H 'Content-Type: application/json' http://localhost:8090/.
```
Now service will be invoked and returns data as 
```
{"args":{}, "data":"{json}", "files":{}, "form":{}, "headers":{"x-forwarded-proto":"https", "x-forwarded-port":"443", "host":"postman-echo.com", "x-amzn-trace-id":"Root=1-61a64b4c-1bcb492d2fd2d5c37370a357", "content-length":"6", "accept":"*/*", "content-type":"application/json", "user-agent":"ballerina"}, "json":null, "url":"https://postman-echo.com/post/"}
```
