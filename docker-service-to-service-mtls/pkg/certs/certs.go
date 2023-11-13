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

package certs

import (
	"crypto/tls"
	"crypto/x509"
	"fmt"
	"os"
)

// LoadKeyPair loads a key pair from the given cert and key files.
func LoadKeyPair(certFile, keyFile string) (tls.Certificate, error) {
	cert, err := tls.LoadX509KeyPair(certFile, keyFile)
	if err != nil {
		return cert, err
	}
	return cert, nil
}

// LoadCACertPool creates a CA cert pool from the given cert files.
func LoadCACertPool(certFiles ...string) (*x509.CertPool, error) {
	caCertPool := x509.NewCertPool()
	for _, certFile := range certFiles {
		caCert, err := os.ReadFile(certFile)
		if err != nil {
			return nil, fmt.Errorf("error loading certificate %q: %w", certFile, err)
		}
		ok := caCertPool.AppendCertsFromPEM(caCert)
		if !ok {
			return nil, fmt.Errorf("failed to parse certificate %q", certFile)
		}
	}
	return caCertPool, nil
}
