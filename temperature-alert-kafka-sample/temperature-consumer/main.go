package main

import (
	"context"
	"crypto/tls"
	"crypto/x509"
	"encoding/json"
	"fmt"
	"log"
	"os"
	"time"

	"github.com/segmentio/kafka-go"
)

type WeatherData struct {
	StationId            int    `json:"stationId"`
	StationName          string `json:"stationName"`
	TemperatureInCelsius int    `json:"temperatureInCelsius"`
}

func loadPEMFromFile(filePath string) ([]byte, error) {
	data, err := os.ReadFile(filePath)
	if err != nil {
		return nil, fmt.Errorf("failed to read file %s: %w", filePath, err)
	}
	return data, nil
}

func main() {

	serviceCert, err := loadPEMFromFile("/service.cert")
	if err != nil {
		log.Fatalf("Failed to load SERVICE_CERT: %s", err)
	}
	serviceKey, err := loadPEMFromFile("/service.key")
	if err != nil {
		log.Fatalf("Failed to load SERVICE_KEY: %s", err)
	}
	caCert, err := loadPEMFromFile("/ca.pem")
	if err != nil {
		log.Fatalf("Failed to load CA_CERT: %s", err)
	}

	keypair, err := tls.X509KeyPair(serviceCert, serviceKey)
	if err != nil {
		log.Fatalf("Failed to load access key and/or access certificate: %s", err)
	}

	caCertPool := x509.NewCertPool()
	ok := caCertPool.AppendCertsFromPEM(caCert)
	if !ok {
		log.Fatalf("Failed to parse CA certificate from environment variable")
	}

	dialer := &kafka.Dialer{
		Timeout:   10 * time.Second,
		DualStack: true,
		TLS: &tls.Config{
			Certificates: []tls.Certificate{keypair},
			RootCAs:      caCertPool,
		},
	}

	serviceURI := os.Getenv("SERVICE_URI")
	if serviceURI == "" {
		fmt.Println("Environment variable 'SERVICE_URI' not set")
	}
	topicName := os.Getenv("TOPIC_NAME")
	if topicName == "" {
		fmt.Println("Environment variable 'TOPIC_NAME' not set")
	}
	consumer := kafka.NewReader(kafka.ReaderConfig{
		Brokers: []string{serviceURI},
		Topic:   topicName,
		Dialer:  dialer,
	})
	defer consumer.Close()

	for {
		message, err := consumer.ReadMessage(context.Background())
		if err != nil {
			log.Printf("Could not read message: %s", err)
		} else {
			temperature := WeatherData{}
			value := message.Value
			log.Printf("Got message using SSL: %s", message.Value)
			err := json.Unmarshal(value, &temperature)
			if err != nil {
				log.Printf("Could not unmarshal message: %s", err)
			}
			if temperature.TemperatureInCelsius > 30 {
				log.Printf("Temperature is too high: %d StationId:%d", temperature.TemperatureInCelsius, temperature.StationId)
			}

		}
	}
}
