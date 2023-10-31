# Data Encoding and Decoding
## Use case
When the service is invoked with a username and password, it returns a URL encoded string. Service is invoked again with URL encoded string to `authenticate` endpoint where URL encoded string is decoded and username and password are obtained. This sample can be used to encode and decode data using base64 or URL encoding schemes.

## Run the sample
Run the Ballerina project created by the service sample by executing `bal run` from the root.

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
