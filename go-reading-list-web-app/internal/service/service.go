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
 
package service

import (
	"bytes"
	"encoding/json"
	"fmt"
	"go-reading-list-web-app/internal/config"
	"net/http"
)

type Service struct {
	ApiUrl string
}

// NewService creates a new instance of the service with the provided API URL
func NewService(apiUrl string) *Service {
	return &Service{
		ApiUrl: apiUrl,
	}
}

// FetchBooks fetches the list of books from the API using the provided access token
func (s *Service) FetchBooks(accessToken string) ([]config.Book, error) {
	client := &http.Client{}
	req, err := http.NewRequest("GET", s.ApiUrl+"/books", nil)
	if err != nil {
		return nil, err
	}
	req.Header.Set("Authorization", "Bearer "+accessToken)
	resp, err := client.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("failed to fetch books: %s", resp.Status)
	}

	var booksMap map[string]config.Book
	if err := json.NewDecoder(resp.Body).Decode(&booksMap); err != nil {
		return nil, err
	}

	books := make([]config.Book, 0, len(booksMap))
	for _, book := range booksMap {
		books = append(books, book)
	}

	return books, nil
}

// AddNewBook adds a new book to the list using the provided access token
func (s Service) AddNewBook(accessToken string, book config.Book) error {
	client := &http.Client{}
	bookJson, err := json.Marshal(book)
	if err != nil {
		return err
	}
	req, err := http.NewRequest("POST", s.ApiUrl+"/books", bytes.NewBuffer(bookJson))
	if err != nil {
		return err
	}
	req.Header.Set("Authorization", "Bearer "+accessToken)
	req.Header.Set("Content-Type", "application/json")
	resp, err := client.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusCreated {
		return fmt.Errorf("failed to add book: %s", resp.Status)
	}
	return nil
}

// DeleteBook deletes a book from the list using the provided access token
func (s Service) DeleteBook(accessToken string, bookId string) error {
	client := &http.Client{}
	req, err := http.NewRequest("DELETE", s.ApiUrl+"/books/"+bookId, nil)
	if err != nil {
		return err
	}
	req.Header.Set("Authorization", "Bearer "+accessToken)
	resp, err := client.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusOK {
		return fmt.Errorf("failed to delete book: %s", resp.Status)
	}
	return nil
}
