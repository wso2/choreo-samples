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
	"log"
	"net"
	"os"
)

func main() {
	serverAddress := os.Getenv("SERVER_ADDRESS")
	customMessage := os.Getenv("CUSTOM_MESSAGE")

	if customMessage == "" {
		customMessage = "TCP client!"
	}

	// Creating a TCP connection using Dial
	conn, err := net.Dial("tcp", serverAddress)
	if err != nil {
		log.Fatalf("Failed to establish TCP connection: %v", err)
	}

	defer conn.Close()
	log.Printf("Connected to TCP server %v", conn.RemoteAddr())

	// Sending Data to the Server
	_, err = conn.Write([]byte(customMessage))
	if err != nil {
		log.Fatalf("Failed to send TCP message: %v", err)
	}

	log.Printf("> Sent message: %s", customMessage)

	// Receiving and Logging Server Response
	buffer := make([]byte, 1024)
	bytesRead, err := conn.Read(buffer)
	if err != nil {
		log.Fatalf("Failed to read response: %v", err)
	}

	log.Printf("< Received response: %s", string(buffer[:bytesRead]))
}
