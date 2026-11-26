#!/bin/sh
set -e

MAGENTA='\033[0;35m'
NC='\033[0m'

if [ ! -f /usr/local/bin/wp ]; then
    echo -e "${MAGENTA}[Info]${NC} Installing wordpress-cli..."
    curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
fi
chmod +x /usr/local/bin/wp

if [ ! -f ~/.wp-cli/config.yml ]; then
    echo -e "${MAGENTA}[Info]${NC} Initialzing config of wordpress-cli"

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
    echo -e "${MAGENTA}[Info]${NC} Downloading wordpress..."

    php -d memory_limit=512M /usr/local/bin/wp core download
    touch /var/www/html/.downloaded
fi

if [ ! -f /var/www/html/wp-config.php ]; then
    echo -e "${MAGENTA}[Info]${NC} Creating wp-config.php..."

    wp config create
fi

if ! wp core is-installed 2>/dev/null; then
    echo -e "${MAGENTA}[Info]${NC} Installing wordpress..."

    wp core install \
        --url="https://rpetit.42.fr" \
        --title="$WORDPRESS_SITE_TITLE" \
        --admin_user="$WORDPRESS_ADMIN_USER" \
        --admin_email="$WORDPRESS_ADMIN_EMAIL" \
        --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
        --skip-email

    echo -e "${MAGENTA}[Info]${NC} Creating wordpress users..."
    wp user create "$WORDPRESS_USER" "$WORDPRESS_EMAIL" \
        --user_pass="$WORDPRESS_PASSWORD"
fi

if [ -z "$(wp post list --post_type=post --title="$WORDPRESS_DEFAULT_POST_TITLE" --field=ID --allow-root)" ]; then
    echo -e "${MAGENTA}[Info]${NC} Creating wordpress post..."

    wp post create --post_type=post \
        --post_title="$WORDPRESS_DEFAULT_POST_TITLE" \
        --post_content="$WORDPRESS_DEFAULT_POST_CONTENT" \
        --post_status="${WORDPRESS_DEFAULT_POST_STATUS:-publish}" \
        --post_author="${WORDPRESS_DEFAULT_POST_AUTHOR:-1}" \
        --allow-root
fi

if ! wp plugin is-installed redis-cache 2>/dev/null; then
    echo -e "${MAGENTA}[Info]${NC} Installing redis cache plugin..."

    wp config set WP_REDIS_HOST         "$WORDPRESS_REDIS_HOST"         --allow-root
    wp config set WP_REDIS_PORT         "$WORDPRESS_REDIS_PORT"         --raw --allow-root
    wp config set WP_REDIS_DATABASE     "$WORDPRESS_REDIS_DATABASE"     --raw --allow-root
    wp config set WP_REDIS_PREFIX       "$WORDPRESS_REDIS_PREFIX"       --allow-root
    wp config set WP_REDIS_TIMEOUT      "$WORDPRESS_REDIS_TIMEOUT"      --raw --allow-root
    wp config set WP_REDIS_READ_TIMEOUT "$WORDPRESS_REDIS_READ_TIMEOUT" --raw --allow-root

    wp plugin install redis-cache --activate --allow-root
    wp redis enable --allow-root
fi

wp core version
wp db check
wp user list

exec php-fpm85 -F
