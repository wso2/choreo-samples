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

package config

import (
	"encoding/json"
	"log"
	"os"
	"strconv"
)

const (
	DefaultPort     = 8080
	DefaultHostname = "localhost"
)

var (
	EnvName         = "ENV"
	Hostname        = "HOSTNAME"
	Port            = "PORT"
	initialDataPath = "INIT_DATA_PATH"
)

var config Config

func GetConfig() *Config {
	return &config
}

func LoadConfig() (*Config, error) {
	config = Config{
		Hostname:        getEnvString(Hostname, DefaultHostname),
		Port:            getEnvInt(Port, DefaultPort),
		Env:             os.Getenv(EnvName),
		InitialDataPath: os.Getenv(initialDataPath),
	}
	return &config, nil
}

func LoadInitialData() (data InitialData) {
	if config.InitialDataPath == "" {
		return
	}
	contents, err := os.ReadFile(config.InitialDataPath)
	if err != nil {
		log.Fatalf("failed to read initial data at [%s]: %s", config.InitialDataPath, err)
	}
	if err := json.Unmarshal(contents, &data); err != nil {
		log.Fatalf("failed to unmarshal initial data at [%s]: %s", config.InitialDataPath, err)
	}
	return
}

func getEnvInt(key string, defaultVal int) int {
	s := os.Getenv(key)
	if s == "" {
		return defaultVal
	}
	v, err := strconv.Atoi(s)
	if err != nil {
		log.Panic(err)
	}
	return v
}

func getEnvString(key string, defaultVal string) string {
	s := os.Getenv(key)
	if s == "" {
		return defaultVal
	}
	return s
}
