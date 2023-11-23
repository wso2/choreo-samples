# JMS Integration Sample - Micro Integrator

This sample demonstrates how to deploy a Micro Integrator component in Choreo that uses JMS transport.

## Prerequisites
- Running ActiveMQ broker in your local machine.
- Expose the ActiveMQ broker to the internet using ngrok. You can use the following command to expose the ActiveMQ broker.
    ```shell
    ngrok tcp 10088
    ```

## Deploying the component in Choreo
1. Fork this repository.
2. Create an `Service` component in Choreo.
    - Log in to Choreo and click on the `Create Component` button.
    - Select the `Service` component type.
    - Select the `WSO2 Micro Integrator` build pack.
    - Select the `jms-integration-mi` directory as the project directory.
    - Click on the `Create` button.
3. Build and Deploy the component

## Testing the component

1. Send a POST request to the following endpoint to send a message to the JMS queue.

    ```shell
    curl -X POST \
    https://<endpoint-url>/ \
    -H 'Content-Type: application/orderpayment' \
    -d '{
        "paymentId": "1234",
        "amount": 100.0,
        "currency": "USD"
    }'
    ```
    Make sure to replace the `<endpoint-url>` with the endpoint URL of the component.
2. You can observe the logs of the component to see the message received by the component.

