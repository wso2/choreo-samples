# Kafka Order Processing Client


This program demonstrates Kafka integration using Ballerina, featuring both Kafka consumer and producer functionalities. The program allows you to configure the Kafka server URL, username, and password. It consumes order objects published to the "order" topic from another Kafka producer. If the payment status of an order is successful, the program produces the same order object to the "payment-success-order" topic.

## Prerequisites

- [Ballerina](https://ballerina.io/downloads/)
- Access to a Kafka server
- Basic understanding of Kafka concepts

## Configuration

Create a `Config.toml` file and configure the following properties to match your Kafka setup:

```toml
[wso2.kakfa.integration.kafkaConfig]
kafkaEndpoint = "KAFKA_SERVER_URL"
kafkaUsername = "KAFKA_USERNAME"
kafkaPass = "KAFKA_PASSWORD"
```
> If you are using Choreo, you can provide values for configuarables via the Choreo Console.

## Kafka Consumer

The Kafka consumer in this program subscribes to the "order" topic and listens for incoming order objects. When an order object is received, the program checks the payment status. If the payment status is successful, the order object is sent to the "payment-success-order" topic using the Kafka producer.

## Kafka Producer
The Kafka producer in this program reads order objects from the "order" topic and sends them to the "payment-success-order" topic when the payment status is SUCESSFUL.

## Sample Order Object

```json
{
    "id": 1,
    "desc": "Order Description",
    "paymentStatus": "SUCCESS"
}
```