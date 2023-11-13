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
	"net/http"
	"testing"

	"github.com/gofiber/fiber/v2"
	"github.com/stretchr/testify/assert"
	"github.com/wso2/choreo-sample-apps/byoi-components/services/rest-user-service/internal/models"
	"github.com/wso2/choreo-sample-apps/byoi-components/services/rest-user-service/internal/repositories"
)

// MockUserRepository is a mock implementation of the models.UserRepository interface for testing purposes.
type MockUserRepository struct {
	data   map[string]models.User
	err    error
	exists bool
}

func (m *MockUserRepository) Add(ctx context.Context, user models.User) (models.User, error) {
	if m.exists {
		return models.User{}, repositories.ErrRecordAlreadyExists
	}
	return user, m.err
}

func (m *MockUserRepository) Update(ctx context.Context, user models.User) (models.User, error) {
	if !m.exists {
		return models.User{}, repositories.ErrRecordNotFound
	}
	return user, m.err
}

func (m *MockUserRepository) List(ctx context.Context) ([]models.User, error) {
	users := make([]models.User, 0, len(m.data))
	for _, user := range m.data {
		users = append(users, user)
	}
	return users, m.err
}

func (m *MockUserRepository) GetById(ctx context.Context, id string) (models.User, error) {
	user, ok := m.data[id]
	if !ok {
		return models.User{}, repositories.ErrRecordNotFound
	}
	return user, m.err
}

func (m *MockUserRepository) DeleteById(ctx context.Context, id string) (models.User, error) {
	user, ok := m.data[id]
	if !ok {
		return models.User{}, repositories.ErrRecordNotFound
	}
	delete(m.data, id)
	return user, m.err
}

func TestUserController(t *testing.T) {
	// Create a mock repository for testing.
	mockRepo := &MockUserRepository{
		data:   make(map[string]models.User),
		err:    nil,
		exists: false,
	}

	controller := NewUserController(mockRepo)

	t.Run("AddUser", func(t *testing.T) {
		// Test adding a new user.
		newUser := models.User{Name: "New User", Age: 10}
		mockRepo.exists = false
		user, err := controller.AddUser(context.Background(), newUser)
		assert.NoError(t, err)
		assert.Equal(t, newUser.Name, user.Name)

		// Test adding a user that already exists.
		mockRepo.exists = true
		_, err = controller.AddUser(context.Background(), newUser)
		assert.Equal(t, fiber.NewError(http.StatusConflict, "the user id [] is already exists"), err)
	})

	t.Run("UpdateUser", func(t *testing.T) {
		// Test updating an existing user.
		updatedUser := models.User{Id: "1", Name: "Updated User", Age: 10}
		mockRepo.exists = true
		user, err := controller.UpdateUser(context.Background(), updatedUser)
		assert.NoError(t, err)
		assert.Equal(t, updatedUser.Name, user.Name)

		// Test updating a user that does not exist.
		mockRepo.exists = false
		_, err = controller.UpdateUser(context.Background(), updatedUser)
		assert.Equal(t, fiber.NewError(http.StatusNotFound, "the user id [1] is not found"), err)
	})

	t.Run("ListUsers", func(t *testing.T) {
		// Test listing users.
		mockRepo.data = map[string]models.User{
			"1": {Id: "1", Name: "User 1", Age: 10},
			"2": {Id: "2", Name: "User 2", Age: 12},
		}
		users, err := controller.ListUsers(context.Background())
		assert.NoError(t, err)
		assert.Len(t, users, 2)

		// Test listing users with an error.
		mockRepo.err = errors.New("mock error")
		_, err = controller.ListUsers(context.Background())
		assert.Equal(t, fiber.NewError(http.StatusInternalServerError, "internal server error"), err)
	})

	t.Run("GetUser", func(t *testing.T) {
		// Test getting an existing user.
		mockRepo.data = map[string]models.User{"1": {Id: "1", Name: "User 1", Age: 12}}
		mockRepo.err = nil
		user, err := controller.GetUser(context.Background(), "1")
		assert.NoError(t, err)
		assert.Equal(t, "User 1", user.Name)

		// Test getting a user that does not exist.
		_, err = controller.GetUser(context.Background(), "2")
		assert.Equal(t, fiber.NewError(http.StatusNotFound, "the user id [2] is not found"), err)
	})

	t.Run("DeleteUser", func(t *testing.T) {
		// Test deleting an existing user.
		mockRepo.data = map[string]models.User{"1": {Id: "1", Name: "User 1", Age: 10}}
		user, err := controller.DeleteUser(context.Background(), "1")
		assert.NoError(t, err)
		assert.Equal(t, "User 1", user.Name)

		// Test deleting a user that does not exist.
		_, err = controller.DeleteUser(context.Background(), "2")
		assert.Equal(t, fiber.NewError(http.StatusNotFound, "the user id [2] is not found"), err)
	})
}
