FROM alpine:3.23

RUN apk update && apk upgrade && apk add --no-cache proftpd proftpd-utils

RUN mkdir -p /etc/proftpd/
COPY ./conf/proftpd.conf /etc/proftpd/proftpd.conf

RUN mkdir -p /opt/tools/
COPY ./tools/entrypoint.sh /opt/tools/
RUN chmod +x /opt/tools/entrypoint.sh

EXPOSE 21 50000-50100
ENTRYPOINT [ "sh", "/opt/tools/entrypoint.sh" ]
