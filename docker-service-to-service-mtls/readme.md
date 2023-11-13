# Go Service to Service mTLS

This sample shows how you can deploy services that communicate with each other using mTLS. 
The server will only accept requests from clients that present a valid certificate and respond with greeting message that contains the client's identity.
The client's identity is extracted from the CN of the certificate presented by the client. 
For this sample, the client application is deployed as a manual trigger on Choreo.


## Generate Certificates

In order to run this sample, we need to generate the certificates for the server and the client by signing them with a private CA certificate.

Run the following commands to generate the certificates.

```shell
  ./gen-certs.sh
```

Note: In order to generate the server certificate correctly, you need to provide the server's hostname for the Subject Alternative Name (SAN). 
At the moment, you need to deploy the server component to Choreo, and retrieve the hostname in the **Project** endpoint from the component **Overview** page.
Once you have the hostname, update the `DNS.1` field in the [server-csr.cnf](certs/server-csr.cnf) file with the hostname and run the script to generate the certificates.

## Steps to Deploy in Choreo

### Deploy the server
1. Create a new Service component with following parameters
   - Build Pack: `Dockerfile`
   - Dockerfile path: `docker-service-to-service-mtls/Dockerfile.server`
   - Build Context: `docker-service-to-service-mtls`
2. Navigate to the **Configs & Secrets** page of the component and add following file mounts to the component
   - Add server certificate file,
     - Config Type: `ConfigMap`
     - Mount Type: `File Mount`
     - Config Name: `server-certificate`
     - Mount Path: `/tls/server.crt`
     - File Content: Copy and paste the generated [server.crt](certs/server.crt) file content
   - Add server private key file,
      - Config Type: `Secret`
      - Mount Type: `File Mount`
      - Config Name: `server-key`
      - Mount Path: `/tls/server.key`
      - File Content: Copy and paste the generated [server.key](certs/server.key) file content
   - Add CA certificate file,
      - Config Type: `ConfigMap`
      - Mount Type: `File Mount`
      - Config Name: `server-ca-certificate`
      - Mount Path: `/tls/ca.crt`
      - File Content: Copy and paste the generated [ca.crt](certs/ca.crt) file content
3. In the same **Configs & Secrets** page, add following environment variables as the `ConfigMap` with config name `tls-cert-env`
   - `CERT_FILE_PATH`: `/tls/server.crt`
   - `KEY_FILE_PATH`: `/tls/server.key`
   - `CA_CERT_FILE_PATH`: `/tls/ca.crt`
4. Deploy the component
5. Navigate to the **Overview** page of the component and copy the Project endpoint URL.

Refer https://wso2.com/choreo/docs/devops-and-ci-cd/manage-configurations-and-secrets/ for more information on how to add configs and secrets to a component.


### Deploy the client
1. Create a new Manual Trigger component on the same project with following parameters
   - Build Pack: `Dockerfile`
   - Dockerfile path: `docker-service-to-service-mtls/Dockerfile.client`
   - Build Context: `docker-service-to-service-mtls`
2. Navigate to the **Configs & Secrets** page of the component and add following file mounts to the component
   - Add client certificate file,
     - Config Type: `ConfigMap`
     - Mount Type: `File Mount`
     - Config Name: `client-certificate`
     - Mount Path: `/tls/client.crt`
     - File Content: Copy and paste the generated [client.crt](certs/client.crt) file content
   - Add client private key file,
      - Config Type: `Secret`
      - Mount Type: `File Mount`
      - Config Name: `client-key`
      - Mount Path: `/tls/client.key`
      - File Content: Copy and paste the generated [client.key](certs/client.key) file content
   - Add CA certificate file,
      - Config Type: `ConfigMap`
      - Mount Type: `File Mount`
      - Config Name: `client-ca-certificate`
      - Mount Path: `/tls/ca.crt`
      - File Content: Copy and paste the generated [ca.crt](certs/ca.crt) file content
3. In the same **Configs & Secrets** page, add following environment variables as the `ConfigMap` with config name `client-tls-cert-env`
    - `CERT_FILE_PATH`: `/tls/client.crt`
    - `KEY_FILE_PATH`: `/tls/client.key`
    - `CA_CERT_FILE_PATH`: `/tls/ca.crt`
    - `GREETER_SERVER_URL`: `https://<server-host>:8443/greeter`

    Use the endpoint URL copied from the server component (Step 5) as the value for `GREETER_SERVER_URL` environment variable and **make sure to change the protocol to `https`**.
    
    Example: http://mtls-server-3192360657:8443/greeter -> https://mtls-server-3192360657:8443/greeter

4. Deploy the component and run it by clicking the **Run Once** button.

### Run the sample locally

1. Start the server
   ```shell
   CERT_FILE_PATH=certs/server.crt KEY_FILE_PATH=certs/server.key CA_CERT_FILE_PATH=certs/ca.crt go run ./server/
   ```
2. Start the client
   ```shell
   CERT_FILE_PATH=certs/client.crt KEY_FILE_PATH=certs/client.key CA_CERT_FILE_PATH=certs/ca.crt GREETER_SERVER_URL=https://localhost:8443/greeter go run ./client/
   ```
