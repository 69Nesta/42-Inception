FROM alpine:3.23

RUN apk update && apk upgrade && apk --no-cache add nginx curl openssl
RUN mkdir -p /etc/nginx/ssl/
RUN openssl req -x509 -nodes -sha256 -days 360 \
    -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/inception_certificat.key \
    -out /etc/nginx/ssl/inception_certificat.crt \
    -subj "/C=FR/ST=Lyon/L=Lyon/O=42 School/OU=inception/CN=rpetit.42.fr/emailAddress=rpetit@student.42lyon.frs"

EXPOSE 80 443
ENTRYPOINT ["nginx", "-g", "daemon off;"]
