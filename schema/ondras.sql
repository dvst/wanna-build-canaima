



-- ---
-- Globals
-- ---

-- SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
-- SET FOREIGN_KEY_CHECKS=0;

-- ---
-- Table 'architectures'
-- 
-- ---

DROP TABLE IF EXISTS `architectures`;
		
CREATE TABLE `architectures` (
  `architecture` TINYINT NULL AUTO_INCREMENT DEFAULT NULL,
  PRIMARY KEY (`architecture`)
);

-- ---
-- Table 'distribution_aliases'
-- 
-- ---

DROP TABLE IF EXISTS `distribution_aliases`;
		
CREATE TABLE `distribution_aliases` (
  `distribution` TINYINT NULL DEFAULT NULL,
  `alias` TINYINT NULL DEFAULT NULL
);

-- ---
-- Table 'packages'
-- 
-- ---

DROP TABLE IF EXISTS `packages`;
		
CREATE TABLE `packages` (
  `distribution` TINYINT NULL DEFAULT NULL,
  `architecture` TINYINT NULL DEFAULT NULL,
  `version` TINYINT NULL DEFAULT NULL,
  `state` TINYINT NULL DEFAULT NULL,
  `section` TINYINT NULL DEFAULT NULL,
  `priority` TINYINT NULL DEFAULT NULL,
  `installed_version` TINYINT NULL DEFAULT NULL,
  `previous_state` TINYINT NULL DEFAULT NULL,
  `state_change` TINYINT NULL DEFAULT NULL,
  `notes` TINYINT NULL DEFAULT NULL,
  `builder` TINYINT NULL DEFAULT NULL,
  `failed` TINYINT NULL DEFAULT NULL,
  `old_failed` TINYINT NULL DEFAULT NULL,
  `binary_nmu_version` TINYINT NULL DEFAULT NULL,
  `binary_nmu_changelog` TINYINT NULL DEFAULT NULL,
  `failed_category` TINYINT NULL DEFAULT NULL,
  `permbuildpri` TINYINT NULL DEFAULT NULL,
  `package` TINYINT NULL DEFAULT NULL,
  `buildpri` TINYINT NULL DEFAULT NULL,
  `depends` TINYINT NULL DEFAULT NULL,
  `rel` TINYINT NULL DEFAULT NULL,
  `bd_problem` TINYINT NULL DEFAULT NULL,
  `extra_depends` TINYINT NULL DEFAULT NULL,
  `extra_conflicts` TINYINT NULL DEFAULT NULL,
  `build_arch_all` TINYINT NULL DEFAULT NULL,
  PRIMARY KEY (`package`)
);

-- ---
-- Table 'pkg_history'
-- 
-- ---

DROP TABLE IF EXISTS `pkg_history`;
		
CREATE TABLE `pkg_history` (
  `package` TINYINT NULL DEFAULT NULL,
  `version` TINYINT NULL DEFAULT NULL,
  `timestamp` TINYINT NULL DEFAULT NULL,
  `result` TINYINT NULL DEFAULT NULL,
  `build_time` TINYINT NULL DEFAULT NULL,
  `disk_space` TINYINT NULL DEFAULT NULL,
  `builder` TINYINT NULL DEFAULT NULL,
  `architecture` TINYINT NULL DEFAULT NULL,
  `distribution` TINYINT NULL DEFAULT NULL
);

-- ---
-- Table 'transactions'
-- 
-- ---

DROP TABLE IF EXISTS `transactions`;
		
CREATE TABLE `transactions` (
  `architecture` TINYINT NULL DEFAULT NULL,
  `package` TINYINT NULL DEFAULT NULL,
  `distribution` TINYINT NULL DEFAULT NULL,
  `version` TINYINT NULL DEFAULT NULL,
  `action` TINYINT NULL DEFAULT NULL,
  `prevstate` TINYINT NULL DEFAULT NULL,
  `state` TINYINT NULL DEFAULT NULL,
  `real_user` TINYINT NULL DEFAULT NULL,
  `set_user` TINYINT NULL DEFAULT NULL,
  `time` TINYINT NULL DEFAULT NULL
);

-- ---
-- Table 'users'
-- 
-- ---

DROP TABLE IF EXISTS `users`;
		
CREATE TABLE `users` (
  `username` TINYINT NULL DEFAULT NULL,
  `architecture` TINYINT NULL DEFAULT NULL,
  `distribution` TINYINT NULL DEFAULT NULL,
  `last_seen` TINYINT NULL DEFAULT NULL
);

-- ---
-- Table 'distributions'
-- 
-- ---

DROP TABLE IF EXISTS `distributions`;
		
CREATE TABLE `distributions` (
  `distribution` TINYINT NULL DEFAULT NULL,
  `public` TINYINT NULL DEFAULT NULL,
  `sort_order` TINYINT NULL DEFAULT NULL,
  `auto_dep_wait` TINYINT NULL DEFAULT NULL,
  `build_dep_resolver` TINYINT NULL DEFAULT NULL,
  `archive` TINYINT NULL DEFAULT NULL,
  `suppress_succesful_logs` TINYINT NULL DEFAULT NULL,
  PRIMARY KEY (`distribution`)
);

-- ---
-- Table 'distribution_architectures'
-- 
-- ---

DROP TABLE IF EXISTS `distribution_architectures`;
		
CREATE TABLE `distribution_architectures` (
  `architecture` TINYINT NULL DEFAULT NULL,
  `distribution` TINYINT NULL DEFAULT NULL
);

-- ---
-- Table 'locks'
-- 
-- ---

DROP TABLE IF EXISTS `locks`;
		
CREATE TABLE `locks` (
  `architecture` TINYINT NULL DEFAULT NULL,
  `distribution` TINYINT NULL DEFAULT NULL,
  PRIMARY KEY (),
KEY ()
);

-- ---
-- Table 'priorities'
-- 
-- ---

DROP TABLE IF EXISTS `priorities`;
		
CREATE TABLE `priorities` (
  `type` TINYINT NULL AUTO_INCREMENT DEFAULT NULL,
  `value` TINYINT NULL DEFAULT NULL,
  `priority` TINYINT NULL DEFAULT NULL
);

-- ---
-- Foreign Keys 
-- ---

ALTER TABLE `distribution_aliases` ADD FOREIGN KEY (distribution) REFERENCES `distributions` (`distribution`);
ALTER TABLE `packages` ADD FOREIGN KEY (architecture) REFERENCES `architectures` (`architecture`);
ALTER TABLE `pkg_history` ADD FOREIGN KEY (architecture) REFERENCES `architectures` (`architecture`);
ALTER TABLE `pkg_history` ADD FOREIGN KEY (distribution) REFERENCES `distributions` (`distribution`);
ALTER TABLE `transactions` ADD FOREIGN KEY (architecture) REFERENCES `architectures` (`architecture`);
ALTER TABLE `transactions` ADD FOREIGN KEY (package) REFERENCES `packages` (`package`);
ALTER TABLE `transactions` ADD FOREIGN KEY (distribution) REFERENCES `distributions` (`distribution`);
ALTER TABLE `users` ADD FOREIGN KEY (architecture) REFERENCES `architectures` (`architecture`);
ALTER TABLE `users` ADD FOREIGN KEY (distribution) REFERENCES `distributions` (`distribution`);
ALTER TABLE `distribution_architectures` ADD FOREIGN KEY (architecture) REFERENCES `architectures` (`architecture`);
ALTER TABLE `distribution_architectures` ADD FOREIGN KEY (distribution) REFERENCES `distributions` (`distribution`);
ALTER TABLE `locks` ADD FOREIGN KEY (architecture) REFERENCES `architectures` (`architecture`);
ALTER TABLE `locks` ADD FOREIGN KEY (distribution) REFERENCES `distributions` (`distribution`);

-- ---
-- Table Properties
-- ---

-- ALTER TABLE `architectures` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `distribution_aliases` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `packages` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `pkg_history` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `transactions` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `users` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `distributions` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `distribution_architectures` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `locks` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `priorities` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ---
-- Test Data
-- ---

-- INSERT INTO `architectures` (`architecture`) VALUES
-- ('');
-- INSERT INTO `distribution_aliases` (`distribution`,`alias`) VALUES
-- ('','');
-- INSERT INTO `packages` (`distribution`,`architecture`,`version`,`state`,`section`,`priority`,`installed_version`,`previous_state`,`state_change`,`notes`,`builder`,`failed`,`old_failed`,`binary_nmu_version`,`binary_nmu_changelog`,`failed_category`,`permbuildpri`,`package`,`buildpri`,`depends`,`rel`,`bd_problem`,`extra_depends`,`extra_conflicts`,`build_arch_all`) VALUES
-- ('','','','','','','','','','','','','','','','','','','','','','','','','');
-- INSERT INTO `pkg_history` (`package`,`version`,`timestamp`,`result`,`build_time`,`disk_space`,`builder`,`architecture`,`distribution`) VALUES
-- ('','','','','','','','','');
-- INSERT INTO `transactions` (`architecture`,`package`,`distribution`,`version`,`action`,`prevstate`,`state`,`real_user`,`set_user`,`time`) VALUES
-- ('','','','','','','','','','');
-- INSERT INTO `users` (`username`,`architecture`,`distribution`,`last_seen`) VALUES
-- ('','','','');
-- INSERT INTO `distributions` (`distribution`,`public`,`sort_order`,`auto_dep_wait`,`build_dep_resolver`,`archive`,`suppress_succesful_logs`) VALUES
-- ('','','','','','','');
-- INSERT INTO `distribution_architectures` (`architecture`,`distribution`) VALUES
-- ('','');
-- INSERT INTO `locks` (`architecture`,`distribution`) VALUES
-- ('','');
-- INSERT INTO `priorities` (`type`,`value`,`priority`) VALUES
-- ('','','');


