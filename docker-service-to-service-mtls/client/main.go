/*
 * Copyright (c) 2023, WSO2 LLC. (https://www.wso2.com/) All Rights Reserved.
 *
 * WSO2 LLC. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package main

import (
	"crypto/tls"
	"fmt"
	"io"
	"log"
	"net/http"

	"github.com/wso2/choreo-sample-apps/go/service-to-service-mtls/pkg/certs"
	"github.com/wso2/choreo-sample-apps/go/service-to-service-mtls/pkg/config"
)

func main() {
	// Read the environment variables
	certFilePath := config.GetEnv("CERT_FILE_PATH", "client.crt")
	keyFilePath := config.GetEnv("KEY_FILE_PATH", "client.key")
	caCertFilePath := config.GetEnv("CA_CERT_FILE_PATH", "ca.crt")
	greeterServerUrl := config.GetEnv("GREETER_SERVER_URL", "https://localhost:8443/greeter")

	// Load the client certificate and private key
	clientKeyPair, err := certs.LoadKeyPair(certFilePath, keyFilePath)
	if err != nil {
		log.Fatalf("Error loading key pair: %v", err)
	}

	// Load CA certificat
	caCertPool, err := certs.LoadCACertPool(caCertFilePath)
	if err != nil {
		log.Fatalf("Error loading CA cert pool: %v", err)
	}

	_ = caCertPool

	// Create a TLS configuration for mutual authentication
	tlsConfig := &tls.Config{
		Certificates: []tls.Certificate{clientKeyPair},
		RootCAs:      caCertPool,
		// ClientCAs:    caCertPool,
		// ClientAuth:   tls.RequireAndVerifyClientCert,
	}

	// Create an HTTP client with the TLS configuration
	httpClient := &http.Client{
		Transport: &http.Transport{
			TLSClientConfig: tlsConfig,
		},
	}

	// Send a request to the server
	resp, err := httpClient.Get(fmt.Sprintf("%s/greet", greeterServerUrl))
	if err != nil {
		log.Fatalf("Error sending request: %v", err)
	}
	defer resp.Body.Close()

	// Print the response status
	fmt.Printf("Response status: %s\n", resp.Status)

	// Print the response body
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		log.Fatalf("Error reading response body: %v", err)
	}
	fmt.Printf("Response body: %s\n", body)

}
