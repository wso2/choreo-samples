# Choreo Samples

This repository contains a collection of sample projects ready to deploy in [Choreo](https://console.choreo.dev/), a developer platform for easily taking your work to production. These samples demonstrate various use cases and provide examples for different scenarios.

## Samples

You can explore the `README.md` of each sample in its respective directory to learn more about how to use Choreo for specific use cases.

## Getting Started

Follow these steps to get started with these Choreo samples:

1. Fork this repository to your GitHub account.
2. Follow the instructions provided in the respective sample's README to deploy and test the sample.


## Contributing
If you'd like to contribute to this repository, feel free to submit pull requests. Make sure to refer the [pull request template](pull_request_template.md).

### Adding a new sample
If you'd like to add a new sample to this repository, please follow the below steps:
1. Create a new directory for the sample.
2. Add a `README.md` file to the directory with the following information:
    - A brief description of the sample.
    - Instructions on how to deploy the sample in Choreo.
    - Instructions on how to test the sample.
3. Add a metadatata file for the sample in the `.samples` directory. The metadata file should be named as `<sample-name>.yaml`. The metadata file should contain the following information:
    - `name`: Name of the sample.
    - `description`: A brief description of the sample.
    - `componentType`: Component type of the sample. Examples:
        - `service`
        - `web-application`
        - `webhook`
        - `manual-task`
        - `scheduled-task`
        - `event-handler`
        - `test-runner`
        - `many`
    - `buildPack`: Build pack of the sample. Examples:
        - `node`
        - `python`
        - `java`
        - `ballerina`
        - `dockerfile`
        - `many`
        - `wso2-mi`
    - `repositoryUrl`: The GitHub repository URL of the sample. https://github.com/wso2/choreo-samples/
    - `componentPath` : The path to the component in the repository. This should be the path to the directory that contains the sample.
    - `thumbnailPath`: The path to the thumbnail image of the sample. This should be the path to the thumbnail image relative to the `repositoryUrl` directory. It is recommended to add the thumbnail to the `.samples/icons` directory and refer it here.
    - `documentationPath`: The path to the documentation/README.md of the sample. This should be the path to the documentation relative to the `repositoryUrl` directory.
    - `tags`: Tags for the sample. This should be a list of strings.

4. For Quick Deployable Samples:
    - Ensure the `componentType` is one of the following:
        - `service`
        - `web-application`
        - `manual-task`
        - `scheduled-task`
    - Ensure the presence of a `Dockerfile` in the sample's root directory. (Make sure you manually build it first)
    - In the `<sample-name>.yaml` file, ensure the `imageVersion` is provided.
    - Ensure the following additional files are included, depending on the component type:
        - For **services**, include an `endpoints.yaml` file in the `/.choreo` directory of the component.
        - If the **service** is a **REST** service, include an OpenAPI specification YAML file in your sample's directory, and specify its relative path from the **sample root** in the `schemaFilePath` field in `endpoints.yaml`.
    - **When making a change that affect the image of the sample**: Bump the `imageVersion`


### `endpoints.yaml` Template


```yaml
version: <Version Number>

# +required List of endpoints to create
endpoints:
  # +required Unique name for the endpoint. (This name will be used when generating the managed API)
  - name: <Your Endpoint Name>
    # +required Numeric port value that gets exposed via this endpoint
    # Note: If you change the service port via environment variables, make sure to update this value accordingly.
    port: <Your Port Number>
    # +required Type of the traffic this endpoint is accepting. Example: REST, GraphQL, etc.
    # Allowed values: REST, GraphQL, GRPC
    type: <Endpoint Type>
    # +optional Network level visibility of this endpoint. Defaults to Project
    # Accepted values: Project|Organization|Public.
    networkVisibility: <Network Visibility>
    # +optional Context (base path) of the API that is exposed via this endpoint.
    # This is mandatory if the endpoint type is set to REST or GraphQL.
    context: <Your API Context>
    # +optional Path to the schema definition file. Defaults to wildcard route if not provided
    # This is only applicable to REST endpoint types.
    # The path should be relative to the sample root directory.
    schemaFilePath: <Relative Path to Your OpenAPI Spec>

```

5. Submit a pull request to this repository.

## License
This project is licensed under the Apache License. 

## Contact
If you have any questions or need assistance, you can join the [Choreo community Discord channel](https://discord.com/channels/955510916064092180/1027661953335820379).

