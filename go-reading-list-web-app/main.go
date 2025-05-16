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

package main

import (
	"go-reading-list-web-app/internal/config"
	"go-reading-list-web-app/internal/routes"
	"go-reading-list-web-app/internal/service"
	"log"

	"github.com/gin-gonic/gin"
)

func main() {
	// Load environment variables and configurations
	if err := config.LoadConfigs(); err != nil {
		log.Fatal("Error loading configs:", err)
	}

	service := service.NewService(config.GetConfig().ApiUrl)

	router := gin.Default()
	router.LoadHTMLGlob("internal/templates/*")

	// route handlers
	routes.PublicRoutes(router)
	routes.ProtectedRoutes(router, service)

	port := config.GetConfig().Port
	router.Run(":" + port)
}
