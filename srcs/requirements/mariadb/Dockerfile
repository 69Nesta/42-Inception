FROM alpine:3.23

RUN apk update && apk upgrade && apk --no-cache add mariadb mariadb-client

COPY tools/install.sh .
RUN chmod +x ./install.sh

EXPOSE 3306
ENTRYPOINT [ "sh", "./install.sh" ]
