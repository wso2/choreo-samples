# Database Connection
## Use-case
When the service is invoked with a country specified, get the customers details in that country. This sample can be used to read data from a MySQL database and returns a JSON response.

## Run the sample
Run the Ballerina project created by the service sample by executing `bal run` from the root.

Once successfully executed, Listener will be started at port 8090. Then you need to invoke the service using the following curl command. Provide the specific country code. Example `usa`
```
$ curl http://localhost:8090/list/[<country>]
```
Now you can get the customers details in the specific country of interest as
```
{"1":{"firstName":"Peter", "lastName":"Stuart"}, "3":{"firstName":"John", "lastName":"Cook"}}
```