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
	"io"
	"log"
	"net"
	"os"
	"os/signal"
	"sync"
	"syscall"
)

// handles incoming client connection
func handleConnection(conn net.Conn) {
	defer conn.Close()
	log.Printf("Accepted connection from %v", conn.RemoteAddr())

	// Read data from the client
	buffer := make([]byte, 1024)
	for {
		n, err := conn.Read(buffer)
		if err != nil && err != io.EOF {
			log.Printf("Error reading data: %v", err)
			break
		}

		if n == 0 {
			return
		}

		log.Printf("> Received message from %s: %v", conn.RemoteAddr(), string(buffer[:n]))
		message := "Hello " + string(buffer[:n])
		_, err = conn.Write([]byte(message))
		if err != nil {
			log.Printf("Error writing data: %v", err)
			break
		}

		log.Printf("< Sent message to %s: %v", conn.RemoteAddr(), message)
	}
}

func main() {
	// Creating a TCP listener
	listener, err := net.Listen("tcp", ":8080")
	if err != nil {
		log.Fatalf("Error starting TCP server: %v", err)
	}

	log.Printf("TCP server listening on %s", listener.Addr())

	// Capture signals to handle graceful shutdown
	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()

	wg := &sync.WaitGroup{}

	// Accept incoming connections
	go func() {
		for {
			conn, err := listener.Accept()
			if err != nil {
				select {
				case <-ctx.Done():
					log.Println("Server shutting down gracefully...")
					return
				default:
					log.Println("Error accepting connection:", err)
					continue
				}
			}
			wg.Add(1)

			// Handle incoming connection in a new goroutine
			go func(conn net.Conn) {
				handleConnection(conn)
				wg.Done()
			}(conn)
		}
	}()

	// Block until the context is canceled (graceful shutdown)
	<-ctx.Done()

	// Stop accepting incoming connections and wait until existing connections are closed
	listener.Close()
	wg.Wait()

	log.Println("Server has gracefully shut down.")
}
