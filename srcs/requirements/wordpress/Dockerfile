FROM alpine:3.24

RUN apk update && apk upgrade && apk --no-cache add php85-fpm curl
RUN mkdir -p /var/www/html/
WORKDIR /var/www/html

RUN wget https://wordpress.org/wordpress-7.1.5.tar.gz
RUN tar -xvzf wordpress-7.1.5.tar.gz --strip-components=1
# RUN chown -R www-data: /var/www/html/wordpress/

COPY tools/config.sh .
RUN chmod +x ./config.sh
RUN ./config.sh

EXPOSE 9000
ENTRYPOINT [ "php-fpm86", "-F" ]
