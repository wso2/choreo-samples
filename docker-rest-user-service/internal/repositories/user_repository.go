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

	"github.com/wso2/choreo-sample-apps/byoi-components/services/rest-user-service/internal/models"
)

type userRepository struct {
	store map[string]models.User
	lock  sync.RWMutex
}

func NewUserRepository(initialData []models.User) models.UserRepository {
	m := make(map[string]models.User, 0)
	if len(initialData) > 0 {
		for _, user := range initialData {
			m[user.Id] = user
		}
	}
	return &userRepository{
		store: m,
		lock:  sync.RWMutex{},
	}
}

func (r *userRepository) Add(ctx context.Context, user models.User) (models.User, error) {
	r.lock.Lock()
	defer r.lock.Unlock()
	if user.Id == "" {
		user.Id = uuid.NewString()
	}
	if _, ok := r.store[user.Id]; ok {
		return models.User{}, fmt.Errorf("userRepository:Add: %w", ErrRecordAlreadyExists)
	}
	r.store[user.Id] = user
	return r.store[user.Id], nil
}

func (r *userRepository) Update(ctx context.Context, updatedUser models.User) (models.User, error) {
	r.lock.Lock()
	defer r.lock.Unlock()
	if _, ok := r.store[updatedUser.Id]; !ok {
		return models.User{}, fmt.Errorf("userRepository:Update: %w", ErrRecordNotFound)
	}
	r.store[updatedUser.Id] = updatedUser
	return r.store[updatedUser.Id], nil
}

func (r *userRepository) List(ctx context.Context) ([]models.User, error) {
	r.lock.RLock()
	defer r.lock.RUnlock()
	var users []models.User
	for _, user := range r.store {
		users = append(users, user)
	}
	return users, nil
}

func (r *userRepository) GetById(ctx context.Context, id string) (models.User, error) {
	r.lock.RLock()
	defer r.lock.RUnlock()
	if _, ok := r.store[id]; !ok {
		return models.User{}, fmt.Errorf("userRepository:GetById: %w", ErrRecordNotFound)
	}
	return r.store[id], nil
}

func (r *userRepository) DeleteById(ctx context.Context, id string) (models.User, error) {
	r.lock.RLock()
	defer r.lock.RUnlock()

	if _, ok := r.store[id]; !ok {
		return models.User{}, fmt.Errorf("userRepository:DeleteById: %w", ErrRecordNotFound)
	}
	user := r.store[id]
	delete(r.store, id)
	return user, nil
}
