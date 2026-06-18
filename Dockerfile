FROM golang:alpine AS builder
WORKDIR /app
COPY main.go .
RUN go build -o go-server main.go

FROM alpine
WORKDIR /app
COPY --from=builder /app/go-server .
EXPOSE 8090
CMD ["./go-server"]
