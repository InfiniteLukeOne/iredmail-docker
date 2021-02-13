<?php
$CONF['configured'] = true;

$CONF['setup_password'] = '$2y$10$RLZ68Hrkj1XBy/Q7CntjN.ZtpIkWzUGrTrVi06zDXVmO4JvtzK69m';

$CONF['database_type'] = 'mysqli';
$CONF['database_host'] = '127.0.0.1';
$CONF['database_user'] = 'vmailadmin';
$CONF['database_password'] = 'TEMP_VMAIL_DB_ADMIN_PASSWD';
$CONF['database_name'] = 'vmail';

$CONF['encrypt'] = 'php_crypt:BLOWFISH';

// Default Aliases
// The default aliases that need to be created for all domains.
// You can specify the target address in two ways:
// a) a full mail address
// b) only a localpart ('postmaster' => 'admin') - the alias target will point to the same domain
$CONF['default_aliases'] = array (
    'abuse' => 'abuse@TEMP_DOMAIN',
    'hostmaster' => 'hostmaster@TEMP_DOMAIN',
    'postmaster' => 'postmaster@TEMP_DOMAIN',
    'webmaster' => 'webmaster@TEMP_DOMAIN'
);

$CONF['vacation_domain'] = 'autoreply.TEMP_DOMAIN';

$CONF['footer_text'] = 'Return to TEMP_DOMAIN';
$CONF['footer_link'] = 'http://TEMP_DOMAIN';

// you can assign special colors to some domains. To do this,
// - add the domain to show_custom_domains
// - add the corresponding color to show_custom_colors
$CONF['show_custom_domains']=array('TEMP_DOMAIN');
$CONF['show_custom_colors']=array("lightgreen");

$CONF['smtp_server'] = '127.0.0.1';
$CONF['smtp_port'] = '25';

$CONF['create_mailbox_subdirs_host']='127.0.0.1';
