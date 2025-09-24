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
 
package routes

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

// PublicRoutes sets up the public routes for the application.
// These routes are accessible without authentication
func PublicRoutes(r *gin.Engine) {
	r.GET("/", handleIndex)
	r.GET("/error", handleError)
}

func handleIndex(c *gin.Context) {
	c.HTML(http.StatusOK, "index.tmpl", nil)
}

func handleError(c *gin.Context) {
	errorCode := c.Query("code")
	errorMsg := c.Query("message")
	errorPath := c.Query("path")

	c.HTML(http.StatusInternalServerError, "error.tmpl", gin.H{
		"errorCode": errorCode,
		"errorMsg":  errorMsg,
		"errorPath": errorPath,
	})
}
