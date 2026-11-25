#!/bin/sh
set -e

ls /var/www/html

echo "--- CONFIG ---"
echo "dbhost: $DB_HOST"
echo "dbname: $DB_NAME"
echo "dbuser: $DB_USER"
echo "dbpass: $DB_PASSWORD"

if [ ! -f /var/www/html/.initialised ]; then
    mkdir -p ~/.wp-cli
    cat > ~/.wp-cli/config.yml <<EOF
path: /var/www/html
core download:
    locale: fr_FR
core config:
    dbhost: $DB_HOST
    dbname: $DB_NAME
    dbuser: $DB_USER
    dbpass: $DB_PASSWORD
    dbprefix: wp_
EOF

    php -d memory_limit=512M /usr/local/bin/wp core download
    wp config create
    wp core install \
      --url="https://rpetit.42.fr" \
      --title="$WP_TITLE" \
      --admin_user="$WP_USER" \
      --admin_password="$WP_PASSWORD" \
      --admin_email="$WP_EMAIL" \
      --skip-email

    wp core version
    touch /var/www/html/.initialised
fi
wp db check
wp user list

exec php-fpm85 -F
