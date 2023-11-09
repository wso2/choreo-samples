# Data service integration

The "Data Service Integration" sample demonstrates how to create an integration that integrates with a relational database management system (RDBMS) and exposes employee information stored in the database as a REST API. To use this sample with Choreo, follow these steps:

## Setting up the database
- Start a MySQL instance and create a database (for example, `misampledb`).
- Import the [script](resources/misampledb.sql) to create the schema and populate employee data.
- Identify the publicly accessible connection URL and credentials for the database.

## Create a MI Integration
- Login to [Choreo console](https://console.choreo.dev/)
- Create a `Service` component.
- Provide a name and description for the component.
- Authorize and select the GitHub details
- Select the `GitHub Account` and the forked repository for `GitHub Repository`
- Select the `Branch` as `main`
- Select `WSO2 MI` as `Build Pack`
- Enter `mi-data-service` as the `Project Path`
- Click on "Create" to create the component.
- Once the component is created, build and deploy the component.

### Setting up Environment variables
- The database details need to be passed as environment variables.
- To do this, go to the DevOps portal and select the component and "Configs & Secrets" to configure the environment variables.
- Click on "Create" and select "Environment Variables" as the configuration type.
- Give a name for the `Config Name`
- Add key-value pairs to register them as environment variables. For example:
  - `DB_DRIVER_CLASS` for `Key` and `com.mysql.jdbc.Driver` for `Value`
  - `DB_CONNECTION_URL` for `Key` and `jdbc:mysql://<public ip or hostname>:3306/misampledb` for `Value`
  - `DB_USER` for `Key` and db username for `Value`
  - `DB_PASS` for `Key` and db password for `Value`
  - Click on `Finish` to apply the changes

Once done go to the Choreo Test console and use the Swagger console to try out the API.
