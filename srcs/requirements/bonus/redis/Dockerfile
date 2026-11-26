FROM alpine:3.23

RUN apk update && apk upgrade && apk add --no-cache redis

EXPOSE 6379
ENTRYPOINT [ "redis-server" ]