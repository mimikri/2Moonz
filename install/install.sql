
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- %PREFIX%aks
CREATE TABLE IF NOT EXISTS `%PREFIX%aks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `target` int(10) unsigned NOT NULL,
  `ankunft` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- %PREFIX%aks: 0 rows
/*!40000 ALTER TABLE `%PREFIX%aks` DISABLE KEYS */;
/*!40000 ALTER TABLE `%PREFIX%aks` ENABLE KEYS */;

-- %PREFIX%alliance
CREATE TABLE IF NOT EXISTS `%PREFIX%alliance` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ally_name` varchar(50) DEFAULT '',
  `ally_tag` varchar(20) DEFAULT '',
  `ally_owner` int(10) unsigned NOT NULL DEFAULT 0,
  `ally_register_time` int(11) NOT NULL DEFAULT 0,
  `ally_description` text DEFAULT NULL,
  `ally_web` varchar(255) DEFAULT '',
  `ally_text` text DEFAULT NULL,
  `ally_image` varchar(255) DEFAULT '',
  `ally_request` varchar(1000) DEFAULT NULL,
  `ally_request_notallow` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `ally_request_min_points` bigint(20) unsigned NOT NULL DEFAULT 0,
  `ally_owner_range` varchar(32) DEFAULT '',
  `ally_members` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `ally_stats` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `ally_diplo` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `ally_universe` tinyint(3) unsigned NOT NULL,
  `ally_max_members` int(10) unsigned NOT NULL DEFAULT 20,
  `ally_events` varchar(55) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `ally_tag` (`ally_tag`),
  KEY `ally_name` (`ally_name`),
  KEY `ally_universe` (`ally_universe`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- %PREFIX%alliance: 0 rows
/*!40000 ALTER TABLE `%PREFIX%alliance` DISABLE KEYS */;
/*!40000 ALTER TABLE `%PREFIX%alliance` ENABLE KEYS */;

-- %PREFIX%alliance_ranks
CREATE TABLE IF NOT EXISTS `%PREFIX%alliance_ranks` (
  `rankID` int(11) NOT NULL AUTO_INCREMENT,
  `rankName` varchar(32) NOT NULL,
  `allianceID` int(10) unsigned NOT NULL,
  `MEMBERLIST` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `ONLINESTATE` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `TRANSFER` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `SEEAPPLY` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `MANAGEAPPLY` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `ROUNDMAIL` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `ADMIN` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `KICK` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `DIPLOMATIC` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `RANKS` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `MANAGEUSERS` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `EVENTS` tinyint(3) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`rankID`),
  KEY `allianceID` (`allianceID`,`rankID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- %PREFIX%alliance_ranks: 0 rows
/*!40000 ALTER TABLE `%PREFIX%alliance_ranks` DISABLE KEYS */;
/*!40000 ALTER TABLE `%PREFIX%alliance_ranks` ENABLE KEYS */;

-- %PREFIX%alliance_request
CREATE TABLE IF NOT EXISTS `%PREFIX%alliance_request` (
  `applyID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `text` text NOT NULL,
  `userID` int(10) unsigned NOT NULL,
  `allianceID` int(10) unsigned NOT NULL,
  `time` int(11) NOT NULL,
  PRIMARY KEY (`applyID`),
  KEY `allianceID` (`allianceID`,`userID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- %PREFIX%alliance_request: 0 rows
/*!40000 ALTER TABLE `%PREFIX%alliance_request` DISABLE KEYS */;
/*!40000 ALTER TABLE `%PREFIX%alliance_request` ENABLE KEYS */;

-- %PREFIX%banned
CREATE TABLE IF NOT EXISTS `%PREFIX%banned` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `who` varchar(64) NOT NULL DEFAULT '',
  `theme` varchar(500) NOT NULL,
  `time` int(11) NOT NULL DEFAULT 0,
  `longer` int(11) NOT NULL DEFAULT 0,
  `author` varchar(64) NOT NULL DEFAULT '',
  `email` varchar(64) NOT NULL DEFAULT '',
  `universe` tinyint(3) unsigned NOT NULL,
  KEY `ID` (`id`),
  KEY `universe` (`universe`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- %PREFIX%banned: 0 rows
/*!40000 ALTER TABLE `%PREFIX%banned` DISABLE KEYS */;
/*!40000 ALTER TABLE `%PREFIX%banned` ENABLE KEYS */;

-- %PREFIX%bots
CREATE TABLE IF NOT EXISTS `%PREFIX%bots` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner_id` int(11) DEFAULT 0 COMMENT 'user id of bot',
  `ress_bonus_time` int(11) DEFAULT 0,
  `stationed_planet_id` int(11) DEFAULT 0 COMMENT 'if the fleet is stationed on a planet, this is the id of the planet',
  `next_fleet_action` int(11) DEFAULT 0 COMMENT 'when landing or lifting the fleet, the time of next activity is put here.',
  `action_index` int(11) DEFAULT 0 COMMENT '0 = fleet is in space, 1 = fleet is on planet',
  `ships_array` text DEFAULT NULL COMMENT 'serialized ships array, like this: array(array(''bonus_time'' => 0, ''name'' => $ship[''name''], ''amount'' => 0) , ...)',
  `bot_type` int(11) DEFAULT 0 COMMENT 'different types use different bot_setting row',
  PRIMARY KEY (`id`),
  KEY `id` (`id`),
  KEY `next_action` (`next_fleet_action`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- %PREFIX%bots: ~0 rows (ungefähr)

-- %PREFIX%bot_setting
CREATE TABLE IF NOT EXISTS `%PREFIX%bot_setting` (
  `id` float NOT NULL DEFAULT 0,
  `name` varchar(50) DEFAULT 'honk' COMMENT 'this is the name of the bot_type for better orientation in administration',
  `metal_per_second` decimal(65,10) DEFAULT 0.0000000000 COMMENT 'metal per planet per sec (gets set automaticly at the start of a period)',
  `crystal_per_second` decimal(65,10) DEFAULT 0.0000000000 COMMENT 'crystem per planet per sec',
  `deuterium_per_second` decimal(65,10) DEFAULT 0.0000000000 COMMENT 'deuterium per planet per sec',
  `last_set` int(11) DEFAULT 0 COMMENT 'timestamp from the start of the running period(30 days)',
  `last_bot` int(11) DEFAULT 0 COMMENT 'id of the last bot wich have got his ress production',
  `ress_contingent` bigint(50) DEFAULT 0 COMMENT 'max res output for planets for the period',
  `ress_ships_contingent` bigint(50) DEFAULT 0,
  `full_contingent` bigint(50) DEFAULT 0 COMMENT 'max ress+ships(in ress) output for this period (30 days)',
  `full_contingent_used` decimal(65,10) DEFAULT 0.0000000000 COMMENT 'saves how many ress in fleet and resshave been outputted, since the start of the 30 day period',
  `ress_ships_contingent_used` decimal(65,10) DEFAULT 0.0000000000,
  `ress_contingent_used` decimal(65,10) DEFAULT 0.0000000000 COMMENT 'saves how much ress are put to plannets of all bots, since the start of the 30 day period',
  `first_points_multiplicator` int(11) DEFAULT 1 COMMENT 'multiplicate with first playerpoints * 1000 to set the ress value wich will be put into the universe',
  `bot_status` int(11) DEFAULT 1 COMMENT '0 = bots turned off, for protection of uni income',
  `ress_value_metal` float DEFAULT 0.5 COMMENT 'defines how much of the ress on the planets will be metal (0.3 = 30%)',
  `ress_value_crystal` float DEFAULT 0.3 COMMENT 'defines how much of the ress on the planets will be crystal (0.3 = 30%)',
  `ress_value_deuterium` float DEFAULT 0.2 COMMENT 'defines how much of the ress on the planets will be deuterium (0.3 = 30%)',
  `max_fleet_seconds_in_space` int(11) DEFAULT 10800 COMMENT 'fleet stays in spae for min 1h , this defines the max. time is chosen random between min and max. in seconds',
  `min_fleet_seconds_in_space` int(11) DEFAULT 3600,
  `max_fleet_seconds_on_planet` int(11) DEFAULT 7200 COMMENT 'fleet stays on planet for min 10min , this defines the max. time is chosen random between min and max. in seconds',
  `min_fleet_seconds_on_planet` int(11) DEFAULT 720,
  `ships_array` text DEFAULT NULL COMMENT 'serialized ships array, like this: array(array(shipvalue, name, leave_on_planet,cintingent_used,per_second,contingent) , ...)',
  `number_of_bots` int(11) DEFAULT 100 COMMENT 'is used to devide the monthly income under the bots',
  `ress_factor` float DEFAULT 0.1 COMMENT 'factor is used to determine how much of the monthly contingent is spend to ress , the rest is for fleet',
  `is_bot` int(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- %PREFIX%bot_setting: ~0 rows (ungefähr)

-- %PREFIX%buddy
CREATE TABLE IF NOT EXISTS `%PREFIX%buddy` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sender` int(10) unsigned NOT NULL DEFAULT 0,
  `owner` int(10) unsigned NOT NULL DEFAULT 0,
  `universe` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `universe` (`universe`),
  KEY `sender` (`sender`,`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- %PREFIX%buddy: 0 rows
/*!40000 ALTER TABLE `%PREFIX%buddy` DISABLE KEYS */;
/*!40000 ALTER TABLE `%PREFIX%buddy` ENABLE KEYS */;

-- %PREFIX%buddy_request
CREATE TABLE IF NOT EXISTS `%PREFIX%buddy_request` (
  `id` int(10) unsigned NOT NULL,
  `text` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- %PREFIX%buddy_request: 0 rows
/*!40000 ALTER TABLE `%PREFIX%buddy_request` DISABLE KEYS */;
/*!40000 ALTER TABLE `%PREFIX%buddy_request` ENABLE KEYS */;

-- %PREFIX%chat
CREATE TABLE IF NOT EXISTS `%PREFIX%chat` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sender_id` int(11) NOT NULL,
  `channel_id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL DEFAULT '',
  `alliance_name` varchar(50) NOT NULL DEFAULT '',
  `message` varchar(1500) NOT NULL DEFAULT '',
  `send_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `id` (`id`,`channel_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- %PREFIX%chat: ~0 rows (ungefähr)

-- %PREFIX%config
CREATE TABLE IF NOT EXISTS `%PREFIX%config` (
  `uni` int(11) NOT NULL AUTO_INCREMENT,
  `VERSION` varchar(8) NOT NULL,
  `sql_revision` int(11) NOT NULL DEFAULT 0,
  `users_amount` int(10) unsigned NOT NULL DEFAULT 1,
  `game_speed` bigint(20) unsigned NOT NULL DEFAULT 2500,
  `fleet_speed` bigint(20) unsigned NOT NULL DEFAULT 2500,
  `resource_multiplier` smallint(5) unsigned NOT NULL DEFAULT 1,
  `storage_multiplier` smallint(5) unsigned NOT NULL DEFAULT 1,
  `message_delete_behavior` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `message_delete_days` tinyint(3) unsigned NOT NULL DEFAULT 7,
  `halt_speed` smallint(5) unsigned NOT NULL DEFAULT 1,
  `Fleet_Cdr` tinyint(3) unsigned NOT NULL DEFAULT 30,
  `Defs_Cdr` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `initial_fields` smallint(5) unsigned NOT NULL DEFAULT 163,
  `uni_name` varchar(30) NOT NULL,
  `game_name` varchar(30) NOT NULL,
  `game_disable` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `close_reason` text NOT NULL,
  `metal_basic_income` int(11) NOT NULL DEFAULT 20,
  `crystal_basic_income` int(11) NOT NULL DEFAULT 10,
  `deuterium_basic_income` int(11) NOT NULL DEFAULT 0,
  `energy_basic_income` int(11) NOT NULL DEFAULT 0,
  `LastSettedGalaxyPos` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `LastSettedSystemPos` smallint(5) unsigned NOT NULL DEFAULT 1,
  `LastSettedPlanetPos` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `noobprotection` int(11) NOT NULL DEFAULT 0,
  `noobprotectiontime` int(11) NOT NULL DEFAULT 5000,
  `noobprotectionmulti` int(11) NOT NULL DEFAULT 5,
  `forum_url` varchar(128) NOT NULL DEFAULT 'http://2moons.cc',
  `adm_attack` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `debug` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `lang` varchar(2) NOT NULL DEFAULT '',
  `stat` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `stat_level` tinyint(3) unsigned NOT NULL DEFAULT 2,
  `stat_last_update` int(11) NOT NULL DEFAULT 0,
  `stat_settings` int(10) unsigned NOT NULL DEFAULT 1000,
  `stat_update_time` tinyint(3) unsigned NOT NULL DEFAULT 25,
  `stat_last_db_update` int(11) NOT NULL DEFAULT 0,
  `stats_fly_lock` int(11) NOT NULL DEFAULT 0,
  `cron_lock` int(11) NOT NULL DEFAULT 0,
  `ts_modon` tinyint(1) NOT NULL DEFAULT 0,
  `ts_server` varchar(64) NOT NULL DEFAULT '',
  `ts_tcpport` smallint(5) unsigned NOT NULL DEFAULT 0,
  `ts_udpport` smallint(5) unsigned NOT NULL DEFAULT 0,
  `ts_timeout` tinyint(1) NOT NULL DEFAULT 1,
  `ts_version` tinyint(1) NOT NULL DEFAULT 2,
  `ts_cron_last` int(11) NOT NULL DEFAULT 0,
  `ts_cron_interval` smallint(6) NOT NULL DEFAULT 5,
  `ts_login` varchar(32) NOT NULL DEFAULT '',
  `ts_password` varchar(32) NOT NULL DEFAULT '',
  `reg_closed` tinyint(1) NOT NULL DEFAULT 0,
  `OverviewNewsFrame` tinyint(1) NOT NULL DEFAULT 1,
  `OverviewNewsText` text NOT NULL,
  `capaktiv` tinyint(1) NOT NULL DEFAULT 0,
  `cappublic` varchar(42) NOT NULL DEFAULT '',
  `capprivate` varchar(42) NOT NULL DEFAULT '',
  `min_build_time` tinyint(4) NOT NULL DEFAULT 1,
  `mail_active` tinyint(1) NOT NULL DEFAULT 0,
  `mail_use` tinyint(1) NOT NULL DEFAULT 0,
  `smtp_host` varchar(64) NOT NULL DEFAULT '',
  `smtp_port` smallint(6) NOT NULL DEFAULT 0,
  `smtp_user` varchar(64) NOT NULL DEFAULT '',
  `smtp_pass` varchar(32) NOT NULL DEFAULT '',
  `smtp_ssl` enum('','ssl','tls') NOT NULL DEFAULT '',
  `smtp_sendmail` varchar(64) NOT NULL DEFAULT '',
  `smail_path` varchar(30) NOT NULL DEFAULT '/usr/sbin/sendmail',
  `user_valid` tinyint(1) NOT NULL DEFAULT 0,
  `fb_on` tinyint(1) NOT NULL DEFAULT 0,
  `fb_apikey` varchar(42) NOT NULL DEFAULT '',
  `fb_skey` varchar(42) NOT NULL DEFAULT '',
  `ga_active` varchar(42) NOT NULL DEFAULT '0',
  `ga_key` varchar(42) NOT NULL DEFAULT '',
  `moduls` varchar(100) NOT NULL DEFAULT '',
  `trade_allowed_ships` varchar(255) NOT NULL DEFAULT '202,401',
  `trade_charge` varchar(5) NOT NULL DEFAULT '30',
  `max_galaxy` tinyint(3) unsigned NOT NULL DEFAULT 9,
  `max_system` smallint(5) unsigned NOT NULL DEFAULT 400,
  `max_planets` tinyint(3) unsigned NOT NULL DEFAULT 15,
  `planet_factor` float(2,1) NOT NULL DEFAULT 1.0,
  `max_elements_build` tinyint(3) unsigned NOT NULL DEFAULT 5,
  `max_elements_tech` tinyint(3) unsigned NOT NULL DEFAULT 2,
  `max_elements_ships` tinyint(3) unsigned NOT NULL DEFAULT 10,
  `min_player_planets` tinyint(3) unsigned NOT NULL DEFAULT 9,
  `planets_tech` tinyint(4) NOT NULL DEFAULT 11,
  `planets_officier` tinyint(4) NOT NULL DEFAULT 5,
  `planets_per_tech` float(2,1) NOT NULL DEFAULT 0.5,
  `max_fleet_per_build` bigint(20) unsigned NOT NULL DEFAULT 1000000,
  `deuterium_cost_galaxy` int(10) unsigned NOT NULL DEFAULT 10,
  `max_dm_missions` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `max_overflow` float(2,1) NOT NULL DEFAULT 1.0,
  `moon_factor` float(2,1) NOT NULL DEFAULT 1.0,
  `moon_chance` tinyint(3) unsigned NOT NULL DEFAULT 20,
  `darkmatter_cost_trader` int(10) unsigned NOT NULL DEFAULT 750,
  `factor_university` tinyint(3) unsigned NOT NULL DEFAULT 8,
  `max_fleets_per_acs` tinyint(3) unsigned NOT NULL DEFAULT 16,
  `debris_moon` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `vmode_min_time` int(11) NOT NULL DEFAULT 259200,
  `gate_wait_time` int(11) NOT NULL DEFAULT 3600,
  `metal_start` int(10) unsigned NOT NULL DEFAULT 500,
  `crystal_start` int(10) unsigned NOT NULL DEFAULT 500,
  `deuterium_start` int(10) unsigned NOT NULL DEFAULT 0,
  `darkmatter_start` int(10) unsigned NOT NULL DEFAULT 0,
  `ttf_file` varchar(128) NOT NULL DEFAULT 'styles/resource/fonts/DroidSansMono.ttf',
  `ref_active` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `ref_bonus` int(10) unsigned NOT NULL DEFAULT 1000,
  `ref_minpoints` bigint(20) unsigned NOT NULL DEFAULT 2000,
  `ref_max_referals` tinyint(3) unsigned NOT NULL DEFAULT 5,
  `del_oldstuff` tinyint(3) unsigned NOT NULL DEFAULT 3,
  `del_user_manually` tinyint(3) unsigned NOT NULL DEFAULT 7,
  `del_user_automatic` tinyint(3) unsigned NOT NULL DEFAULT 30,
  `del_user_sendmail` tinyint(3) unsigned NOT NULL DEFAULT 21,
  `sendmail_inactive` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `silo_factor` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `timezone` varchar(32) NOT NULL DEFAULT 'Europe/London',
  `dst` enum('0','1','2') NOT NULL DEFAULT '2',
  `energySpeed` smallint(6) NOT NULL DEFAULT 1,
  `disclamerAddress` text NOT NULL,
  `disclamerPhone` text NOT NULL,
  `disclamerMail` text NOT NULL,
  `disclamerNotice` text NOT NULL,
  `alliance_create_min_points` bigint(20) unsigned NOT NULL DEFAULT 0,
  `first_player_points` bigint(20) unsigned NOT NULL DEFAULT 0,
  `last_weekstat` bigint(20) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`uni`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- %PREFIX%config: 1 rows
/*!40000 ALTER TABLE `%PREFIX%config` DISABLE KEYS */;

INSERT INTO `%PREFIX%config` (`uni`, `VERSION`, `sql_revision`, `users_amount`, `game_speed`, `fleet_speed`, `resource_multiplier`, `storage_multiplier`, `message_delete_behavior`, `message_delete_days`, `halt_speed`, `Fleet_Cdr`, `Defs_Cdr`, `initial_fields`, `uni_name`, `game_name`, `game_disable`, `close_reason`, `metal_basic_income`, `crystal_basic_income`, `deuterium_basic_income`, `energy_basic_income`, `LastSettedGalaxyPos`, `LastSettedSystemPos`, `LastSettedPlanetPos`, `noobprotection`, `noobprotectiontime`, `noobprotectionmulti`, `forum_url`, `adm_attack`, `debug`, `lang`, `stat`, `stat_level`, `stat_last_update`, `stat_settings`, `stat_update_time`, `stat_last_db_update`, `stats_fly_lock`, `cron_lock`, `ts_modon`, `ts_server`, `ts_tcpport`, `ts_udpport`, `ts_timeout`, `ts_version`, `ts_cron_last`, `ts_cron_interval`, `ts_login`, `ts_password`, `reg_closed`, `OverviewNewsFrame`, `OverviewNewsText`, `capaktiv`, `cappublic`, `capprivate`, `min_build_time`, `mail_active`, `mail_use`, `smtp_host`, `smtp_port`, `smtp_user`, `smtp_pass`, `smtp_ssl`, `smtp_sendmail`, `smail_path`, `user_valid`, `fb_on`, `fb_apikey`, `fb_skey`, `ga_active`, `ga_key`, `moduls`, `trade_allowed_ships`, `trade_charge`, `max_galaxy`, `max_system`, `max_planets`, `planet_factor`, `max_elements_build`, `max_elements_tech`, `max_elements_ships`, `min_player_planets`, `planets_tech`, `planets_officier`, `planets_per_tech`, `max_fleet_per_build`, `deuterium_cost_galaxy`, `max_dm_missions`, `max_overflow`, `moon_factor`, `moon_chance`, `darkmatter_cost_trader`, `factor_university`, `max_fleets_per_acs`, `debris_moon`, `vmode_min_time`, `gate_wait_time`, `metal_start`, `crystal_start`, `deuterium_start`, `darkmatter_start`, `ttf_file`, `ref_active`, `ref_bonus`, `ref_minpoints`, `ref_max_referals`, `del_oldstuff`, `del_user_manually`, `del_user_automatic`, `del_user_sendmail`, `sendmail_inactive`, `silo_factor`, `timezone`, `dst`, `energySpeed`, `disclamerAddress`, `disclamerPhone`, `disclamerMail`, `disclamerNotice`, `alliance_create_min_points`, `first_player_points`, `last_weekstat`) VALUES
	(1, '%VERSION%', %REVISION%, 1, 2500, 2500, 1, 1, 0, 7, 1, 30, 0, 163, '', '2Moons', 1, '', 20, 10, 0, 0, 1, 1, 1, 0, 5000, 5, 'http://2moons.de', 0, 0, '', 0, 2, 0, 1000, 25, 0, 0, 0, 0, '', 0, 0, 1, 2, 0, 5, '', '', 0, 1, '', 0, '', '', 1, 0, 0, '', 0, '', '', '', '', '/usr/sbin/sendmail', 0, 0, '', '', '0', '', '', '202,401', '30', 9, 400, 15, 1.0, 5, 2, 10, 9, 11, 5, 0.5, 1000000, 10, 1, 1.0, 1.0, 20, 750, 8, 16, 1, 259200, 3600, 500, 500, 0, 0, 'styles/resource/fonts/DroidSansMono.ttf', 0, 1000, 2000, 5, 3, 7, 30, 21, 0, 1, 'Europe/London', '2', 1, '', '', '', '', 0, 0, 0);/*!40000 ALTER TABLE `%PREFIX%config` ENABLE KEYS */;

-- %PREFIX%cronjobs
CREATE TABLE IF NOT EXISTS `%PREFIX%cronjobs` (
  `cronjobID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  `isActive` tinyint(1) NOT NULL DEFAULT 1,
  `min` varchar(32) NOT NULL,
  `hours` varchar(32) NOT NULL,
  `dom` varchar(32) NOT NULL,
  `month` varchar(32) NOT NULL,
  `dow` varchar(32) NOT NULL,
  `class` varchar(32) NOT NULL,
  `nextTime` int(11) DEFAULT NULL,
  `lock` varchar(32) DEFAULT NULL,
  UNIQUE KEY `cronjobID` (`cronjobID`),
  KEY `isActive` (`isActive`,`nextTime`,`lock`,`cronjobID`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- %PREFIX%cronjobs: 8 rows
/*!40000 ALTER TABLE `%PREFIX%cronjobs` DISABLE KEYS */;
INSERT INTO `%PREFIX%cronjobs` (`cronjobID`, `name`, `isActive`, `min`, `hours`, `dom`, `month`, `dow`, `class`, `nextTime`, `lock`) VALUES
	(1, 'referral', 1, '0,30', '*', '*', '*', '*', 'ReferralCronjob', 0, NULL),
	(2, 'statistic', 1, '0,30', '*', '*', '*', '*', 'StatisticCronjob', 0, NULL),
	(3, 'daily', 1, '25', '2', '*', '*', '*', 'DailyCronjob', 0, NULL),
	(4, 'cleaner', 1, '45', '2', '*', '*', '6', 'CleanerCronjob', 0, NULL),
	(5, 'inactive', 1, '30', '1', '*', '*', '0,3,6', 'InactiveMailCronjob', 0, NULL),
	(6, 'teamspeak', 0, '*/3', '*', '*', '*', '*', 'TeamSpeakCronjob', 0, NULL),
	(7, 'databasedump', 1, '30', '1', '*', '*', '1', 'DumpCronjob', 0, NULL),
	(8, 'tracking', 1, '18', '20', '*', '*', '0', 'TrackingCronjob', 0, NULL);
/*!40000 ALTER TABLE `%PREFIX%cronjobs` ENABLE KEYS */;

-- %PREFIX%cronjobs_log
CREATE TABLE IF NOT EXISTS `%PREFIX%cronjobs_log` (
  `cronjobId` int(10) unsigned NOT NULL,
  `executionTime` datetime NOT NULL,
  `lockToken` varchar(32) NOT NULL,
  KEY `cronjobId` (`cronjobId`,`executionTime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- %PREFIX%cronjobs_log: 0 rows
/*!40000 ALTER TABLE `%PREFIX%cronjobs_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `%PREFIX%cronjobs_log` ENABLE KEYS */;

-- %PREFIX%diplo
CREATE TABLE IF NOT EXISTS `%PREFIX%diplo` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `owner_1` int(10) unsigned NOT NULL,
  `owner_2` int(10) unsigned NOT NULL,
  `level` tinyint(3) unsigned NOT NULL,
  `accept` tinyint(3) unsigned NOT NULL,
  `accept_text` varchar(255) NOT NULL,
  `universe` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `universe` (`universe`),
  KEY `owner_1` (`owner_1`,`owner_2`,`accept`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- %PREFIX%diplo: 0 rows
/*!40000 ALTER TABLE `%PREFIX%diplo` DISABLE KEYS */;
/*!40000 ALTER TABLE `%PREFIX%diplo` ENABLE KEYS */;

-- %PREFIX%fleets
CREATE TABLE IF NOT EXISTS `%PREFIX%fleets` (
  `fleet_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `fleet_owner` int(10) unsigned NOT NULL DEFAULT 0,
  `fleet_mission` tinyint(3) unsigned NOT NULL DEFAULT 3,
  `fleet_amount` bigint(20) unsigned NOT NULL DEFAULT 0,
  `fleet_array` text DEFAULT NULL,
  `fleet_universe` tinyint(3) unsigned NOT NULL,
  `fleet_start_time` int(11) NOT NULL DEFAULT 0,
  `fleet_start_id` int(10) unsigned NOT NULL,
  `fleet_start_galaxy` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `fleet_start_system` smallint(5) unsigned NOT NULL DEFAULT 0,
  `fleet_start_planet` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `fleet_start_type` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `fleet_end_time` int(11) NOT NULL DEFAULT 0,
  `fleet_end_stay` int(11) NOT NULL DEFAULT 0,
  `fleet_end_id` int(10) unsigned NOT NULL,
  `fleet_end_galaxy` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `fleet_end_system` smallint(5) unsigned NOT NULL DEFAULT 0,
  `fleet_end_planet` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `fleet_end_type` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `fleet_target_obj` smallint(5) unsigned NOT NULL DEFAULT 0,
  `fleet_resource_metal` double(50,0) unsigned NOT NULL DEFAULT 0,
  `fleet_resource_crystal` double(50,0) unsigned NOT NULL DEFAULT 0,
  `fleet_resource_deuterium` double(50,0) unsigned NOT NULL DEFAULT 0,
  `fleet_resource_darkmatter` double(50,0) unsigned NOT NULL DEFAULT 0,
  `fleet_target_owner` int(10) unsigned NOT NULL DEFAULT 0,
  `fleet_group` int(10) unsigned NOT NULL DEFAULT 0,
  `fleet_mess` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `start_time` int(11) DEFAULT NULL,
  `fleet_busy` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `hasCanceled` tinyint(3) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`fleet_id`),
  KEY `fleet_target_owner` (`fleet_target_owner`,`fleet_mission`),
  KEY `fleet_owner` (`fleet_owner`,`fleet_mission`),
  KEY `fleet_group` (`fleet_group`)
) ENGINE=InnoDB AUTO_INCREMENT=15023 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- %PREFIX%fleets: 0 rows
/*!40000 ALTER TABLE `%PREFIX%fleets` DISABLE KEYS */;
/*!40000 ALTER TABLE `%PREFIX%fleets` ENABLE KEYS */;

-- %PREFIX%fleet_event
CREATE TABLE IF NOT EXISTS `%PREFIX%fleet_event` (
  `fleetID` int(11) NOT NULL,
  `time` int(11) NOT NULL,
  `lock` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`fleetID`),
  KEY `lock` (`lock`,`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- %PREFIX%fleet_event: 0 rows
/*!40000 ALTER TABLE `%PREFIX%fleet_event` DISABLE KEYS */;
/*!40000 ALTER TABLE `%PREFIX%fleet_event` ENABLE KEYS */;

-- %PREFIX%log
CREATE TABLE IF NOT EXISTS `%PREFIX%log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `mode` tinyint(3) unsigned NOT NULL,
  `admin` int(10) unsigned NOT NULL,
  `target` int(11) NOT NULL,
  `time` int(10) unsigned NOT NULL,
  `data` text NOT NULL,
  `universe` tinyint(4) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `mode` (`mode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- %PREFIX%log: 0 rows
/*!40000 ALTER TABLE `%PREFIX%log` DISABLE KEYS */;
/*!40000 ALTER TABLE `%PREFIX%log` ENABLE KEYS */;

-- %PREFIX%log_fleets
CREATE TABLE IF NOT EXISTS `%PREFIX%log_fleets` (
  `fleet_id` bigint(20) unsigned NOT NULL,
  `fleet_owner` int(10) unsigned NOT NULL DEFAULT 0,
  `fleet_mission` tinyint(3) unsigned NOT NULL DEFAULT 3,
  `fleet_amount` bigint(20) unsigned NOT NULL DEFAULT 0,
  `fleet_array` text DEFAULT NULL,
  `fleet_universe` tinyint(3) unsigned NOT NULL,
  `fleet_start_time` int(11) NOT NULL DEFAULT 0,
  `fleet_start_id` int(10) unsigned NOT NULL,
  `fleet_start_galaxy` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `fleet_start_system` smallint(5) unsigned NOT NULL DEFAULT 0,
  `fleet_start_planet` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `fleet_start_type` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `fleet_end_time` int(11) NOT NULL DEFAULT 0,
  `fleet_end_stay` int(11) NOT NULL DEFAULT 0,
  `fleet_end_id` int(10) unsigned NOT NULL,
  `fleet_end_galaxy` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `fleet_end_system` smallint(5) unsigned NOT NULL DEFAULT 0,
  `fleet_end_planet` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `fleet_end_type` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `fleet_target_obj` smallint(5) unsigned NOT NULL DEFAULT 0,
  `fleet_resource_metal` double(50,0) unsigned NOT NULL DEFAULT 0,
  `fleet_resource_crystal` double(50,0) unsigned NOT NULL DEFAULT 0,
  `fleet_resource_deuterium` double(50,0) unsigned NOT NULL DEFAULT 0,
  `fleet_resource_darkmatter` double(50,0) unsigned NOT NULL DEFAULT 0,
  `fleet_target_owner` int(10) unsigned NOT NULL DEFAULT 0,
  `fleet_group` varchar(15) NOT NULL DEFAULT '0',
  `fleet_mess` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `start_time` int(11) DEFAULT NULL,
  `fleet_busy` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `fleet_state` tinyint(3) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`fleet_id`),
  KEY `BashRule` (`fleet_owner`,`fleet_end_id`,`fleet_start_time`,`fleet_mission`,`fleet_state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- %PREFIX%log_fleets: 0 rows
/*!40000 ALTER TABLE `%PREFIX%log_fleets` DISABLE KEYS */;
/*!40000 ALTER TABLE `%PREFIX%log_fleets` ENABLE KEYS */;

-- %PREFIX%lostpassword
CREATE TABLE IF NOT EXISTS `%PREFIX%lostpassword` (
  `userID` int(10) unsigned NOT NULL,
  `key` varchar(32) NOT NULL,
  `time` int(10) unsigned NOT NULL,
  `hasChanged` tinyint(1) NOT NULL DEFAULT 0,
  `fromIP` varchar(40) NOT NULL,
  PRIMARY KEY (`key`),
  UNIQUE KEY `userID` (`userID`,`key`,`time`,`hasChanged`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- %PREFIX%lostpassword: 0 rows
/*!40000 ALTER TABLE `%PREFIX%lostpassword` DISABLE KEYS */;
/*!40000 ALTER TABLE `%PREFIX%lostpassword` ENABLE KEYS */;

-- %PREFIX%messages
CREATE TABLE IF NOT EXISTS `%PREFIX%messages` (
  `message_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `message_owner` int(10) unsigned NOT NULL DEFAULT 0,
  `message_sender` int(10) unsigned NOT NULL DEFAULT 0,
  `message_time` int(11) NOT NULL DEFAULT 0,
  `message_type` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `message_from` varchar(128) DEFAULT NULL,
  `message_subject` varchar(255) DEFAULT NULL,
  `message_text` text DEFAULT NULL,
  `message_unread` tinyint(4) NOT NULL DEFAULT 1,
  `message_universe` tinyint(3) unsigned NOT NULL,
  `message_deleted` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`message_id`),
  KEY `message_sender` (`message_sender`),
  KEY `message_deleted` (`message_deleted`),
  KEY `message_owner` (`message_owner`,`message_type`,`message_unread`,`message_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- %PREFIX%messages: 0 rows
/*!40000 ALTER TABLE `%PREFIX%messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `%PREFIX%messages` ENABLE KEYS */;

-- %PREFIX%multi
CREATE TABLE IF NOT EXISTS `%PREFIX%multi` (
  `multiID` int(11) NOT NULL AUTO_INCREMENT,
  `userID` int(11) NOT NULL,
  PRIMARY KEY (`multiID`),
  KEY `userID` (`userID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- %PREFIX%multi: 0 rows
/*!40000 ALTER TABLE `%PREFIX%multi` DISABLE KEYS */;
/*!40000 ALTER TABLE `%PREFIX%multi` ENABLE KEYS */;

-- %PREFIX%news
CREATE TABLE IF NOT EXISTS `%PREFIX%news` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user` varchar(64) NOT NULL,
  `date` int(11) NOT NULL,
  `title` varchar(64) NOT NULL,
  `text` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- %PREFIX%news: 0 rows
/*!40000 ALTER TABLE `%PREFIX%news` DISABLE KEYS */;
/*!40000 ALTER TABLE `%PREFIX%news` ENABLE KEYS */;

-- %PREFIX%notes
CREATE TABLE IF NOT EXISTS `%PREFIX%notes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` int(10) unsigned DEFAULT NULL,
  `time` int(11) DEFAULT NULL,
  `priority` tinyint(3) unsigned DEFAULT 1,
  `title` varchar(32) DEFAULT NULL,
  `text` text DEFAULT NULL,
  `universe` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `universe` (`universe`),
  KEY `owner` (`owner`,`time`,`priority`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- %PREFIX%notes: 0 rows
/*!40000 ALTER TABLE `%PREFIX%notes` DISABLE KEYS */;
/*!40000 ALTER TABLE `%PREFIX%notes` ENABLE KEYS */;

-- %PREFIX%planets
CREATE TABLE IF NOT EXISTS `%PREFIX%planets` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(20) DEFAULT 'Hauptplanet',
  `id_owner` int(10) unsigned DEFAULT NULL,
  `universe` tinyint(3) unsigned NOT NULL,
  `galaxy` int(11) NOT NULL DEFAULT 0,
  `system` int(11) NOT NULL DEFAULT 0,
  `planet` tinyint(4) NOT NULL DEFAULT 0,
  `last_update` int(11) DEFAULT NULL,
  `planet_type` enum('1','3') NOT NULL DEFAULT '1',
  `destruyed` int(11) NOT NULL DEFAULT 0,
  `b_building` int(11) NOT NULL DEFAULT 0,
  `b_building_id` text DEFAULT NULL,
  `b_hangar` int(11) NOT NULL DEFAULT 0,
  `b_hangar_id` text DEFAULT NULL,
  `b_hangar_plus` int(11) NOT NULL DEFAULT 0,
  `image` varchar(32) NOT NULL DEFAULT 'normaltempplanet01',
  `diameter` int(10) unsigned NOT NULL DEFAULT 12800,
  `field_current` smallint(5) unsigned NOT NULL DEFAULT 0,
  `field_max` smallint(5) unsigned NOT NULL DEFAULT 163,
  `temp_min` int(11) NOT NULL DEFAULT -17,
  `temp_max` int(11) NOT NULL DEFAULT 23,
  `eco_hash` varchar(32) NOT NULL DEFAULT '',
  `metal` double(50,6) unsigned NOT NULL DEFAULT 0.000000,
  `metal_perhour` double(50,6) NOT NULL DEFAULT 0.000000,
  `metal_max` double(50,0) unsigned DEFAULT 100000,
  `crystal` double(50,6) unsigned NOT NULL DEFAULT 0.000000,
  `crystal_perhour` double(50,6) NOT NULL DEFAULT 0.000000,
  `crystal_max` double(50,0) unsigned DEFAULT 100000,
  `deuterium` double(50,6) unsigned NOT NULL DEFAULT 0.000000,
  `deuterium_perhour` double(50,6) NOT NULL DEFAULT 0.000000,
  `deuterium_max` double(50,0) unsigned DEFAULT 100000,
  `energy_used` double(50,0) NOT NULL DEFAULT 0,
  `energy` double(50,0) unsigned NOT NULL DEFAULT 0,
  `metal_mine` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `crystal_mine` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `deuterium_sintetizer` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `solar_plant` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `fusion_plant` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `robot_factory` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `nano_factory` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `hangar` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `metal_store` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `crystal_store` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `deuterium_store` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `laboratory` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `terraformer` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `university` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `ally_deposit` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `silo` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `mondbasis` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `phalanx` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `sprungtor` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `small_ship_cargo` bigint(20) unsigned NOT NULL DEFAULT 0,
  `big_ship_cargo` bigint(20) unsigned NOT NULL DEFAULT 0,
  `light_hunter` bigint(20) unsigned NOT NULL DEFAULT 0,
  `heavy_hunter` bigint(20) unsigned NOT NULL DEFAULT 0,
  `crusher` bigint(20) unsigned NOT NULL DEFAULT 0,
  `battle_ship` bigint(20) unsigned NOT NULL DEFAULT 0,
  `colonizer` bigint(20) unsigned NOT NULL DEFAULT 0,
  `recycler` bigint(20) unsigned NOT NULL DEFAULT 0,
  `spy_sonde` bigint(20) unsigned NOT NULL DEFAULT 0,
  `bomber_ship` bigint(20) unsigned NOT NULL DEFAULT 0,
  `solar_satelit` bigint(20) unsigned NOT NULL DEFAULT 0,
  `destructor` bigint(20) unsigned NOT NULL DEFAULT 0,
  `dearth_star` bigint(20) unsigned NOT NULL DEFAULT 0,
  `battleship` bigint(20) unsigned NOT NULL DEFAULT 0,
  `lune_noir` bigint(20) unsigned NOT NULL DEFAULT 0,
  `ev_transporter` bigint(20) unsigned NOT NULL DEFAULT 0,
  `star_crasher` bigint(20) unsigned NOT NULL DEFAULT 0,
  `giga_recykler` bigint(20) unsigned NOT NULL DEFAULT 0,
  `dm_ship` bigint(20) NOT NULL DEFAULT 0,
  `orbital_station` bigint(20) unsigned NOT NULL DEFAULT 0,
  `misil_launcher` bigint(20) unsigned NOT NULL DEFAULT 0,
  `small_laser` bigint(20) unsigned NOT NULL DEFAULT 0,
  `big_laser` bigint(20) unsigned NOT NULL DEFAULT 0,
  `gauss_canyon` bigint(20) unsigned NOT NULL DEFAULT 0,
  `ionic_canyon` bigint(20) unsigned NOT NULL DEFAULT 0,
  `buster_canyon` bigint(20) unsigned NOT NULL DEFAULT 0,
  `small_protection_shield` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `planet_protector` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `big_protection_shield` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `graviton_canyon` bigint(20) unsigned NOT NULL DEFAULT 0,
  `interceptor_misil` bigint(20) unsigned NOT NULL DEFAULT 0,
  `interplanetary_misil` bigint(20) unsigned NOT NULL DEFAULT 0,
  `metal_mine_porcent` enum('0','1','2','3','4','5','6','7','8','9','10') NOT NULL DEFAULT '10',
  `crystal_mine_porcent` enum('0','1','2','3','4','5','6','7','8','9','10') NOT NULL DEFAULT '10',
  `deuterium_sintetizer_porcent` enum('0','1','2','3','4','5','6','7','8','9','10') NOT NULL DEFAULT '10',
  `solar_plant_porcent` enum('0','1','2','3','4','5','6','7','8','9','10') NOT NULL DEFAULT '10',
  `fusion_plant_porcent` enum('0','1','2','3','4','5','6','7','8','9','10') NOT NULL DEFAULT '10',
  `solar_satelit_porcent` enum('0','1','2','3','4','5','6','7','8','9','10') NOT NULL DEFAULT '10',
  `last_jump_time` int(11) NOT NULL DEFAULT 0,
  `der_metal` double(50,0) unsigned NOT NULL DEFAULT 0,
  `der_crystal` double(50,0) unsigned NOT NULL DEFAULT 0,
  `id_luna` int(11) NOT NULL DEFAULT 0,
  `is_bot` int(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `id_luna` (`id_luna`),
  KEY `id_owner` (`id_owner`),
  KEY `destruyed` (`destruyed`),
  KEY `universe` (`universe`,`galaxy`,`system`,`planet`,`planet_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- %PREFIX%planets: 0 rows
/*!40000 ALTER TABLE `%PREFIX%planets` DISABLE KEYS */;
/*!40000 ALTER TABLE `%PREFIX%planets` ENABLE KEYS */;

-- %PREFIX%raports
CREATE TABLE IF NOT EXISTS `%PREFIX%raports` (
  `rid` varchar(32) NOT NULL,
  `raport` text NOT NULL,
  `time` int(11) NOT NULL,
  `attacker` varchar(255) NOT NULL DEFAULT '',
  `defender` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`rid`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- %PREFIX%raports: 0 rows
/*!40000 ALTER TABLE `%PREFIX%raports` DISABLE KEYS */;
/*!40000 ALTER TABLE `%PREFIX%raports` ENABLE KEYS */;

-- %PREFIX%records
CREATE TABLE IF NOT EXISTS `%PREFIX%records` (
  `userID` int(10) unsigned NOT NULL,
  `elementID` smallint(5) unsigned NOT NULL,
  `level` bigint(20) unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- %PREFIX%records: 0 rows
/*!40000 ALTER TABLE `%PREFIX%records` DISABLE KEYS */;
/*!40000 ALTER TABLE `%PREFIX%records` ENABLE KEYS */;

-- %PREFIX%session
CREATE TABLE IF NOT EXISTS `%PREFIX%session` (
  `sessionID` varchar(32) NOT NULL,
  `userID` int(10) unsigned NOT NULL,
  `userIP` varchar(40) NOT NULL,
  `lastonline` int(11) NOT NULL,
  PRIMARY KEY (`userID`),
  KEY `sessionID` (`sessionID`)
) ENGINE=MEMORY DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- %PREFIX%session: 0 rows
/*!40000 ALTER TABLE `%PREFIX%session` DISABLE KEYS */;
/*!40000 ALTER TABLE `%PREFIX%session` ENABLE KEYS */;

-- %PREFIX%shortcuts
CREATE TABLE IF NOT EXISTS `%PREFIX%shortcuts` (
  `shortcutID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ownerID` int(10) unsigned NOT NULL,
  `name` varchar(32) NOT NULL,
  `galaxy` tinyint(3) unsigned NOT NULL,
  `system` smallint(5) unsigned NOT NULL,
  `planet` tinyint(3) unsigned NOT NULL,
  `type` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`shortcutID`),
  KEY `ownerID` (`ownerID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- %PREFIX%shortcuts: 0 rows
/*!40000 ALTER TABLE `%PREFIX%shortcuts` DISABLE KEYS */;
/*!40000 ALTER TABLE `%PREFIX%shortcuts` ENABLE KEYS */;

-- %PREFIX%statpoints
CREATE TABLE IF NOT EXISTS `%PREFIX%statpoints` (
  `id_owner` int(11) unsigned NOT NULL DEFAULT 0,
  `id_ally` int(11) unsigned NOT NULL DEFAULT 0,
  `stat_type` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `universe` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `tech_rank` int(11) unsigned NOT NULL DEFAULT 0,
  `tech_old_rank` int(11) unsigned NOT NULL DEFAULT 0,
  `tech_points` double(50,0) unsigned NOT NULL DEFAULT 0,
  `tech_count` bigint(20) unsigned NOT NULL DEFAULT 0,
  `build_rank` int(11) unsigned NOT NULL DEFAULT 0,
  `build_old_rank` int(11) unsigned NOT NULL DEFAULT 0,
  `build_points` double(50,0) unsigned NOT NULL DEFAULT 0,
  `build_count` bigint(20) unsigned NOT NULL DEFAULT 0,
  `defs_rank` int(11) unsigned NOT NULL DEFAULT 0,
  `defs_old_rank` int(11) unsigned NOT NULL DEFAULT 0,
  `defs_points` double(50,0) unsigned NOT NULL DEFAULT 0,
  `defs_count` bigint(20) unsigned NOT NULL DEFAULT 0,
  `fleet_rank` int(11) unsigned NOT NULL DEFAULT 0,
  `fleet_old_rank` int(11) unsigned NOT NULL DEFAULT 0,
  `fleet_points` double(50,0) unsigned NOT NULL DEFAULT 0,
  `fleet_count` bigint(20) unsigned NOT NULL DEFAULT 0,
  `ress_rank` int(11) unsigned NOT NULL DEFAULT 0,
  `ress_old_rank` int(11) unsigned NOT NULL DEFAULT 0,
  `ress_count` bigint(20) unsigned NOT NULL DEFAULT 0,
  `ress_points` bigint(20) unsigned NOT NULL DEFAULT 0,
  `total_rank` int(11) unsigned NOT NULL DEFAULT 0,
  `total_old_rank` int(11) unsigned NOT NULL DEFAULT 0,
  `total_points` double(50,0) unsigned NOT NULL DEFAULT 0,
  `total_count` bigint(20) unsigned NOT NULL DEFAULT 0,
  `tech_old` double(50,0) unsigned NOT NULL DEFAULT 0,
  `build_old` double(50,0) unsigned NOT NULL DEFAULT 0,
  `defs_old` double(50,0) unsigned NOT NULL DEFAULT 0,
  `fleet_old` double(50,0) unsigned NOT NULL DEFAULT 0,
  `ress_old` double(50,0) unsigned NOT NULL DEFAULT 0,
  `total_old` double(50,0) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id_owner`),
  KEY `id_owner` (`id_owner`),
  KEY `universe` (`universe`),
  KEY `stat_type` (`stat_type`),
  KEY `total_points` (`total_points`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- %PREFIX%statpoints: ~0 rows (ungefähr)

-- %PREFIX%statpoints_alliance
CREATE TABLE IF NOT EXISTS `%PREFIX%statpoints_alliance` (
  `id_owner` int(11) unsigned NOT NULL DEFAULT 0,
  `id_ally` int(11) unsigned NOT NULL DEFAULT 0,
  `stat_type` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `universe` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `tech_rank` int(11) unsigned NOT NULL DEFAULT 0,
  `tech_old_rank` int(11) unsigned NOT NULL DEFAULT 0,
  `tech_points` double(50,0) unsigned NOT NULL DEFAULT 0,
  `tech_count` bigint(20) unsigned NOT NULL DEFAULT 0,
  `build_rank` int(11) unsigned NOT NULL DEFAULT 0,
  `build_old_rank` int(11) unsigned NOT NULL DEFAULT 0,
  `build_points` double(50,0) unsigned NOT NULL DEFAULT 0,
  `build_count` bigint(20) unsigned NOT NULL DEFAULT 0,
  `defs_rank` int(11) unsigned NOT NULL DEFAULT 0,
  `defs_old_rank` int(11) unsigned NOT NULL DEFAULT 0,
  `defs_points` double(50,0) unsigned NOT NULL DEFAULT 0,
  `defs_count` bigint(20) unsigned NOT NULL DEFAULT 0,
  `fleet_rank` int(11) unsigned NOT NULL DEFAULT 0,
  `fleet_old_rank` int(11) unsigned NOT NULL DEFAULT 0,
  `fleet_points` double(50,0) unsigned NOT NULL DEFAULT 0,
  `fleet_count` bigint(20) unsigned NOT NULL DEFAULT 0,
  `ress_rank` int(11) unsigned NOT NULL DEFAULT 0,
  `ress_old_rank` int(11) unsigned NOT NULL DEFAULT 0,
  `ress_count` bigint(20) unsigned NOT NULL DEFAULT 0,
  `ress_points` bigint(20) unsigned NOT NULL DEFAULT 0,
  `total_rank` int(11) unsigned NOT NULL DEFAULT 0,
  `total_old_rank` int(11) unsigned NOT NULL DEFAULT 0,
  `total_points` double(50,0) unsigned NOT NULL DEFAULT 0,
  `total_count` bigint(20) unsigned NOT NULL DEFAULT 0,
  `tech_old` double(50,0) unsigned NOT NULL DEFAULT 0,
  `build_old` double(50,0) unsigned NOT NULL DEFAULT 0,
  `defs_old` double(50,0) unsigned NOT NULL DEFAULT 0,
  `fleet_old` double(50,0) unsigned NOT NULL DEFAULT 0,
  `ress_old` double(50,0) unsigned NOT NULL DEFAULT 0,
  `total_old` double(50,0) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id_owner`),
  KEY `id_owner` (`id_owner`) USING BTREE,
  KEY `universe` (`universe`) USING BTREE,
  KEY `stat_type` (`stat_type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- %PREFIX%statpoints_alliance: ~0 rows (ungefähr)

-- %PREFIX%system
CREATE TABLE IF NOT EXISTS `%PREFIX%system` (
  `dbVersion` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*!40000 ALTER TABLE `uni1_system` DISABLE KEYS */;
INSERT INTO `%PREFIX%system` (`dbVersion`) VALUES
	(4);
/*!40000 ALTER TABLE `uni1_system` ENABLE KEYS */;


-- %PREFIX%ticket
CREATE TABLE IF NOT EXISTS `%PREFIX%ticket` (
  `ticketID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `universe` tinyint(3) unsigned NOT NULL,
  `ownerID` int(10) unsigned NOT NULL,
  `categoryID` tinyint(3) unsigned NOT NULL,
  `subject` varchar(255) NOT NULL,
  `status` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `time` int(10) unsigned NOT NULL,
  PRIMARY KEY (`ticketID`),
  KEY `ownerID` (`ownerID`),
  KEY `universe` (`universe`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- %PREFIX%ticket: 0 rows
/*!40000 ALTER TABLE `%PREFIX%ticket` DISABLE KEYS */;
/*!40000 ALTER TABLE `%PREFIX%ticket` ENABLE KEYS */;

-- %PREFIX%ticket_answer
CREATE TABLE IF NOT EXISTS `%PREFIX%ticket_answer` (
  `answerID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ownerID` int(10) unsigned NOT NULL,
  `ownerName` varchar(32) NOT NULL,
  `ticketID` int(10) unsigned NOT NULL,
  `time` int(10) unsigned NOT NULL,
  `subject` varchar(255) NOT NULL,
  `message` mediumtext NOT NULL,
  PRIMARY KEY (`answerID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- %PREFIX%ticket_answer: 0 rows
/*!40000 ALTER TABLE `%PREFIX%ticket_answer` DISABLE KEYS */;
/*!40000 ALTER TABLE `%PREFIX%ticket_answer` ENABLE KEYS */;

-- %PREFIX%ticket_category
CREATE TABLE IF NOT EXISTS `%PREFIX%ticket_category` (
  `categoryID` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  PRIMARY KEY (`categoryID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- %PREFIX%ticket_category: 1 rows
/*!40000 ALTER TABLE `%PREFIX%ticket_category` DISABLE KEYS */;
INSERT INTO `%PREFIX%ticket_category` (`categoryID`, `name`) VALUES
	(1, 'Support');
/*!40000 ALTER TABLE `%PREFIX%ticket_category` ENABLE KEYS */;

-- %PREFIX%topkb
CREATE TABLE IF NOT EXISTS `%PREFIX%topkb` (
  `rid` varchar(32) NOT NULL,
  `units` double(50,0) unsigned NOT NULL,
  `result` varchar(1) NOT NULL,
  `time` int(11) NOT NULL,
  `universe` tinyint(3) unsigned NOT NULL,
  KEY `time` (`universe`,`rid`,`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- %PREFIX%topkb: 0 rows
/*!40000 ALTER TABLE `%PREFIX%topkb` DISABLE KEYS */;
/*!40000 ALTER TABLE `%PREFIX%topkb` ENABLE KEYS */;

-- %PREFIX%users
CREATE TABLE IF NOT EXISTS `%PREFIX%users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(32) NOT NULL DEFAULT '',
  `password` varchar(60) NOT NULL DEFAULT '',
  `email` varchar(64) NOT NULL DEFAULT '',
  `email_2` varchar(64) NOT NULL DEFAULT '',
  `lang` varchar(2) NOT NULL DEFAULT 'de',
  `authattack` tinyint(1) NOT NULL DEFAULT 0,
  `authlevel` tinyint(1) NOT NULL DEFAULT 0,
  `rights` text DEFAULT NULL,
  `id_planet` int(10) unsigned NOT NULL DEFAULT 0,
  `universe` tinyint(3) unsigned NOT NULL,
  `galaxy` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `system` smallint(5) unsigned NOT NULL DEFAULT 0,
  `planet` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `darkmatter` double(50,0) NOT NULL DEFAULT 0,
  `user_lastip` varchar(40) NOT NULL DEFAULT '',
  `ip_at_reg` varchar(40) NOT NULL DEFAULT '',
  `register_time` int(11) NOT NULL DEFAULT 0,
  `onlinetime` int(11) NOT NULL DEFAULT 0,
  `dpath` varchar(20) NOT NULL DEFAULT 'gow',
  `timezone` varchar(32) NOT NULL DEFAULT 'Europe/London',
  `planet_sort` tinyint(1) NOT NULL DEFAULT 0,
  `planet_sort_order` tinyint(1) NOT NULL DEFAULT 0,
  `spio_anz` int(10) unsigned NOT NULL DEFAULT 1,
  `settings_fleetactions` tinyint(3) unsigned NOT NULL DEFAULT 3,
  `settings_esp` tinyint(1) NOT NULL DEFAULT 1,
  `settings_wri` tinyint(1) NOT NULL DEFAULT 1,
  `settings_bud` tinyint(1) NOT NULL DEFAULT 1,
  `settings_mis` tinyint(1) NOT NULL DEFAULT 1,
  `settings_blockPM` tinyint(1) NOT NULL DEFAULT 0,
  `urlaubs_modus` tinyint(1) NOT NULL DEFAULT 0,
  `urlaubs_until` int(11) NOT NULL DEFAULT 0,
  `db_deaktjava` int(11) NOT NULL DEFAULT 0,
  `b_tech_planet` int(10) unsigned NOT NULL DEFAULT 0,
  `b_tech` int(10) unsigned NOT NULL DEFAULT 0,
  `b_tech_id` smallint(5) unsigned NOT NULL DEFAULT 0,
  `b_tech_queue` text DEFAULT NULL,
  `spy_tech` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `computer_tech` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `military_tech` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `defence_tech` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `shield_tech` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `energy_tech` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `hyperspace_tech` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `combustion_tech` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `impulse_motor_tech` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `hyperspace_motor_tech` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `laser_tech` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `ionic_tech` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `buster_tech` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `intergalactic_tech` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `expedition_tech` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `metal_proc_tech` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `crystal_proc_tech` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `deuterium_proc_tech` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `graviton_tech` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `ally_id` int(10) unsigned NOT NULL DEFAULT 0,
  `ally_register_time` int(11) NOT NULL DEFAULT 0,
  `ally_rank_id` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `rpg_geologue` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `rpg_amiral` tinyint(4) NOT NULL DEFAULT 0,
  `rpg_ingenieur` tinyint(4) NOT NULL DEFAULT 0,
  `rpg_technocrate` tinyint(4) NOT NULL DEFAULT 0,
  `rpg_espion` tinyint(4) NOT NULL DEFAULT 0,
  `rpg_constructeur` tinyint(4) NOT NULL DEFAULT 0,
  `rpg_scientifique` tinyint(4) NOT NULL DEFAULT 0,
  `rpg_commandant` tinyint(4) NOT NULL DEFAULT 0,
  `rpg_stockeur` tinyint(4) NOT NULL DEFAULT 0,
  `rpg_defenseur` tinyint(4) NOT NULL DEFAULT 0,
  `rpg_destructeur` tinyint(4) NOT NULL DEFAULT 0,
  `rpg_general` tinyint(4) NOT NULL DEFAULT 0,
  `rpg_bunker` tinyint(4) NOT NULL DEFAULT 0,
  `rpg_raideur` tinyint(4) NOT NULL DEFAULT 0,
  `rpg_empereur` tinyint(4) NOT NULL DEFAULT 0,
  `bana` tinyint(1) NOT NULL DEFAULT 0,
  `banaday` int(11) NOT NULL DEFAULT 0,
  `hof` tinyint(1) NOT NULL DEFAULT 1,
  `spyMessagesMode` tinyint(1) NOT NULL DEFAULT 0,
  `wons` int(10) unsigned NOT NULL DEFAULT 0,
  `loos` int(10) unsigned NOT NULL DEFAULT 0,
  `draws` int(10) unsigned NOT NULL DEFAULT 0,
  `kbmetal` double(50,0) unsigned NOT NULL DEFAULT 0,
  `kbcrystal` double(50,0) unsigned NOT NULL DEFAULT 0,
  `lostunits` double(50,0) unsigned NOT NULL DEFAULT 0,
  `desunits` double(50,0) unsigned NOT NULL DEFAULT 0,
  `uctime` int(11) NOT NULL DEFAULT 0,
  `setmail` int(11) NOT NULL DEFAULT 0,
  `dm_attack` int(11) NOT NULL DEFAULT 0,
  `dm_defensive` int(11) NOT NULL DEFAULT 0,
  `dm_buildtime` int(11) NOT NULL DEFAULT 0,
  `dm_researchtime` int(11) NOT NULL DEFAULT 0,
  `dm_resource` int(11) NOT NULL DEFAULT 0,
  `dm_energie` int(11) NOT NULL DEFAULT 0,
  `dm_fleettime` int(11) NOT NULL DEFAULT 0,
  `ref_id` int(11) NOT NULL DEFAULT 0,
  `ref_bonus` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `inactive_mail` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `is_bot` int(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `authlevel` (`authlevel`),
  KEY `ref_bonus` (`ref_bonus`),
  KEY `universe` (`universe`,`username`,`password`,`onlinetime`,`authlevel`),
  KEY `ally_id` (`ally_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- %PREFIX%users: 0 rows
/*!40000 ALTER TABLE `%PREFIX%users` DISABLE KEYS */;
/*!40000 ALTER TABLE `%PREFIX%users` ENABLE KEYS */;

-- %PREFIX%users_to_acs
CREATE TABLE IF NOT EXISTS `%PREFIX%users_to_acs` (
  `userID` int(10) unsigned NOT NULL,
  `acsID` int(10) unsigned NOT NULL,
  KEY `userID` (`userID`),
  KEY `acsID` (`acsID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- %PREFIX%users_to_acs: 0 rows
/*!40000 ALTER TABLE `%PREFIX%users_to_acs` DISABLE KEYS */;
/*!40000 ALTER TABLE `%PREFIX%users_to_acs` ENABLE KEYS */;

-- %PREFIX%users_to_extauth
CREATE TABLE IF NOT EXISTS `%PREFIX%users_to_extauth` (
  `id` int(11) NOT NULL,
  `account` varchar(64) NOT NULL,
  `mode` varchar(32) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`),
  KEY `account` (`account`,`mode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- %PREFIX%users_to_extauth: 0 rows
/*!40000 ALTER TABLE `%PREFIX%users_to_extauth` DISABLE KEYS */;
/*!40000 ALTER TABLE `%PREFIX%users_to_extauth` ENABLE KEYS */;

-- %PREFIX%users_to_topkb
CREATE TABLE IF NOT EXISTS `%PREFIX%users_to_topkb` (
  `rid` varchar(32) NOT NULL,
  `uid` int(11) NOT NULL,
  `username` varchar(128) NOT NULL,
  `role` tinyint(1) NOT NULL,
  KEY `rid` (`rid`,`role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- %PREFIX%users_to_topkb: 0 rows
/*!40000 ALTER TABLE `%PREFIX%users_to_topkb` DISABLE KEYS */;
/*!40000 ALTER TABLE `%PREFIX%users_to_topkb` ENABLE KEYS */;

-- %PREFIX%users_valid
CREATE TABLE IF NOT EXISTS `%PREFIX%users_valid` (
  `validationID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `userName` varchar(64) NOT NULL,
  `validationKey` varchar(32) NOT NULL,
  `password` varchar(60) NOT NULL,
  `email` varchar(64) NOT NULL,
  `date` int(11) NOT NULL,
  `ip` varchar(40) NOT NULL,
  `language` varchar(3) NOT NULL,
  `universe` tinyint(3) unsigned NOT NULL,
  `referralID` int(11) DEFAULT NULL,
  `externalAuthUID` varchar(128) DEFAULT NULL,
  `externalAuthMethod` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`validationID`,`validationKey`)
) ENGINE=InnoDB AUTO_INCREMENT=651 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- %PREFIX%users_valid: 2 rows
/*!40000 ALTER TABLE `%PREFIX%users_valid` DISABLE KEYS */;
INSERT INTO `%PREFIX%users_valid` (`validationID`, `userName`, `validationKey`, `password`, `email`, `date`, `ip`, `language`, `universe`, `referralID`, `externalAuthUID`, `externalAuthMethod`) VALUES
	(49, 'yoelsanchez', 'a585056670b18ade8c3c665f5cb1944f', '$2a$09$hpMKvOlBaYxreVj4dITRLO0qBAvt3BbSMPYAKV0tqRxV3Qeuu5mY6', 'yoelsanchezmartinez756@gmail.com', 1682012109, '152.206.213.145', 'es', 1, 0, '0', ''),
	(491, 'Lyon9704.', 'd498f1956757a248f10bae6f9a38373b', '$2a$09$hpMKvOlBaYxreVj4dITRLOTQyk0bXFgWvlp06S1nduZ/VDUiSJoY.', 'paguacell02@gmail.com', 1724111870, '152.206.233.212', 'es', 1, 0, '0', '');
/*!40000 ALTER TABLE `%PREFIX%users_valid` ENABLE KEYS */;

-- %PREFIX%vars
CREATE TABLE IF NOT EXISTS `%PREFIX%vars` (
  `elementID` smallint(5) unsigned NOT NULL,
  `name` varchar(32) NOT NULL,
  `class` int(11) NOT NULL,
  `onPlanetType` set('1','3') NOT NULL,
  `onePerPlanet` tinyint(4) NOT NULL,
  `factor` float(4,2) NOT NULL,
  `maxLevel` int(11) DEFAULT NULL,
  `cost901` bigint(20) unsigned NOT NULL DEFAULT 0,
  `cost902` bigint(20) unsigned NOT NULL DEFAULT 0,
  `cost903` bigint(20) unsigned NOT NULL DEFAULT 0,
  `cost911` bigint(20) unsigned NOT NULL DEFAULT 0,
  `cost921` bigint(20) unsigned NOT NULL DEFAULT 0,
  `consumption1` int(10) unsigned DEFAULT NULL,
  `consumption2` int(10) unsigned DEFAULT NULL,
  `speedTech` int(10) unsigned DEFAULT NULL,
  `speed1` int(10) unsigned DEFAULT NULL,
  `speed2` int(10) unsigned DEFAULT NULL,
  `speed2Tech` int(10) unsigned DEFAULT NULL,
  `speed2onLevel` int(10) unsigned DEFAULT NULL,
  `speed3Tech` int(10) unsigned DEFAULT NULL,
  `speed3onLevel` int(10) unsigned DEFAULT NULL,
  `capacity` int(10) unsigned DEFAULT NULL,
  `attack` int(10) unsigned DEFAULT NULL,
  `defend` int(10) unsigned DEFAULT NULL,
  `timeBonus` int(10) unsigned DEFAULT NULL,
  `bonusAttack` float(4,2) NOT NULL DEFAULT 0.00,
  `bonusDefensive` float(4,2) NOT NULL DEFAULT 0.00,
  `bonusShield` float(4,2) NOT NULL DEFAULT 0.00,
  `bonusBuildTime` float(4,2) NOT NULL DEFAULT 0.00,
  `bonusResearchTime` float(4,2) NOT NULL DEFAULT 0.00,
  `bonusShipTime` float(4,2) NOT NULL DEFAULT 0.00,
  `bonusDefensiveTime` float(4,2) NOT NULL DEFAULT 0.00,
  `bonusResource` float(4,2) NOT NULL DEFAULT 0.00,
  `bonusEnergy` float(4,2) NOT NULL DEFAULT 0.00,
  `bonusResourceStorage` float(4,2) NOT NULL DEFAULT 0.00,
  `bonusShipStorage` float(4,2) NOT NULL DEFAULT 0.00,
  `bonusFlyTime` float(4,2) NOT NULL DEFAULT 0.00,
  `bonusFleetSlots` float(4,2) NOT NULL DEFAULT 0.00,
  `bonusPlanets` float(4,2) NOT NULL DEFAULT 0.00,
  `bonusSpyPower` float(4,2) NOT NULL DEFAULT 0.00,
  `bonusExpedition` float(4,2) NOT NULL DEFAULT 0.00,
  `bonusGateCoolTime` float(4,2) NOT NULL DEFAULT 0.00,
  `bonusMoreFound` float(4,2) NOT NULL DEFAULT 0.00,
  `bonusAttackUnit` smallint(6) NOT NULL DEFAULT 0,
  `bonusDefensiveUnit` smallint(6) NOT NULL DEFAULT 0,
  `bonusShieldUnit` smallint(6) NOT NULL DEFAULT 0,
  `bonusBuildTimeUnit` smallint(6) NOT NULL DEFAULT 0,
  `bonusResearchTimeUnit` smallint(6) NOT NULL DEFAULT 0,
  `bonusShipTimeUnit` smallint(6) NOT NULL DEFAULT 0,
  `bonusDefensiveTimeUnit` smallint(6) NOT NULL DEFAULT 0,
  `bonusResourceUnit` smallint(6) NOT NULL DEFAULT 0,
  `bonusEnergyUnit` smallint(6) NOT NULL DEFAULT 0,
  `bonusResourceStorageUnit` smallint(6) NOT NULL DEFAULT 0,
  `bonusShipStorageUnit` smallint(6) NOT NULL DEFAULT 0,
  `bonusFlyTimeUnit` smallint(6) NOT NULL DEFAULT 0,
  `bonusFleetSlotsUnit` smallint(6) NOT NULL DEFAULT 0,
  `bonusPlanetsUnit` smallint(6) NOT NULL DEFAULT 0,
  `bonusSpyPowerUnit` smallint(6) NOT NULL DEFAULT 0,
  `bonusExpeditionUnit` smallint(6) NOT NULL DEFAULT 0,
  `bonusGateCoolTimeUnit` smallint(6) NOT NULL DEFAULT 0,
  `bonusMoreFoundUnit` smallint(6) NOT NULL DEFAULT 0,
  `speedFleetFactor` float(4,2) DEFAULT NULL,
  `production901` varchar(255) DEFAULT NULL,
  `production902` varchar(255) DEFAULT NULL,
  `production903` varchar(255) DEFAULT NULL,
  `production911` varchar(255) DEFAULT NULL,
  `production921` varchar(255) DEFAULT NULL,
  `storage901` varchar(255) DEFAULT NULL,
  `storage902` varchar(255) DEFAULT NULL,
  `storage903` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`elementID`),
  KEY `class` (`class`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- %PREFIX%vars: 92 rows
/*!40000 ALTER TABLE `%PREFIX%vars` DISABLE KEYS */;
INSERT INTO `%PREFIX%vars` (`elementID`, `name`, `class`, `onPlanetType`, `onePerPlanet`, `factor`, `maxLevel`, `cost901`, `cost902`, `cost903`, `cost911`, `cost921`, `consumption1`, `consumption2`, `speedTech`, `speed1`, `speed2`, `speed2Tech`, `speed2onLevel`, `speed3Tech`, `speed3onLevel`, `capacity`, `attack`, `defend`, `timeBonus`, `bonusAttack`, `bonusDefensive`, `bonusShield`, `bonusBuildTime`, `bonusResearchTime`, `bonusShipTime`, `bonusDefensiveTime`, `bonusResource`, `bonusEnergy`, `bonusResourceStorage`, `bonusShipStorage`, `bonusFlyTime`, `bonusFleetSlots`, `bonusPlanets`, `bonusSpyPower`, `bonusExpedition`, `bonusGateCoolTime`, `bonusMoreFound`, `bonusAttackUnit`, `bonusDefensiveUnit`, `bonusShieldUnit`, `bonusBuildTimeUnit`, `bonusResearchTimeUnit`, `bonusShipTimeUnit`, `bonusDefensiveTimeUnit`, `bonusResourceUnit`, `bonusEnergyUnit`, `bonusResourceStorageUnit`, `bonusShipStorageUnit`, `bonusFlyTimeUnit`, `bonusFleetSlotsUnit`, `bonusPlanetsUnit`, `bonusSpyPowerUnit`, `bonusExpeditionUnit`, `bonusGateCoolTimeUnit`, `bonusMoreFoundUnit`, `speedFleetFactor`, `production901`, `production902`, `production903`, `production911`, `production921`, `storage901`, `storage902`, `storage903`) VALUES
	(1, 'metal_mine', 0, '1', 0, 1.50, 255, 60, 15, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, '(30 * $BuildLevel * pow((1.1), $BuildLevel)) * (0.1 * $BuildLevelFactor)', NULL, NULL, '-(10 * $BuildLevel * pow((1.1), $BuildLevel)) * (0.1 * $BuildLevelFactor)', NULL, NULL, NULL, NULL),
	(2, 'crystal_mine', 0, '1', 0, 1.50, 255, 48, 24, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, '(20 * $BuildLevel * pow((1.1), $BuildLevel)) * (0.1 * $BuildLevelFactor)', NULL, '-(10 * $BuildLevel * pow((1.1), $BuildLevel)) * (0.1 * $BuildLevelFactor);', NULL, NULL, NULL, NULL),
	(3, 'deuterium_sintetizer', 0, '1', 0, 1.50, 255, 225, 75, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, '(10 * $BuildLevel * pow((1.1), $BuildLevel) * (-0.002 * $BuildTemp + 1.28) * (0.1 * $BuildLevelFactor))', '- (30 * $BuildLevel * pow((1.1), $BuildLevel)) * (0.1 * $BuildLevelFactor)', NULL, NULL, NULL, NULL),
	(4, 'solar_plant', 0, '1', 0, 1.50, 255, 75, 30, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, '(20 * $BuildLevel * pow((1.1), $BuildLevel)) * (0.1 * $BuildLevelFactor)', NULL, NULL, NULL, NULL),
	(6, 'university', 0, '1', 0, 2.00, 255, 100000000, 50000000, 25000000, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(12, 'fusion_plant', 0, '1', 0, 2.00, 255, 900, 360, 180, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, '- (10 * $BuildLevel * pow(1.1,$BuildLevel) * (0.1 * $BuildLevelFactor))', '(30 * $BuildLevel * pow((1.05 + $BuildEnergy * 0.01), $BuildLevel)) * (0.1 * $BuildLevelFactor)', NULL, NULL, NULL, NULL),
	(14, 'robot_factory', 0, '1,3', 0, 2.00, 255, 400, 120, 200, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(15, 'nano_factory', 0, '1', 0, 2.00, 255, 1000000, 500000, 100000, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(21, 'hangar', 0, '1,3', 0, 2.00, 255, 400, 200, 100, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(22, 'metal_store', 0, '1,3', 0, 2.00, 255, 2000, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, 'floor(2.5 * pow(1.8331954764, $BuildLevel)) * 5000', NULL, NULL),
	(23, 'crystal_store', 0, '1,3', 0, 2.00, 255, 2000, 1000, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'floor(2.5 * pow(1.8331954764, $BuildLevel)) * 5000', NULL),
	(24, 'deuterium_store', 0, '1,3', 0, 2.00, 255, 2000, 2000, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'floor(2.5 * pow(1.8331954764, $BuildLevel)) * 5000'),
	(31, 'laboratory', 0, '1', 0, 2.00, 255, 200, 400, 200, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(33, 'terraformer', 0, '1', 0, 2.00, 255, 0, 50000, 100000, 1000, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(34, 'ally_deposit', 0, '1', 0, 2.00, 255, 20000, 40000, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(41, 'mondbasis', 0, '3', 0, 2.00, 255, 20000, 40000, 20000, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(42, 'phalanx', 0, '3', 0, 2.00, 255, 20000, 40000, 20000, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(43, 'sprungtor', 0, '3', 0, 2.00, 255, 2000000, 4000000, 2000000, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(44, 'silo', 0, '1', 0, 2.00, 255, 20000, 20000, 1000, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(106, 'spy_tech', 100, '1,3', 0, 2.00, 255, 200, 1000, 200, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(108, 'computer_tech', 100, '1,3', 0, 2.00, 255, 0, 400, 600, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(109, 'military_tech', 100, '1,3', 0, 2.00, 255, 800, 200, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(110, 'defence_tech', 100, '1,3', 0, 2.00, 255, 200, 600, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(111, 'shield_tech', 100, '1,3', 0, 2.00, 255, 1000, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(113, 'energy_tech', 100, '1,3', 0, 2.00, 255, 0, 800, 400, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(114, 'hyperspace_tech', 100, '1,3', 0, 2.00, 255, 0, 4000, 2000, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(115, 'combustion_tech', 100, '1,3', 0, 2.00, 255, 400, 0, 600, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(117, 'impulse_motor_tech', 100, '1,3', 0, 2.00, 255, 2000, 4000, 600, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(118, 'hyperspace_motor_tech', 100, '1,3', 0, 2.00, 255, 10000, 20000, 6000, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(120, 'laser_tech', 100, '1,3', 0, 2.00, 255, 200, 100, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(121, 'ionic_tech', 100, '1,3', 0, 2.00, 255, 1000, 300, 100, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(122, 'buster_tech', 100, '1,3', 0, 2.00, 255, 2000, 4000, 1000, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(123, 'intergalactic_tech', 100, '1,3', 0, 2.00, 255, 240000, 400000, 160000, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(124, 'expedition_tech', 100, '1,3', 0, 1.75, 255, 4000, 8000, 4000, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(131, 'metal_proc_tech', 100, '1,3', 0, 2.00, 255, 750, 500, 250, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(132, 'crystal_proc_tech', 100, '1,3', 0, 2.00, 255, 1000, 750, 500, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(133, 'deuterium_proc_tech', 100, '1,3', 0, 2.00, 255, 1250, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(199, 'graviton_tech', 100, '1,3', 0, 3.00, 255, 0, 0, 0, 300000, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(202, 'small_ship_cargo', 200, '1,3', 0, 1.00, NULL, 2000, 2000, 0, 0, 0, 10, 20, 4, 5000, 10000, NULL, NULL, NULL, NULL, 5000, 5, 10, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(203, 'big_ship_cargo', 200, '1,3', 0, 1.00, NULL, 6000, 6000, 0, 0, 0, 50, 50, 1, 7500, 7500, NULL, NULL, NULL, NULL, 25000, 5, 25, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(204, 'light_hunter', 200, '1,3', 0, 1.00, NULL, 3000, 1000, 0, 0, 0, 20, 20, 1, 12500, 12500, NULL, NULL, NULL, NULL, 50, 50, 10, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(205, 'heavy_hunter', 200, '1,3', 0, 1.00, NULL, 6000, 4000, 0, 0, 0, 75, 75, 2, 10000, 15000, NULL, NULL, NULL, NULL, 100, 150, 25, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(206, 'crusher', 200, '1,3', 0, 1.00, NULL, 20000, 7000, 2000, 0, 0, 300, 300, 2, 15000, 15000, NULL, NULL, NULL, NULL, 800, 400, 50, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(207, 'battle_ship', 200, '1,3', 0, 1.00, NULL, 45000, 15000, 0, 0, 0, 250, 250, 3, 10000, 10000, NULL, NULL, NULL, NULL, 1500, 1000, 200, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(208, 'colonizer', 200, '1,3', 0, 1.00, NULL, 10000, 20000, 10000, 0, 0, 1000, 1000, 2, 2500, 2500, NULL, NULL, NULL, NULL, 7500, 50, 100, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(209, 'recycler', 200, '1,3', 0, 1.00, NULL, 10000, 6000, 2000, 0, 0, 300, 300, 1, 2000, 2000, NULL, NULL, NULL, NULL, 20000, 1, 10, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(210, 'spy_sonde', 200, '1,3', 0, 1.00, NULL, 0, 1000, 0, 0, 0, 1, 1, 1, 100000000, 100000000, NULL, NULL, NULL, NULL, 5, 0, 0, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(211, 'bomber_ship', 200, '1,3', 0, 1.00, NULL, 50000, 25000, 15000, 0, 0, 1000, 1000, 5, 4000, 5000, NULL, NULL, NULL, NULL, 500, 1000, 500, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(212, 'solar_satelit', 200, '1,3', 0, 1.00, NULL, 0, 2000, 500, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, '((($BuildTemp + 160) / 6) * (0.1 * $BuildLevelFactor) * $BuildLevel)', NULL, NULL, NULL, NULL),
	(213, 'destructor', 200, '1,3', 0, 1.00, NULL, 60000, 50000, 15000, 0, 0, 1000, 1000, 3, 5000, 5000, NULL, NULL, NULL, NULL, 2000, 2000, 500, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(214, 'dearth_star', 200, '1,3', 0, 1.00, NULL, 5000000, 4000000, 1000000, 0, 0, 1, 1, 3, 200, 200, NULL, NULL, NULL, NULL, 1000000, 200000, 50000, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(215, 'battleship', 200, '1,3', 0, 1.00, NULL, 30000, 40000, 15000, 0, 0, 250, 250, 3, 10000, 10000, NULL, NULL, NULL, NULL, 750, 700, 400, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(216, 'lune_noir', 200, '1,3', 0, 1.00, NULL, 8000000, 2000000, 1500000, 0, 0, 250, 250, 3, 900, 900, NULL, NULL, NULL, NULL, 15000000, 150000, 70000, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(217, 'ev_transporter', 200, '1,3', 0, 1.00, NULL, 35000, 20000, 1500, 0, 0, 90, 90, 3, 6000, 6000, NULL, NULL, NULL, NULL, 400000000, 50, 120, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(218, 'star_crasher', 200, '1,3', 0, 1.00, NULL, 275000000, 130000000, 60000000, 0, 0, 10000, 10000, 3, 10, 10, NULL, NULL, NULL, NULL, 50000000, 35000000, 2000000, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(219, 'giga_recykler', 200, '1,3', 0, 1.00, NULL, 1000000, 600000, 200000, 0, 0, 300, 300, 3, 7500, 7500, NULL, NULL, NULL, NULL, 200000000, 1, 1000, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(220, 'dm_ship', 200, '1,3', 0, 1.00, NULL, 6000000, 7000000, 3000000, 0, 0, 100000, 100000, 3, 100, 100, NULL, NULL, NULL, NULL, 6000000, 5, 50000, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(401, 'misil_launcher', 400, '1,3', 0, 1.00, NULL, 2000, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 80, 20, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(402, 'small_laser', 400, '1,3', 0, 1.00, NULL, 1500, 500, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 100, 25, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(403, 'big_laser', 400, '1,3', 0, 1.00, NULL, 6000, 2000, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 250, 100, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(404, 'gauss_canyon', 400, '1,3', 0, 1.00, NULL, 20000, 15000, 2000, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1100, 200, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(405, 'ionic_canyon', 400, '1,3', 0, 1.00, NULL, 2000, 6000, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 150, 500, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(406, 'buster_canyon', 400, '1,3', 0, 1.00, NULL, 50000, 50000, 30000, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 3000, 300, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(407, 'small_protection_shield', 400, '1,3', 1, 1.00, NULL, 10000, 10000, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 2000, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(408, 'big_protection_shield', 400, '1,3', 1, 1.00, NULL, 50000, 50000, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 10000, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(409, 'planet_protector', 400, '1,3', 1, 1.00, NULL, 10000000, 5000000, 2500000, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1000000, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(410, 'graviton_canyon', 400, '1,3', 0, 1.00, NULL, 15000000, 15000000, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 500000, 80000, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(411, 'orbital_station', 400, '1,3', 1, 1.00, NULL, 5000000000, 2000000000, 500000000, 1000000, 10000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 400000000, 2000000000, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(502, 'interceptor_misil', 500, '1,3', 0, 1.00, NULL, 8000, 0, 2000, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(503, 'interplanetary_misil', 500, '1,3', 0, 1.00, NULL, 12500, 2500, 10000, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 12000, 1, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(601, 'rpg_geologue', 600, '1,3', 0, 1.00, 20, 0, 0, 0, 0, 1000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.05, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(602, 'rpg_amiral', 600, '1,3', 0, 1.00, 20, 0, 0, 0, 0, 1000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.05, 0.05, 0.05, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(603, 'rpg_ingenieur', 600, '1,3', 0, 1.00, 10, 0, 0, 0, 0, 1000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.05, 0.05, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.05, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(604, 'rpg_technocrate', 600, '1,3', 0, 1.00, 10, 0, 0, 0, 0, 1000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, -0.05, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(605, 'rpg_constructeur', 600, '1,3', 0, 1.00, 3, 0, 0, 0, 0, 1000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, -0.10, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(606, 'rpg_scientifique', 600, '1,3', 0, 1.00, 3, 0, 0, 0, 0, 1000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, -0.10, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(607, 'rpg_stockeur', 600, '1,3', 0, 1.00, 2, 0, 0, 0, 0, 1000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.50, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(608, 'rpg_defenseur', 600, '1,3', 0, 1.00, 2, 0, 0, 0, 0, 1000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, -0.25, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(609, 'rpg_bunker', 600, '1,3', 0, 1.00, 1, 0, 0, 0, 0, 1000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(610, 'rpg_espion', 600, '1,3', 0, 1.00, 2, 0, 0, 0, 0, 1000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.35, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(611, 'rpg_commandant', 600, '1,3', 0, 1.00, 3, 0, 0, 0, 0, 1000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 3.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(612, 'rpg_destructeur', 600, '1,3', 0, 1.00, 1, 0, 0, 0, 0, 1000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(613, 'rpg_general', 600, '1,3', 0, 1.00, 3, 0, 0, 0, 0, 1000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, -0.10, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(614, 'rpg_raideur', 600, '1,3', 0, 1.00, 1, 0, 0, 0, 0, 1000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(615, 'rpg_empereur', 600, '1,3', 0, 1.00, 1, 0, 0, 0, 0, 1000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 2.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(701, 'dm_attack', 700, '1,3', 0, 1.00, NULL, 0, 0, 0, 0, 1500, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 86400, 0.10, 0.10, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(702, 'dm_defensive', 700, '1,3', 0, 1.00, NULL, 0, 0, 0, 0, 1500, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 86400, 0.00, 0.00, 0.10, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(703, 'dm_buildtime', 700, '1,3', 0, 1.00, NULL, 0, 0, 0, 0, 750, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 86400, 0.00, 0.00, 0.00, -0.10, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(704, 'dm_resource', 700, '1,3', 0, 1.00, NULL, 0, 0, 0, 0, 2500, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 86400, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.10, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(705, 'dm_energie', 700, '1,3', 0, 1.00, NULL, 0, 0, 0, 0, 2000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 86400, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.10, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(706, 'dm_researchtime', 700, '1,3', 0, 1.00, NULL, 0, 0, 0, 0, 1250, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 86400, 0.00, 0.00, 0.00, 0.00, -0.10, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(707, 'dm_fleettime', 700, '1,3', 0, 1.00, NULL, 0, 0, 0, 0, 3000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 86400, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, -0.10, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
/*!40000 ALTER TABLE `%PREFIX%vars` ENABLE KEYS */;

-- %PREFIX%vars_rapidfire
CREATE TABLE IF NOT EXISTS `%PREFIX%vars_rapidfire` (
  `elementID` int(11) NOT NULL,
  `rapidfireID` int(11) NOT NULL,
  `shoots` int(11) NOT NULL,
  KEY `elementID` (`elementID`),
  KEY `rapidfireID` (`rapidfireID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- %PREFIX%vars_rapidfire: 97 rows
/*!40000 ALTER TABLE `%PREFIX%vars_rapidfire` DISABLE KEYS */;
INSERT INTO `%PREFIX%vars_rapidfire` (`elementID`, `rapidfireID`, `shoots`) VALUES
	(202, 210, 5),
	(202, 212, 5),
	(203, 210, 5),
	(203, 212, 5),
	(204, 210, 5),
	(204, 212, 5),
	(205, 202, 3),
	(205, 210, 5),
	(205, 212, 5),
	(206, 204, 6),
	(206, 401, 10),
	(206, 210, 5),
	(206, 212, 5),
	(207, 210, 5),
	(207, 212, 5),
	(208, 210, 5),
	(208, 212, 5),
	(209, 210, 5),
	(209, 212, 5),
	(211, 210, 5),
	(211, 212, 5),
	(211, 401, 20),
	(211, 402, 20),
	(211, 403, 10),
	(211, 405, 10),
	(213, 210, 5),
	(213, 212, 5),
	(213, 215, 2),
	(213, 402, 10),
	(214, 210, 1250),
	(214, 212, 1250),
	(214, 202, 250),
	(214, 203, 250),
	(214, 208, 250),
	(214, 209, 250),
	(214, 204, 200),
	(214, 205, 100),
	(214, 206, 33),
	(214, 207, 30),
	(214, 211, 25),
	(214, 215, 15),
	(214, 213, 5),
	(214, 401, 200),
	(214, 402, 200),
	(214, 403, 100),
	(214, 404, 50),
	(214, 405, 100),
	(215, 202, 3),
	(215, 203, 3),
	(215, 205, 4),
	(215, 206, 4),
	(215, 207, 10),
	(215, 210, 5),
	(215, 212, 5),
	(216, 210, 1250),
	(216, 212, 1250),
	(216, 202, 250),
	(216, 203, 250),
	(216, 204, 200),
	(216, 205, 100),
	(216, 206, 33),
	(216, 207, 30),
	(216, 208, 250),
	(216, 209, 250),
	(216, 211, 25),
	(216, 213, 5),
	(216, 214, 1),
	(216, 215, 15),
	(216, 401, 400),
	(216, 402, 200),
	(216, 403, 100),
	(216, 404, 50),
	(216, 405, 100),
	(217, 210, 5),
	(217, 212, 5),
	(218, 210, 1250),
	(218, 212, 1250),
	(218, 202, 250),
	(218, 203, 250),
	(218, 204, 200),
	(218, 205, 100),
	(218, 206, 33),
	(218, 207, 30),
	(218, 208, 250),
	(218, 209, 250),
	(218, 211, 25),
	(218, 213, 5),
	(218, 215, 15),
	(218, 401, 400),
	(218, 402, 200),
	(218, 403, 100),
	(218, 404, 50),
	(218, 405, 100),
	(219, 210, 5),
	(219, 212, 5),
	(220, 210, 5),
	(220, 212, 5);
/*!40000 ALTER TABLE `%PREFIX%vars_rapidfire` ENABLE KEYS */;

-- %PREFIX%vars_requriements
CREATE TABLE IF NOT EXISTS `%PREFIX%vars_requriements` (
  `elementID` int(11) NOT NULL,
  `requireID` int(11) NOT NULL,
  `requireLevel` int(11) NOT NULL,
  KEY `elementID` (`elementID`),
  KEY `requireID` (`requireID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- %PREFIX%vars_requriements: 184 rows
/*!40000 ALTER TABLE `%PREFIX%vars_requriements` DISABLE KEYS */;
INSERT INTO `%PREFIX%vars_requriements` (`elementID`, `requireID`, `requireLevel`) VALUES
	(6, 14, 20),
	(6, 31, 22),
	(6, 15, 4),
	(6, 108, 12),
	(6, 123, 3),
	(12, 3, 5),
	(12, 113, 3),
	(15, 14, 10),
	(15, 108, 10),
	(21, 14, 2),
	(33, 15, 1),
	(33, 113, 12),
	(42, 41, 1),
	(43, 41, 1),
	(43, 114, 7),
	(44, 21, 1),
	(106, 31, 3),
	(108, 31, 1),
	(109, 31, 4),
	(110, 113, 3),
	(110, 31, 6),
	(111, 31, 2),
	(113, 31, 1),
	(114, 113, 5),
	(114, 110, 5),
	(114, 31, 7),
	(115, 113, 1),
	(115, 31, 1),
	(117, 113, 1),
	(117, 31, 2),
	(118, 114, 3),
	(118, 31, 7),
	(120, 31, 1),
	(120, 113, 2),
	(121, 31, 4),
	(121, 120, 5),
	(121, 113, 4),
	(122, 31, 5),
	(122, 113, 8),
	(122, 120, 10),
	(122, 121, 5),
	(123, 31, 10),
	(123, 108, 8),
	(123, 114, 8),
	(124, 106, 3),
	(124, 117, 3),
	(124, 31, 3),
	(131, 31, 8),
	(131, 113, 5),
	(132, 31, 8),
	(132, 113, 5),
	(133, 31, 8),
	(133, 113, 5),
	(199, 31, 12),
	(202, 21, 2),
	(202, 115, 2),
	(203, 21, 4),
	(203, 115, 6),
	(204, 21, 1),
	(204, 115, 1),
	(205, 21, 3),
	(205, 111, 2),
	(205, 117, 2),
	(206, 21, 5),
	(206, 117, 4),
	(206, 121, 2),
	(207, 21, 7),
	(207, 118, 4),
	(208, 21, 4),
	(208, 117, 3),
	(209, 21, 4),
	(209, 115, 6),
	(209, 110, 2),
	(210, 21, 3),
	(210, 115, 3),
	(210, 106, 2),
	(211, 117, 6),
	(211, 21, 8),
	(211, 122, 5),
	(212, 21, 1),
	(213, 21, 9),
	(213, 118, 6),
	(213, 114, 5),
	(214, 21, 12),
	(214, 118, 7),
	(214, 114, 6),
	(214, 199, 1),
	(215, 114, 5),
	(215, 120, 12),
	(215, 118, 5),
	(215, 21, 8),
	(216, 106, 12),
	(216, 21, 15),
	(216, 109, 14),
	(216, 110, 14),
	(216, 111, 15),
	(216, 114, 10),
	(216, 120, 20),
	(216, 199, 3),
	(217, 111, 10),
	(217, 21, 14),
	(217, 114, 10),
	(217, 110, 14),
	(217, 117, 15),
	(218, 21, 18),
	(218, 109, 20),
	(218, 110, 20),
	(218, 111, 20),
	(218, 114, 15),
	(218, 118, 20),
	(218, 120, 25),
	(218, 199, 8),
	(219, 21, 15),
	(219, 109, 15),
	(219, 110, 15),
	(219, 111, 15),
	(219, 118, 8),
	(220, 21, 9),
	(220, 114, 5),
	(220, 118, 6),
	(401, 21, 1),
	(402, 113, 1),
	(402, 21, 2),
	(402, 120, 3),
	(403, 113, 3),
	(403, 21, 4),
	(403, 120, 6),
	(404, 21, 6),
	(404, 113, 6),
	(404, 109, 3),
	(404, 110, 1),
	(405, 21, 4),
	(405, 121, 4),
	(406, 21, 8),
	(406, 122, 7),
	(407, 110, 2),
	(407, 21, 1),
	(408, 110, 6),
	(408, 21, 6),
	(409, 609, 1),
	(410, 199, 7),
	(410, 21, 18),
	(410, 109, 20),
	(411, 199, 10),
	(411, 110, 22),
	(411, 122, 20),
	(411, 108, 15),
	(411, 111, 25),
	(411, 113, 20),
	(411, 608, 2),
	(411, 21, 20),
	(502, 44, 2),
	(502, 21, 1),
	(503, 44, 4),
	(503, 21, 1),
	(503, 117, 1),
	(603, 601, 5),
	(604, 602, 5),
	(605, 601, 10),
	(605, 603, 2),
	(606, 601, 10),
	(606, 603, 2),
	(607, 605, 1),
	(608, 606, 1),
	(609, 601, 20),
	(609, 603, 10),
	(609, 605, 3),
	(609, 606, 3),
	(609, 607, 2),
	(609, 608, 2),
	(610, 602, 10),
	(610, 604, 5),
	(611, 602, 10),
	(611, 604, 5),
	(612, 610, 1),
	(613, 611, 1),
	(614, 602, 20),
	(614, 604, 10),
	(614, 610, 2),
	(614, 611, 2),
	(614, 612, 1),
	(614, 613, 3),
	(615, 614, 1),
	(615, 609, 1);
/*!40000 ALTER TABLE `%PREFIX%vars_requriements` ENABLE KEYS */;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
