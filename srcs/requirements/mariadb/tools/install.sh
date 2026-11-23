#!/bin/sh

mariadb-install-db --user=mysql --datadir=/var/lib/mysql
mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld


