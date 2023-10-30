# RabbitMQ Listener Integration in MI

RabbitMQ listener developed usign WSO2 Integration Studio

## Project Description

In this project, we implement a RabbitMQ listener using WSO2 Integration Studio. The project is designed to listen to a RabbitMQ server where sales order messages are sent to a specific queue called "SalesOrderQueue." The primary goal of this project is to capture these sales order messages as they arrive in the queue and log the contents of these messages for further processing or analysis.

## Prerequisites

- RabbitMQ server access

## Deploy in Choreo

To deploy this project in Choreo, follow these steps:

1. **Fork this repo.**
2. **Create an Event Handler component.**
3. **Configure the component with the following environment variables:**
   - `HOSTNAME`: Set the hostname of your RabbitMQ server.
   - `VHOST`: Specify the virtual hostname of your RabbitMQ server.
   - `USERNAME`: Provide the username for connecting to RabbitMQ.
   - `PASSWORD` (marked as a secret): Enter the password associated with the RabbitMQ username. Make sure to mark this as a secret.
4. **Deploy the component.**

## Testing the Component

To test the functionality of your deployed component, follow these steps:

1. **Send a Sales Order Message:**

   Send a sample sales order message in JSON format through the RabbitMQ server to the "SalesOrderQueue." For example:

   ```json
   {
     "order_id": "12345",
     "customer_name": "John Doe",
     "product": "Widget",
     "quantity": 10,
     "total_amount": 100.00
   }
   ```
2. **Observe the logs:**

   Observe the logs in the Choreo console. You should see the contents of the sales order message logged by the component.