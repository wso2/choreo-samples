# Build A Next.js Application with a separate Backend Service

Choreo is an Internal Developer Platform (IDevP) that allows you to build, deploy, monitor, and manage your cloud-native applications effortlessly.

In this quick start guide, you will explore how to expose a service endpoint as a REST API via Choreo and securely consume the API from a Next.js web application.

You will build a simple todo list web application with a sign-in page and functionality to interact with a secure backend REST API. You will use Asgardeo, WSO2's Identity as a Service (IDaaS) solution, to secure user authentication to the web application. The application will allow users to sign in and view the todo list. On signing in, a user can view profile details and view todo lists and view description of the task separately. The application will also allow users to sign out of the application.

This guide walks you through the following steps:

- Develop, deploy the service component.
- Securely consume the golang service via your web application.
- Deploy your web application and use Asgardeo as the IDaaS provider to secure user authentication to the web application.

## Prerequisites

Before you try out this guide, complete the following:

1. Create a GitHub repository to save the service implementation. For this guide, you can fork [https://github.com/wso2/choreo-sample-apps](https://github.com/wso2/choreo-sample-apps).
2. If you are signing in to the Choreo Console for the first time, create an organization as follows:

    1. Go to [https://console.choreo.dev/](https://console.choreo.dev/), and sign in using your Google, GitHub, or Microsoft account.
    2. Enter a unique organization name. For example, `Stark Industries`.
    3. Read and accept the privacy policy and terms of use.
    4. Click **Create**.

    This creates the organization and opens the home page of the default project created for you.

    !!! info "Enable Asgardeo as the key manager"

         If you created your organization in Choreo before the 21st of February 2023, and you have not already enabled Asgardeo as the key manager, follow these steps to enable Asgardeo as the default key manager:

         1. In the Choreo Console, go to the top navigation menu and click **Organization**. This takes you to the organization's home page.
         2. In the left navigation menu, click **Settings**.
         3. Click the **API Management** tab and then click **Enable Asgardeo Key Manager**.
         4. In the confirmation dialog that opens, click **Yes**.

## Step 1: Create the service component

In this step, you are playing the role of an API developer. You will create a service and deploy it as a REST API for your web application to consume.

### Step 1.1: Create the service

Follow the steps below to create the service:

1. Go to [https://console.choreo.dev/](https://console.choreo.dev/cloud-native-app-developer) and sign in. This opens the project home page.
2. If you already have one or more components in your project, click **+ Create**. Otherwise, proceed to the next step.
3. Go to the **Service** card and click **Create**.
4. Enter a unique name and a description of the service. You can enter the name and description given below:

    | **Field**       | **Value**               |
    |-----------------|-------------------------|
    | **Name**        | `Todo List Service`  |
    | **Description** | `Manages Todo lists` |

5. Click **Next**.
6. To allow Choreo to connect to your GitHub account, click **Authorize with GitHub**.
7. If you have not already connected your GitHub repository to Choreo, enter your GitHub credentials, and select the repository you created by forking [https://github.com/wso2/choreo-examples](https://github.com/wso2/choreo-examples) to install the [Choreo GitHub App](https://github.com/marketplace/choreo-apps).

    !!! info
         The **Choreo GitHub App** requires the following permissions:<br/><br/>- Read and write access to code and pull requests.<br/><br/>- Read access to issues and metadata.<br/><br/>You can [revoke access](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/reviewing-your-authorized-integrations#reviewing-your-authorized-github-apps) if you do not want Choreo to have access to your GitHub account. However, write access is only needed to send pull requests to a user repository. Choreo will not directly push any changes to a repository.


8. In the **Connect Repository** pane, enter the following information:

    | **Field**             | **Description**                               |
    |-----------------------|-----------------------------------------------|
    | **GitHub Account**    | Your account                                  |
    | **GitHub Repository** | **`choreo--sample-apps`** |
    | **Branch**            | **`main`**                               |
    | **Build Preset**      | Click **Dockerfile** because you are creating the REST API from a Dockerfile.|
    | **Project Path**              | **`web-apps/NextJs-App/backend-service`**                    |
    | **Dockerfile Path**            | **`web-apps/NextJs-App/backend-service/Dockerfile`**                               |
    | **Docker Context Path**            | **`web-apps/NextJs-App/backend-service`**                               |

9. Click **Create**. This initializes the service with the implementation from your GitHub repository and takes you to the **Overview** page of the component.

###  Step 1.2: Deploy the service

For the REST endpoint of the service to be invokable, you need to deploy it. To deploy the service, follow the steps given below:

1. In the left navigation menu, click **Deploy**.

2. In the **Build Area** card, click **Configure & Deploy** from the split button.

!!! info

1.  To successfully build your container with Choreo, it is essential to explicitly define a User ID (UID) under the USER instruction in your Dockerfile. For reference, see [sample Dockerfile](https://github.com/wso2/choreo-sample-apps/blob/main/go/greeter/Dockerfile).

To ensure that the defined USER instruction is valid, it must conform to the following conditions:

- A valid User ID is a numeric value between 10000-20000, such as `10001` or `10500`.

- Usernames are considered invalid and should not be used. For example, `my-custom-user-12221` or `my-custom-user` are invalid User IDs.

2. Deploying the service component may take a while. You can track the progress by observing the logs. Once the deployment is complete, the deployment status changes to Active in the corresponding environment card.

3. Check the deployment progress by observing the console logs on the right of the page.
    You can access the following scans under **Build**. 

    - **The Dockerfile scan**: Choreo performs a scan to check if a non-root user ID is assigned to the Docker container to ensure security. If no non-root user is specified, the build will fail.
    - **Container (Trivy) vulnerability scan**: This detects vulnerabilities in the final docker image. 
    -  **Container (Trivy) vulnerability scan**: The details of the vulnerabilities open in a separate pane. If this scan detects critical vulnerabilities, the build will fail.

!!! info

    If you have Choreo environments on a private data plane, you can ignore these vulnerabilities and proceed with the deployment.

You have successfully created a Service component from a Dockerfile and deployed it.

## Step 2: Create the Next.js Web Application

### Step 2.1: Deploy a web application and invoke the REST API

Let's deploy a next.js front-end application to consume the API. This application is designed to personalize the todo lists based on the user ID that it obtains from its identity provider.

#### Step 2.1.1: Create a web application component

To host the front-end application in Choreo, you must create a web application component. To create a web application component, follow the steps given below.

1. In the Choreo console, select the project of the todo list application that you created in the previous steps, from the project list located on the header.
2. Click **Create** under the **Component Listing** section to create a new component.
3. On the **Web Application** card, click **Create**.
4. Enter a unique name and a description for the web application. You can enter the name and description given below:

    | **Field**       | **Value**               |
    |-----------------|-------------------------|
    | **Name**        | `Todo List Web App`  |
    | **Description** | `Frontend application for the todo list service` |

5. Click **Next**.
6. To allow Choreo to connect to your GitHub account, click **Authorize with GitHub**.
7. In the **Connect Repository** pane, enter the following information:

    | **Field**             | **Description**                               |
    |-----------------------|-----------------------------------------------|
    | **GitHub Account**    | Your account                                  |
    | **GitHub Repository** | **`choreo-sample-apps`** |
    | **Branch**            | **`main`**                               |
    | **Build Preset**      | Click **Dockerfile** since the frontend is a containerized Next.js application built using a Dockerfile|
    | **Dockerfile Path***              | **`web-apps/NextJs-App/backend-service/Dockerfile`** |
    | **Dockerfile context Path***     | **`web-apps/NextJs-App/frontend-app/`**             |
    | **Port** | **`3000`** |

9. Click **Create**. This initializes the service with the implementation from your GitHub repository and takes you to the **Overview** page of the component.

Let's consume the service through the web app. Choreo services are by default secured. To consume a service in Choreo you need an access token. Let's configure the web application to connect to an IdP (For this guide, let's use Asgardeo) to generate an access token for a user.

#### Step 2.1.2: Deploy the web application component

Once you create the web application component, you can deploy it to the Choreo runtime. To deploy the web application component, follow the steps below:

1. In the left menu, click **Deploy**.
2. In the **Build Area** card, select **Deploy** from the split button and click to deploy. 
3. The deployment may take a few minutes to complete. See how to define and read configurations at [Develop a Web Application page](https://wso2.com/choreo/docs/develop-components/develop-a-web-application/#creating-a-web-application).
4. Once you deploy the web application, copy the **Web App URL** from the development environment card.

Although you hosted the web application, you have not configured the web application to securely invoke the service. Let's create an OAuth app in the IdP (Asgardeo) and configure the web app.

#### Step 2.1.3: Configure Asgardeo (IdP) to integrate with your application

Choreo uses Asgardeo as the default identity provider for Choreo applications.

1. Access Asgardeo at [https://console.asgardeo.io/](https://console.asgardeo.io/) and sign in with the same credentials with which you signed in to Choreo.
2. In the Asgardeo Console's left navigation, click **Application**. Click **New Application** then choose **Standard based application**.
3. Provide a name for the application. For example, `todoListApp`, choose **OpenIDConnect** and Register.
4. Click the **Protocol** tab and apply the following changes:

    1. Under **Allowed grant types**, select **Code**.
    2. Select the **Public client** checkbox.
    3. In the **Authorized redirect URLs** field, enter {WebApp URL}/api/auth/callback/asgardeo. E.g http://localhost:3000/api/auth/callback/asgardeo`` and click the **+** icon to add the entry.
    4. In the **Allowed origins** field, add the Web Application URL.
    6. Under **Access Token**, select **JWT** as the **Token type**.
    7. Click **Update**.
5. Click the **User Attributes** tab and apply the following changes:
    1. Select **email** and **username** as Mandatory from the **User Attribute Selection** list.
#### Step 2.1.4: Configure the web application component

Once the web application component is deployed, you can configure the web application. To configure the web application, follow the steps given below:

1. In the **Environment Card**, click **Manage Configs & Secrets**, which will take you to the window to add configurations. 
2. Create a new configuration, and select **ConfigMap** as config Type and **File Mount** as Mount Type.
3. Give a meaningful config name, add the mount path as `/app/.env` and add the following configurations in the editor:
```
SECRET={a random secret}
NEXTAUTH_SECRET={a random secret}
ASGARDEO_CLIENT_ID={Asgardeo client id of the Asgardeo application created}
ASGARDEO_CLIENT_SECRET={Asgardeo client secret of the Asgardeo application created}
ASGARDEO_SCOPES=openid email profile
ASGARDEO_SERVER_ORIGIN=https://api.asgardeo.io/t/{org-name}
TODO_API_BASE_URL={project URL of the todo list service}
```

!!! info

    1. You can copy the project URL of the todo list service from the overview page of the service component.

    2. See more details on NEXTAUTH_URL and NEXTAUTH_SECRET configurations at [Next.js Official Documentation] (https://next-auth.js.org/configuration/options)


4. Once the web application is deployed, copy the **Web App URL** from the development environment card.
5. Navigate to the **DevOps** view from the left pane and click Configs & Secrets and add a new config as `NEXTAUTH_URL= {Copied web app url}` to the created config map at the deployment . 
6. Click save.
5. After a few seconds when the deployment is active, navigate to the copied web app URL. You can verify that the web app is successfully hosted.

Next, let's create a user to access the web application.

#### Step 2.1.5: Create a user in Asgardeo

To sign in to the **todoListApp** application and create private todo lists, the end users require user IDs. End users can self-register these user IDs in Asgardeo or request an Asgardeo user with administrative privileges to register them. For more information, see [Asgardeo Documentation - Manage users](https://wso2.com/asgardeo/docs/guides/users/manage-customers/#onboard-a-user).

In this step, you play the role of an Asgardeo user with administrative privileges who can register user IDs.

To define a user for the **todoListApp** application, follow the steps given below:

1. Go to the [Asgardeo Console](https://console.asgardeo.io/) and click **Users**.
2. On the **Users** page, click **+ New User**.
3. In the **Add User** dialog, enter values for **Username (Email)**, **First Name**, and **Last Name**.
4. Under **Select the method to set the user password**, select **Invite the user to set the user password**, and make sure you select **Invite Via Email**.

5. Click **Finish**.

    Asgardeo will send you an email to set your password.  It will also open your user profile on a separate page.

6. In your user profile, toggle the **Lock User** switch to unlock your profile.
7. In the email you receive from Asgardeo (with the subject **Here is your new account in the organization <ORGANIZATION_ID>**), click **Set Password**.
8. In the **Enter new password** and **Confirm password** fields, enter a password that complies with the given criteria, and then click **Proceed**.

#### Step 2.1.6: Log in and test the front-end application

To test the front-end application and send requests to the **Todo List Service** REST API via it, follow the steps given below:

1. Access the front-end application via its web URL mentioned in the web application overview page.
2. Click **Login with Asgardeo**, and sign in with the credentials of a user that you created in Asgardeo.
**Allow**.

Congratulations! You have successfully created Next.js Web Application with a separate backend. You can navigate through pages and view the todo lists. Since the web application is created for demonstration purposes only, it does not have the functionality to add or delete todo lists currently.