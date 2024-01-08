# Choreo Sample Python REST API - Reading List

## Repository File Structure

The below table gives a brief overview of the important files in the service.\
Note: The following file paths are relative to the path /python/rest-api/

| Filepath               | Description                                                                                                                                                  |
| ---------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| app.py                 | The Python based service code.                                                                                                                               |
| Dockerfile             | Choreo uses the Dockerfile to build the container image of the application.                                                                                  |
| .choreo/endpoints.yaml | Choreo-specific configuration that provides information about how Choreo exposes the service.                                                                |
| openapi.yaml           | OpenAPI contract of the service. This is needed to publish our service as a managed API. This openapi.yaml file is referenced by the .choreo/endpoints.yaml. |

### Prerequisites
1. Fork the repositoy

## Deploy Application

Please refer to the Choreo documentation under the [Develop a REST API](https://wso2.com/choreo/docs/develop-components/develop-services/develop-a-rest-api/#step-1-create-a-service-component-from-a-dockerfile) section to learn how to deploy the application.

You can select either Docker or Go as buildpacks. Fill as follow according to selected Buildpack.

1. Select `Service` Card from Component Creation Wizard
2. Select `Python` as the buildpack. Fill as follow according to selected Buildpack.

    | **Field**             | **Description**                               |
    |-----------------------|-----------------------------------------------|
    |Name           | Reading books list service              |
    |Description    | reading books list service        |
    | **GitHub Account**    | Your account                                  |
    | **GitHub Repository** | choreo-samples |
    | **Branch**            | **`main`**                               |
    | **Buildpack**      | `Python` |
    | **Select Go Project Directory**       | reading-books-list-service-python|
    | **Select Language Version**              | 3.10.x |

3. Click Create. Once the component creation is complete, you will see the component overview page.
4. Deploy the created component

The [endpoints.yaml](.choreo/endpoints.yaml) file contains the endpoint configurations that are used by the Choreo to expose the service.

`Procfile` is added to specify the entrypoint.

## Execute the Sample Locally

Navigate to the Python application directory

```bash
cd reading-books-list-service-python
```

Run the service

```bash
pip3 install -r requirements.txt
flask run
```
