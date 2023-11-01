PROTOC_GEN_GO := $(GOPATH)/bin/protoc-gen-go

.PHONY: all clean greeter_server greeter_client serve say_hello

all: greeter_server greeter_client

greeter_server:
	mkdir -p target/greeter_server
	protoc --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative \
    pkg/greeter.proto
	go build -o target/greeter_server/server greeter_server/main.go

greeter_client:
	mkdir -p target/greeter_client
	protoc --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative \
    pkg/greeter.proto
	go build -o target/greeter_client/client greeter_client/main.go

clean:
	rm -rf target

serve:
	./target/greeter_server/server

say_hello:
	GREETER_SERVICE=localhost:8080 ./target/greeter_client/client
