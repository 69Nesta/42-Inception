FROM alpine:3.23

RUN apk update && apk upgrade && apk add --no-cache vsftpd

RUN mkdir -p /etc/vsftpd/
COPY ./conf/vsftpd.conf /etc/vsftpd/vsftpd.conf

RUN mkdir -p /opt/tools/
COPY ./tools/entrypoint.sh /opt/tools/
RUN chmod +x /opt/tools/entrypoint.sh

EXPOSE 21
ENTRYPOINT [ "sh", "/opt/tools/entrypoint.sh" ]
