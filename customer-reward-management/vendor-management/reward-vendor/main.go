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

package main

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"math/rand"
	"net/http"
	"os"
	"time"

	"github.com/gorilla/mux"
	"go.uber.org/zap"
	"golang.org/x/oauth2/clientcredentials"
)

type Reward struct {
	RewardId  string `json:"rewardId"`
	UserId    string `json:"userId"`
	FirstName string `json:"firstName"`
	LastName  string `json:"lastName"`
	Email     string `json:"email"`
}

type RewardConfirmation struct {
	RewardConfirmationNumber string `json:"rewardConfirmationNumber"`
	UserId                   string `json:"userId"`
	RewardId                 string `json:"rewardId"`
}

var logger *zap.Logger
var rewards []Reward

var clientId = os.Getenv("CLIENT_ID")
var clientSecret = os.Getenv("CLIENT_SECRET")
var tokenUrl = os.Getenv("TOKEN_URL")
var rewardConfirmationWebhookUrl = os.Getenv("REWARD_CONFIRMATION_WEBHOOK_URL")

var clientCredsConfig = clientcredentials.Config{
	ClientID:     clientId,
	ClientSecret: clientSecret,
	TokenURL:     tokenUrl,
}

func init() {
	var err error
	logger, err = zap.NewProduction()
	if err != nil {
		panic(err)
	}
}

func main() {
	defer logger.Sync() // Ensure all buffered logs are written

	logger.Info("Starting the reward vendor...")

	r := mux.NewRouter()

	r.HandleFunc("/rewards", HandleCreateReward).Methods("POST")
	http.ListenAndServe(":8080", r)
}

func HandleCreateReward(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	var reward Reward
	_ = json.NewDecoder(r.Body).Decode(&reward)

	logger.Info("creating a reward")
	rewards = append(rewards, reward)
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(reward)
	logger.Info("successfully created a reward")

	RespondWithRewardConfirmation(reward.RewardId, reward.UserId)
}

func RespondWithRewardConfirmation(rewardId string, userId string) {
	logger.Info("responding with reward confirmation")

	// Generate the 16-digit number and encapsulate in an anonymous struct
	rewardConfirmation := RewardConfirmation{
		RewardConfirmationNumber: Generate16DigitNumber(),
		UserId:                   userId,
		RewardId:                 rewardId,
	}

	// Convert the anonymous struct to JSON
	data, err := json.Marshal(rewardConfirmation)
	if err != nil {
		logger.Error("Failed to marshal data", zap.Error(err))
	}

	resp, err := clientCredsConfig.Client(context.Background()).Post(rewardConfirmationWebhookUrl,
		"application/json", bytes.NewBuffer(data))
	if err != nil {
		logger.Error("Failed to send POST request", zap.Error(err))
	}
	defer resp.Body.Close()

	// Optionally, handle non-200 status codes
	if resp.StatusCode != http.StatusAccepted {
		logger.Warn("Webhook responded with non-200 status code", zap.Int("statusCode", resp.StatusCode))
	} else {
		logger.Info("Successfully sent reward confirmation", zap.Any("rewardConfirmation", rewardConfirmation))
	}
}

func Generate16DigitNumber() string {
	src := rand.NewSource(time.Now().UnixNano())
	r := rand.New(src)
	// To ensure it's always 16 digits, generate a number between 1000_0000_0000_0000 and 9999_9999_9999_9999
	number := r.Int63n(9000_0000_0000_0000) + 1000_0000_0000_0000

	return fmt.Sprintf("%016d", number)
}
