#!/bin/sh

# Update RCB password
. /opt/iredmail/.cv
sed -i "s/TEMP_RCM_DB_PASSWD/$RCM_DB_PASSWD/" \
    /opt/www/roundcubemail/config/config.inc.php \
    /opt/www/roundcubemail/plugins/password/config.inc.php

sed -i "s/TEMP_RCM_DES_KEY/${</dev/urandom tr -dc A-Za-z0-9 | (head -c $1 &>/dev/null || head -c 32)}/" \
    /opt/www/roundcubemail/config/config.inc.php

# start php fpm
exec /usr/sbin/php-fpm --nodaemonize

# mkdir -p /run/php
# exec /usr/sbin/php-fpm7.0 --nodaemonize --fpm-config /etc/php/7.0/fpm/php-fpm.conf
