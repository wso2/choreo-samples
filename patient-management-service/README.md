# Patient Management Service (Mediflow) - Ballerina

This is a simple patient management REST service developed using Ballerina. This service provides functionalities to manage patient data, including adding a new patient, retrieving patient details by name, and listing all patients.

## Deploy in Choreo

Follow these steps to deploy the application in Choreo.

1. Create a component
     - Sign in to [Choreo](https://wso2.com/choreo/)
     - If you already have one or more components in your project, click **+ Create**. Otherwise, click the **Service** card. 
     - Provide a name and description for the component.
     - Click **`Try with Sample URL`**.
     - Select `Ballerina` as the `Buildpack`.
     - Select `patient-management-service` as the `Ballerina Project Directory`.
     - Click **Create**. Once the component is created, the initial build will trigger automatically, generating a container image.
2. Build and deploy the component
     - After the build completes, go to the left navigation menu and click **Deploy**. 
     - Deploy the service.

## Test the service
You can go to the left navigation menu, click **Test**, and use the OpenAPI Console to test the service endpoints.

### 1. Health check
Verify if the service is operational:

**Endpoint:** `/health`
**Method:** `GET`

📌 Response:
```bash
{
  "status": "MediFlow is operational"
}
```

### 2. Add a new patient

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
### 3. Retrieve a patient by name

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

### 4. List all patients

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
