FROM golang:1.21.1-alpine as build-env

RUN mkdir /app
WORKDIR /app
COPY go.mod go.sum ./

# Get dependancies - will also be cached if we won't change mod/sum
RUN go mod download

# Create a new user with UID 10014
RUN addgroup -g 10014 choreo && \
    adduser  --disabled-password  --no-create-home --uid 10014 --ingroup choreo choreouser


# COPY the source code as the last step
COPY . .

ENV CGO_ENABLED=0 GOOS=linux GOARCH=amd64

# Build the binary
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o /go/bin/app -buildvcs=false

FROM alpine
COPY --from=build-env /go/bin/app /go/bin/app

USER 10014
ENTRYPOINT ["/go/bin/app"]