# Copyright (c) 2023, WSO2 LLC. (https://www.wso2.com/) All Rights Reserved.
#
# WSO2 LLC. licenses this file to you under the Apache License,
# Version 2.0 (the "License"); you may not use this file except
# in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied. See the License for the
# specific language governing permissions and limitations
# under the License.

# Start with the official Golang base image as a build environment.
FROM golang:1.21-alpine AS builder

# Install necessary build tools.
# 'ca-certificates' is for SSL-enabled applications.
RUN apk add --no-cache ca-certificates git && update-ca-certificates

# Set the current working directory inside the container.
WORKDIR /src

# Copy go.mod and go.sum files first for better caching.
COPY go.mod go.sum ./

# Download dependencies.
# If these files haven't changed, this layer won't be rebuilt in subsequent docker builds.
RUN go mod download

# Copy the entire project source to the container.
COPY . .

# Build the Go app for a smaller binary size:
#   - CGO_ENABLED=0: Disables cgo resulting in a static binary.
#   - -ldflags: Strips debugging information.
#   - -trimpath: Removes file system paths from the resulting binary.
RUN CGO_ENABLED=0 GOOS=linux go build -a -ldflags='-w -s -extldflags "-static"' -trimpath -o /app .

# Use a minimal image for the runtime.
FROM scratch

# Import ca-certs to the runtime to ensure SSL works.
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# Copy the compiled binary from the builder stage.
COPY --from=builder /app /app

# Specify a non-root user to run the application (security best practice).
USER 10014

# Expose port 8080 for the application.
EXPOSE 8080

# Command to run the application.
CMD ["/app"]
