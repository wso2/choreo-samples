/*
 * Copyright (c) 2025, WSO2 LLC. (https://www.wso2.com/) All Rights Reserved.
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
 
package config

type EnvConfig struct {
	ApiUrl string `env:"API_URL,required"`
	Port   string `env:"PORT" envDefault:"8080"`
}

// Book represents a book in the reading list
type Book struct {
	Id     string `json:"uuid"`
	Title  string `json:"title"`
	Author string `json:"author"`
	Status string `json:"status"`
}

// User represents a user in the system.
// This implementation uses a minimal set of fields for demonstration purposes
type User struct {
	Username string `json:"username"`
	Email    string `json:"email"`
	FirstName string `json:"first_name"`
	LastName  string `json:"last_name"`
	Groups    []string `json:"groups"`
	Organization Organization `json:"organization"`
	Issuer    string `json:"iss"`
	Subject   string `json:"sub"`
}

type Organization struct {
	Uuid string `json:"uuid"`
}

type ErrorResponse struct {
	Code    string `json:"code"`
	Message string `json:"message"`
	Path    string `json:"path"`
	Debug   error  `json:"debug"`
}
