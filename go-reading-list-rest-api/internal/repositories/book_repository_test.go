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
	"github.com/wso2/choreo-sample-apps/go/rest-api/internal/models"
)

func TestBookRepository(t *testing.T) {
	// Create a new repository for testing with an initial book.
	initialBook := models.Book{Id: "1", Title: "Test Book", Author: "Test Author"}
	updatedBook := models.Book{Id: initialBook.Id, Title: "Updated Book", Author: "Updated Author"}
	repo := NewBookRepository([]models.Book{initialBook})

	t.Run("Add", func(t *testing.T) {
		// Test adding a new book.
		newBook := models.Book{Title: "New Book", Author: "New Author"}
		addedBook, err := repo.Add(context.Background(), newBook)
		assert.NoError(t, err)
		assert.NotEmpty(t, addedBook.Id)

		// Test adding a book with an existing ID.
		duplicateBook := models.Book{Id: addedBook.Id, Title: "Duplicate Book", Author: "Duplicate Author"}
		_, err = repo.Add(context.Background(), duplicateBook)
		assert.Error(t, err)
	})

	t.Run("Update", func(t *testing.T) {
		// Test updating an existing book.
		updated, err := repo.Update(context.Background(), updatedBook)
		assert.NoError(t, err)
		assert.Equal(t, updatedBook, updated)

		// Test updating a non-existing book.
		nonExistingBook := models.Book{Id: "non-existing-id", Title: "Non-existing Book", Author: "Non-existing Author"}
		_, err = repo.Update(context.Background(), nonExistingBook)
		assert.Error(t, err)
	})

	t.Run("List", func(t *testing.T) {
		// Test listing all books.
		books, err := repo.List(context.Background())
		assert.NoError(t, err)
		assert.Len(t, books, 2) // Includes the initial book and the one added.
	})

	t.Run("GetById", func(t *testing.T) {
		// Test getting a book by ID.
		book, err := repo.GetById(context.Background(), initialBook.Id)
		assert.NoError(t, err)
		assert.Equal(t, updatedBook, book)

		// Test getting a non-existing book.
		_, err = repo.GetById(context.Background(), "non-existing-id")
		assert.Error(t, err)
	})

	t.Run("DeleteById", func(t *testing.T) {
		// Test deleting a book by ID.
		deletedBook, err := repo.DeleteById(context.Background(), initialBook.Id)
		assert.NoError(t, err)
		assert.Equal(t, updatedBook, deletedBook)

		// Test deleting a non-existing book.
		_, err = repo.DeleteById(context.Background(), "non-existing-id")
		assert.Error(t, err)
	})
}
