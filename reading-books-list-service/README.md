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

## Deploy Application

Please refer to the Choreo documentation under the [Develop a REST API](https://wso2.com/choreo/docs/develop-components/develop-services/develop-a-rest-api/#step-1-create-a-service-component-from-a-dockerfile) section to learn how to deploy the application.

### Use the following configuration when creating this component in Choreo:

- Build Preset: **Dockerfile**
- Dockerfile Path: `python/rest-api/Dockerfile`
- Docker Context Path: `python/rest-api`

The [endpoints.yaml](.choreo/endpoints.yaml) file contains the endpoint configurations that are used by the Choreo to expose the service.

## Execute the Sample Locally

Navigate to the Python application directory

```bash
cd choreo-sample-apps/python/rest-api
```

Run the service

```bash
pip3 install -r requirements.txt
flask run
```
