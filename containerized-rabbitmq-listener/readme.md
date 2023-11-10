# Containerized RabbitMQ Listener

This is a simple example of a containerized RabbitMQ listener. 

## Prerequisites
- Access to a RabbitMQ server

## Deploying in Choreo

1. Create an `Event Handler` component
    - Fork this repository
    - Login to [Choreo](https://wso2.com/choreo/)
    - Navigate to create a `Event Handler` component
    - Provide a name and description for the component
    - Authorize and select the GitHub details
    - Select the `GitHub Account` and the forked repository for `GitHub Repository`
    - Select the `Branch` as `main`
    - Select `Ballerina` as `Buildpack`
    - Select `containerized-rabbitmq-listener` as the `Ballerina Project Directory`
    - Click on "Create" to create the component

2. Build and deploy the component
    - Once the component is created, add the following environment variables:
        - `HOST` - The RabbitMQ server host
        - `VHOST` - The RabbitMQ virtual host
        - `USERNAME` - The RabbitMQ username
        - `PASSWORD` - The RabbitMQ password
    - Deploy the component


## Testing the Component
Send a message to the "TestQueue" queue using a RabbitMQ producer. The message should be logged in the Choreo console.