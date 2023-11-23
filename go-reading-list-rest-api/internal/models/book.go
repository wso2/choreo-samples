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

package models

import (
	"context"
)

type ReadStatus string

const (
	ReadStatusToRead  ReadStatus = "to_read"
	ReadStatusReading ReadStatus = "reading"
	ReadStatusRead    ReadStatus = "read"
)

func (s ReadStatus) String() string {
	return string(s)
}

type Book struct {
	Id     string     `json:"id" example:"fe2594d0-ccea-42a2-97ac-0487458b5642"`
	Title  string     `json:"title" example:"The Lord of the Rings"`
	Author string     `json:"author" example:"J. R. R. Tolkien"`
	Status ReadStatus `json:"status" example:"to_read" enums:"to_read,reading,read"`
}

type BookRepository interface {
	Add(ctx context.Context, book Book) (Book, error)
	Update(ctx context.Context, updatedBook Book) (Book, error)
	List(ctx context.Context) ([]Book, error)
	GetById(ctx context.Context, id string) (Book, error)
	DeleteById(ctx context.Context, id string) (Book, error)
}
