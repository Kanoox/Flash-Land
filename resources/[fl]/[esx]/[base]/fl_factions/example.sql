INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUES
	('society_medellin', 'medellin', 1);

INSERT INTO `addon_inventory` (`name`, `label`, `shared`) VALUES
	('society_medellin', 'medellin', 1);

INSERT INTO `datastore` (`name`, `label`, `shared`) VALUES
	('society_medellin', 'medellin', 1);

INSERT INTO `factions` (`name`, `label`) VALUES
	('medellin', 'medellin');

INSERT INTO `faction_grades` (`faction_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
	('medellin', 0, 'pequeno', 'Pequeno', 0, '{}', '{}'),
	('medellin', 1, 'soldado', 'Soldado', 0, '{}', '{}'),
	('medellin', 2, 'commandante', 'Commandante', 0, '{}', '{}'),
	('medellin', 3, 'teniente', 'Téniente', 0, '{}', '{}'),
	('medellin', 4, 'segundo', 'Segundo', 0, '{}', '{}'),
	('medellin', 5, 'boss', 'Jéfé', 0, '{}', '{}');