# Choreo Sample GraphQL Service - Reading List

## Repository File Structure

The below table gives a brief overview of the important files in the greeter service.\
Note: The following file paths are relative to the path /ballerina/readling-list

| Filepath               | Description                                                                                   |
| ---------------------- | --------------------------------------------------------------------------------------------- |
| service.bal            | GraphQL service code written in the Ballerina language.                                       |
| Ballerina.toml         | Ballerina configuration file.                                                                 |
| .choreo/endpoints.yaml | Choreo-specific configuration that provides information about how Choreo exposes the service. |

## Deploy Application

Please refer to the Choreo documentation under the [Develop a Ballerina GraphQL API](https://wso2.com/choreo/docs/develop-components/develop-services/develop-a-ballerina-graphql-api/) section to learn how to deploy the application.

### Use the following configuration when creating this component in Choreo:

- Build Pack: **Ballerina**
- Project Path: `/reading-list-graphql`

The [endpoints.yaml](.choreo/endpoints.yaml) file contains the endpoint configurations that are used by the Choreo to expose the service.

### Test the service in Choreo

Deploy the created component in Choreo and navigate to the test page. In the GraphQL console, execute the below sample query to add a book item to the reading list:

```
mutation { addBook(book: {title: "Sample Book Name", author: "Test Author"}) { id title author status } }
```

## Execute the Sample Locally

Navigate to the Ballerina GraphQL application directory

```bash
cd choreo-sample-apps/ballerina/readling-list
```

Run the service

```shell
bal run
```

Execute the following sample cURL command to add a book item to the reading list:

```shell
curl -X POST -H "Content-type: application/json" -d '{ "query": "mutation { addBook(book: {title: \"Sample Book Name\", author: \"Test Author\"}) { id title author status } }" }' 'http://localhost:8090'
```
