# Getting Started with React Chat App

Let's deploy a React front-end application to consume the Published WebSocket API with Authentication.

#### Create a web application component

To host the front-end application in Choreo, you must create a web application component. To create a web application component, follow the steps given below.

1. Click **Create** under the **Component Listing** section to create a new component.
2. Click on the **Web Application** card to create a Web Application.
3. Enter a unique name and a description for the web application. You can enter the name and description given below:

    | **Field**       | **Value**                                        |
    |-----------------|--------------------------------------------------|
    | **Name**        | `Chat Client`                                    |
    | **Description** | `Frontend application for the websocket service` |

5. Click **Next**.
6. To allow Choreo to connect to your GitHub account, click **Authorize with GitHub**.
7. In the **Connect Repository** pane, enter the following information:

    | **Field**             | **Description**                               |
    |-----------------------|-----------------------------------------------|
    | **GitHub Account**    | Your account                                  |
    | **GitHub Repository** | **`choreo-samples`**                          |
    | **Branch**            | **`main`**                                    |
    | **Buildpack**         | Click **React**                               |

9. Click **Create**. This initializes the service with the implementation from your GitHub repository and takes you to the **Overview** page of the component.

#### Deploy the web application component

Once you create the web application component, you can deploy it to the Choreo runtime. To deploy the web application component, follow the steps below:

1. In the left menu, click **Build** and select the latest commit and build.
1. In the left menu, click **Deploy**.
2. In the **Set up Area** card, select **Deploy** from the split button and click to deploy. 
3. The deployment may take a few minutes to complete. See how to define and read configurations at [Develop a Web Application page](https://wso2.com/choreo/docs/develop-components/develop-a-web-application/#creating-a-web-application).
4. Once you deploy the web application, copy the **Web App URL** from the development environment card.


Although you hosted the web application, you have not configured the web application to securely invoke the service. Let's create an OAuth app in the IdP (Asgardeo) and configure the web app.

!!! Note

Before proceeding to the next step, ensure that you have published your WebSocket API. Additionally, subscribe to the API through a new application and generate the necessary credentials.

#### Configure Asgardeo (IdP) to integrate with your application

Choreo uses Asgardeo as the default identity provider for Choreo applications.

1. Access Asgardeo at [https://console.asgardeo.io/](https://console.asgardeo.io/) and sign in with the same credentials with which you signed in to Choreo.
2. In the Asgardeo Console's left navigation, click **Application** and select your Application.
4. Click the **Protocol** tab and apply the following changes:

    1. Under **Allowed grant types**, select **Code**.
    2. Select the **Public client** checkbox.
    3. In the **Authorized redirect URLs** field, enter copied webApp URL. E.g http://localhost:3000`` and click the **+** icon to add the entry.
    4. In the **Allowed origins** field, add the Web Application URL.
    6. Under **Access Token**, select **JWT** as the **Token type**.
    7. Click **Update**.
5. Click the **User Attributes** tab and apply the following changes:
    1. Select **email** as Mandatory from the **User Attribute Selection** list.

#### Step 2.1.4: Configure the web application component

Once the web application component is deployed, you can configure the web application. To configure the web application, follow the steps given below:

1. In the **Environment Card**, click **Manage Configs & Secrets**
2. Add the following configurations in the editor:
```
window.__RUNTIME_CONFIG__ = {
    VITE_APP_SIGN_IN_REDIRECT_URL: "{WebApp_URL}",
    VITE_APP_SIGN_OUT_REDIRECT_URL:"{WebApp_URL}",
    VITE_APP_CLIENT_ID: "{Asgardeo_ClientID}",
    VITE_APP_AUTH_URL:"https://api.asgardeo.io/t/{organizationHandle}",
    VITE_APP_SERVER_URL:"{Service_URL}/"
};
```

6. Click Update and save.
5. After a few seconds when the deployment is active, navigate to the web app URL. You can verify that the web app is successfully hosted.

Next, let's create a user to access the web application.

#### Step 2.1.5: Create a user in Asgardeo

To sign in to the application, the end users require user IDs. End users can self-register these user IDs in Asgardeo or request an Asgardeo user with administrative privileges to register them. For more information, see [Asgardeo Documentation - Manage users](https://wso2.com/asgardeo/docs/guides/users/manage-customers/#onboard-a-user).

In this step, you play the role of an Asgardeo user with administrative privileges who can register user IDs.

To define a user for the application, follow the steps given below:

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

To test the front-end application and connect to the WebSocket Servixe via it, follow the steps given below:

1. Access the front-end application via its web URL mentioned in the web application overview page.
2. Click **Login**, and sign in with the credentials of a user that you created in Asgardeo.
**Allow**.
