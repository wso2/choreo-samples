# Choreo Question Answering Bot Example - Backend Service

Welcome to the Choreo Question Answering Bot Example! This application is designed to help you get familiar with the Choreo platform and its features.

## Overview

This service demonstrates answering user questions based on product documentation. The service queries the Pinecone vector database to find the most relevant document and then uses the Azure OpenAI service to find the most relevant answer to the question from the document.

### Getting Started

To use the example:
1. **Create Azure OpenAI embedding and chat model deployments and obtain the keys and configs**: [Create deployments](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/create-resource?pivots=web-portal) for the Azure OpenAI embedding and chat models and obtain the following configs for the Azure OpenAI service.
    ```
    API Key
    API Base URL
    API Version
    Deployment ID of the embedding model
    Deployment ID of the chat model
    ```
2. **Set up the Pinecone Vector Database**:
    - Sign up and log in to [Pinecone](https://www.pinecone.io/).
    - Create an index and populate the database using the data loader. Alternatively, you can manually add the data to the database.
    - Click on `API Keys` and obtain the API key.
3. **Fork the Repository**: Fork this repository to your GitHub account.
4. **Clone Your Forked Repository**:
   ```
   git clone [URL of your forked repository]
   ```
5. Log into [Choreo](https://console.choreo.dev/)
6. Create a project in choreo and create a new service component by providing the repository path for the `question-answering-backend`, with the `Python` buildpack and `3.10.x` as the Python version.
7. Configure the following configs as environment variables and deploy the component.
    ```
    OPENAI_API_KEY : <Azure OpenAI API Key>
    OPENAI_API_BASE : <Azure OpenAI API Base URL>
    EMBEDDING_MODEL : <Azure OpenAI Embedding Model Deployment ID>
    CHAT_MODEL : <Azure OpenAI Chat Model Deployment ID>
    PINECONE_API_KEY: <Pinecone API Key>
    PINECONE_INDEX_NAME : <Pinecone Index Name>
    PINECONE_ENVIRONMENT : <Pinecone Environment Name>
    ```

### Contribution & Feedback

We greatly value community insights:

- **Contribute**: Got a new example or an enhancement? We'd love to incorporate it.
- **Feedback**: Encounter issues or have suggestions? Please raise them under this repository's [issues section](https://github.com/wso2/choreo-samples/issues).
