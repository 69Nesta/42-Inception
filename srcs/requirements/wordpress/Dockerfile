FROM alpine:3.23

RUN apk update && apk upgrade && apk add --no-cache bash curl less mariadb-client \
    php85 php85-fpm php85-phar php85-mysqli php85-curl php85-mbstring php85-openssl \
    php85-xml php85-dom php85-zip php85-gd php85-iconv php85-tokenizer \
    php85-session php85-fileinfo php85-json

RUN ln -sf /usr/bin/php85 /usr/bin/php
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x /usr/local/bin/wp
# RUN adduser -D -s /bin/bash wpuser
RUN mkdir -p /var/www/html #&& chown wpuser:wpuser /var/www/html

# USER wpuser
WORKDIR /var/www/html

RUN mkdir -p /opt/tools
COPY tools/install.sh /opt/tools
RUN chmod +x /opt/tools/install.sh
# USER wpuser
# RUN /opt/tools/install.sh

EXPOSE 9000
ENTRYPOINT [ "sh", "/opt/tools/install.sh" ]
