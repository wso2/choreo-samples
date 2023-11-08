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
	"context"
	"crypto/tls"
	"errors"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/wso2/choreo-sample-apps/go/service-to-service-mtls/pkg/certs"
	"github.com/wso2/choreo-sample-apps/go/service-to-service-mtls/pkg/config"
)

func main() {
	// Read environment variables
	certFilePath := config.GetEnv("CERT_FILE_PATH", "server.crt")
	keyFilePath := config.GetEnv("KEY_FILE_PATH", "server.key")
	caCertFilePath := config.GetEnv("CA_CERT_FILE_PATH", "ca.crt")

	// Load the server certificate and private key
	serverKeyPair, err := certs.LoadKeyPair(certFilePath, keyFilePath)
	if err != nil {
		log.Fatalf("Error loading key pair: %v", err)
	}
	// Load the CA certificate
	caCertPool, err := certs.LoadCACertPool(caCertFilePath)
	if err != nil {
		log.Fatalf("Error loading CA cert pool: %v", err)
	}

	// Create a TLS configuration with mutual authentication
	tlsConfig := &tls.Config{
		Certificates: []tls.Certificate{serverKeyPair},
		ClientCAs:    caCertPool,
		ClientAuth:   tls.RequireAndVerifyClientCert,
	}

	serverMux := http.NewServeMux()
	serverMux.HandleFunc("/greeter/greet", greet)

	serverPort := 8443
	server := &http.Server{
		Addr:      fmt.Sprintf(":%d", serverPort),
		TLSConfig: tlsConfig,
		Handler:   serverMux,
	}

	go func() {
		log.Printf("Starting HTTPS Greeter on port %d\n", serverPort)
		if err := server.ListenAndServeTLS("", ""); !errors.Is(err, http.ErrServerClosed) {
			log.Fatalf("Server ListenAndServeTLS error: %v", err)
		}
		log.Println("HTTPS server stopped serving new requests.")
	}()

	stopCh := make(chan os.Signal, 1)
	signal.Notify(stopCh, syscall.SIGINT, syscall.SIGTERM)
	<-stopCh // Wait for shutdown signal

	shutdownCtx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	log.Println("Shutting down the server...")
	if err := server.Shutdown(shutdownCtx); err != nil {
		log.Fatalf("HTTPS server shutdown error: %v", err)
	}
	log.Println("Shutdown complete.")
}

func greet(w http.ResponseWriter, r *http.Request) {
	name := "Stranger"
	if r.TLS != nil {
		log.Println("==== Start - Certificate Chain ====")
		for i, cert := range r.TLS.PeerCertificates {
			subject := cert.Subject
			issuer := cert.Issuer
			log.Println(subject)
			log.Printf("--> Cert %d Subject: %s", i+1, subject)
			log.Printf("           Issuer: %s", issuer)
		}
		log.Println("==== End- Certificate Chain ====")
		fmt.Println("")
		if len(r.TLS.VerifiedChains) > 0 && len(r.TLS.VerifiedChains[0]) > 0 {
			// Use the CN from the client certificate as the name to greet
			name = r.TLS.VerifiedChains[0][0].Subject.CommonName
		}
	}
	// Greet the client with the client certificate CN
	fmt.Fprintf(w, "Hello, %s!\n", name)
}
