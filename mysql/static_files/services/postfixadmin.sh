#!/bin/sh
# MySQL actually runs
#while ! mysqladmin ping -h localhost --silent; do
#  sleep 1; 
#done

DOMAIN=$(hostname -d)
HOSTNAME=$(hostname -s)

. /opt/iredmail/.cv

POSTMASTER_ADMIN_PASSWORD=$(echo $POSTMASTER_PASSWORD | sed 's/{MD5-CRYPT}//')
echo "UPDATE admin SET username = 'postmaster@$DOMAIN' WHERE username = 'postmaster@DOMAIN'" | mysql vmail
echo "UPDATE admin SET password = '$POSTMASTER_ADMIN_PASSWORD' WHERE username = 'postmaster@${DOMAIN}'" | mysql vmail
echo "INSERT INTO domain VALUES ('$DOMAIN','',NULL,0,0,0,0,0,'',0,NULL,'2018-01-27 10:56:53','2018-01-27 10:56:53','9999-12-31 00:00:00',1,0) WHERE NOT EXISTS (SELECT 1 FROM `domain` WHERE `domain` = '$DOMAIN')" | mysql vmail
#default aliase erstellen
echo "UPDATE alias SET domain = '$DOMAIN', address = REGEXP_REPLACE(address, '@DOMAIN$', '@$DOMAIN'), goto = REGEXP_REPLACE(goto, '@DOMAIN$', '@$DOMAIN') WHERE domain = 'DOMAIN';" | mysql vmail

sed -i "s/TEMP_VMAIL_DB_ADMIN_PASSWD/$VMAIL_DB_ADMIN_PASSWD/" /opt/www/postfixadmin-3.3.5/config.local.php
#sed -i "s/TEMP_SETUP_PASSWORD/$(openssl rand -hex 32)/" /opt/www/postfixadmin-3.3.5/config.local.php
sed -i "s/TEMP_DOMAIN/$DOMAIN/" /opt/www/postfixadmin-3.3.5/config.local.php

