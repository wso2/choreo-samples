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

package config

import (
	"github.com/wso2/choreo-sample-apps/byoi-components/services/rest-user-service/internal/models"
)

type Config struct {
	// Env sets the environment the service is running in.
	// This is used in health check endpoint to indicate the environment.
	Env string
	// Hostname sets the hostname of the running service.
	// This is used to generate the Swagger host URL.
	Hostname string
	// Port sets the port of the running service.
	Port int
	// InitialDataPath sets the path to load the initial data file.
	// Refer to the InitialData struct for the file format.
	InitialDataPath string
}

type InitialData struct {
	Users []models.User `json:"users"`
}
