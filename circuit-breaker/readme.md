# Circuit Breaker
## Use case
In case of a failed attempt when connecting with the backend, the circuit breaker configuration specifies how to respond to subsequent requests to the same backend. When the service is invoked, the service will handle outages and service slowness gracefully to avoid cascading failures.

## Run the sample
Run the Ballerina project created by the service sample by executing `bal run` from the root.

Once successfully executed, Listener will be started at port 9090. Then you need to invoke the service using the following curl command
```
$ curl http://localhost:9090/gateway
```
Now service will be invoked and in case of a failed attempt when connecting with backend circuit breaker configuration specifies how to respond to subsequent requests to the same backend
