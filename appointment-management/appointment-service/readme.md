# Appointment Management System

## Use Case

This sample demonstrates an appointment booking system designed to streamline the process of scheduling of healthcare appointments, with a backend for managing the appointments. The backend uses a database connection to connect with a database created in Choreo.

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

### Step 01: Create the service component

1. Fork the repository
2. Create a Service component using `NodeJS` buildpack with language version `20.x.x` and link the `appointment-management/appointment-service` directory

### Step 02: Create a database connection

1. In the left navigation menu, click `Dependencies` and then click `Connections`.
2. Click `Database` Card to create a database connection
3. Click on the database you want to connect to.
4. Enter `database_connection` as the name and description for connection.
5. Under Environment Configuration, select credentials for each database and databases for each environment.

### Step 03: Consume the created database connection

1. Copy the code snippet for component.yaml v1.1 from the inline how-to guide of the previously created connection.
2. Add it to the `appointment-management/appointment-service/.choreo/component.yaml` file as per the instructions in the guide.
3. Commit the changes to your repository.
4. Build the component with the latest commit and deploy it.
5. Try out the APIs with the test console

##### Note
If you use a different name for the connection, update the environment variable names in `appointment-management/appointment-service/database.js`
