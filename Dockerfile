FROM golang:1.21 AS builder
RUN apt-get update && \
    apt-get install -y protobuf-compiler && \
    go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.31.0 && \
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.3.0
WORKDIR /
COPY api.proto .
RUN protoc --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative --experimental_allow_proto3_optional api.proto
    
FROM scratch
COPY --from=builder /api.pb.go /api_grpc.pb.go /
