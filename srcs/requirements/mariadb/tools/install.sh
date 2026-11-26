#!/bin/sh
set -e

MAGENTA='\033[0;36m'
NC='\033[0m'

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
    echo -e "${MAGENTA}[INFO]${NC} MariaDB initialization (1/2)..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

if [ ! -f "/var/lib/mysql/.initialized" ]; then
    echo -e "${MAGENTA}[INFO]${NC} MariaDB initialization (2/2)..."
    mariadbd --user=mysql --datadir=/var/lib/mysql &
    pid=$!

    until mariadb-admin ping --silent 2>/dev/null; do
        echo -e "${MAGENTA}[INFO]${NC} MariaDB waiting..."
        sleep 1
    done
    echo -e "${MAGENTA}[INFO]${NC} MariaDB database : '$MARIADB_DATABASE'"
    echo -e "${MAGENTA}[INFO]${NC} MariaDB user : '$MARIADB_USER'"

    mariadb -u root <<EOF
CREATE DATABASE IF NOT EXISTS $MARIADB_DATABASE CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '$MARIADB_USER'@'localhost' IDENTIFIED BY '$MARIADB_PASSWORD';
CREATE USER IF NOT EXISTS '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_PASSWORD';
GRANT ALL PRIVILEGES ON $MARIADB_DATABASE.* TO '$MARIADB_USER'@'localhost';
GRANT ALL PRIVILEGES ON $MARIADB_DATABASE.* TO '$MARIADB_USER'@'%';
FLUSH PRIVILEGES;
EOF
     mariadb-admin -u root shutdown
     wait $pid || true
fi

# Start MariaDB
echo -e "${MAGENTA}[INFO]${NC} MariaDB starting..."
exec mariadbd --user=mysql --datadir='/var/lib/mysql' --bind-address=0.0.0.0 --port=3306
