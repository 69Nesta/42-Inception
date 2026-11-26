FROM alpine:3.23

RUN apk update && apk upgrade && apk add --no-cache redis

COPY ./conf/redis.conf /ect/redis.conf

EXPOSE 6379
ENTRYPOINT [ "redis-server", "/ect/redis.conf", "--requirepass", "$REDIS_PASSWORD" ]
