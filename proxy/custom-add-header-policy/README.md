# Implement an Custom API policy

When you attach a policy and deploy an API, Choreo pulls the necessary packages from Ballerina Central and bundles them into the interceptor application under the hood. Therefore to use policies in your APIs, you must publish them as public packages.

To publish the policy, follow the steps given below:

1. Open the project locally and to package the policy before you publish it to Ballerina Central, issue the following command:

    ```
    bal pack 
    ```

2. To publish the package to Ballerina Central, issue the following command:

    ```
    export BALLERINA_CENTRAL_ACCESS_TOKEN=<access-token> 
    bal push 
    ```

    Note: Replace `<access-token>` with your access token. The access token can be generated via https://central.ballerina.io/dashboard?tab=token.

3. Once you publish the package, it will appear in the policy list as "Custom Add Header (2.0.0)".
