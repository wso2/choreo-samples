# Choreo Question Answering Bot Example - Frontend

Welcome to the Choreo Question Answering Bot Example! This application is designed to help you get familiar with the Choreo platform and its features.

## Overview

This react webapp serves as the frontend for the question answering bot. The webapp allows users to ask questions and get answers based on documentation from the bot.

### Getting Started

To use this example:

1. **Fork the Repository**: Begin by forking this repository to your GitHub account.
2. **Clone Your Forked Repository**:
   ```
   git clone [URL of your forked repository]
   ```
3. Log into [Choreo](https://console.choreo.dev/)
4. **Configure Asgardeo as an IDP**: [Configure Asgardeo as an IDP](https://wso2.com/choreo/docs/administer/configure-an-external-idp/configure-asgardeo-as-an-external-idp/) in your Choreo organization.
5. Deploy and publish the [`question-answering-backend`](../question-answering-backend/) in Choreo. Refer to the [README](../question-answering-backend/README.md) for more information.
6. Log into [Choreo Developer Portal](https://devportal.choreo.dev/) and create a new application.
7. In the **Credentials** section select the IDP configured in (4) for production.
8. [Subscribe to the `question-answering-backend`](https://wso2.com/choreo/docs/consuming-services/consuming-a-sevice/#subscribe-to-an-api) API through the created dev portal application.
8. In the Choreo console create a new component of type `Web Application` by providing the repositpry path for `question-answering-app-front-end`, with `React` build preset and the following information:
   ```
    Build Command: npm install && npm run build
    Build Output: dist
    Node Version: 16.18.0
   ```
9. Build and deploy the component.
10. Add the config file with the following information as a configmap and specify the mount path as `/usr/share/nginx/html/config.js`.
    ```
    window.config = {
        redirectUrl: <URL-of-the-deployed-webapp>,
        asgardeoClientId: <asgardeo-client-id (obrained in step(4))>,
        asgardeoBaseUrl: "https://api.asgardeo.io/t/<your-asgardeo-org-name>",
        choreoApiUrl: <URL-of-the-backend-service-deployed-in-Choreo>,
    };
    ```

### Contribution & Feedback

We greatly value community insights:

- **Contribute**: Got a new example or an enhancement? We'd love to incorporate it.
- **Feedback**: Encounter issues or have suggestions? Please raise them under this repository's [issues section](https://github.com/wso2/choreo-samples/issues).