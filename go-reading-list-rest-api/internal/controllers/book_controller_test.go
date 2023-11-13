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
	"github.com/wso2/choreo-sample-apps/go/rest-api/internal/models"
	"github.com/wso2/choreo-sample-apps/go/rest-api/internal/repositories"
)

// MockBookRepository is a mock implementation of the models.BookRepository interface for testing purposes.
type MockBookRepository struct {
	data   map[string]models.Book
	err    error
	exists bool
}

func (m *MockBookRepository) Add(ctx context.Context, book models.Book) (models.Book, error) {
	if m.exists {
		return models.Book{}, repositories.ErrRecordAlreadyExists
	}
	return book, m.err
}

func (m *MockBookRepository) Update(ctx context.Context, book models.Book) (models.Book, error) {
	if !m.exists {
		return models.Book{}, repositories.ErrRecordNotFound
	}
	return book, m.err
}

func (m *MockBookRepository) List(ctx context.Context) ([]models.Book, error) {
	books := make([]models.Book, 0, len(m.data))
	for _, book := range m.data {
		books = append(books, book)
	}
	return books, m.err
}

func (m *MockBookRepository) GetById(ctx context.Context, id string) (models.Book, error) {
	book, ok := m.data[id]
	if !ok {
		return models.Book{}, repositories.ErrRecordNotFound
	}
	return book, m.err
}

func (m *MockBookRepository) DeleteById(ctx context.Context, id string) (models.Book, error) {
	book, ok := m.data[id]
	if !ok {
		return models.Book{}, repositories.ErrRecordNotFound
	}
	delete(m.data, id)
	return book, m.err
}

func TestBookController(t *testing.T) {
	// Create a mock repository for testing.
	mockRepo := &MockBookRepository{
		data:   make(map[string]models.Book),
		err:    nil,
		exists: false,
	}

	controller := NewBookController(mockRepo)

	t.Run("AddBook", func(t *testing.T) {
		// Test adding a new book.
		newBook := models.Book{Title: "New Book", Author: "New Author"}
		mockRepo.exists = false
		book, err := controller.AddBook(context.Background(), newBook)
		assert.NoError(t, err)
		assert.Equal(t, newBook.Title, book.Title)

		// Test adding a book that already exists.
		mockRepo.exists = true
		_, err = controller.AddBook(context.Background(), newBook)
		assert.Equal(t, fiber.NewError(http.StatusConflict, "the book id [] is already exists"), err)
	})

	t.Run("UpdateBook", func(t *testing.T) {
		// Test updating an existing book.
		updatedBook := models.Book{Id: "1", Title: "Updated Book", Author: "Updated Author"}
		mockRepo.exists = true
		book, err := controller.UpdateBook(context.Background(), updatedBook)
		assert.NoError(t, err)
		assert.Equal(t, updatedBook.Title, book.Title)

		// Test updating a book that does not exist.
		mockRepo.exists = false
		_, err = controller.UpdateBook(context.Background(), updatedBook)
		assert.Equal(t, fiber.NewError(http.StatusNotFound, "the book id [1] is not found"), err)
	})

	t.Run("ListBooks", func(t *testing.T) {
		// Test listing books.
		mockRepo.data = map[string]models.Book{
			"1": {Id: "1", Title: "Book 1", Author: "Author 1"},
			"2": {Id: "2", Title: "Book 2", Author: "Author 2"},
		}
		books, err := controller.ListBooks(context.Background())
		assert.NoError(t, err)
		assert.Len(t, books, 2)

		// Test listing books with an error.
		mockRepo.err = errors.New("mock error")
		_, err = controller.ListBooks(context.Background())
		assert.Equal(t, fiber.NewError(http.StatusInternalServerError, "internal server error"), err)
	})

	t.Run("GetBook", func(t *testing.T) {
		// Test getting an existing book.
		mockRepo.data = map[string]models.Book{"1": {Id: "1", Title: "Book 1", Author: "Author 1"}}
		mockRepo.err = nil
		book, err := controller.GetBook(context.Background(), "1")
		assert.NoError(t, err)
		assert.Equal(t, "Book 1", book.Title)

		// Test getting a book that does not exist.
		_, err = controller.GetBook(context.Background(), "2")
		assert.Equal(t, fiber.NewError(http.StatusNotFound, "the book id [2] is not found"), err)
	})

	t.Run("DeleteBook", func(t *testing.T) {
		// Test deleting an existing book.
		mockRepo.data = map[string]models.Book{"1": {Id: "1", Title: "Book 1", Author: "Author 1"}}
		book, err := controller.DeleteBook(context.Background(), "1")
		assert.NoError(t, err)
		assert.Equal(t, "Book 1", book.Title)

		// Test deleting a book that does not exist.
		_, err = controller.DeleteBook(context.Background(), "2")
		assert.Equal(t, fiber.NewError(http.StatusNotFound, "the book id [2] is not found"), err)
	})
}
