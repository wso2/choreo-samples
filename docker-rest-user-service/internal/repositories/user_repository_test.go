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
package repositories

import (
	"context"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/wso2/choreo-sample-apps/byoi-components/services/rest-user-service/internal/models"
)

func TestUserRepository(t *testing.T) {
	// Create a new repository for testing with an initial book.
	initialUser := models.User{Id: "1", Name: "Test User", Age: 10}
	updatedUser := models.User{Id: initialUser.Id, Name: "Updated User", Age: 11}
	repo := NewUserRepository([]models.User{initialUser})

	t.Run("Add", func(t *testing.T) {
		// Test adding a new book.
		newUser := models.User{Name: "Test User", Age: 10}
		addedUser, err := repo.Add(context.Background(), newUser)
		assert.NoError(t, err)
		assert.NotEmpty(t, addedUser.Id)

		// Test adding a book with an existing ID.
		duplicateUser := models.User{Id: addedUser.Id, Name: "Duplicate User", Age: 10}
		_, err = repo.Add(context.Background(), duplicateUser)
		assert.Error(t, err)
	})

	t.Run("Update", func(t *testing.T) {
		// Test updating an existing book.
		updated, err := repo.Update(context.Background(), updatedUser)
		assert.NoError(t, err)
		assert.Equal(t, updatedUser, updated)

		// Test updating a non-existing book.
		nonExistingUser := models.User{Id: "non-existing-id", Name: "Non Existing User", Age: 10}
		_, err = repo.Update(context.Background(), nonExistingUser)
		assert.Error(t, err)
	})

	t.Run("List", func(t *testing.T) {
		// Test listing all users.
		users, err := repo.List(context.Background())
		assert.NoError(t, err)
		assert.Len(t, users, 2) // Includes the initial book and the one added.
	})

	t.Run("GetById", func(t *testing.T) {
		// Test getting a book by ID.
		book, err := repo.GetById(context.Background(), initialUser.Id)
		assert.NoError(t, err)
		assert.Equal(t, updatedUser, book)

		// Test getting a non-existing book.
		_, err = repo.GetById(context.Background(), "non-existing-id")
		assert.Error(t, err)
	})

	t.Run("DeleteById", func(t *testing.T) {
		// Test deleting a book by ID.
		deletedUser, err := repo.DeleteById(context.Background(), initialUser.Id)
		assert.NoError(t, err)
		assert.Equal(t, updatedUser, deletedUser)

		// Test deleting a non-existing book.
		_, err = repo.DeleteById(context.Background(), "non-existing-id")
		assert.Error(t, err)
	})
}
