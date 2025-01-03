package main

import (
	"context"
	"crypto/tls"
	"crypto/x509"
	"encoding/json"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/segmentio/kafka-go"
)

type WeatherData struct {
	StationId            int    `json:"stationId"`
	StationName          string `json:"stationName"`
	TemperatureInCelsius int    `json:"temperatureInCelsius"`
}

func main() {

	serviceCert, err := os.ReadFile("/service.cert")
	if err != nil {
		log.Fatalf("Failed to load SERVICE_CERT: %s", err)
	}
	serviceKey, err := os.ReadFile("/service.key")
	if err != nil {
		log.Fatalf("Failed to load SERVICE_KEY: %s", err)
	}
	caCert, err := os.ReadFile("/ca.pem")
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
		log.Fatalf("Environment variable 'SERVICE_URI' not set")
	}
	topicName := os.Getenv("TOPIC_NAME")
	if topicName == "" {
		log.Fatalf("Environment variable 'TOPIC_NAME' not set")
	}
	producer := kafka.NewWriter(kafka.WriterConfig{
		Brokers: []string{serviceURI},
		Topic:   topicName,
		Dialer:  dialer,
	})
	defer producer.Close()

	// Below endpoint will publish the temperature values of a certain station
	http.HandleFunc("/publish-temperature", func(w http.ResponseWriter, r *http.Request) {
		if r.Method != http.MethodPost {
			http.Error(w, "Invalid request method", http.StatusMethodNotAllowed)
			return
		}

		var data WeatherData
		if err := json.NewDecoder(r.Body).Decode(&data); err != nil {
			http.Error(w, "Invalid request payload", http.StatusBadRequest)
			return
		}

		jsonData, err := json.Marshal(data)
		if err != nil {
			http.Error(w, "Failed to marshal JSON data", http.StatusInternalServerError)
			return
		}
		err = producer.WriteMessages(context.Background(), kafka.Message{Value: jsonData})
		if err != nil {
			log.Printf("Failed to send message: %s", err)
			http.Error(w, "Failed to send message", http.StatusInternalServerError)
			return
		}
		log.Printf("Message sent: %s", jsonData)
		w.WriteHeader(http.StatusOK)
		response := map[string]string{
			"status":  "success",
			"message": "Temperature data published successfully",
			"values":  string(jsonData),
		}
		json.NewEncoder(w).Encode(response)
	})

	// Start the server on port 9090
	log.Println("Server starting on port 9090...")
	log.Fatal(http.ListenAndServe(":9090", nil))
}
