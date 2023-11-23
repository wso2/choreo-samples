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

package controllers

import (
	"context"
	"errors"
	"fmt"
	"net/http"

	"github.com/gofiber/fiber/v2"
	"github.com/wso2/choreo-sample-apps/byoi-components/services/rest-user-service/internal/models"
	"github.com/wso2/choreo-sample-apps/byoi-components/services/rest-user-service/internal/repositories"
)

type UserController struct {
	userRepository models.UserRepository
}

func NewUserController(userRepository models.UserRepository) *UserController {
	return &UserController{userRepository}
}

func (c *UserController) AddUser(ctx context.Context, newUser models.User) (models.User, error) {
	if err := validateUser(newUser); err != nil {
		return models.User{}, err
	}
	user, err := c.userRepository.Add(ctx, newUser)
	if errors.Is(err, repositories.ErrRecordAlreadyExists) {
		return models.User{}, makeHttpConflictError(newUser.Id)
	} else if err != nil {
		return models.User{}, makeHttpInternalServerError()
	}
	return user, nil
}

func (c *UserController) UpdateUser(ctx context.Context, updatedUser models.User) (models.User, error) {
	if err := validateUser(updatedUser); err != nil {
		return models.User{}, err
	}
	user, err := c.userRepository.Update(ctx, updatedUser)
	if errors.Is(err, repositories.ErrRecordNotFound) {
		return models.User{}, makeHttpNotFoundError(updatedUser.Id)
	} else if err != nil {
		return models.User{}, makeHttpInternalServerError()
	}
	return user, nil
}

func (c *UserController) ListUsers(ctx context.Context) ([]models.User, error) {
	users, err := c.userRepository.List(ctx)
	if err != nil {
		return nil, makeHttpInternalServerError()
	}
	if users == nil {
		return make([]models.User, 0), nil
	}
	return users, nil
}

func (c *UserController) GetUser(ctx context.Context, userId string) (models.User, error) {
	user, err := c.userRepository.GetById(ctx, userId)
	if errors.Is(err, repositories.ErrRecordNotFound) {
		return models.User{}, makeHttpNotFoundError(userId)
	} else if err != nil {
		return models.User{}, makeHttpInternalServerError()
	}
	return user, nil
}

func (c *UserController) DeleteUser(ctx context.Context, userId string) (models.User, error) {
	user, err := c.userRepository.DeleteById(ctx, userId)
	if errors.Is(err, repositories.ErrRecordNotFound) {
		return models.User{}, makeHttpNotFoundError(userId)
	} else if err != nil {
		return models.User{}, makeHttpInternalServerError()
	}
	return user, nil
}

func makeHttpNotFoundError(id string) *fiber.Error {
	return fiber.NewError(http.StatusNotFound, fmt.Sprintf("the user id [%s] is not found", id))
}

func makeHttpConflictError(id string) *fiber.Error {
	return fiber.NewError(http.StatusConflict, fmt.Sprintf("the user id [%s] is already exists", id))
}

func makeHttpInternalServerError() *fiber.Error {
	return fiber.NewError(http.StatusInternalServerError, "internal server error")
}

func validateUser(user models.User) *fiber.Error {
	if user.Name == "" {
		return fiber.NewError(http.StatusBadRequest, "user title is required")
	}
	return nil
}
