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
	"fmt"
	"sync"

	"github.com/google/uuid"

	"github.com/wso2/choreo-sample-apps/go/rest-api/internal/models"
)

type bookRepository struct {
	store map[string]models.Book
	lock  sync.RWMutex
}

func NewBookRepository(initialData []models.Book) models.BookRepository {
	m := make(map[string]models.Book, 0)
	if len(initialData) > 0 {
		for _, book := range initialData {
			m[book.Id] = book
		}
	}
	return &bookRepository{
		store: m,
		lock:  sync.RWMutex{},
	}
}

func (r *bookRepository) Add(ctx context.Context, book models.Book) (models.Book, error) {
	r.lock.Lock()
	defer r.lock.Unlock()
	if book.Id == "" {
		book.Id = uuid.NewString()
	}
	if _, ok := r.store[book.Id]; ok {
		return models.Book{}, fmt.Errorf("bookRepository:Add: %w", ErrRecordAlreadyExists)
	}
	r.store[book.Id] = book
	return r.store[book.Id], nil
}

func (r *bookRepository) Update(ctx context.Context, updatedBook models.Book) (models.Book, error) {
	r.lock.Lock()
	defer r.lock.Unlock()
	if _, ok := r.store[updatedBook.Id]; !ok {
		return models.Book{}, fmt.Errorf("bookRepository:Update: %w", ErrRecordNotFound)
	}
	r.store[updatedBook.Id] = updatedBook
	return r.store[updatedBook.Id], nil
}

func (r *bookRepository) List(ctx context.Context) ([]models.Book, error) {
	r.lock.RLock()
	defer r.lock.RUnlock()
	var books []models.Book
	for _, book := range r.store {
		books = append(books, book)
	}
	return books, nil
}

func (r *bookRepository) GetById(ctx context.Context, id string) (models.Book, error) {
	r.lock.RLock()
	defer r.lock.RUnlock()
	if _, ok := r.store[id]; !ok {
		return models.Book{}, fmt.Errorf("bookRepository:GetById: %w", ErrRecordNotFound)
	}
	return r.store[id], nil
}

func (r *bookRepository) DeleteById(ctx context.Context, id string) (models.Book, error) {
	r.lock.RLock()
	defer r.lock.RUnlock()

	if _, ok := r.store[id]; !ok {
		return models.Book{}, fmt.Errorf("bookRepository:DeleteById: %w", ErrRecordNotFound)
	}
	book := r.store[id]
	delete(r.store, id)
	return book, nil
}
