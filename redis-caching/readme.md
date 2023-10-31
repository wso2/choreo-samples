# Redis Caching
## Use case
When the service is invoked with JSON data it invokes API endpoint and cache result in the Redis cache. For subsequent requests data is fetched from Redis cache instead of invoking API endpoint again and again.

## Configuration
Create a file called `Config.toml` at the root of the project.

### Config.toml 
```
[<ORG_NAME>.redis_caching]
host = "<HOST_NAME_WITH_PORT>"
password = "<PASSWORD>"
```

## Run the sample
Run the Ballerina project created by the service sample by executing `bal run` from the root.

Once successfully executed, Listener will be started at port 9090. Then you need to invoke the service using the following curl command
```
$ curl http://localhost:9090/get -d '{"CountryCode": "LKA"}' -H "Content-Type:application/json"
```
Now service will be invoked and returns data as 
```
[{"indicator":{"id":"SP.POP.TOTL","value":"Population, total"},"country":{"id":"LK","value":"Sri Lanka"},"date":"2010","value":20261738,"countryiso3code":"LKA","unit":"","decimal":0,"obs_status":""}]
```
