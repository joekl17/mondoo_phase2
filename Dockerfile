FROM --platform=linux/amd64 golang:alpine AS builder

ARG TOKEN
ARG DOWNLOAD_URL

WORKDIR /app

RUN apk add --no-cache curl tar libc6-compat

RUN curl -L \
    -H "Accept: application/octet-stream" \
    -H "Authorization: Bearer $TOKEN" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    $DOWNLOAD_URL -o app.tar.gz && \
    tar -xzf app.tar.gz && \
    mv mondoo-phase1 /app/app_binary && \
    chmod +x /app/app_binary

FROM --platform=linux/amd64 alpine:latest AS application

RUN apk add --no-cache curl tar libc6-compat

WORKDIR /app

COPY --from=builder /app/app_binary /app/app_binary

EXPOSE 8080

ENTRYPOINT ["/app/app_binary"]
