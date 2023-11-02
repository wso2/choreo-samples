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
	"encoding/base64"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"os"

	"github.com/gorilla/mux"
	"go.uber.org/zap"
)

type User struct {
	UserId    string `json:"userId"`
	FirstName string `json:"firstName"`
	LastName  string `json:"lastName"`
	Email     string `json:"email"`
}

type RewardOffer struct {
	Id          string  `json:"id"`
	Name        string  `json:"name"`
	Value       float32 `json:"value"`
	TotalPoints int     `json:"totalPoints"`
	Description string  `json:"description"`
	LogoUrl     string  `json:"logoUrl"`
}

type UserReward struct {
	UserId               string `json:"userId"`
	SelectedRewardDealId string `json:"selectedRewardDealId"`
	Timestamp            string `json:"timestamp"`
	AcceptedTnC          bool   `json:"acceptedTnC"`
}

type RewardConfirmation struct {
	UserId                   string `json:"userId"`
	RewardId                 string `json:"rewardId"`
	RewardConfirmationNumber string `json:"rewardConfirmationNumber"`
}

type RewardConfirmationWithQR struct {
	UserId   string `json:"userId"`
	RewardId string `json:"rewardId"`
	QRCode   string `json:"qrCode"`
}

var logger *zap.Logger

var dataStoreApiUrl = os.Getenv("DATA_STORE_API_URL")
var qrCodeGeneratorApiUrl = os.Getenv("QR_CODE_GENERATOR_API_URL")

func init() {
	var err error
	logger, err = zap.NewProduction()
	if err != nil {
		panic(err)
	}
}

func main() {

	defer logger.Sync() // Ensure all buffered logs are written

	logger.Info("Starting the loyalty engine...")

	r := mux.NewRouter()

	r.HandleFunc("/rewards", getRewardOffers).Methods("GET")
	r.HandleFunc("/rewards/{id}", getRewardOffer).Methods("GET")
	r.HandleFunc("/user-rewards", getUserRewards).Methods("GET")
	r.HandleFunc("/user/{id}", getUserDetails).Methods("GET")
	r.HandleFunc("/reward-confirmation", getRewardConfirmation).Methods("GET")
	r.HandleFunc("/reward-confirmations", getRewardConfirmations).Methods("GET")
	r.HandleFunc("/qr-code", getQRCode).Methods("GET")
	http.ListenAndServe(":8080", r)
}

func getRewardOffers(w http.ResponseWriter, r *http.Request) {
	logger.Info("get reward offers")
	w.Header().Set("Content-Type", "application/json")

	var rewardOffers []RewardOffer
	rewardOffers, err := FetchRewardOffersFromDataStoreAPI()
	if err != nil {
		logger.Error("failed to fetch reward offers", zap.Error(err))
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte("failed to fetch reward offers"))
		return
	}

	json.NewEncoder(w).Encode(rewardOffers)
}

func getRewardOffer(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	params := mux.Vars(r)

	var rewardOffers []RewardOffer
	rewardOffers, err := FetchRewardOffersFromDataStoreAPI()
	if err != nil {
		logger.Error("failed to fetch reward offers", zap.Error(err))
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte("failed to fetch reward offers"))
		return
	}

	for _, item := range rewardOffers {
		if item.Id == params["id"] {
			json.NewEncoder(w).Encode(item)
			logger.Info("get reward offer", zap.Any("reward offer", item))
			return
		}
	}

	logger.Info("reward offer not found", zap.String("offer id", params["id"]))
	w.WriteHeader(http.StatusNotFound)
	json.NewEncoder(w).Encode(&User{})
}

func getUserRewards(w http.ResponseWriter, r *http.Request) {
	logger.Info("get user rewards")
	w.Header().Set("Content-Type", "application/json")

	var userRewards []UserReward
	userRewards, err := FetchUserRewardsFromDataStoreAPI()
	if err != nil {
		logger.Error("failed to fetch user rewards", zap.Error(err))
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte("failed to fetch user rewards"))
		return
	}

	json.NewEncoder(w).Encode(userRewards)
}

func getUserDetails(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	params := mux.Vars(r)

	var users []User
	users, err := FetchUsersFromDataStoreAPI()
	if err != nil {
		logger.Error("failed to fetch users", zap.Error(err))
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte("failed to fetch user details"))
		return
	}

	for _, user := range users {
		if user.UserId == params["id"] {
			json.NewEncoder(w).Encode(user)
			logger.Info("get user details", zap.Any("user", user))
			return
		}
	}

	logger.Info("user not found", zap.String("user id", params["id"]))
	w.WriteHeader(http.StatusNotFound)
	json.NewEncoder(w).Encode(&User{})
}

func getRewardConfirmation(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	userId := r.URL.Query().Get("userId")
	rewardId := r.URL.Query().Get("rewardId")
	logger.Info("get reward confirmation for:", zap.String("userId", userId), zap.String("rewardId", rewardId))

	rewardConfirmation, err := FetchRewardConfirmationFromDataStoreAPI(userId, rewardId)
	if err != nil {
		logger.Error("failed to fetch reward confirmation", zap.Error(err))
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte("failed to fetch reward confirmation"))
		return
	}
	logger.Info("reward confirmation: ", zap.Any("reward confirmation", rewardConfirmation))

	json.NewEncoder(w).Encode(rewardConfirmation)
}

func getRewardConfirmations(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	userId := r.URL.Query().Get("userId")
	logger.Info("get reward confirmations for:", zap.String("userId", userId))

	rewardConfirmations, err := FetchRewardConfirmationsFromDataStoreAPI(userId)
	if err != nil {
		logger.Error("failed to fetch reward confirmations", zap.Error(err))
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte("failed to fetch reward confirmations"))
		return
	}
	logger.Info("reward confirmation: ", zap.Any("reward confirmation", rewardConfirmations))

	rewardConfirmationsWithQR := make([]RewardConfirmationWithQR, len(rewardConfirmations))
	for i, rewardConfirmation := range rewardConfirmations {
		qrCode, err := FetchQRCodeFromQRCodeGeneratorAPI(rewardConfirmation.RewardConfirmationNumber)
		if err != nil {
			logger.Error("failed to fetch QR code", zap.Error(err))
			w.WriteHeader(http.StatusInternalServerError)
			w.Write([]byte("failed to fetch QR code"))
		}
		// Encode the qrCode to base64
		encodedQRCode := base64.StdEncoding.EncodeToString(qrCode)
		rewardConfirmationsWithQR[i] = RewardConfirmationWithQR{
			UserId:   rewardConfirmation.UserId,
			RewardId: rewardConfirmation.RewardId,
			QRCode:   encodedQRCode,
		}
	}
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(rewardConfirmationsWithQR)
	logger.Info("reward confirmations: ", zap.Any("reward confirmations", rewardConfirmationsWithQR))
}

func getQRCode(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	userId := r.URL.Query().Get("userId")
	rewardId := r.URL.Query().Get("rewardId")
	logger.Info("get reward confirmation for:", zap.String("userId", userId), zap.String("rewardId", rewardId))

	rewardConfirmation, err := FetchRewardConfirmationFromDataStoreAPI(userId, rewardId)
	if err != nil {
		logger.Error("failed to fetch reward confirmation", zap.Error(err))
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte("failed to fetch reward confirmation"))
		return
	}
	logger.Info("reward confirmation: ", zap.Any("reward confirmation", rewardConfirmation))

	qrCode, err := FetchQRCodeFromQRCodeGeneratorAPI(rewardConfirmation.RewardConfirmationNumber)
	if err != nil {
		logger.Error("failed to fetch QR code", zap.Error(err))
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte("failed to fetch QR code"))
	}

	w.Header().Set("Content-Type", "image/png")
	w.Write(qrCode)
}

func FetchRewardOffersFromDataStoreAPI() ([]RewardOffer, error) {
	// Construct the full URL using the base URL from the environment variable
	url := fmt.Sprintf("%s/reward-offers", dataStoreApiUrl)
	// Make the HTTP GET request
	resp, err := http.Get(url)
	if err != nil {
		logger.Error("failed to fetch reward offers", zap.Error(err))
		return nil, fmt.Errorf("failed to fetch reward offers: %v", err)
	}
	defer resp.Body.Close()

	// Check for non-200 status codes
	if resp.StatusCode != http.StatusOK {
		logger.Warn("API responded with non-200 status code", zap.Int("statusCode", resp.StatusCode))
		return nil, fmt.Errorf("API responded with status code: %d", resp.StatusCode)
	}

	// Decode the response body into the User struct
	var rewardOffers []RewardOffer
	if err := json.NewDecoder(resp.Body).Decode(&rewardOffers); err != nil {
		logger.Error("failed to decode reward offers data", zap.Error(err))
		return nil, fmt.Errorf("failed to decode reward offers data: %v", err)
	}

	logger.Info("successfully fetched reward offers")
	return rewardOffers, nil
}

func FetchUserRewardsFromDataStoreAPI() ([]UserReward, error) {
	// Construct the full URL using the base URL from the environment variable
	url := fmt.Sprintf("%s/user-rewards", dataStoreApiUrl)
	// Make the HTTP GET request
	resp, err := http.Get(url)
	if err != nil {
		logger.Error("failed to fetch user rewards", zap.Error(err))
		return nil, fmt.Errorf("failed to fetch user rewards: %v", err)
	}
	defer resp.Body.Close()

	// Check for non-200 status codes
	if resp.StatusCode != http.StatusOK {
		logger.Warn("API responded with non-200 status code", zap.Int("statusCode", resp.StatusCode))
		return nil, fmt.Errorf("API responded with status code: %d", resp.StatusCode)
	}

	// Decode the response body into the User struct
	var userRewards []UserReward
	if err := json.NewDecoder(resp.Body).Decode(&userRewards); err != nil {
		logger.Error("failed to decode user rewards data", zap.Error(err))
		return nil, fmt.Errorf("failed to decode user rewards data: %v", err)
	}

	logger.Info("successfully fetched user rewards")
	return userRewards, nil
}

func FetchUsersFromDataStoreAPI() ([]User, error) {
	// Construct the full URL using the base URL from the environment variable
	url := fmt.Sprintf("%s/users", dataStoreApiUrl)
	// Make the HTTP GET request
	resp, err := http.Get(url)
	if err != nil {
		logger.Error("failed to fetch users", zap.Error(err))
		return nil, fmt.Errorf("failed to fetch users: %v", err)
	}
	defer resp.Body.Close()

	// Check for non-200 status codes
	if resp.StatusCode != http.StatusOK {
		logger.Warn("API responded with non-200 status code", zap.Int("statusCode", resp.StatusCode))
		return nil, fmt.Errorf("API responded with status code: %d", resp.StatusCode)
	}

	// Decode the response body into the User struct
	var users []User
	if err := json.NewDecoder(resp.Body).Decode(&users); err != nil {
		logger.Error("failed to decode users data", zap.Error(err))
		return nil, fmt.Errorf("failed to decode users data: %v", err)
	}

	logger.Info("successfully fetched users")
	return users, nil
}

func FetchRewardConfirmationFromDataStoreAPI(userId string, rewardId string) (*RewardConfirmation, error) {
	// Construct the full URL using the base URL from the environment variable
	url := fmt.Sprintf("%s/reward-confirmation?userId=%s&rewardId=%s", dataStoreApiUrl, userId, rewardId)
	// Make the HTTP GET request
	resp, err := http.Get(url)
	if err != nil {
		logger.Error("failed to fetch reward confirmatio", zap.Error(err))
		return nil, fmt.Errorf("failed to fetch reward confirmatio: %v", err)
	}
	defer resp.Body.Close()

	// Check for non-200 status codes
	if resp.StatusCode != http.StatusOK {
		logger.Warn("API responded with non-200 status code", zap.Int("statusCode", resp.StatusCode))
		return nil, fmt.Errorf("API responded with status code: %d", resp.StatusCode)
	}

	// Decode the response body into the User struct
	var rewardConfirmation RewardConfirmation
	if err := json.NewDecoder(resp.Body).Decode(&rewardConfirmation); err != nil {
		logger.Error("failed to decode reward confirmation data", zap.Error(err))
		return nil, fmt.Errorf("failed to decode reward confirmation data: %v", err)
	}

	logger.Info("successfully fetched reward confirmation", zap.String("userId", userId),
		zap.String("rewardId", rewardId), zap.Any("rewardConfirmation", rewardConfirmation))
	return &rewardConfirmation, nil
}

func FetchRewardConfirmationsFromDataStoreAPI(userId string) ([]RewardConfirmation, error) {
	// Construct the full URL using the base URL from the environment variable
	url := fmt.Sprintf("%s/reward-confirmations?userId=%s", dataStoreApiUrl, userId)
	// Make the HTTP GET request
	resp, err := http.Get(url)
	if err != nil {
		logger.Error("failed to fetch reward confirmations", zap.Error(err))
		return nil, fmt.Errorf("failed to fetch reward confirmations: %v", err)
	}
	defer resp.Body.Close()

	// Check for non-200 status codes
	if resp.StatusCode != http.StatusOK {
		logger.Warn("API responded with non-200 status code", zap.Int("statusCode", resp.StatusCode))
		return nil, fmt.Errorf("API responded with status code: %d", resp.StatusCode)
	}

	// Decode the response body into the RewardConfirmation struct
	var rewardConfirmations []RewardConfirmation
	if err := json.NewDecoder(resp.Body).Decode(&rewardConfirmations); err != nil {
		logger.Error("failed to decode reward confirmations data", zap.Error(err))
		return nil, fmt.Errorf("failed to decode reward confirmations data: %v", err)
	}

	logger.Info("successfully fetched reward confirmations", zap.String("userId", userId),
		zap.Any("rewardConfirmation", rewardConfirmations))
	return rewardConfirmations, nil
}

func FetchQRCodeFromQRCodeGeneratorAPI(rewardConfirmationNumber string) ([]byte, error) {
	// Construct the full URL using the base URL from the environment variable
	url := fmt.Sprintf("%s/qrcode?content=%s", qrCodeGeneratorApiUrl, rewardConfirmationNumber)
	// Make the HTTP GET request
	resp, err := http.Get(url)
	if err != nil {
		logger.Error("failed to fetch qr code", zap.Error(err))
		return nil, fmt.Errorf("failed to fetch qr code: %v", err)
	}
	defer resp.Body.Close()

	// Check for non-200 status codes
	if resp.StatusCode != http.StatusOK {
		logger.Warn("API responded with non-200 status code", zap.Int("statusCode", resp.StatusCode))
		return nil, fmt.Errorf("API responded with status code: %d", resp.StatusCode)
	}

	var binaryPayload []byte
	binaryPayload, err = ioutil.ReadAll(resp.Body)
	if err != nil {
		logger.Error("failed to read qr code response body", zap.Error(err))
		return nil, fmt.Errorf("failed to read qr code response body: %v", err)
	}

	logger.Info("successfully fetched qr code", zap.String("rewardConfirmationNumber", rewardConfirmationNumber))
	return binaryPayload, nil
}
