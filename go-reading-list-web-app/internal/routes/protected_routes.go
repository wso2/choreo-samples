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
	"encoding/json"
	"go-reading-list-web-app/internal/config"
	"go-reading-list-web-app/internal/service"
	"net/http"

	"github.com/gin-gonic/gin"
)

// ProtectedRoutes sets up the protected routes for the application.
// These routes should be configured as `protected routes` from the Choreo Console, when deploying the application.
// Otherwise, the application will not work as expected and users may access these routes without a proper authentication.
func ProtectedRoutes(r *gin.Engine, s *service.Service) {
	r.GET("/dashboard", handleDashboard(s))
	r.POST("/addNewBook", handleAddNewBookPostRequest(s))
	r.POST("/deleteBook", handleDeleteBook(s))

	r.GET("/addNewBook", func(c *gin.Context) {
		c.HTML(http.StatusOK, "addNewBook.tmpl", nil)
	})

	r.POST("/logout", handleLogout)
}

// handleDashboard handles the dashboard request
func handleDashboard(s *service.Service) gin.HandlerFunc {
	return func(c *gin.Context) {
		// read userClaims from the request
		var user config.User
		userClaims := c.Request.Header.Get("Choreo-User-Claims")
		if err := json.Unmarshal([]byte(userClaims), &user); err != nil {
			SendErrorResponse(c, config.ErrorResponse{
				Code:    "401",
				Message: "Unauthorized",
				Path:    "/dashboard",
				Debug:   err,
			})
			return
		}

		accessToken := c.Request.Header.Get("Choreo-Access-Token")
		books, err := s.FetchBooks(accessToken)
		if err != nil {
			SendErrorResponse(c, config.ErrorResponse{
				Code:    "500",
				Message: "Internal Server Error: Failed to fetch books",
				Path:    "/dashboard",
				Debug:   err,
			})
			return
		}

		c.HTML(http.StatusOK, "dashboard.tmpl", gin.H{
			"username": user.Username,
			"email":    user.Email,
			"books":    books,
		})
	}
}

// handleAddNewBookPostRequest handles the form submission for adding a new book
func handleAddNewBookPostRequest(s *service.Service) gin.HandlerFunc {
	return func(c *gin.Context) {
		bookTitle := c.Request.FormValue("title")
		bookAuthor := c.Request.FormValue("author")
		bookStatus := c.Request.FormValue("status")
		if bookTitle == "" || bookAuthor == "" || bookStatus == "" {
			SendErrorResponse(c, config.ErrorResponse{
				Code:    "400",
				Message: "Bad Request: All fields are required",
				Path:    "/AddNewBook",
				Debug:   nil,
			})
			return
		}

		book := config.Book{
			Title:  bookTitle,
			Author: bookAuthor,
			Status: bookStatus,
		}

		accessToken := c.Request.Header.Get("Choreo-Access-Token")
		if err := s.AddNewBook(accessToken, book); err != nil {
			SendErrorResponse(c, config.ErrorResponse{
				Code:    "500",
				Message: "Internal Server Error: Failed to add new book",
				Path:    "/AddNewBook",
				Debug:   err,
			})
			return
		}
		c.Redirect(http.StatusSeeOther, "/dashboard")
	}
}

// handleDeleteBook handles the deletion of a book
func handleDeleteBook(s *service.Service) gin.HandlerFunc {
	return func(c *gin.Context) {
		bookId := c.Request.FormValue("id")
		if bookId == "" {
			SendErrorResponse(c, config.ErrorResponse{
				Code:    "400",
				Message: "Bad Request: Book ID is required",
				Path:    "/deleteBook",
				Debug:   nil,
			})
			return
		}

		accessToken := c.Request.Header.Get("Choreo-Access-Token")
		if err := s.DeleteBook(accessToken, bookId); err != nil {
			SendErrorResponse(c, config.ErrorResponse{
				Code:    "500",
				Message: "Internal Server Error: Failed to delete book",
				Path:    "/deleteBook",
				Debug:   err,
			})
			return
		}
		c.Redirect(http.StatusSeeOther, "/dashboard")
	}
}

// handleLogout handles the logout request
func handleLogout(c *gin.Context) {
	sessionHint := c.Request.Header.Get("Choreo-Session-Hint")
	c.Redirect(http.StatusSeeOther, "/auth/logout?session_hint="+sessionHint)
}

// SendErrorResponse redirects the user to the error page with the provided error response
func SendErrorResponse(c *gin.Context, e config.ErrorResponse) {
	c.Redirect(http.StatusSeeOther, "/error?code="+e.Code+"&message="+e.Message+"&path="+e.Path+"&debug="+e.Debug.Error())
}
