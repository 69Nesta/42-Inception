#!/bin/sh
set -e
: "${FTP_USER:=rpetit}"
: "${FTP_PASSWORD:?FTP_PASSWORD is required}"
: "${FTP_UID:=1000}"

if ! id "$FTP_USER" >/dev/null 2>&1; then
  adduser -D -h /srv/ftp -s /sbin/nologin -u "$FTP_UID" "$FTP_USER"
fi
echo "$FTP_USER:$FTP_PASSWORD" | chpasswd

exec proftpd -n