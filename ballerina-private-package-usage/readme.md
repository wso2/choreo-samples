# Choreo Sample - Private Package Usage

This sample demonstrates how to deploy a Ballerina component in Choreo that uses private packages.

The sample contains following directories:

- [greeting_lib](greeting_lib): contains a Ballerina package that is published to the Ballerina Central.
- [greeting_service](greeting_service): contains a Ballerina service that uses the `greeting_lib` package.

In order to try out this sample, you need to use same organizations in Choreo and Ballerina Central.

## Update the source files with your organization name

1. Replace the `package.org` in the following `Ballerina.toml` files with your organization name.

   - [greeting_lib/Ballerina.toml](greeting_lib/Ballerina.toml)
   - [greeting_service/Ballerina.toml](greeting_service/Ballerina.toml)

2. Replace the package import `import <your-organization-name>/greeting_lib;` in the [service.bal](greeting_service/service.bal) file with your organization name.


You can use the organization settings page to retrieve the organization name. Make sure the organization name is same as the organization name you used in Choreo and Ballerina Central.

## Publishing the package to Ballerina Central

Make sure you already prepared your environment to publish packages to Ballerina Central. You can refer to the [Publish packages to Ballerina Central](https://ballerina.io/learn/publish-packages-to-ballerina-central/#prepare-for-publishing) documentation for more information.

Execute the following commands from the sample root directory to publish the `greeting_lib` package to Ballerina Central.

```shell
cd greeting_lib
```

```shell
bal pack && bal push
```

Verify that the package is published to the Ballerina Central by visiting https://central.ballerina.io/dashboard?tab=my-packages

## Test the service locally

Execute the following commands from the sample root directory to run the service:

```shell
cd greeting_service
```

```shell
bal run
```

Invoke the service using the following cURL command:

```shell
curl http://localhost:9090/greeting?name=Choreo
```

## Create the service in Choreo

Use the following configuration when creating this component in Choreo as Service:

- Build Pack: **Ballerina**
- Project Path: `ballerina/private-package-usage/greeting_service`
