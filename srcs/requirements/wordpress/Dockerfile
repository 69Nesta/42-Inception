FROM alpine:3.23

RUN apk update && apk upgrade && apk add --no-cache \
    curl
    mariadb-client \
    php85 \
    php85-fpm \
    php85-phar \
    php85-mysqli \
    php85-curl \
    php85-mbstring \
    php85-openssl \
    php85-xml \
    php85-dom \
    php85-zip \
    php85-gd \
    php85-iconv \
    php85-tokenizer \
    php85-session \
    php85-fileinfo \
    php85-json

RUN ln -sf /usr/bin/php85 /usr/bin/php
RUN sed -i 's/^listen = .*/listen = 0.0.0.0:9000/' /etc/php85/php-fpm.d/www.conf

# USER wpuser
RUN mkdir -p /var/www/html
WORKDIR /var/www/html

RUN mkdir -p /opt/tools
COPY tools/install.sh /opt/tools
RUN chmod +x /opt/tools/install.sh
# USER wpuser
# RUN /opt/tools/install.sh

EXPOSE 9000
ENTRYPOINT [ "sh", "/opt/tools/install.sh" ]
