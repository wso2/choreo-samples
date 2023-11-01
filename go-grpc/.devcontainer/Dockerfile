FROM "mcr.microsoft.com/devcontainers/go:0-1.19"

USER vscode

RUN curl -o /tmp/protoc.zip -LO https://github.com/protocolbuffers/protobuf/releases/download/v22.3/protoc-22.3-linux-aarch_64.zip && \
    unzip /tmp/protoc.zip -d /home/vscode/.local && \
    echo 'export PATH=$PATH:/home/vscode/.local/bin' >> /home/vscode/.bashrc && \
    rm /tmp/protoc.zip && \
    go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28 && \
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2
