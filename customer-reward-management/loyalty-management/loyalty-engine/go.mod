module loyalty-engine

go 1.21.0

require (
	github.com/gorilla/mux v1.8.0 // indirect
	go.uber.org/multierr v1.11.0 // indirect
	go.uber.org/zap v1.25.0 // indirect
	golang.org/x/oauth2 v0.12.0
)

replace loyalty-engine/model => ./model
