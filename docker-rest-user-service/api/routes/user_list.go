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

package routes

import (
	"fmt"
	"net/http"

	"github.com/gofiber/fiber/v2"
	"github.com/wso2/choreo-sample-apps/byoi-components/services/rest-user-service/internal/models"

	"github.com/wso2/choreo-sample-apps/byoi-components/services/rest-user-service/internal/utils"
)

func registerUserStoreRoutes(router fiber.Router) {
	r := router.Group("/users")
	r.Post("/", AddUser)
	r.Get("/:id", GetUser)
	r.Put("/:id", UpdateUser)
	r.Delete("/:id", DeleteUser)
	r.Get("/", ListUsers)
}

// AddUser
//
//	@Summary	Add a new user to the user store
//	@Tags		users
//	@Accept		json
//	@Produce	json
//	@Param		request	body	models.User	true	"New user details"
//	@Router		/users [post]
//	@Success	201	{object}	models.User			"successful operation"
//	@Failure	400	{object}	utils.ErrorResponse	"invalid user details"
//	@Failure	409	{object}	utils.ErrorResponse	"user already exists"
func AddUser(c *fiber.Ctx) error {
	ctx := utils.GetRequestContext(c)
	newUser := models.User{}
	if err := c.BodyParser(&newUser); err != nil {
		return makeHttpBadRequestError(err)
	}
	res, err := userController.AddUser(ctx, newUser)
	if err != nil {
		return err
	}
	return c.Status(fiber.StatusCreated).JSON(res)
}

// UpdateUser
//
//	@Summary	Update a user store user by id
//	@Tags		users
//	@Accept		json
//	@Produce	json
//	@Param		id		path	string		true	"User ID"
//	@Param		request	body	models.User	true	"Updated user details"
//	@Router		/users/{id} [put]
//	@Success	200	{object}	models.User			"successful operation"
//	@Failure	400	{object}	utils.ErrorResponse	"invalid user details"
//	@Failure	404	{object}	utils.ErrorResponse	"user not found"
func UpdateUser(c *fiber.Ctx) error {
	ctx := utils.GetRequestContext(c)
	id := c.Params("id")
	updatedUser := models.User{}
	if err := c.BodyParser(&updatedUser); err != nil {
		return makeHttpBadRequestError(err)
	}
	updatedUser.Id = id
	user, err := userController.UpdateUser(ctx, updatedUser)
	if err != nil {
		return err
	}
	return c.Status(fiber.StatusOK).JSON(user)
}

// DeleteUser
//
//	@Summary	Delete a user store user by id
//	@Tags		users
//	@Produce	json
//	@Param		id	path	string	true	"User ID"
//	@Router		/users/{id} [delete]
//	@Success	200	{object}	models.User			"successful operation"
//	@Failure	404	{object}	utils.ErrorResponse	"user not found"
func DeleteUser(c *fiber.Ctx) error {
	ctx := utils.GetRequestContext(c)
	id := c.Params("id")
	user, err := userController.DeleteUser(ctx, id)
	if err != nil {
		return err
	}
	return c.Status(fiber.StatusOK).JSON(user)
}

// GetUser
//
//	@Summary	Get user store user by id
//
//	@Tags		users
//
//	@Produce	json
//	@Param		id	path	string	true	"User ID"
//	@Router		/users/{id} [get]
//	@Success	200	{object}	models.User			"successful operation"
//	@Failure	404	{object}	utils.ErrorResponse	"user not found"
func GetUser(c *fiber.Ctx) error {
	ctx := utils.GetRequestContext(c)
	id := c.Params("id")

	user, err := userController.GetUser(ctx, id)
	if err != nil {
		return err
	}
	return c.Status(fiber.StatusOK).JSON(user)
}

// ListUsers
//
//	@Summary	List all the user store users
//	@Tags		users
//	@Produce	json
//	@Router		/users [get]
//	@Success	200	{array}	models.User	"successful operation"
func ListUsers(c *fiber.Ctx) error {
	ctx := utils.GetRequestContext(c)
	users, err := userController.ListUsers(ctx)
	if err != nil {
		return err
	}
	return c.Status(fiber.StatusOK).JSON(users)
}

func makeHttpBadRequestError(err error) *fiber.Error {
	return fiber.NewError(http.StatusBadRequest, fmt.Sprintf("failed to parse the payload: %s", err.Error()))
}
