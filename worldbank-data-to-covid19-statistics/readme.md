# COVID-19 Statistics
## Use-case
When the service is invoked with a country specified, get the COVID-19 cases per million in that country. It is important to be aware of the covid situation in a specific country. We may need to get information about the reported covid cases in that country. This sample can be used to get the covid19 cases per million in a specific country of interest.

## Run the sample
Run the Ballerina project created by the service sample by executing `bal run` from the root.

Once successfully executed, Listener will be started at port 8090. Then you need to invoke the service using the following curl command. Provide the specific country code. Example `usa`
```
$ curl http://localhost:8090/stats/[<country>]
```
Now you can get the covid19 cases per million in the specific country of interest as
```
{"country":"usa", "totalCasesPerMillion":159550.3883495145631067961165048544}
```
