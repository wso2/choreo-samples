# Choreo Sample - Go Reading List Web App

This is a sample Go web app that helps you to get familiar with the [Choreo](https://console.choreo.dev/) platform and its managed authentication features.

## Prerequisites

1. Deploy the [Reading List Service](https://github.com/wso2/choreo-sample-book-list-service) in Choreo. Refer Choreo Documentation: [Deploy Your First Service](https://wso2.com/choreo/docs/quick-start-guides/deploy-your-first-service/) on how to deploy the service.
2. Fork this repository to your GitHub account.

## Deploy Application

You can refer Choreo Documentation: [Deploy Your First Static Web Application](https://wso2.com/choreo/docs/quick-start-guides/deploy-your-first-static-web-application/) for a similar guide on how to deploy a static web application.

1. Select `Web Application` Card from Component Creation Wizard.
2. Authorize your GitHub account and select the forked repository.
3. Use the following configurations.

    | **Field**           | **Description**                               |
    |---------------------|-----------------------------------------------|
    | GitHub Repository   | `choreo-samples`                              |
    | Branch              | `main`                                        |
    | Component Directory | `go-reading-list-web-app`                     |
    | Name                | Reading List Web App                          |
    | Description         | Go web app to manage your reading list        |
    | Buildpack           | `Go`                                          |
    | Language Version    | 1.x                                           |
    | Port                | `8080` (Or the port you specify in the environment variable `PORT`) |

4. Click on "**Create**". Once the component creation is complete, you will see the component overview page.
5. While the component is building, go to **DevOps** > **Configs & Secrets** to create environment variables needed.
6. Click on "**Create**" and create the following environment variables. Refer to the Choreo Documentation: [Apply Environment Variables to your Container](https://wso2.com/choreo/docs/devops-and-ci-cd/manage-configurations-and-secrets/#apply-environment-variables-to-your-container) for more details on how to set environment variables in Choreo.

    | **Key**    | **Value**                                                                 |
    |------------|---------------------------------------------------------------------------|
    | `API_URL`    | The URL of the Reading List Service deployed in Choreo.                   |
    | `PORT`       | The port on which the app will run. Default is 8080. (Optional)           |

7. Go back to Component **Overview** page. Once the build is complete, Go to **Deploy** page and click on "**Configure and Deploy**" button.
8. In the Authentication section, make sure "**Managed Authentication**" is enabled and set the following configurations.

    | **Field**           | **Description**                               |
    |---------------------|-----------------------------------------------|
    | Post Login Path     | `/dashboard`                                  |
    | Post Logout Path    | `/`                                           |
    | Error Path          | `/error`                                      |
    | Protected Paths     | `/dashboard`, `/addNewBook`, `/deleteBook`    |

9. Click "**Deploy**" to deploy the component.

## Running the Sample App Locally

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
