Use template (HTTP Header Manipulation) to manipulate the header value provided.

## Use case
When the service is invoked with an Authorization header it checks the value provided in the header and uses that value to do operations. This template can be used to manipulate the header value provided.

## Prerequisites
* Pull the template from central  
  `bal new -t choreo/header_manipulation <newProjectName>`

## Run the template
Run the Ballerina project created by the service template by executing `bal run` from the root.

Once successfully executed, Listener will be started at port 8090. Then you need to invoke the service using the following curl command
```
$ curl http://localhost:8090/home -H "x-authorization: Basic amFjazpiZWFucw%3D%3D"
```
Now service will be invoked and returns result by manipulating the header value provided

