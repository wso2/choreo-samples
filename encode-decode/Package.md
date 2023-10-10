Use template (Data Encoding and Decoding) to encode and decode data using base64 or URL encoding schemes.

## Use case
When the service is invoked with a username and password, it returns a URL encoded string. Service is invoked again with URL encoded string to `authenticate` endpoint where URL encoded string is decoded and username and password are obtained. This template can be used to encode and decode data using base64 or URL encoding schemes.

## Prerequisites
* Pull the template from central  
`bal new -t choreo/encode_decode <newProjectName>`

## Run the template
Run the Ballerina project created by the service template by executing `bal run` from the root.

Once successfully executed, Listener will be started at port 8090. Then you need to invoke the service using the following curl command
```
$ curl -X POST "http://localhost:8090/encode?username=jack&password=beans"
```
Now service will be invoked and returns URL encoded string as  
```
amFjazpiZWFucw%3D%3D
```
Using the URL encoded string service can be invoked again using the following curl command
```
$ curl -X POST http://localhost:8090/authenticate?credentials=amFjazpiZWFucw%3D%3D
```
Now service will be invoked again and URL encoded string is decoded and username and password are obtained 
