# Choreo Question Answering Bot Example

Welcome to the Choreo Question Answering Bot Example! This application is designed to help you get familiar with the Choreo platform and its features.

## Overview

This application is a chat bot for answering questions based on product documentation using AI. It allows uploading the docuemnt contents along with their embeddings to a vector database and asking related question through the chat UI. This sample uses a subset of Choreo documentation. It's built using the Choreo platform, showcasing its capabilities in building and deploying multi-user web applications.

## Directory Overview

The repository is structured into distinct sections:

- **Data loader**: Program to read document contents from a Google spreadsheet and upload to a Pinecone vector database index along with the embeddings.
- **Backend** - Python backend microservice that handles the application logic. It retrieves the relevant documents from the vector database and uses the Azure OpenAI service to find the most relevant answer to the question from the document.
- **Frontend**: React web frontend with auth handled through Asgardeo (Similar to using any third party IDP).

### Getting Started

To engage with these examples:

1. **Fork the Repository**: Begin by forking this repository to your GitHub account.
2. **Clone Your Forked Repository**:
   ```
   git clone [URL of your forked repository]
   ```
3. Log into [Choreo](https://console.choreo.dev/)
4. Create a mono repo project and create the components based on the READMEs in the respective directories.
    - [Data Loader](./question-answering-data-loader/README.md)
    - [Backend Service](./question-answering-backend/README.md)
    - [Frontend](./question-answering-app-frontend/README.md)

### Contribution & Feedback

We greatly value community insights:

- **Contribute**: Got a new example or an enhancement? We'd love to incorporate it.
- **Feedback**: Encounter issues or have suggestions? Please raise them under this repository's [issues section](https://github.com/wso2/choreo-samples/issues).
