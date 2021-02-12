ALTER TABLE `admin`
  ADD `superadmin` tinyint(1) NOT NULL DEFAULT '0' AFTER `password`,
  ADD `phone` varchar(30) NOT NULL DEFAULT '',
  ADD `email_other` varchar(255) NOT NULL DEFAULT '',
  ADD `token` varchar(255) NOT NULL DEFAULT '',
  ADD `token_validity` datetime NOT NULL DEFAULT '2000-01-01 00:00:00';

ALTER TABLE `alias`
  ADD `goto` text NOT NULL;

DROP TABLE IF EXISTS `config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `value` varchar(20) CHARACTER SET latin1 NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='PostfixAdmin settings';
/*!40101 SET character_set_client = @saved_cs_client */;

ALTER TABLE `domain`
  ADD `password_expiry` int(11) DEFAULT '0';

DROP TABLE IF EXISTS `fetchmail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fetchmail` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `domain` varchar(255) DEFAULT '',
  `mailbox` varchar(255) NOT NULL,
  `src_server` varchar(255) NOT NULL,
  `src_auth` enum('password','kerberos_v5','kerberos','kerberos_v4','gssapi','cram-md5','otp','ntlm','msn','ssh','any') CHARACTER SET utf8 DEFAULT NULL,
  `src_user` varchar(255) NOT NULL,
  `src_password` varchar(255) NOT NULL,
  `src_folder` varchar(255) NOT NULL,
  `poll_time` int(11) unsigned NOT NULL DEFAULT '10',
  `fetchall` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `keep` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `protocol` enum('POP3','IMAP','POP2','ETRN','AUTO') CHARACTER SET utf8 DEFAULT NULL,
  `usessl` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `sslcertck` tinyint(1) NOT NULL DEFAULT '0',
  `sslcertpath` varchar(255) CHARACTER SET utf8 DEFAULT '',
  `sslfingerprint` varchar(255) DEFAULT '',
  `extra_options` text,
  `returned_text` text,
  `mda` varchar(255) NOT NULL,
  `date` timestamp NOT NULL DEFAULT '2000-01-01 00:00:00',
  `created` timestamp NOT NULL DEFAULT '2000-01-01 00:00:00',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `active` tinyint(1) NOT NULL DEFAULT '0',
  `src_port` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log` (
  `timestamp` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `username` varchar(255) NOT NULL,
  `domain` varchar(255) NOT NULL,
  `action` varchar(255) NOT NULL,
  `data` text NOT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  KEY `timestamp` (`timestamp`),
  KEY `domain_timestamp` (`domain`,`timestamp`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 COMMENT='Postfix Admin - Log';
/*!40101 SET character_set_client = @saved_cs_client */;

ALTER TABLE `mailbox`
  ADD `local_part` varchar(255) NOT NULL,
  ADD `phone` varchar(30) NOT NULL DEFAULT '',
  ADD `email_other` varchar(255) NOT NULL DEFAULT '',
  ADD `token` varchar(255) NOT NULL DEFAULT '',
  ADD `token_validity` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  ADD `password_expiry` datetime NOT NULL DEFAULT '2000-01-01 00:00:00';

DROP TABLE IF EXISTS `quota`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quota` (
  `username` varchar(255) CHARACTER SET latin1 NOT NULL,
  `path` varchar(100) CHARACTER SET latin1 NOT NULL,
  `current` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`username`,`path`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `quota2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quota2` (
  `username` varchar(100) CHARACTER SET latin1 NOT NULL,
  `bytes` bigint(20) NOT NULL DEFAULT '0',
  `messages` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`username`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `vacation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vacation` (
  `email` varchar(255) NOT NULL,
  `subject` varchar(255) CHARACTER SET utf8 NOT NULL,
  `body` text CHARACTER SET utf8 NOT NULL,
  `activefrom` timestamp NOT NULL DEFAULT '2000-01-01 00:00:00',
  `activeuntil` timestamp NOT NULL DEFAULT '2038-01-17 23:00:00',
  `cache` text NOT NULL,
  `domain` varchar(255) NOT NULL,
  `interval_time` int(11) NOT NULL DEFAULT '0',
  `created` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`email`),
  KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Postfix Admin - Virtual Vacation';
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `vacation_notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vacation_notification` (
  `on_vacation` varchar(255) CHARACTER SET latin1 NOT NULL,
  `notified` varchar(255) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `notified_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`on_vacation`,`notified`),
  CONSTRAINT `vacation_notification_pkey` FOREIGN KEY (`on_vacation`) REFERENCES `vacation` (`email`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Postfix Admin - Virtual Vacation Notifications';
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `config` WRITE;
/*!40000 ALTER TABLE `config` DISABLE KEYS */;
INSERT INTO `config` VALUES (1,'version','1843');
/*!40000 ALTER TABLE `config` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `domain` WRITE;
/*!40000 ALTER TABLE `domain` DISABLE KEYS */;
INSERT INTO `domain` VALUES ('ALL','',NULL,0,0,0,0,0,'',0,NULL,'2018-01-27 10:56:53','2018-01-27 10:56:53','9999-12-31 00:00:00',1,0);
/*!40000 ALTER TABLE `domain` ENABLE KEYS */;
UNLOCK TABLES;

INSERT INTO `admin` VALUES ('postmaster@DOMAIN','TEMP_POSTMASTER_PASSWORD',1,'','',NOW(),NULL,NOW(),NOW(),'9999-12-31 00:00:00',1,'','','',NOW());

LOCK TABLES `alias` WRITE;
/*!40000 ALTER TABLE `alias` DISABLE KEYS */;
INSERT INTO `alias` (`address`, `domain`, `goto`) VALUES ('abuse@DOMAIN', 'DOMAIN', 'postmaster@DOMAIN'),('hostmaster@DOMAIN', 'DOMAIN', 'postmaster@DOMAIN'),('webmaster@DOMAIN', 'DOMAIN', 'postmaster@DOMAIN');
/*!40000 ALTER TABLE `alias` ENABLE KEYS */;
UNLOCK TABLES;
