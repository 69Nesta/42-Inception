FROM alpine:3.24

RUN apk update && apk upgrade && apk add mariadb mariadb-client

COPY tools/install.sh .
RUN sh ./install.sh

ENTRYPOINT [ "mariadbd", "--user=mysql", "--datadir=/var/lib/mysql" ]
