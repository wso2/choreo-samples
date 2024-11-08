# Choreo Sample GraphQL Service - User Store

## Overview

The Go GraphQL User Store is a sample GraphQL API built using Go that provides basic user management functionality. It allows clients to query user information, create new users, and list all users. This README provides instructions for setting up, deploying, and running the service locally or on Choreo.

## Repository File Structure

The following table provides a brief overview of key files and directories in this service.  
Note: All paths are relative to `/go/user-store`.

| Filepath               | Description                                                                                                                           |
| ---------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| `main.go`              | Contains the Go code for the GraphQL User Store service.                                                                              |
| `Dockerfile`           | Docker configuration used by Choreo to build and containerize the application.                                                        |
| `.choreo/endpoints.yaml` | Choreo-specific configuration that defines how Choreo exposes the service to the internet.                                           |

## Deploying the Application on Choreo

### Deployment Steps

1. **Component Creation Wizard**:
   - Select **Service** as the component type.
   - Choose **Go** as the buildpack.

2. **Configure Component Fields**:

    | **Field**             | **Description**                               |
    |-----------------------|-----------------------------------------------|
    | **Name**              | `GraphQL User Store Service`                          |
    | **Description**       | `A simple GraphQL service for managing users` |
    | **GitHub Account**    | `wso2`                       |
    | **GitHub Repository** | `choreo-samples`                              |
    | **Branch**            | `main`                                        |
    | **Buildpack**         | `Go`                                          |
    | **Go Project Directory** | `go-graphql-service`                              |
    | **Language Version**  | `1.x`                                         |

3. **Create and Deploy**:
   - Click **Create** to set up the component. After the component is created and built, navigate to the deploy page and select **Deploy** to deploy the service.

## Running the Service Locally

### Prerequisites

1. **Install Go**: Make sure you have Go installed on your system ([Install Go](https://golang.org/doc/install)).
2. **Install Dependencies**: Install the `graphql-go` library using:
   ```bash
   go get github.com/graphql-go/graphql
3. Clone [choreo-samples](https://github.com/wso2/choreo-samples) repository.

### To run the service locally, 
navigate to the Go application directory and start the server.

1. **Navigate to the Directory**:
   ```bash
   cd go-graphql-service
2. **Run the Service**:
    ```bash
    go run main.go
3. **Access the GraphQL Endpoint: With the service running, you can access the GraphQL endpoint at**:
    ```bash
    http://localhost:8080/graphql
## Example Queries

Here are some sample queries and mutations you can use to interact with the GraphQL User Store service.

### Query for a User by ID
This query returns information about a user based on their ID.

```graphql
query {
  user(id: "1") {
    id
    name
    email
  }
}
```
### List All Users
This query lists all users in the store.

```graphql
query {
  listUsers {
    id
    name
    email
  }
}
```
### Create a New User
This mutation creates a new user with a name and email.

```graphql
mutation {
  createUser(name: "Alice", email: "alice@example.com") {
    id
    name
    email
  }
}
```