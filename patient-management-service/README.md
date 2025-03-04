# Patient Management Service (Mediflow) - Ballerina

Sample for Patient Management Service service.

### Prerequisites
1. Fork the repositoy

## Getting started

Please refer to the Choreo documentation under the [Develop an Application with Buildpacks](https://wso2.com/choreo/develop-components/deploy-an-application-with-buildpacks) to learn how to deploy the application.

1. Click `Create` button in the Project Overview Page.
2. Select `Service` Card from Component Creation Wizard.
3. Select `Ballerina` as the buildpack. Fill as follow according to selected Buildpack.

    | **Field**             | **Description**                               |
    |-----------------------|-----------------------------------------------|
    |Name           | Patient Management Ballerina Service |
    |Description    | Patient Management (Mediflow) Ballerina Service  |
    | **GitHub Repository** | choreo-samples (Click **`Try with Sample URL`**) |
    | **Branch**            | **`main`**                               |
    | **Buildpack**      | Ballerina|
    | **Select Ballerina Project Directory**       | patient-management-service |

4. Click Create. Once the component creation is complete, you will see the component overview page.
5. Deploy the created component.

## Testing
The **MediFlow** service provides functionalities to manage patient data, including:
- Adding a new patient
- Retrieving patient details by name
- Listing all patients

You can test the service in the `Test Console` Page. You can find it in the side drawer.

### 1. Health Check
Verify if the service is operational:

**Endpoint:** `/health`
**Method:** `GET`

📌 Response:
```bash
{
  "status": "MediFlow is operational"
}
```

### 2. Add a New Patient

**Endpoint:** `/patients`  
**Method:** `POST` 

```bash
{
  "name": "Alice",
  "age": 30,
  "condition": "Healthy"
}
```
📌 Response:
```bash
{
  "message": "Patient added",
  "patient": "{
    "name": "Alice",
    "age": 30,
    "condition": "Healthy"
  }"
}
```
### 3. Retrieve a Patient by Name

**Endpoint:** `/patients/{name}`  
**Method:** `GET`  

📌 Response:
```bash
{
  "name": "Alice",
  "age": 30,
  "condition": "Healthy"
}
```

### 4. List All Patients

**Endpoint:** `/patients`  
**Method:** `GET`  

📌 Response:
```bash
{
  "alice": "{
    "name": "Alice",
    "age": 30,
    "condition": "Healthy"
  }"
}
```
