# JMS producer and consumer integration in MI

These samples demonstrate how to create an integration that consumes messages from a JMS queue and sends those messages to another JMS queue.

## Setting up ActiveMQ
- In this sample, ActiveMQ is used as the broker. You can download ActiveMQ from their official website: [ActiveMQ](https://activemq.apache.org/download.html).

## Setting up additional configurations
- The JMS transport details should be added to the deployment.toml file.
- If a deployment.toml file is not present in the project root, create a new one.
- Add or edit the following JMS sender and receiver configurations as needed:
```
[[transport.jms.sender]]
name = "myQueueSender"
parameter.initial_naming_factory = "org.apache.activemq.jndi.ActiveMQInitialContextFactory"
parameter.provider_url = "$env{JMS_PROVIDER_URL}"
parameter.connection_factory_name = "QueueConnectionFactory"
parameter.connection_factory_type = "queue"
parameter.cache_level = "producer"

[[transport.jms.listener]]
name = "myQueueListener"
parameter.initial_naming_factory = "org.apache.activemq.jndi.ActiveMQInitialContextFactory"
parameter.provider_url = "$env{JMS_PROVIDER_URL}"
parameter.connection_factory_name = "QueueConnectionFactory"
parameter.connection_factory_type = "queue"
parameter.cache_level = "consumer"

```

## Deploying in Choreo
To deploy this project in Choreo, follow these steps:

1. **Fork this repo.**
2. **Create an Event Handler component.**
3. **Deploy the component.**

## Testing

Once you have completed the setup, you can go to the ActiveMQ web console or use a JMS client to send a message to the `SimpleStockQuoteServiceSource` queue. This service will listen to messages on `SimpleStockQuoteServiceSource` and send them to `SimpleStockQuoteService` queue

