# Choreo Model Gateway Example

Welcome to the Choreo Model Gateway Example! This service is designed to help you get familiar with the Choreo platform and its features.

## Overview

This example is a Ballerina service which acts as a model gateway in order to detect Personal Identifiable Information (PII) in text inputs prior to sending them to hosted machine learning models (e.g., LLMs). The example demonstrates the usage of implementing a model gateway for Azure OpenAI completion, chat and embedding models.

### Getting Started

To use this example:

1. **Create Azure OpenAI model deployments and obtain the configs**: [Create deployments](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/create-resource?pivots=web-portal) for the Azure OpenAI completion, chat and embedding models and obtain the following configs for the Azure OpenAI service.
    ```
    API Key
    Service URL
    API Version
    ```
2. **Fork the Repository**: Fork this repository to your GitHub account.
3. **Clone Your Forked Repository**:
   ```
   git clone [URL of your forked repository]
   ```
4. Log into [Choreo](https://console.choreo.dev/)
5. Create a project and create a service type component with the Ballerina preset.
6. Set the following configurables when prompted at the component deployment.
    ```
    azureOpenAIToken: API Key
    azureOpenAIServiceUrl: Service URL
    azureOpenAIApiVersion: API Version
    ```
7. **Try Out**: Try out the functionality of the model gateway by sending requests to the corresponding resources of the deployed service with the relevant payloads (The URL pattern and the payload schemas are the same as what is expected by the Azure OpenAI API).
Note: The `deploymentId` path parameter in the service resources corresponds to the respective names of the model deployments.

### Contribution & Feedback

We greatly value community insights:

- **Contribute**: Got a new example or an enhancement? We'd love to incorporate it.
- **Feedback**: Encounter issues or have suggestions? Please raise them under this repository's [issues section](https://github.com/wso2/choreo-samples/issues).
