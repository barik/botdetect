-- MySQL dump 10.13  Distrib 5.5.16, for Win32 (x86)
--
-- Host: 127.0.0.1    Database: wwf
-- ------------------------------------------------------
-- Server version	5.1.53-community-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `wwf`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wwf` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `wwf`;

--
-- Table structure for table `events`
--

DROP TABLE IF EXISTS `events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `events` (
  `user_id` int(11) NOT NULL DEFAULT '0',
  `event_id` int(11) NOT NULL DEFAULT '0',
  `event_type` varchar(50) NOT NULL,
  PRIMARY KEY (`user_id`,`event_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mouse_events`
--

DROP TABLE IF EXISTS `mouse_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mouse_events` (
  `user_id` int(11) NOT NULL,
  `event_id` int(11) NOT NULL,
  `event_type` varchar(25) NOT NULL,
  `x` int(11) NOT NULL,
  `y` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`,`event_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tile_events`
--

DROP TABLE IF EXISTS `tile_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tile_events` (
  `user_id` int(11) NOT NULL,
  `event_id` int(11) NOT NULL,
  `event_type` varchar(25) NOT NULL,
  `x_from` varchar(15) NOT NULL,
  `y_from` varchar(15) NOT NULL,
  `x_to` varchar(15) NOT NULL,
  `y_to` varchar(15) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`,`event_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ip_address` int(10) unsigned NOT NULL,
  `nonce` varchar(40) NOT NULL,
  `is_expired` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `avHardwareDisable` varchar(1) DEFAULT NULL,
  `hasAccessibility` varchar(1) DEFAULT NULL,
  `hasAudio` varchar(1) DEFAULT NULL,
  `hasAudioEncoder` varchar(1) DEFAULT NULL,
  `hasEmbeddedVideo` varchar(1) DEFAULT NULL,
  `hasIME` varchar(1) DEFAULT NULL,
  `hasMP3` varchar(1) DEFAULT NULL,
  `hasPrinting` varchar(1) DEFAULT NULL,
  `hasScreenBroadcast` varchar(1) DEFAULT NULL,
  `hasScreenPlayback` varchar(1) DEFAULT NULL,
  `hasStreamingAudio` varchar(1) DEFAULT NULL,
  `hasStreamingVideo` varchar(1) DEFAULT NULL,
  `hasTLS` varchar(1) DEFAULT NULL,
  `hasVideoEncoder` varchar(1) DEFAULT NULL,
  `isDebugger` varchar(1) DEFAULT NULL,
  `language` varchar(32) DEFAULT NULL,
  `localFileReadDisable` varchar(1) DEFAULT NULL,
  `manufacturer` varchar(32) DEFAULT NULL,
  `maxLevelIDC` varchar(32) DEFAULT NULL,
  `os` varchar(32) DEFAULT NULL,
  `pixelAspectRatio` varchar(32) DEFAULT NULL,
  `playerType` varchar(32) DEFAULT NULL,
  `screenColor` varchar(32) DEFAULT NULL,
  `screenDPI` varchar(32) DEFAULT NULL,
  `screenResolutionX` varchar(32) DEFAULT NULL,
  `screenResolutionY` varchar(32) DEFAULT NULL,
  `version` varchar(32) DEFAULT NULL,
  `windowlessMode` varchar(32) DEFAULT NULL,
  `uagent` varchar(64) DEFAULT NULL,
  `client_version` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=162 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `word_events`
--

DROP TABLE IF EXISTS `word_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `word_events` (
  `user_id` int(11) NOT NULL,
  `event_id` int(11) NOT NULL,
  `event_type` varchar(25) NOT NULL,
  `word` varchar(15) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`,`event_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2011-11-28 20:18:18
