# Appointment Management System

## Use Case

This sample demonstrates an appointment booking system designed to streamline the process of scheduling healthcare appointments, featuring a backend for managing appointments and a frontend web application. The backend uses a database connection to connect with a database created in Choreo. 


## Prerequisites

Database connections can only be created for databases in the marketplace, so you will need to have at least one database in the marketplace. Follow these steps to create a database in Choreo and add it to the marketplace.

<details>
<summary> Step 01 : Create a database in Choreo</summary>

1. Log in to Choreo
2. From the organizations list on the header, select your Organization.
3. . In the left navigation menu, click `Dependencies` and then `Databases`.
4. Click `Create` and select `MySQL` as the database type.
5. Provide a display name, choose your preferred cloud provider, and then select the region and service plan for your database
6. Click on `Create` button.
7. Wait for the created database server to power on.
8. Click the `Databases` tab.
9. Click on `Create` and provide a database name and Click on `Create`
10. Repeat step 09 to create databases for each of your environments if you wish to use different databases across different environments.
</details>

<details>
<summary> Step 02 : Add the created databases to Marketplace</summary>

1. To add a Choreo-managed database to the Marketplace, you must register at least one credential for it.
2. Click to expand the database for which you want to register credentials, then click `Add Credentials`.
3. Follow the instructions to add credentials for the created database, which will be used when establishing the database connection.
4. Click `+Add to Marketplace` on the created database.
5. Repeat steps 02-04 for all the databases you created.
</details>

## Deploy in Choreo

To deploy this demo use case in Choreo, follow these steps:

### Step 01: Create the service component for appointment service

1. Fork the repository
2. Create a Service component using `NodeJS` buildpack with language version `20.x.x` and link the `appointment-management/appointment-service` directory

### Step 02: Create a database connection

1. In the left navigation menu, click `Dependencies` and then click `Connections`.
2. Click `Database` Card to create a database connection
3. Click on the database you want to connect to.
4. Enter `database_connection` as the name and description for connection.
5. Under Environment Configuration, select credentials for each database and databases for each environment.

### Step 03: Consume the created database connection

1. Copy the code snippet for component.yaml v1.1 from the inline how-to guide of the  created connection.
2. Add it to the `appointment-management/appointment-service/.choreo/component.yaml` file as per the instructions in the guide.
3. Commit the changes to your repository.
4. Build the component with the latest commit and deploy it.
5. Try out the APIs with the test console

### Step 04: Create a service component for Backend for Frontend

1. Fork the repository
2. Create a Service component using `NodeJS` buildpack with language version `20.x.x` and link the `appointment-management/web-portal/backend` directory

### Step 05:  Create a service connection for service to service communication

1. In the left navigation menu, click `Dependencies` and then click `Connections`.
2. Click `Service` Card to create a service connection
3. Click on the service card corresponding to the appointment service.
4. Enter `appointment_connection` as the name and description and create the connection.

### Step 06: Consume the created service connection

1. Copy the code snippet for component.yaml v1.1 from the inline how-to guide of the  created connection.
2. Add it to the `appointment-management/web-portal/backend/.choreo/component.yaml` file as per the instructions in the guide.
3. Commit the changes to your repository.
4. Build the component with the latest commit and deploy it.
5. Try out the APIs with the test console

### Step 07: Create a web application component for frontend

1. Fork the repository
2. Create a web application component using the `React` buildpack with node version `20`, a build command of `npm run build`, and a build path set to `/build`. Link it to the `appointment-management/web-portal/frontend` directory.

### Step 08:  Create a service connection for web application to service communication

1. In the left navigation menu, click `Dependencies` and then click `Connections`.
2. Click `Service` Card to create a service connection
3. Click on the service card corresponding to the service created for backend for frontend.
4. Enter `backend_connection` as the name and description and create the connection.

### Step 09: Consume the created service connection

1. Copy the code snippet from the inline how-to guide of the created connection.
2. Navigate to deploy page and select `Configure & Deploy` button. This opens the Configure & Deploy pane, where you can specify values for the mount file.
3. Paste the code snippet copied in step 01 as the `config.js` file content and click `Next`. 
4. Under Authentication Settings, make sure that you have the Managed authentication with Choreo toggle enabled.
5. Deploy the web application

In this use case we are using Choreo managed authentication to authenticate with the backend. In the development environment, you can use the Choreo Built-in Identity Provider, while Asgardeo can be used as the Identity Provider in the production environment.

<details>
<summary> Follow below steps to configure Choreo Built-in Identity Provider.</summary>

1. Go to your organization
2. In the left navigation menu, click `Setting` and then click `Application Security`.
3. Click on the Manage link on "Choreo Built-in Identity Provider" card
4. Select the file YOUR_FORKED_REPO/web-portal/frontend/userstore.cv and click the `Re-upload` button to update the Choreo Identity Provider.
5. Use the uploaded credentials to login and tryout the web application

For more information, see our [documentation](https://wso2.com/choreo/docs/administer/configure-a-user-store-with-built-in-idp/)
</details>
<details>

<summary> Follow below steps to configure Asgardeo as Identity Provider.</summary>

1. Make sure you are within the created web application
2. In the left navigation menu, click `Setting` and then click `Authentication Keys`, then select `Production` tab.
3. Select Asgardeo as the identity provider.
4. Go to https://console.asgardeo.io/ and create a new user to sign in to the wbe application from `User Management` settings
5. Create a new standard based application and configure it using the provided OIDC App Configuration information.
6. Copy Client ID and Client Secret to Choreo console's OIDC App configuration and click on `Add Keys` button. 


</details>



##### Note
If you use different names for the connections, update the environment variable names in `appointment-management/appointment-service/database.js` and `appointment-management/web-portal/backend/server.js` by following the instructions provided in the inline guide of the created connections.
