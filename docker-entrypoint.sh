#!/bin/sh
set -e

# Iniciar PHP-FPM en segundo plano
php-fpm83 --nodaemonize --fpm-config /etc/php83/php-fpm.conf &

# Iniciar nginx en primer plano
exec nginx -g 'daemon off;'
