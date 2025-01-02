# Use the official Golang image from Docker Hub.
# It includes the Go runtime and tools at the specified version (1.22.3).
FROM golang:1.22.3 as builder

# Set the working directory inside the container.
WORKDIR /app

# Copy go.mod and go.sum files to the container image.
# If you have these files, uncomment the following lines:
# COPY go.mod ./
# COPY go.sum ./

# If you use modules, download dependencies.
# Uncomment this line if your project uses go.mod:
# RUN go mod download

# Copy the local package files to the container's workspace.
COPY . .

# Build the command inside the container.
# Depending on your application structure, you might need to change './...' to './cmd/myapp' or similar.
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o main .

# Use a Docker multi-stage build to create a lean production image.
# Start with a smaller base image.
FROM alpine:latest  
RUN apk --no-cache add ca-certificates

# Set the working directory to /root/ (or any directory that suits your needs)
WORKDIR /root/

# Copy the binary from the builder stage to the production image.
COPY --from=builder /app/main .

# Run the binary.
ENTRYPOINT ["./main"]

# Expose port 9090 to the outside world.
EXPOSE 9090
