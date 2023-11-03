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
	"fmt"
	"log"
	"net"
)

func main() {
	serverPort := 5050

	// Resolve server address
	serverAddr, err := net.ResolveUDPAddr("udp", fmt.Sprintf(":%d", serverPort))
	if err != nil {
		log.Fatalf("Error resolving UDP address: %v", err)
	}

	// Listen on UDP connection
	conn, err := net.ListenUDP("udp", serverAddr)
	if err != nil {
		log.Fatalf("Error listening on UDP address: %v", err)
	}

	defer conn.Close()
	log.Printf("UDP server listening on %s", serverAddr)

	for {
		// Read from UDP connection
		buffer := make([]byte, 1024)
		bytesRead, clientAddr, err := conn.ReadFromUDP(buffer)
		if err != nil {
			log.Printf("Error reading UDP message: %v", err)
			continue
		}

		log.Printf("> Received message from %s: %s\n", clientAddr.String(), string(buffer[:bytesRead]))

		/// Prepare and send a response to the client
		message := "Hello " + string(buffer[:bytesRead])
		response := []byte(message)
		_, err = conn.WriteToUDP(response, clientAddr)
		if err != nil {
			log.Printf("Error sending response: %v", err)
		}

		log.Printf("< Sent message to %s: %s\n", clientAddr.String(), message)
	}
}
