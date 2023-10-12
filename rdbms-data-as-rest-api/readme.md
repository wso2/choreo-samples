Use template (RDBMS Data as REST API) to expose data as REST API with basic CRUD operations (Insert, Select, Update and Delete) from a MySQL database.

## Use-case
When the service is invoked, relevant CRUD operations will be performed in the database. This template can be used to expose data that resides in a MySQL database using CRUD operations. In this use case, the data is exposed as a REST service.

## Prerequisites
* Pull the template from central  
`bal new -t choreo/rdbms_data_as_rest_api <newProjectName>`

* Create a database in MySQL 
```
CREATE DATABASE company;
```

* Using  this `company` database, create `employees` table using following command.

```
CREATE TABLE employees (EmployeeId int(11) NOT NULL, FirstName varchar(50) NOT NULL, LastName varchar(50) DEFAULT NULL, Email varchar(255) NOT NULL, Designation varchar(50) NOT NULL, PRIMARY KEY(EmployeeId));
```

* Configure values for `host`, `port`, `user`, `password`, and `database`. 

## Run the template
Run the Ballerina project created by the service template by executing `bal run` from the root.

Once successfully executed, Listener will be started at port 8090. Then you need to invoke the service using the following  HTTP requests.

* To insert an employee

    First, create a file named `employee-payload.json` , and define the JSON payload to insert new data as shown below.
    ```
    {
        "employeeId": 1,
        "firstName": "Edgar",
        "lastName": "Codd",
        "email": "edgar@example.com",
        "designation": "SoftwareEngineer"
    }
    ```
    Next, navigate to the location where the `employee-payload.json` file is stored, and execute the following HTTP request:
    ```
    $ curl -v -X POST -H "Content-Type:application/json" -d@employee-payload.json http://localhost:8090/company/employees
    ```
* To get employees who have a designation "SoftwareEngineer"

    ```
    $ curl -v -X GET -H "Content-Type:application/json" http://localhost:8090/company/employees?designation=SoftwareEngineer
    ```
* To update an employee detail

    First, create a file named `employee-update-payload.json` , and define the JSON payload to update `employee` detail as shown below.
    ```
    {
        "employeeId": 1,
        "firstName": "Edgar",
        "lastName": "Codd",
        "email": "edgar@example.com",
        "designation": "TechLead"
    }
    ```
    Next, navigate to the location where the `employee-update-payload.json` file is stored, and execute the following HTTP request:
    ```
    $ curl -v -X PUT -H "Content-Type:application/json" -d@employee-update-payload.json http://localhost:8090/company/employees
    ```
* To delete an employee

    ```
    $ curl -v -X DELETE -H "Content-Type:application/json" http://localhost:8090/company/employees?employeeId=1
    ```
