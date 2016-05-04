#!/bin/sh

[ -f /run-pre.sh ] && /run-pre.sh

if [ ! -d /app/public ] ; then
  mkdir -p /app/public
  chown nginx:www-data /app/public
fi

# start php-fpm
mkdir -p /var/logs/php-fpm
php-fpm

# start nginx
mkdir -p /var/logs/nginx
mkdir -p /tmp/nginx
chown nginx /tmp/nginx
nginx
