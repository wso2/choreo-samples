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
	"github.com/wso2/choreo-sample-apps/go/rest-api/internal/models"
	"github.com/wso2/choreo-sample-apps/go/rest-api/internal/repositories"
)

type BookController struct {
	bookRepository models.BookRepository
}

func NewBookController(bookRepository models.BookRepository) *BookController {
	return &BookController{bookRepository}
}

func (c *BookController) AddBook(ctx context.Context, newBook models.Book) (models.Book, error) {
	setDefaultBookFields(&newBook)
	if err := validateBook(newBook); err != nil {
		return models.Book{}, err
	}
	book, err := c.bookRepository.Add(ctx, newBook)
	if errors.Is(err, repositories.ErrRecordAlreadyExists) {
		return models.Book{}, makeHttpConflictError(newBook.Id)
	} else if err != nil {
		return models.Book{}, makeHttpInternalServerError()
	}
	return book, nil
}

func (c *BookController) UpdateBook(ctx context.Context, updatedBook models.Book) (models.Book, error) {
	setDefaultBookFields(&updatedBook)
	if err := validateBook(updatedBook); err != nil {
		return models.Book{}, err
	}
	book, err := c.bookRepository.Update(ctx, updatedBook)
	if errors.Is(err, repositories.ErrRecordNotFound) {
		return models.Book{}, makeHttpNotFoundError(updatedBook.Id)
	} else if err != nil {
		return models.Book{}, makeHttpInternalServerError()
	}
	return book, nil
}

func (c *BookController) ListBooks(ctx context.Context) ([]models.Book, error) {
	books, err := c.bookRepository.List(ctx)
	if err != nil {
		return nil, makeHttpInternalServerError()
	}
	if books == nil {
		return make([]models.Book, 0), nil
	}
	return books, nil
}

func (c *BookController) GetBook(ctx context.Context, bookId string) (models.Book, error) {
	book, err := c.bookRepository.GetById(ctx, bookId)
	if errors.Is(err, repositories.ErrRecordNotFound) {
		return models.Book{}, makeHttpNotFoundError(bookId)
	} else if err != nil {
		return models.Book{}, makeHttpInternalServerError()
	}
	return book, nil
}

func (c *BookController) DeleteBook(ctx context.Context, bookId string) (models.Book, error) {
	book, err := c.bookRepository.DeleteById(ctx, bookId)
	if errors.Is(err, repositories.ErrRecordNotFound) {
		return models.Book{}, makeHttpNotFoundError(bookId)
	} else if err != nil {
		return models.Book{}, makeHttpInternalServerError()
	}
	return book, nil
}

func makeHttpNotFoundError(id string) *fiber.Error {
	return fiber.NewError(http.StatusNotFound, fmt.Sprintf("the book id [%s] is not found", id))
}

func makeHttpConflictError(id string) *fiber.Error {
	return fiber.NewError(http.StatusConflict, fmt.Sprintf("the book id [%s] is already exists", id))
}

func makeHttpInternalServerError() *fiber.Error {
	return fiber.NewError(http.StatusInternalServerError, "internal server error")
}

func validateBook(book models.Book) *fiber.Error {
	if book.Title == "" {
		return fiber.NewError(http.StatusBadRequest, "book title is required")
	}
	switch book.Status {
	case models.ReadStatusToRead, models.ReadStatusReading, models.ReadStatusRead:
	default:
		return fiber.NewError(http.StatusBadRequest, "book status should be one of [ro_read, reading, read]")

	}
	return nil
}

func setDefaultBookFields(book *models.Book) {
	if book.Status == "" {
		book.Status = models.ReadStatusToRead
	}
}
