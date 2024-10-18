FROM golang:alpine AS build_webhook
MAINTAINER Dolf <398745129@qq.com>
RUN apk add --update --no-cache -t build-deps curl gcc libc-dev libgcc
WORKDIR /go/src/github.com/adnanh/webhook
ENV WEBHOOK_VERSION 2.8.1
RUN curl -L --silent -o webhook.tar.gz https://github.com/adnanh/webhook/archive/${WEBHOOK_VERSION}.tar.gz && \
            tar -xzf webhook.tar.gz --strip 1
RUN go get -d -v
RUN CGO_ENABLED=0 go build -ldflags="-s -w" -o /usr/local/bin/webhook

FROM ubuntu:latest
COPY --from=build_webhook /usr/local/bin/webhook /usr/local/bin/webhook
COPY ./webhook /webhook
WORKDIR /webhook
EXPOSE 9000
ENTRYPOINT  ["/usr/local/bin/webhook"]
CMD [ "-verbose", "-hotreload", "-hooks=config/hooks.yml"]
