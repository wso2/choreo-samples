# Sample-Producer

This is a sample producer program that sends temperature data to a Kafka topic.

This program has an endpoint where we can call with the temperature value and it will send the temperature value to the Kafka topic.

The sample http endpoint is `http://localhost:9090/publish-temperature` and it accepts a POST request with the following JSON payload:

```json
{
  "stationId": 25,
  "stationName": "Chennai",
  "temperatureInCelsius": 35
}
```

You can deploy this program in Choreo as a service component and invoke the endpoint to send temperature data to the Kafka topic. And, make sure to add all the necessary configurations (service.cert, service.key, ca.pem, service uri, and the Kafka topic) to the service component.

Please note that you can get all these configuration values after creating a Kafka service on Choreo.
