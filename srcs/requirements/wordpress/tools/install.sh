#!/bin/sh
set -e

CYAN='\033[0;31m'
NC='\033[0m'

if [ ! -f /usr/local/bin/wp ]; then
    echo "[Info] Installing wordpress-cli..."
    curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
fi
chmod +x /usr/local/bin/wp

if [ ! -f ~/.wp-cli/config.yml ]; then
    echo "[Info] Initialzing config of wordpress-cli"

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
fi

if [ ! -f /var/www/html/.downloaded ]; then
    echo -e "${CYAN}[Info]${NC} Downloading wordpress..."

    php -d memory_limit=512M /usr/local/bin/wp core download
    touch /var/www/html/.downloaded
fi

if [ ! -f /var/www/html/wp-config.php ]; then
    echo -e "${CYAN}[Info]${NC} Creating wp-config.php..."

    wp config create
fi

if ! wp core is-installed 2>/dev/null; then
    echo -e "${CYAN}[Info]${NC} Installing wordpress..."

    wp core install \
        --url="https://rpetit.42.fr" \
        --title="$WORDPRESS_SITE_TITLE" \
        --admin_user="$WORDPRESS_ADMIN_USER" \
        --admin_email="$WORDPRESS_ADMIN_EMAIL" \
        --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
        --skip-email

    echo -e "${CYAN}[Info]${NC} Creating wordpress users..."
    wp user create "$WORDPRESS_USER" "$WORDPRESS_EMAIL" \
        --user_pass="$WORDPRESS_PASSWORD"
fi

wp core version
wp db check
wp user list

exec php-fpm85 -F
