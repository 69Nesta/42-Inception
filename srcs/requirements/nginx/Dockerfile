FROM alpine:3.24

RUN apk update && apk upgrade && apk --no-cache add nginx

EXPOSE 80
EXPOSE 443
ENTRYPOINT ["nginx", "-g", "daemon off;"]
