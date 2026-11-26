#!/bin/sh
set -e

if ! id "$FTP_USER" >/dev/null 2>&1; then
    adduser -D -h "/home/$FTP_USER" -s /bin/sh "$FTP_USER"
fi
echo "$FTP_USER:$FTP_PASSWORD" | chpasswd


exec vsftpd /etc/vsftpd/vsftpd.conf