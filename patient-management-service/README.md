# 🏥 MediFlow Service - Patient Management

## 📌 Overview
The **MediFlow** service provides functionalities to manage patient data, including:
- Adding a new patient
- Retrieving patient details by name
- Listing all patients

The service exposes several REST endpoints for performing these operations.

---

## ⚡ Use Cases
### ✅ Health Check  
🔹 **Endpoint:** `/health`  
🔹 **Functionality:** Ensures the service is running.

### ➕ Add a New Patient  
🔹 **Endpoint:** `/patients`  
🔹 **Method:** `POST`  
🔹 **Functionality:** Adds a new patient by sending a JSON payload.

### 🔍 Retrieve a Patient by Name  
🔹 **Endpoint:** `/patients/{name}`  
🔹 **Method:** `GET`  
🔹 **Functionality:** Retrieves patient details by their name.

### 📋 List All Patients  
🔹 **Endpoint:** `/patients`  
🔹 **Method:** `GET`  
🔹 **Functionality:** Retrieves all patients.

---

## 🚀 Run the Sample

### 1️⃣ Set Up Your Environment
Ensure you have **Ballerina** installed. Download it from the [official Ballerina website](https://ballerina.io/download/).

### 2️⃣ Run the Service
Start the MediFlow service by running the following command:

```bash
bal run
```

## Invoke the Service

Once the service is running, it will start listening on **port 9090**. You can interact with the service using the following `curl` commands.

### 1. Health Check
Verify if the service is operational:

```bash
curl http://localhost:9090/mediflow/health
```

📌 Response:
```bash
{
  "status": "MediFlow is operational"
}

```
### 2. Add a New Patient
```bash
curl -X POST http://localhost:9090/mediflow/patients \
     -H "Content-Type: application/json" \
     -d '{
          "name": "Alice",
          "age": 30,
          "condition": "Healthy"
         }'
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
```bash
curl http://localhost:9090/mediflow/patients/Alice
```
📌 Response:
```bash
{
  "name": "Alice",
  "age": 30,
  "condition": "Healthy"
}
```
### 4. List All Patients
```bash
curl http://localhost:9090/mediflow/patients
```

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
