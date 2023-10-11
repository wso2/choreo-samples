Use template (Circuit Breaker) to handle outages and service slowness gracefully to avoid cascading failures.

## Use case
In case of a failed attempt when connecting with the backend, the circuit breaker configuration specifies how to respond to subsequent requests to the same backend. When the service is invoked, the service will handle outages and service slowness gracefully to avoid cascading failures.

## Prerequisites
* Pull the template from central  
`bal new -t choreo/circuit_breaker <newProjectName>`

## Run the template
Run the Ballerina project created by the service template by executing `bal run` from the root.

Once successfully executed, Listener will be started at port 9090. Then you need to invoke the service using the following curl command
```
$ curl http://localhost:9090/gateway
```
Now service will be invoked and in case of a failed attempt when connecting with backend circuit breaker configuration specifies how to respond to subsequent requests to the same backend
