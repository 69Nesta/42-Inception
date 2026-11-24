#!/bin/sh
set -e

# Create folders
mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

# Set Config
rm -f /etc/my.cnf /etc/mysql/my.cnf
cat > /etc/my.cnf.d/docker.cnf << EOF
[mysqld]
bind-address=0.0.0.0
port=3306
datadir=/var/lib/mysql
socket=/run/mysqld/mysqld.sock
skip-networking=0
EOF

# Install MariaDB if needed
if [ ! -d /var/lib/mysql/mysql ]; then
    echo '[INFO] MariaDB initialization (1/2)...'
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

if [ ! -f "/var/lib/mysql/.initialized" ]; then
    echo '[INFO] MariaDB initialization (2/2)...'
    mariadbd --user=mysql --datadir=/var/lib/mysql &
    pid=$!

    until mariadb-admin ping --silent 2>/dev/null; do
        echo '[INFO] MariaDB waiting...'
        sleep 1
    done
    echo "[INFO] MariaDB database : '$MARIADB_DATABASE'"
    echo "[INFO] MariaDB user : '$MARIADB_USER'"

    mariadb -u root <<EOF
CREATE DATABASE IF NOT EXISTS $MARIADB_DATABASE CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '$MARIADB_USER'@'localhost' IDENTIFIED BY '$MARIADB_PASSWORD';
CREATE USER IF NOT EXISTS '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_PASSWORD';
GRANT ALL PRIVILEGES ON $MARIADB_DATABASE.* TO '$MARIADB_USER'@'localhost';
FLUSH PRIVILEGES;
EOF
     mariadb-admin -u root shutdown
     wait $pid || true
fi

# Start MariaDB
echo '[INFO] MariaDB starting...'
exec mariadbd --user=mysql --datadir='/var/lib/mysql' --bind-address=0.0.0.0 --port=3306
