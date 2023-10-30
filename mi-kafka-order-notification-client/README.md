# WSO2 MI - Kafka Order Notification Client

This integration project enables you to produce and consume messages from a Kafka topic. It consists of a Kafka producer and a Kafka consumer. The producer sends order payloads to a specified Kafka topic, and the consumer listens to the same topic, retrieving and logging the order payloads.

## Prerequisites

- Access to a running Kafka server with SASL Plain text auth enabled.
- Basic understanding of Kafka concepts such as topics, brokers, and producers/consumers.
- HTTP client (e.g., curl) for testing the integration.

## Deploying in Choreo

1. Fork this repository.
2. Create a service component in Choreo under the WSO2 MI build preset.
3. Add the following environment variables to the service component:
    - `KAFKA_URL`: The URL of the Kafka broker.
    - `KAFKA_JAAS_CONFIG`: The JAAS configuration for the Kafka broker. In the format `org.apache.kafka.common.security.plain.PlainLoginModule required username="<username>" password="<password>";`.
4. Deploy the service component.

## Testing the integration

1. Send a POST request to the `/produce` endpoint with the following payload:

    ```json
    {
        "id": 89,
        "desc": "Order Description",
        "paymentStatus": "SUCCESS"
    }
    ```
2. Observe the logs in the Choreo console. You should see the order payload logged by the consumer.