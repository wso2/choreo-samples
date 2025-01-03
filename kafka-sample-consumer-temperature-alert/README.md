# Sample-Consumer

This is a sample consumer program that reads temperature data from a Kafka topic and sends an alert if the temperature exceeds a certain threshold (30C in this program).

You can deploy this program in Choreo as a event handler component and subscribe to the Kafka topic to receive temperature data. And, make sure to add all the necessary configurations (service.cert, service.key, ca.pem, service uri, and the Kafka topic) to the event handler component.

Please note that you can get all these configuration values after creating a Kafka service on Choreo.
