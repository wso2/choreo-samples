# Choreo Sample Go Web App - Reading List

This is a sample Go web app that helps you to get familiar with the [Choreo](https://console.choreo.dev/) platform and its managed authentication features.

## Getting Started

1. Deploy the [Reading List Service](https://github.com/wso2/choreo-sample-book-list-app/tree/main/reading-list-service) in Choreo. Refer Choreo Documentation: [Deploy Your First Service](https://wso2.com/choreo/docs/quick-start-guides/deploy-your-first-service/).

2. Follow the instructions below to build and deploy the web app in Choreo.

## Build and Deploy in Choreo

You can refer Choreo Documentation: [Deploy Your First Static Web Application](https://wso2.com/choreo/docs/quick-start-guides/deploy-your-first-static-web-application/) for a similar guide. Use below details when creating the component and deploying the app.

**Build Configs:**

Use the following build config when creating this component in Choreo.
- Build Pack: **Go**
- Port: 8080 (Or any other port you specify in the environment variable `PORT`)

**Environment Variables:**

- `API_URL`: The URL of the Reading List Service deployed in Choreo.
- `PORT`: The port on which the app will run. Default is 8080. (Optional)

Refer to the Choreo Documentation: [Apply Environment Variables to your Container](https://wso2.com/choreo/docs/devops-and-ci-cd/manage-configurations-and-secrets/#apply-environment-variables-to-your-container) for more details on how to set environment variables in Choreo.

**Deployment Configurations:**

When deploying, make sure Managed Authentication is enabled and set the following configurations.
- Post Login Path: `/dashboard`
- Post Logout Path: `/`
- Error Path: `/error`
- Protected Paths: `/dashboard`, `/addNewBook`, `/deleteBook`

## Running the App Locally

1. Refer to Choreo Documentation: [Develop Web Applications Locally with Choreo’s Managed Authentication](https://wso2.com/choreo/docs/develop-components/develop-web-applications/develop-web-applications-locally-with-managed-authentication/) to set up the proxy server needed to facilitate the managed authentication feature.

2. Create a `.env` file with the following content:
    ```env
    API_URL=<URL of the Reading List Service deployed in Choreo>
    PORT=<port> # (Optional) Default is 8080
    ```

3. Use the following commands for run the app locally:
    ```bash
    # build and run the app
    go build -o reading-list-app
    ./reading-list-app

    # or run the app directly
    go run main.go
    ```
