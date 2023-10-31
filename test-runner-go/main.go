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
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"testing"

	"github.com/stretchr/testify/assert"
)

// Struct to represent the JSON data
 type Post struct {
	 UserID int    `json:"userId"`
	 ID     int    `json:"id"`
	 Title  string `json:"title"`
	 Body   string `json:"body"`
 }
 
 func main() {
	 fmt.Println("Running tests...")
	 // Run tests programmatically
	 testing.Main(func(pat, str string) (bool, error) {
		 return true, nil
	 }, []testing.InternalTest{
		 {Name: "TestMyFunction", F: TestMyFunction},
	 }, nil, nil)
	 fmt.Println("Tests complete.")
 }
 
 // Helper function to make an API request and perform assertions.
 func performAPICallAndAssert(t *testing.T, postID int) {
	 // Make an HTTP GET request to a public API (for example, JSONPlaceholder) with the specified post ID.
	 url := fmt.Sprintf("https://jsonplaceholder.typicode.com/posts/%d", postID)
	 resp, err := http.Get(url)
	 if err != nil {
		 t.Fatalf("Failed to make API request: %v", err)
	 }
	 defer resp.Body.Close()
 
	 // Read the response body.
	 body, err := ioutil.ReadAll(resp.Body)
	 if err != nil {
		 t.Fatalf("Failed to read response body: %v", err)
	 }
 
	 // Unmarshal the JSON data into a Post struct.
	 var post Post
	 err = json.Unmarshal(body, &post)
	 if err != nil {
		 t.Fatalf("Failed to unmarshal JSON: %v", err)
	 }
 
	 // Perform assertions on the response (intentionally set to fail).
	 assert.Equal(t, post.UserID, 1, "user Id mismatch")
	 assert.Equal(t,post.ID, postID, "post Id mismatch")
 
	 // You can perform more assertions as needed.
 
	 // Print the JSON data for demonstration.
	 fmt.Printf("Received JSON Data for Post ID %d:\n%+v\n", postID, post)
 }
 
 func TestMyFunction(t *testing.T) {
	 performAPICallAndAssert(t, 1)
	 performAPICallAndAssert(t, 2)
 }
 
