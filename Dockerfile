ARG GOOS=linux
ARG GOARCH=amd64

#------------------------------------
# Builder
FROM golang:alpine as builder

# Install git.
# Git is required for fetching the dependencies.
RUN apk update && apk add --no-cache git && rm -f /var/cache/apk/*

WORKDIR /go/src/app
COPY ./app .

# Install dependencies...
# Using go get.
RUN go get -d -v

# Compile
RUN CGO_ENABLED=0 GOOS=${GOOS} GOARCH=${GOARCH} go build -v -a -installsuffix cgo -o /app_bin .

#------------------------------------
# Exec
FROM scratch
EXPOSE 9000
COPY --from=builder /app_bin /app_bin

CMD ["/app_bin"]