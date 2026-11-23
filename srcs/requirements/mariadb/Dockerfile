FROM alpine:3.24

RUN apk update && apk upgrade && apk add mariadb mariadb-client

COPY tools/install.sh .
COPY tools/init.sh .
RUN chmod +x ./install.sh ./init.sh
RUN ./install.sh
RUN ./init.sh

ENTRYPOINT [ "mariadbd", "--user=mysql", "--datadir=/var/lib/mysql" ]
