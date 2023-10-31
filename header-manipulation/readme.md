# HTTP Header Manipulation
## Use case
When the service is invoked with an Authorization header it checks the value provided in the header and uses that value to do operations. This sample can be used to manipulate the header value provided.

## Run the sample
Run the Ballerina project created by the service sample by executing `bal run` from the root.

Once successfully executed, Listener will be started at port 8090. Then you need to invoke the service using the following curl command
```
$ curl http://localhost:8090/home -H "x-authorization: Basic amFjazpiZWFucw%3D%3D"
```
Now service will be invoked and returns result by manipulating the header value provided

