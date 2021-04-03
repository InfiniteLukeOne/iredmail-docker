FROM centos:7
MAINTAINER Miloš Kozák <milos.kozak@lejmr.com>

# Suporting software versions
ARG IREDMAIL_VERSION=1.3.1
ARG GOSU_VERSION=1.12

# Default values changable at startup
ARG DOMAIN=DOMAIN
ARG HOSTNAME=HOSTNAME

### Installation
WORKDIR /opt/iredmail
ADD static_files/opt/iredmail /opt/iredmail

# All-in-one installation
RUN yum install -y mariadb-server openssl \
    && curl -o /usr/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64" \
    && chmod +x /usr/bin/gosu
    # Start temporary MariaDB server
RUN mysql_install_db  --datadir=/var/lib/mysql --skip-name-resolve --force \
    && chown mysql:mysql /var/lib/mysql -R \
    && mysqld_safe & while ! mysqladmin ping --silent; do sleep 1; done \
    && echo "SELECT 1;"  | mysql \
    && ps -ef \
    # Download iRedMail
    && curl -k -q https://codeload.github.com/iredmail/iRedMail/tar.gz/"${IREDMAIL_VERSION}" | \
    tar xvz --strip-components=1 \
    # Prepare default configuration and install
    && static/config-gen HOSTNAME DOMAIN > ./config \
    && IREDMAIL_DEBUG='NO' \
       IREDMAIL_HOSTNAME="HOSTNAME.DOMAIN" \
       CHECK_NEW_IREDMAIL='NO' \
       AUTO_USE_EXISTING_CONFIG_FILE=y \
       AUTO_INSTALL_WITHOUT_CONFIRM=y \
       AUTO_CLEANUP_REMOVE_SENDMAIL=y \
       AUTO_CLEANUP_REMOVE_MOD_PYTHON=y \
       AUTO_CLEANUP_REPLACE_FIREWALL_RULES=n \
       AUTO_CLEANUP_RESTART_IPTABLES=n \
       AUTO_CLEANUP_REPLACE_MYSQL_CONFIG=y \
       AUTO_CLEANUP_RESTART_POSTFIX=n \
       bash iRedMail.sh \
    && yum install -y supervisor MySQL-python python-webpy fail2ban \
    # Remove iredadmin and sogo from backup
    && sed -i 's/export DATABASES='\''mysql vmail roundcubemail amavisd iredadmin sogo iredapd sa_bayes'\''/export DATABASES='\''mysql vmail roundcubemail amavisd iredapd sa_bayes'\''/' /var/vmail/backup/backup_mysql.sh \
    && sed -i -r 's/^(\s*)(\$\{CMD_MYSQL\} iredadmin -e )/\1#\2/' /var/vmail/backup/backup_mysql.sh \
    # Update database for PostfixAdmin
    && mysql vmail < /opt/iredmail/migrations/vmail/postfixadmin.sql \
    # Update php
    && yum install -y yum-utils \
    && yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
    && yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm \
    && yum-config-manager --enable remi-php73 \
    && yum update -y php php* \
    # Remove all dependencies and all caches
    && mkdir dumps \
    && for d in amavisd iredapd roundcubemail vmail mysql; do mysqldump $d | gzip -c > dumps/${d}.sql.gz; done \
    && yum clean all \
    && find /var/cache/yum/ -type f -exec rm -f {} \; \
    && rm /var/lib/mysql -rf \
    && rm -rf /var/lib/clamav/* \
    && tar jcf dumps/vmail.tar.bz2 /var/vmail \
    && rm -rf /var/vmail/vmail1/DOMAIN \
    && rm -f /etc/ssl/private/iRedMail.key \
    && rm -f /etc/ssl/certs/iRedMail.crt \
    && rm -f /var/lib/dkim/DOMAIN.pem \
    # Prepare for first run
    && rm -rf /var/vmail
    
    # Install Postfixadmin
RUN wget -q -O - "https://sourceforge.net/projects/postfixadmin/files/postfixadmin-3.3.5/PostfixAdmin%203.3.5%20-%20bug%20fix.tar.gz/download" | tar -xzf - -C /opt/www \
    && mv /opt/www/postfixadmin-postfixadmin-96a0227 /opt/www/postfixadmin-3.3.5 \
    && mkdir /opt/www/postfixadmin-3.3.5/templates_c \
    && chown nginx:nginx /opt/www/postfixadmin-3.3.5/templates_c \
    && ln -s /opt/www/postfixadmin-3.3.5 /opt/www/postfixadmin
    
    # Install additional roundcube plugins
RUN cd /opt/www/roundcubemail-1.4.7 \
    && curl -s https://getcomposer.org/installer | php \
    && php composer.phar remove roundcube/plugin-installer \
    && php composer.phar require roundcube/plugin-installer \
    && sed -i "s/^\$config\['password_dovecotpw_method'\].*$/\$config['password_dovecotpw_method'] = 'SHA512-CRYPT';/" /opt/www/roundcubemail-1.4.7/plugins/password/config.inc.php \
    && sed -i "s/^\$config\['password_crypt_rounds'\].*$/\$config['password_crypt_rounds'] = 200000;/" /opt/www/roundcubemail-1.4.7/plugins/password/config.inc.php \
    && sed -i "s/^\$config\['plugins'\].*$/\$config['plugins'] = array('managesieve', 'password', 'enigma', 'emoticons', 'identity_select', 'vcard_attachments', 'carddav');/" /opt/www/roundcubemail-1.4.7/config/config.inc.php \
    && echo "Y" | php composer.phar require roundcube/carddav

    # Add multi domain dkim support
RUN sed -i "s/^dkim_key('DOMAIN'/dkim_key('*'/" /etc/amavisd/amavisd.conf \
    && perl -pi -e "s/^(\s+)'\.' => \{d => 'DOMAIN',/\1'.' => {/" /etc/amavisd/amavisd.conf

# At this point the layer contains services configured by iRedMail installer
# However, some configurations need to be adapted, so the software composition
# works under docker. That is the main reason for closing this layer, and opening
# a new one in the next part of this Dockerfile

# Installation of all static files (some of them are conf file overrides)
ADD static_files /

# Starting mechanism
ENTRYPOINT ["/entrypoint.sh"]
CMD ["supervisord"]

# Open Ports:
# Apache: 80/tcp, 443/tcp Postfix: 25/tcp, 587/tcp
# Dovecot: 110/tcp, 143/tcp, 993/tcp, 995/tcp
EXPOSE 80 443 25 587 110 143 993 995

# Default values changable at startup
#ENV SOGO_WORKERS=2
ENV TZ=Etc/UTC
