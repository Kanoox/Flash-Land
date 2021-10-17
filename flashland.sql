-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost
-- Généré le : sam. 21 août 2021 à 16:57
-- Version du serveur :  10.5.8-MariaDB-1:10.5.8+maria~bionic
-- Version de PHP : 7.2.34-8+ubuntu18.04.1+deb.sury.org+1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `s5418_69life`
--

-- --------------------------------------------------------

--
-- Structure de la table `addon_account`
--

CREATE TABLE `addon_account` (
  `name` varchar(60) NOT NULL,
  `label` varchar(100) NOT NULL,
  `shared` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `addon_account`
--

INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUES
('bank_savings', 'Livret Bleu', 0),
('caution', 'Caution', 0),
('property_black_money', 'Argent Sale Propriété', 0),
('property_money', 'Argent Propriété', 0),
('society_410', '410', 1),
('society_ambulance', 'Ambulance', 1),
('society_ammunation', 'Ammunation', 1),
('society_avocat', 'Avocat', 1),
('society_bahamas', 'Bahamas', 1),
('society_ballas', 'Ballas', 1),
('society_banker', 'Banque', 1),
('society_barber', 'Coiffeur', 1),
('society_bennys', 'Benny\'s', 1),
('society_bennys_black', 'Benny\'s Argent Sale', 1),
('society_bikedealer', 'Concessionnaire Moto', 1),
('society_blackout', 'Blackout', 1),
('society_bloods', 'Bloods', 1),
('society_burgershot', 'Burgershot', 1),
('society_cafe', 'Cafe', 1),
('society_cardealer', 'Concessionnaire', 1),
('society_casino', 'Casino', 1),
('society_cholas', 'Los Cholas', 1),
('society_daymson', 'Daymson', 1),
('society_event', 'Evenementiel', 1),
('society_families', 'Families', 1),
('society_farc', 'FARC', 1),
('society_galaxy', 'Galaxy', 1),
('society_garbage', 'Eboueur', 1),
('society_gouv', 'Gouvernement', 1),
('society_greenmotors', 'GreenMotor\'s', 1),
('society_journaliste', 'Journaliste', 1),
('society_locura', 'Locura', 1),
('society_lopez', 'Lopez', 1),
('society_lost', 'Lost', 1),
('society_ltdb', 'Ltdb', 1),
('society_madrazo', 'Madrazo', 1),
('society_mannschaft', 'Mannschaft Kämpfer Zwei', 1),
('society_marabunta', 'Marabunta', 1),
('society_mechanic', 'Mécano', 1),
('society_nord', 'Nord', 1),
('society_palace', 'Palace', 1),
('society_palace_black', 'Palace Argent Sale', 1),
('society_pegorino', 'Pegorino', 1),
('society_police', 'Police', 1),
('society_realestateagent', 'Agent immobilier', 1),
('society_rebelstudio', 'Rebel Studio', 1),
('society_rebelstudio_black', 'Rebel Studio Argent Sale', 1),
('society_rosa', 'Rosanueva', 1),
('society_sheriff', 'Sheriff', 1),
('society_sixt', 'Sixt', 1),
('society_sons', 'Sons of Anarchy', 1),
('society_southside', 'Southside', 1),
('society_tabac', 'Tabac', 1),
('society_tabac_black', 'Tabac Argent Sale', 1),
('society_tailor', 'Tailleur', 1),
('society_tattoo', 'Tatoueur', 1),
('society_taxi', 'Taxi', 1),
('society_ubereats', 'Uber Eats', 1),
('society_unicorn', 'Unicorn', 1),
('society_vagos', 'Vagos', 1),
('society_vercetti', 'Vercetti', 1),
('society_vigneron', 'Vigneron', 1),
('society_vigneron_black', 'Vigneron Argent Sale', 1);

-- --------------------------------------------------------

--
-- Structure de la table `addon_account_data`
--

CREATE TABLE `addon_account_data` (
  `id` int(11) NOT NULL,
  `account_name` varchar(100) DEFAULT NULL,
  `money` int(11) NOT NULL,
  `owner` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `addon_account_data`
--

INSERT INTO `addon_account_data` (`id`, `account_name`, `money`, `owner`) VALUES
(1, 'society_410', 0, NULL),
(2, 'society_ambulance', 0, NULL),
(3, 'society_ammunation', 0, NULL),
(4, 'society_avocat', 0, NULL),
(5, 'society_bahamas', 0, NULL),
(6, 'society_ballas', 0, NULL),
(7, 'society_banker', 0, NULL),
(8, 'society_barber', 0, NULL),
(9, 'society_bennys', 0, NULL),
(10, 'society_bennys_black', 0, NULL),
(11, 'society_bikedealer', 0, NULL),
(12, 'society_blackout', 0, NULL),
(13, 'society_bloods', 0, NULL),
(14, 'society_burgershot', 0, NULL),
(15, 'society_cafe', 0, NULL),
(16, 'society_cardealer', 0, NULL),
(17, 'society_casino', 0, NULL),
(18, 'society_cholas', 0, NULL),
(19, 'society_daymson', 0, NULL),
(20, 'society_event', 0, NULL),
(21, 'society_families', 0, NULL),
(22, 'society_farc', 0, NULL),
(23, 'society_galaxy', 0, NULL),
(24, 'society_garbage', 0, NULL),
(25, 'society_gouv', 0, NULL),
(26, 'society_greenmotors', 0, NULL),
(27, 'society_journaliste', 0, NULL),
(28, 'society_locura', 0, NULL),
(29, 'society_lopez', 0, NULL),
(30, 'society_lost', 0, NULL),
(31, 'society_ltdb', 0, NULL),
(32, 'society_madrazo', 0, NULL),
(33, 'society_mannschaft', 0, NULL),
(34, 'society_marabunta', 0, NULL),
(35, 'society_mechanic', 0, NULL),
(36, 'society_nord', 0, NULL),
(37, 'society_palace', 0, NULL),
(38, 'society_palace_black', 0, NULL),
(39, 'society_pegorino', 0, NULL),
(40, 'society_police', 0, NULL),
(41, 'society_realestateagent', 0, NULL),
(42, 'society_rebelstudio', 0, NULL),
(43, 'society_rebelstudio_black', 0, NULL),
(44, 'society_rosa', 0, NULL),
(45, 'society_sheriff', 0, NULL),
(46, 'society_sixt', 0, NULL),
(47, 'society_sons', 0, NULL),
(48, 'society_southside', 0, NULL),
(49, 'society_tabac', 0, NULL),
(50, 'society_tabac_black', 0, NULL),
(51, 'society_tailor', 0, NULL),
(52, 'society_tattoo', 0, NULL),
(53, 'society_taxi', 0, NULL),
(54, 'society_ubereats', 0, NULL),
(55, 'society_unicorn', 0, NULL),
(56, 'society_vagos', 0, NULL),
(57, 'society_vercetti', 0, NULL),
(58, 'society_vigneron', 0, NULL),
(59, 'society_vigneron_black', 0, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `addon_inventory`
--

CREATE TABLE `addon_inventory` (
  `name` varchar(60) NOT NULL,
  `label` varchar(100) NOT NULL,
  `shared` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `addon_inventory`
--

INSERT INTO `addon_inventory` (`name`, `label`, `shared`) VALUES
('property', 'Propriété', 0),
('society_410', '410', 1),
('society_ambulance', 'Ambulance', 1),
('society_ammunation', 'Ammunation', 1),
('society_avocat', 'Avocat', 1),
('society_bahamas', 'Bahamas', 1),
('society_ballas', '!society_ballas', 1),
('society_banker', 'Banquier', 1),
('society_barber', 'Coiffeur', 1),
('society_bennys', 'Benny\'s', 1),
('society_bikedealer', 'Concesionnaire Moto', 1),
('society_blackout', 'Blackout', 1),
('society_bloods', 'Bloods', 1),
('society_burgershot', 'Burgershot', 1),
('society_cafe', 'Cafe', 1),
('society_cardealer', 'Concesionnaire', 1),
('society_casino', 'Casino', 1),
('society_cholas', '!society_cholas', 1),
('society_confe', '!society_confe', 1),
('society_daymson', 'Daymson', 1),
('society_drarux', 'Drarux', 1),
('society_event', 'Evenementiel', 1),
('society_families', '!society_families', 1),
('society_farc', 'FARC', 1),
('society_galaxy', 'Galaxy', 1),
('society_gouv', 'Gouvernement', 1),
('society_greenmotors', 'GreenMotor\'s', 1),
('society_journaliste', 'Journaliste', 1),
('society_locura', 'Locura', 1),
('society_lopez', '!society_lopez', 1),
('society_lost', 'Lost', 1),
('society_ltdb', 'Ltdb', 1),
('society_madrazo', 'Madrazo', 1),
('society_mannschaft', 'Mannschaft Kämpfer Zwei', 1),
('society_marabunta', 'Marabunta', 1),
('society_mechanic', 'Mécano', 1),
('society_palace', 'Palace', 1),
('society_pegorino', 'Pegorino', 1),
('society_police', 'Police', 1),
('society_police_weapons', 'Armes Police', 1),
('society_rebelstudio', 'Rebel Studio', 1),
('society_resid', '!society_resid', 1),
('society_rosa', 'Rosanueva', 1),
('society_sheriff', 'Sheriff', 1),
('society_sheriff_weapons', 'Armes Sheriff', 1),
('society_sixt', 'Sixt', 1),
('society_sons', 'Sons of Anarchy', 1),
('society_southside', 'Southside', 1),
('society_tabac', 'Tabac', 1),
('society_tailor', 'Tailleur', 1),
('society_tattoo', 'Tatoueur', 1),
('society_taxi', 'Taxi', 1),
('society_ubereats', 'Uber Eats', 1),
('society_ubereats_fridge', 'Uber Eats (Frigo)', 1),
('society_unicorn', 'Unicorn', 1),
('society_unicorn_fridge', 'Unicorn (frigo)', 1),
('society_vagos', '!society_vagos', 1),
('society_vercetti', 'Vercetti', 1),
('society_vigneron', 'Vigneron', 1);

-- --------------------------------------------------------

--
-- Structure de la table `addon_inventory_items`
--

CREATE TABLE `addon_inventory_items` (
  `id` int(11) NOT NULL,
  `inventory_name` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `count` int(11) NOT NULL,
  `owner` varchar(60) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `addon_inventory_items`
--

INSERT INTO `addon_inventory_items` (`id`, `inventory_name`, `name`, `count`, `owner`) VALUES
(1781, 'society_families', 'covid', 1, NULL),
(1977, 'society_vagos', 'radio', 7, NULL),
(1785, 'society_locura', 'bread', 3, NULL),
(1824, 'society_ubereats_fridge', 'sprite', 69, NULL),
(1992, 'property', 'machete', 10, 'property_24'),
(2074, 'society_bennys', 'caprisun', 7, NULL),
(1791, 'society_bennys', 'soda', 20, NULL),
(1792, 'society_bennys', 'bread', 8, NULL),
(1797, 'society_ubereats_fridge', 'tacos', 117, NULL),
(1794, 'society_taxi', 'water', 5, NULL),
(1795, 'society_taxi', 'bread', 5, NULL),
(1796, 'society_taxi', 'radio', 3, NULL),
(1823, 'society_ubereats_fridge', 'fanta', 58, NULL),
(1801, 'society_police_weapons', 'radio', 39, NULL),
(1802, 'society_police_weapons', 'stungun', 7, NULL),
(2002, 'society_marabunta', 'pistol_ammo', 102, NULL),
(2003, 'property', 'pistol_ammo_box', 100, 'property_26'),
(1809, 'society_bennys', 'water', 4, NULL),
(1810, 'society_bennys', 'ihelmet_136_3', 1, NULL),
(1811, 'society_bennys', 'ihelmet_142_13', 1, NULL),
(1812, 'society_bennys', 'ihelmet_142_19', 1, NULL),
(1813, 'society_bennys', 'hamburger', 5, NULL),
(1814, 'society_bennys', 'kebab', 14, NULL),
(1845, 'society_police_weapons', 'fixkit', 3, NULL),
(1877, 'property', 'radio', 29, 'property_8'),
(1926, 'society_marabunta', 'kebab', 2, NULL),
(1822, 'society_ubereats_fridge', 'icetea', 8, NULL),
(1838, 'property', 'bandage', 18, 'property_10'),
(2073, 'society_bennys', 'donuts_chocolat', 18, NULL),
(1825, 'society_ubereats_fridge', 'pizzza', 85, NULL),
(1843, 'society_police', 'bat', 1, NULL),
(1827, 'society_police_weapons', 'nightstick', 2, NULL),
(1828, 'society_ubereats', 'simcard_4448682', 1, NULL),
(1829, 'society_ubereats', 'simcard_4441167', 1, NULL),
(1925, 'society_marabunta', 'soda', 2, NULL),
(1836, 'society_madrazo', 'packaged_chicken', 45, NULL),
(1939, 'society_burgershot', 'frites', 450, NULL),
(1938, 'society_burgershot', 'cheeseburger', 418, NULL),
(2071, 'society_bennys', 'ihelmet_110_4', 1, NULL),
(1857, 'society_ubereats_fridge', 'kebab', 185, NULL),
(1858, 'society_ubereats_fridge', 'energy', 80, NULL),
(1859, 'society_ubereats_fridge', 'donuts_chocolat', 240, NULL),
(1860, 'society_ubereats_fridge', 'beer', 94, NULL),
(1861, 'society_ubereats_fridge', 'water', 238, NULL),
(1862, 'society_ubereats_fridge', 'frites', 321, NULL),
(1863, 'society_ubereats_fridge', 'caprisun', 34, NULL),
(1864, 'society_ubereats_fridge', 'redbull', 88, NULL),
(1865, 'society_ubereats_fridge', 'cocacola', 4, NULL),
(1866, 'society_cardealer', 'hamburger', 108, NULL),
(1924, 'society_police', 'pistol', 3, NULL),
(1943, 'society_police', 'pistol_ammo', 218, NULL),
(2042, 'society_cardealer', 'icetea', 57, NULL),
(1881, 'society_marabunta', 'pistol_ammo_box', 5, NULL),
(1923, 'society_police', 'machete', 1, NULL),
(1884, 'property', 'bat', 4, 'property_9'),
(1986, 'society_madrazo', 'shit', 302, NULL),
(1887, 'society_marabunta', 'phone', 1, NULL),
(1942, 'society_burgershot', 'fanta', 461, NULL),
(1989, 'society_madrazo', 'wool', 44, NULL),
(1891, 'society_ubereats_fridge', 'soda', 916, NULL),
(1919, 'society_farc', 'clothe', 25, NULL),
(1941, 'society_burgershot', 'icetea', 376, NULL),
(1940, 'society_burgershot', 'cocacola', 426, NULL),
(1978, 'society_ubereats_fridge', 'bread', 3, NULL),
(1937, 'society_ubereats_fridge', 'donuts_fraise', 149, NULL),
(1903, 'society_bennys', 'tacos', 38, NULL),
(1993, 'society_police', 'combatpistol', 1, NULL),
(1935, 'society_mechanic', 'radio', 1, NULL),
(2056, 'society_sons', 'kebab', 41, NULL),
(1981, 'society_police_weapons', 'flashlight', 24, NULL),
(1962, 'society_burgershot', 'hamburger', 387, NULL),
(1956, 'property', 'jewels', 1050, 'property_24'),
(1958, 'society_bennys', 'cocacola', 12, NULL),
(2049, 'society_marabunta', 'pistol', 1, NULL),
(1976, 'society_madrazo', 'pistol_ammo_box', 2, NULL),
(1996, 'property', 'fixkit', 15, 'property_24'),
(2069, 'society_locura', 'croquettes', 1, NULL),
(2063, 'society_sons', 'soda', 8, NULL),
(2070, 'society_bennys', 'frites', 18, NULL),
(2019, 'society_bennys', 'fixkit', 23, NULL),
(2020, 'society_bennys', 'fixtool', 13, NULL),
(2021, 'society_bennys', 'carokit', 13, NULL),
(2059, 'society_vercetti', 'pistol_ammo', 64, NULL),
(2043, 'society_vagos', 'pistol_ammo_box', 238, NULL),
(2055, 'society_marabunta', 'knife', 1, NULL),
(2026, 'society_police', 'pistol_ammo_box', 3, NULL),
(2047, 'society_vagos', 'pistol_ammo', 55, NULL),
(2046, 'society_vagos', 'pistol', 15, NULL),
(2072, 'society_bennys', 'fanta', 15, NULL),
(2075, 'society_bennys', 'energy', 5, NULL),
(2088, 'society_madrazo', 'shit_pooch', 90, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `aircrafts`
--

CREATE TABLE `aircrafts` (
  `name` varchar(60) NOT NULL,
  `model` varchar(60) NOT NULL,
  `price` int(11) NOT NULL,
  `category` varchar(60) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `aircrafts`
--

INSERT INTO `aircrafts` (`name`, `model`, `price`, `category`) VALUES
('Alpha Z1', 'alphaz1', 1200000, 'plane'),
('Besra', 'besra', 1200000, 'plane'),
('Buzzard', 'buzzard2', 900000, 'heli'),
('Cuban 800', 'cuban800', 400000, 'plane'),
('Dodo', 'dodo', 500000, 'plane'),
('Duster', 'duster', 400000, 'plane'),
('Frogger', 'frogger', 990000, 'heli'),
('Havok', 'havok', 350000, 'heli'),
('Howard NX25', 'howard', 1275000, 'plane'),
('Luxor', 'luxor', 2500000, 'plane'),
('Luxor Deluxe ', 'luxor2', 2500000, 'plane'),
('Mammatus', 'mammatus', 300000, 'plane'),
('Maverick', 'maverick', 750000, 'heli'),
('Ultra Light', 'microlight', 450000, 'plane'),
('Nimbus', 'nimbus', 900000, 'plane'),
('Rogue', 'rogue', 1300000, 'plane'),
('Sea Breeze', 'seabreeze', 850000, 'plane'),
('Sea Sparrow', 'seasparrow', 815000, 'heli'),
('Shamal', 'shamal', 1150000, 'plane'),
('Mallard', 'stunt', 375000, 'plane'),
('SuperVolito', 'supervolito', 1400000, 'heli'),
('SuperVolito Carbon', 'supervolito2', 1350000, 'heli'),
('Swift', 'swift', 1400000, 'heli'),
('Swift Deluxe', 'swift2', 1250000, 'heli'),
('Velum', 'velum2', 450000, 'plane'),
('Vestra', 'vestra', 1000000, 'plane'),
('Volatus', 'volatus', 1350000, 'heli');

-- --------------------------------------------------------

--
-- Structure de la table `aircraft_categories`
--

CREATE TABLE `aircraft_categories` (
  `name` varchar(60) NOT NULL,
  `label` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `aircraft_categories`
--

INSERT INTO `aircraft_categories` (`name`, `label`) VALUES
('heli', 'Hélicoptère'),
('plane', 'Avion');

-- --------------------------------------------------------

--
-- Structure de la table `baninfo`
--

CREATE TABLE `baninfo` (
  `id` int(11) NOT NULL,
  `license` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `identifier` varchar(25) COLLATE utf8mb4_bin DEFAULT NULL,
  `liveid` varchar(21) COLLATE utf8mb4_bin DEFAULT NULL,
  `xblid` varchar(21) COLLATE utf8mb4_bin DEFAULT NULL,
  `discord` varchar(30) COLLATE utf8mb4_bin DEFAULT NULL,
  `playerip` varchar(25) COLLATE utf8mb4_bin DEFAULT NULL,
  `playername` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- --------------------------------------------------------

--
-- Structure de la table `bank_history`
--

CREATE TABLE `bank_history` (
  `id` int(10) UNSIGNED NOT NULL,
  `discord` varchar(50) NOT NULL DEFAULT '',
  `type` varchar(50) NOT NULL,
  `amount` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `banlist`
--

CREATE TABLE `banlist` (
  `license` varchar(50) COLLATE utf8mb4_bin NOT NULL,
  `identifier` varchar(25) COLLATE utf8mb4_bin DEFAULT NULL,
  `liveid` varchar(21) COLLATE utf8mb4_bin DEFAULT NULL,
  `xblid` varchar(21) COLLATE utf8mb4_bin DEFAULT NULL,
  `discord` varchar(30) COLLATE utf8mb4_bin DEFAULT NULL,
  `playerip` varchar(25) COLLATE utf8mb4_bin DEFAULT NULL,
  `targetplayername` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL,
  `sourceplayername` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL,
  `reason` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `timeat` varchar(50) COLLATE utf8mb4_bin NOT NULL,
  `expiration` varchar(50) COLLATE utf8mb4_bin NOT NULL,
  `permanent` int(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- --------------------------------------------------------

--
-- Structure de la table `banlisthistory`
--

CREATE TABLE `banlisthistory` (
  `id` int(11) NOT NULL,
  `license` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `identifier` varchar(25) COLLATE utf8mb4_bin DEFAULT NULL,
  `liveid` varchar(21) COLLATE utf8mb4_bin DEFAULT NULL,
  `xblid` varchar(21) COLLATE utf8mb4_bin DEFAULT NULL,
  `discord` varchar(30) COLLATE utf8mb4_bin DEFAULT NULL,
  `playerip` varchar(25) COLLATE utf8mb4_bin DEFAULT NULL,
  `targetplayername` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL,
  `sourceplayername` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL,
  `reason` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `timeat` int(11) NOT NULL,
  `added` varchar(40) COLLATE utf8mb4_bin NOT NULL,
  `expiration` int(11) NOT NULL,
  `permanent` int(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- --------------------------------------------------------

--
-- Structure de la table `bikedealer_vehicles`
--

CREATE TABLE `bikedealer_vehicles` (
  `id` int(11) NOT NULL,
  `vehicle` varchar(255) NOT NULL,
  `price` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `bikes`
--

CREATE TABLE `bikes` (
  `name` varchar(60) NOT NULL,
  `model` varchar(60) NOT NULL,
  `price` int(11) NOT NULL,
  `category` varchar(60) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `bikes`
--

INSERT INTO `bikes` (`name`, `model`, `price`, `category`) VALUES
('Akuma', 'AKUMA', 11257, 'motorcycles'),
('Avarus', 'avarus', 9812, 'motorcycles'),
('Bagger', 'bagger', 5600, 'motorcycles'),
('Bati 801', 'bati', 12964, 'motorcycles'),
('Bati 801RR', 'bati2', 13112, 'motorcycles'),
('BF400', 'bf400', 17000, 'motorcycles'),
('BMX (velo)', 'bmx', 250, 'motorcycles'),
('Carbon RS', 'carbonrs', 18612, 'motorcycles'),
('Chimera', 'chimera', 13541, 'motorcycles'),
('Cliffhanger', 'cliffhanger', 15653, 'motorcycles'),
('Cruiser (velo)', 'cruiser', 250, 'motorcycles'),
('Daemon', 'daemon', 5629, 'motorcycles'),
('Daemon High', 'daemon2', 6000, 'motorcycles'),
('Defiler', 'defiler', 15400, 'motorcycles'),
('Double T', 'double', 13028, 'motorcycles'),
('Enduro', 'enduro', 10665, 'motorcycles'),
('Esskey', 'esskey', 8886, 'motorcycles'),
('KTM 250sm', 'exc250sm', 35000, 'imports'),
('Faggio', 'faggio', 590, 'motorcycles'),
('Vespa', 'faggio2', 770, 'motorcycles'),
('Fixter (velo)', 'fixter', 250, 'motorcycles'),
('Gargoyle', 'gargoyle', 11843, 'motorcycles'),
('Hakuchou', 'hakuchou', 20728, 'motorcycles'),
('Hakuchou Sport', 'hakuchou2', 23693, 'motorcycles'),
('Hexer', 'hexer', 5921, 'motorcycles'),
('Innovation', 'innovation', 5482, 'motorcycles'),
('kx450f', 'kx450f', 30000, 'imports'),
('Manchez', 'manchez', 4620, 'motorcycles'),
('Nemesis', 'nemesis', 11843, 'motorcycles'),
('Nightblade', 'nightblade', 11257, 'motorcycles'),
('PCJ-600', 'pcj', 10072, 'motorcycles'),
('Ruffian', 'ruffian', 8886, 'motorcycles'),
('Sanchez', 'sanchez', 5390, 'motorcycles'),
('Sanchez Sport', 'sanchez2', 6160, 'motorcycles'),
('Sanctus', 'sanctus', 17772, 'motorcycles'),
('Scorcher (velo)', 'scorcher', 800, 'motorcycles'),
('Shotaro Concept', 'shotaro', 320000, 'motorcycles'),
('Sovereign', 'sovereign', 7700, 'motorcycles'),
('Thrust', 'thrust', 10364, 'motorcycles'),
('Tri bike (velo)', 'tribike3', 520, 'motorcycles'),
('Vader', 'vader', 11257, 'motorcycles'),
('Vortex', 'vortex', 15400, 'motorcycles'),
('Woflsbane', 'wolfsbane', 5629, 'motorcycles'),
('yzf250sm', 'yzf250sm', 37000, 'imports'),
('Zombie', 'zombiea', 7638, 'motorcycles'),
('Zombie Luxuary', 'zombieb', 7223, 'motorcycles');

-- --------------------------------------------------------

--
-- Structure de la table `bike_categories`
--

CREATE TABLE `bike_categories` (
  `name` varchar(60) NOT NULL,
  `label` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `bike_categories`
--

INSERT INTO `bike_categories` (`name`, `label`) VALUES
('imports', 'Moto Importé'),
('motorcycles', 'Motos');

-- --------------------------------------------------------

--
-- Structure de la table `bike_sold`
--

CREATE TABLE `bike_sold` (
  `client` varchar(50) NOT NULL,
  `model` varchar(50) NOT NULL,
  `plate` varchar(50) NOT NULL,
  `soldby` varchar(50) NOT NULL,
  `date` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `billing`
--

CREATE TABLE `billing` (
  `id` int(11) NOT NULL,
  `discord` varchar(255) NOT NULL,
  `sender` varchar(255) NOT NULL,
  `target_type` varchar(50) NOT NULL,
  `target` varchar(255) NOT NULL,
  `label` varchar(255) NOT NULL,
  `amount` int(11) NOT NULL,
  `date` datetime DEFAULT curtime()
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `boats`
--

CREATE TABLE `boats` (
  `name` varchar(60) NOT NULL,
  `model` varchar(60) NOT NULL,
  `price` int(11) NOT NULL,
  `category` varchar(60) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `boats`
--

INSERT INTO `boats` (`name`, `model`, `price`, `category`) VALUES
('Dinghy 4Seat', 'dinghy', 150000, 'boat'),
('Dinghy 2Seat', 'dinghy2', 170000, 'boat'),
('Dinghy Yacht', 'dinghy4', 200000, 'boat'),
('Jetmax', 'jetmax', 120000, 'boat'),
('Marquis', 'marquis', 95000, 'boat'),
('Seashark', 'seashark', 50000, 'boat'),
('Seashark Yacht', 'seashark3', 75000, 'boat'),
('Speeder', 'speeder', 150000, 'boat'),
('Squalo', 'squalo', 80000, 'boat'),
('Submarine', 'submersible', 250000, 'subs'),
('Kraken', 'submersible2', 350000, 'subs'),
('Suntrap', 'suntrap', 80000, 'boat'),
('Toro', 'toro', 145000, 'boat'),
('Toro Yacht', 'toro2', 150000, 'boat'),
('Tropic', 'tropic', 125000, 'boat'),
('Tropic Yacht', 'tropic2', 140000, 'boat');

-- --------------------------------------------------------

--
-- Structure de la table `boat_categories`
--

CREATE TABLE `boat_categories` (
  `name` varchar(60) NOT NULL,
  `label` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `boat_categories`
--

INSERT INTO `boat_categories` (`name`, `label`) VALUES
('boat', 'Boats'),
('subs', 'Submersibles');

-- --------------------------------------------------------

--
-- Structure de la table `cardealer_vehicles`
--

CREATE TABLE `cardealer_vehicles` (
  `id` int(11) NOT NULL,
  `vehicle` varchar(255) NOT NULL,
  `price` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `crash_data`
--

CREATE TABLE `crash_data` (
  `id` int(11) NOT NULL,
  `discord` varchar(50) NOT NULL,
  `crash_hash` varchar(50) NOT NULL,
  `position` varchar(50) NOT NULL,
  `velocity` varchar(50) NOT NULL,
  `time` timestamp NOT NULL DEFAULT curtime()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `datastore`
--

CREATE TABLE `datastore` (
  `name` varchar(60) NOT NULL,
  `label` varchar(100) NOT NULL,
  `shared` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `datastore`
--

INSERT INTO `datastore` (`name`, `label`, `shared`) VALUES
('property', 'Propriété', 0),
('society_410', '410', 1),
('society_ambulance', 'Ambulance', 1),
('society_ammunation', 'Ammunation', 1),
('society_avocat', 'Avocat', 1),
('society_ballas', 'Ballas', 1),
('society_barber', 'Coiffeur', 1),
('society_bennys', 'Benny\'s', 1),
('society_blackout', 'Blackout', 1),
('society_bloods', 'Bloods', 1),
('society_cafe', 'Cafe', 1),
('society_casino', 'casino', 1),
('society_daymson', 'Daymson', 1),
('society_drarux', 'Drarux', 1),
('society_families', 'Families', 1),
('society_farc', 'FARC', 1),
('society_gouv', 'Gouvernement', 1),
('society_journaliste', 'Journaliste', 1),
('society_locura', 'Locura', 1),
('society_lost', 'Lost', 1),
('society_ltdb', 'Ltdb', 1),
('society_madrazo', 'Madrazo', 1),
('society_mannschaft', 'Mannschaft Kämpfer Zwei', 1),
('society_mara', 'Mara', 1),
('society_marabunta', 'Marabunta', 1),
('society_palace', 'Palace', 1),
('society_pegorino', 'Pegorino', 1),
('society_police', 'Police', 1),
('society_realestateagent', 'Agence Immobilière', 1),
('society_rebelstudio', 'Rebel Studio', 1),
('society_rosa', 'Rosanueva', 1),
('society_sheriff', 'Sheriff', 1),
('society_sons', 'Sons of Anarchy', 1),
('society_southside', 'Southside', 1),
('society_tabac', 'Tabac', 1),
('society_tattoo', 'Tatoueur', 1),
('society_taxi', 'Taxi', 1),
('society_ubereats', 'Uber Eats', 1),
('society_unicorn', 'unicorn', 1),
('society_vagos', 'Vagos', 1),
('society_vercetti', 'Vercetti', 1),
('society_vigneron', 'Vigneron', 1),
('user_casino', 'Casino', 0),
('user_ears', 'Oreillette', 0),
('user_glasses', 'Lunettes', 0),
('user_helmet', 'Casque', 0),
('user_mask', 'Masque', 0);

-- --------------------------------------------------------

--
-- Structure de la table `datastore_data`
--

CREATE TABLE `datastore_data` (
  `id` int(11) NOT NULL,
  `name` varchar(60) NOT NULL,
  `owner` varchar(60) DEFAULT NULL,
  `data` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `datastore_data`
--

INSERT INTO `datastore_data` (`id`, `name`, `owner`, `data`) VALUES
(1, 'society_410', NULL, '{}'),
(2, 'society_ambulance', NULL, '{}'),
(3, 'society_ammunation', NULL, '{}'),
(4, 'society_avocat', NULL, '{}'),
(5, 'society_ballas', NULL, '{}'),
(6, 'society_barber', NULL, '{}'),
(7, 'society_bennys', NULL, '{}'),
(8, 'society_blackout', NULL, '{}'),
(9, 'society_bloods', NULL, '{}'),
(10, 'society_cafe', NULL, '{}'),
(11, 'society_casino', NULL, '{}'),
(12, 'society_daymson', NULL, '{}'),
(13, 'society_drarux', NULL, '{}'),
(14, 'society_families', NULL, '{}'),
(15, 'society_farc', NULL, '{}'),
(16, 'society_gouv', NULL, '{}'),
(17, 'society_journaliste', NULL, '{}'),
(18, 'society_locura', NULL, '{}'),
(19, 'society_lost', NULL, '{}'),
(20, 'society_ltdb', NULL, '{}'),
(21, 'society_madrazo', NULL, '{}'),
(22, 'society_mannschaft', NULL, '{}'),
(23, 'society_mara', NULL, '{}'),
(24, 'society_marabunta', NULL, '{}'),
(25, 'society_palace', NULL, '{}'),
(26, 'society_pegorino', NULL, '{}'),
(27, 'society_police', NULL, '{}'),
(28, 'society_realestateagent', NULL, '{}'),
(29, 'society_rebelstudio', NULL, '{}'),
(30, 'society_rosa', NULL, '{}'),
(31, 'society_sheriff', NULL, '{}'),
(32, 'society_sons', NULL, '{}'),
(33, 'society_southside', NULL, '{}'),
(34, 'society_tabac', NULL, '{}'),
(35, 'society_tattoo', NULL, '{}'),
(36, 'society_taxi', NULL, '{}'),
(37, 'society_ubereats', NULL, '{}'),
(38, 'society_unicorn', NULL, '{}'),
(39, 'society_vagos', NULL, '{}'),
(40, 'society_vercetti', NULL, '{}'),
(41, 'society_vigneron', NULL, '{}');

-- --------------------------------------------------------

--
-- Structure de la table `dpkeybinds`
--

CREATE TABLE `dpkeybinds` (
  `id` varchar(50) DEFAULT NULL,
  `keybind1` varchar(50) DEFAULT 'num4',
  `emote1` varchar(255) DEFAULT '',
  `keybind2` varchar(50) DEFAULT 'num5',
  `emote2` varchar(255) DEFAULT '',
  `keybind3` varchar(50) DEFAULT 'num6',
  `emote3` varchar(255) DEFAULT '',
  `keybind4` varchar(50) DEFAULT 'num7',
  `emote4` varchar(255) DEFAULT '',
  `keybind5` varchar(50) DEFAULT 'num8',
  `emote5` varchar(255) DEFAULT '',
  `keybind6` varchar(50) DEFAULT 'num9',
  `emote6` varchar(255) DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `factions`
--

CREATE TABLE `factions` (
  `name` varchar(50) NOT NULL,
  `label` varchar(50) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `factions`
--

INSERT INTO `factions` (`name`, `label`) VALUES
('resid', 'Civil'),
('mannschaft', 'Mannschaft Kämpfer Zwei'),
('rosa', 'Rosanueva'),
('bloods', 'Bloods'),
('ballas', 'Ballas'),
('families', 'Families'),
('vagos', 'Vagos'),
('vercetti', 'Vercetti'),
('madrazo', 'Madrazo'),
('sons', 'Sons of Anarchy'),
('marabunta', 'Marabunta'),
('locura', 'Locura');

-- --------------------------------------------------------

--
-- Structure de la table `faction_grades`
--

CREATE TABLE `faction_grades` (
  `id` int(11) NOT NULL,
  `faction_name` varchar(50) DEFAULT NULL,
  `grade` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `label` varchar(50) NOT NULL,
  `salary` int(11) NOT NULL,
  `skin_male` longtext NOT NULL,
  `skin_female` longtext NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `faction_grades`
--

INSERT INTO `faction_grades` (`id`, `faction_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
(1, 'resid', 0, 'resid', 'Civil', 0, '{}', '{}'),
(14, 'vagos', 1, 'affranchis', 'Grande', 0, '{}', '{}'),
(13, 'vagos', 0, 'recrue', 'Pekenio', 0, '{}', '{}'),
(5, 'ballas', 3, 'boss', 'OG', 0, '{}', '{}'),
(6, 'ballas', 1, 'affranchis', 'Hustler', 0, '{}', '{}'),
(19, 'families', 1, 'affranchis', 'Cuzz', 0, '{}', '{}'),
(7, 'ballas', 0, 'recrue', 'Petite frappe', 0, '{}', '{}'),
(8, 'families', 0, 'recrue', 'Young', 0, '{}', '{}'),
(9, 'families', 4, 'boss', 'Double OG', 0, '{}', '{}'),
(15, 'vagos', 2, 'boss', 'Jefe', 0, '{}', '{}'),
(16, 'families', 2, 'boss', 'Général', 0, '{}', '{}'),
(17, 'families', 3, 'boss', 'OG', 0, '{}', '{}'),
(18, 'ballas', 2, 'gg', 'Big Hustler', 0, '{}', '{}'),
(125, 'sons', 0, 'prospect', 'Prospect', 0, '{}', '{}'),
(126, 'sons', 1, 'nomad', 'Nomad', 0, '{}', '{}'),
(82, 'madrazo', 0, 'pequeno', 'Pequeno', 0, '{}', '{}'),
(83, 'madrazo', 1, 'soldado', 'Soldado', 0, '{}', '{}'),
(84, 'madrazo', 2, 'teniente', 'Teniente', 0, '{}', '{}'),
(85, 'madrazo', 3, 'segundo', 'Segundo', 0, '{}', '{}'),
(86, 'madrazo', 4, 'boss', 'Jefe', 0, '{}', '{}'),
(87, 'vercetti', 0, 'soldato', 'Soldato', 0, '{}', '{}'),
(88, 'vercetti', 1, 'tenente', 'Tenente', 0, '{}', '{}'),
(89, 'vercetti', 2, 'capitano', 'Capitano', 0, '{}', '{}'),
(90, 'vercetti', 3, 'braccio', 'Braccio Destro', 0, '{}', '{}'),
(91, 'vercetti', 4, 'boss', 'Capo', 0, '{}', '{}'),
(92, 'bloods', 0, 'petit', 'Petit du hood', 0, '{}', '{}'),
(93, 'bloods', 1, 'man', 'Man Certifié', 0, '{}', '{}'),
(94, 'bloods', 2, 'grand', 'Grand du hood', 0, '{}', '{}'),
(95, 'bloods', 3, 'caid', 'Caïd', 0, '{}', '{}'),
(96, 'bloods', 4, 'boss', 'OG', 0, '{}', '{}'),
(129, 'sons', 4, 'road', 'Road captain', 0, '{}', '{}'),
(128, 'sons', 3, 'enforcer', 'Enforcer', 0, '{}', '{}'),
(127, 'sons', 2, 'loyal', 'Loyal', 0, '{}', '{}'),
(101, 'mannschaft', 0, 'rakrutieren', 'Rakrutieren', 0, '{}', '{}'),
(102, 'mannschaft', 1, 'soldat', 'Soldat', 0, '{}', '{}'),
(103, 'mannschaft', 2, 'korporal', 'Korporal', 0, '{}', '{}'),
(104, 'mannschaft', 3, 'sergeant', 'Sergeant', 0, '{}', '{}'),
(105, 'mannschaft', 4, 'leutnant', 'Leutnant', 0, '{}', '{}'),
(106, 'mannschaft', 5, 'kapitan', 'Kapitan', 0, '{}', '{}'),
(107, 'mannschaft', 6, 'kolonel', 'Kolonel', 0, '{}', '{}'),
(108, 'mannschaft', 7, 'boss', 'Boss', 0, '{}', '{}'),
(109, 'marabunta', 0, 'pequeno', 'Pequeno', 0, '{}', '{}'),
(110, 'marabunta', 1, 'soldado', 'Soldado', 0, '{}', '{}'),
(111, 'marabunta', 2, 'teniente', 'Téniente', 0, '{}', '{}'),
(112, 'marabunta', 3, 'segundo', 'Segundo', 0, '{}', '{}'),
(113, 'marabunta', 4, 'boss', 'Jéfé', 0, '{}', '{}'),
(130, 'sons', 5, 'secretaire', 'Secrétaire', 0, '{}', '{}'),
(131, 'sons', 6, 'tresorier', 'Trésorier', 0, '{}', '{}'),
(132, 'sons', 7, 'sergent', 'Sergent d’armes', 0, '{}', '{}'),
(119, 'locura', 0, 'pequeno', 'Pequeno', 0, '{}', '{}'),
(120, 'locura', 1, 'soldado', 'Soldado', 0, '{}', '{}'),
(121, 'locura', 2, 'commandante', 'Commandante', 0, '{}', '{}'),
(122, 'locura', 3, 'teniente', 'Téniente', 0, '{}', '{}'),
(123, 'locura', 4, 'segundo', 'Segundo', 0, '{}', '{}'),
(124, 'locura', 5, 'boss', 'Jéfé', 0, '{}', '{}'),
(133, 'sons', 8, 'viceboss', 'Vice Président', 0, '{}', '{}'),
(134, 'sons', 9, 'boss', 'Président', 0, '{}', '{}'),
(135, 'rosa', 0, 'nuevo', 'Nuevo', 0, '{}', '{}'),
(136, 'rosa', 1, 'soldado', 'Soldado', 0, '{}', '{}'),
(137, 'rosa', 2, 'vice', 'Vice', 0, '{}', '{}'),
(138, 'rosa', 3, 'capo', 'Capo', 0, '{}', '{}'),
(139, 'rosa', 4, 'consulente', 'Consulente', 0, '{}', '{}'),
(140, 'rosa', 5, 'boss', 'Don', 0, '{}', '{}');

-- --------------------------------------------------------

--
-- Structure de la table `fine_types`
--

CREATE TABLE `fine_types` (
  `id` int(11) NOT NULL,
  `label` varchar(255) DEFAULT NULL,
  `amount` int(11) DEFAULT NULL,
  `category` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `fine_types`
--

INSERT INTO `fine_types` (`id`, `label`, `amount`, `category`) VALUES
(1, 'Usage abusif du klaxon', 125, 0),
(2, 'Franchir une ligne continue', 100, 0),
(3, 'Circulation à contresens', 250, 0),
(4, 'Demi-tour non autorisé', 500, 0),
(5, 'Circulation hors-route', 750, 0),
(6, 'Non-respect des distances de sécurité', 500, 0),
(7, 'Arrêt dangereux / interdit', 450, 0),
(8, 'Stationnement gênant / interdit', 500, 0),
(9, 'Non respect de la priorité à droite', 350, 0),
(10, 'Non-respect à un véhicule prioritaire', 200, 0),
(11, 'Non-respect d\'un stop', 350, 0),
(12, 'Non-respect d\'un feu rouge', 200, 0),
(13, 'Dépassement dangereux', 400, 0),
(14, 'Véhicule non en état', 200, 0),
(15, 'Conduite sans permis', 1000, 0),
(16, 'Refus Optemperer', 1500, 0),
(17, 'Excès de vitesse < 5 kmh', 200, 0),
(18, 'Entrave de la circulation', 350, 1),
(19, 'Dégradation de la voie publique', 400, 1),
(20, 'Trouble à l\'ordre publique', 1000, 1),
(21, 'Entrave opération de police', 2500, 1),
(22, 'Outrage à agent de police', 1250, 1),
(23, 'Manifestation illégale', 1750, 1),
(24, 'Tentative de corruption', 5000, 1),
(25, 'Port d\'arme non autorisé', 5000, 2),
(26, 'Port d\'arme illégal', 7000, 2),
(27, 'Vol de voiture', 2000, 2),
(28, 'Vente de drogue', 1000, 2),
(29, 'Fabriquation de drogue', 3000, 2),
(30, 'Possession de drogue +5', 1000, 2),
(31, 'Prise d\'otage civil', 5000, 2),
(32, 'Prise d\'otage agent de l\'état', 7500, 2),
(33, 'Braquage particulier', 4000, 2),
(34, 'Braquage magasin', 4500, 2),
(35, 'Braquage de banque', 50000, 2),
(36, 'Tir sur civil', 6500, 3),
(37, 'Tir sur agent de l\'état', 15000, 3),
(38, 'Tentative de meurtre sur civil', 5000, 3),
(39, 'Tentative de meurtre sur agent de l\'état', 7500, 3),
(40, 'Meurtre sur civil', 20000, 3),
(41, 'Meurte sur agent de l\'état', 60000, 3),
(42, 'Meurtre involontaire', 12000, 3),
(43, 'Escroquerie x5', 2500, 2),
(44, 'Braquage sur police', 25000, 2);

-- --------------------------------------------------------

--
-- Structure de la table `fine_types_gouv`
--

CREATE TABLE `fine_types_gouv` (
  `id` int(11) NOT NULL,
  `label` varchar(255) DEFAULT NULL,
  `amount` int(11) DEFAULT NULL,
  `category` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `fine_types_gouv`
--

INSERT INTO `fine_types_gouv` (`id`, `label`, `amount`, `category`) VALUES
(1, 'Escroquerie à l\'entreprise', 15000, 2),
(2, 'Travail au (Black)', 50000, 2);

-- --------------------------------------------------------

--
-- Structure de la table `groups_cameras`
--

CREATE TABLE `groups_cameras` (
  `name` varchar(50) NOT NULL DEFAULT '0',
  `label` varchar(50) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `h4ci_report`
--

CREATE TABLE `h4ci_report` (
  `id` int(11) NOT NULL,
  `type` varchar(255) NOT NULL,
  `reporteur` varchar(255) DEFAULT NULL,
  `nomreporter` varchar(255) DEFAULT NULL,
  `raison` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `items`
--

CREATE TABLE `items` (
  `name` varchar(50) NOT NULL,
  `label` varchar(50) NOT NULL,
  `limit` int(11) NOT NULL DEFAULT -1,
  `can_remove` int(11) NOT NULL DEFAULT 1,
  `weight` float NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `items`
--

INSERT INTO `items` (`name`, `label`, `limit`, `can_remove`, `weight`) VALUES
('weed_pooch', 'Pochon de Weed', 50, 1, 0.4),
('wood', 'Bois', 20, 1, 1),
('diamond', 'Diamant', 50, 1, 0.3),
('gold', 'Or', 21, 1, 0.8),
('clip', 'Chargeur vide', -1, 1, 0.4),
('jumelles', 'Jumelles', 20, 1, 1),
('coke_pooch', 'Pochon de Coke', 50, 1, 0.4),
('meth', 'Meth', 100, 1, 0.3),
('meth_pooch', 'Pochon de Meth', 50, 1, 0.8),
('coke', 'Coke', 100, 1, 0.3),
('opium', 'Opium', 50, 1, 0.3),
('gazbottle', 'Bouteille de gaz', 10, 1, 1),
('fixtool', 'Outils de réparation', 6, 1, 0.7),
('carotool', 'Outils carosserie', 4, 1, 0.8),
('fixkit', 'Kit réparation', 10, 1, 1),
('carokit', 'Kit carosserie', 3, 1, 0.8),
('medikit', 'Kit médical', 10, 1, 0.6),
('bandage', 'Bandage', 20, 1, 0.1),
('drill', 'Perceuse', 5, 1, 0.8),
('vodkaenergy', 'Vodka-RedBull', 7, 1, 0.4),
('whiskycoca', 'Whisky-coca', 7, 1, 0.7),
('kebab', 'Kebab', -1, 1, 0.7),
('vin', 'Bouteille de Vin', 10, 1, 0.8),
('saucisson', 'Saucisson', 7, 1, 0.4),
('opona', 'Pneu', 5, 1, 0.4),
('caprisun', 'Capri-Sun', -1, 1, 0.4),
('jager', 'Jägermeister', -1, 1, 0.6),
('limonade', 'Limonade', 5, 1, 0.4),
('drpepper', 'Dr. Pepper', 5, 1, 0.8),
('energy', 'RedBull', 5, 1, 0.5),
('icetea', 'Bouteille d\'Ice-Tea', 5, 1, 0.8),
('jusfruit', 'Jus de fruits', 5, 1, 0.8),
('iron', 'Fer', 42, 1, 0.5),
('martini', 'Martini blanc', 5, 1, 0.8),
('tequila', 'Tequila', 5, 1, 0.5),
('whisky', 'Whisky', 5, 1, 0.5),
('rhum', 'Rhum', 5, 1, 0.4),
('vodka', 'Vodka', 5, 1, 0.5),
('pizza', 'Pizza', -1, 1, 0.6),
('brolly', 'Parapluie', -1, 1, 0.5),
('kitpic', 'Pic Nic', 5, 1, 0.6),
('ball', 'Grosse balle de foot', 5, 1, 1),
('bong', 'Bang', 10, 1, 0.6),
('mask_swim', 'Masque de plongé', -1, 1, 1),
('sandwich', 'Sandwich', 10, 1, 0.6),
('magazine', 'Magasine Playboy', 5, 1, 0.08),
('kalilinux', 'Kali Linux', 10, 1, 0.3),
('notepad', 'Bloc Note', 10, 1, 0.3),
('rose', 'Rose', 50, 1, 0.3),
('blowtorch', 'Chalumeau', 5, 1, 1),
('tatgun', 'Dermographe', 50, 1, 0.3),
('lighter', 'Briquet', -1, 1, 0.4),
('raisin', 'Raisin', 100, 1, 0.2),
('orangejus', 'Jus d\'orange', 10, 1, 0.3),
('jusraisin', 'Jus de raisin', 10, 1, 0.4),
('phone', 'Téléphone', 10, 1, 0.3),
('bread', 'Pain', 15, 1, 0.4),
('water', 'Bouteille d\'eau', 15, 1, 0.6),
('redbull', 'RedBull', 15, 1, 0.6),
('cafe', 'Café', 15, 1, 0.4),
('sevenup', 'Bouteille de 7-Up', 15, 1, 0.7),
('cocacola', 'Bouteille de Coca-Cola', 15, 1, 0.7),
('eau_arom', 'Bouteille de Diabolo', 15, 1, 0.7),
('cheeseburger', 'CheeseBurger', 15, 1, 0.8),
('tacos', 'Tacos', 15, 1, 0.8),
('donuts_chocolat', 'Donuts Chocolat', 15, 1, 0.2),
('donuts_fraise', 'Donuts Fraise', 15, 1, 0.2),
('viennoiserie', 'Viennoiserie', 15, 1, 0.6),
('gps', 'GPS', -1, 1, 0.02),
('hackerDevice', 'Hacking', -1, 1, 0.3),
('wine', 'Wine', -1, 1, 0.5),
('beer', 'Bière', -1, 1, 0.6),
('chocolate', 'Chocolat', -1, 1, 0.2),
('mojito', 'Mojito', 5, 1, 0.5),
('ice', 'Glaçon', -1, 1, 0.2),
('mixapero', 'Mix Apéritif', 3, 1, 0.7),
('metreshooter', 'Mètre de shooter', 3, 1, 0.7),
('hifi', 'HiFi', -1, 1, 0.6),
('menthe', 'Feuille de menthe', 10, 1, 0.5),
('headbag', 'Sac en papier', 5, 1, 0.3),
('pepsi', 'Bouteille de Pepsi', 15, 1, 0.8),
('sprite', 'Bouteille de Sprite', 15, 1, 0.8),
('fanta', 'Bouteille de Fanta', 15, 1, 0.8),
('orangina', 'Bouteille d\'Orangina', 15, 1, 0.6),
('hazmat1', 'Combinaison Noir', -1, 1, 0.8),
('hazmat2', 'Combinaison Bleu', -1, 1, 0.8),
('hazmat3', 'Combinaison Jaune', -1, 1, 0.8),
('hazmat4', 'Combinaison Blanche', -1, 1, 0.8),
('lsd_pooch', 'Pochon de LSD', 50, 1, 1),
('lsd', 'LSD', 100, 1, 0.3),
('opium_pooch', 'Pochon de Opium', 20, 1, 0.8),
('weed', 'Weed', 100, 1, 0.3),
('swim', 'Tenue de plongée', -1, 1, 0.8),
('nightvision', 'Night Vision', 1, 1, 0.5),
('milk', 'Lait', -1, 1, 0.4),
('bag', 'Sac', 1, 1, 0.3),
('lockpick', 'Lock Pick', 5, 1, 0.5),
('cutted_wood', 'Bois coupé', 20, 1, 1),
('copper', 'Cuivre', 56, 1, 0.3),
('washed_stone', 'Pierre Lavée', 7, 1, 2),
('stone', 'Pierre', 7, 1, 2),
('fish', 'Poisson', 100, 1, 0.4),
('packaged_plank', 'Paquet de planches', 100, 1, 0.2),
('packaged_chicken', 'Poulet en barquette', 100, 1, 0.5),
('pizzza', 'Pizza', -1, 1, 0.8),
('slaughtered_chicken', 'Poulet abattu', 100, 1, 0.4),
('alive_chicken', 'Poulet vivant', 100, 1, 0.4),
('farine', 'Farine', 100, 1, 0.2),
('petrol', 'Pétrole', 24, 1, 0.8),
('petrol_raffin', 'Pétrole Raffiné', 24, 1, 0.8),
('essence', 'Essence', 24, 1, 0.5),
('wool', 'Laine', 40, 1, 0.5),
('fabric', 'Tissu', 80, 1, 0.2),
('clothe', 'Vêtement', 40, 1, 0.5),
('poubelle', 'Poubelle', -1, 1, 0.6),
('jewels', 'Bijoux', 200, 1, 0.1),
('golfclub', 'Club de Golf', -1, 1, 1.5),
('feuilletabac', 'Feuille de Tabac', 70, 1, 0.2),
('tabacsec', 'Tabac Sec', 50, 1, 0.3),
('malbora', 'Malboro', 25, 1, 0.4),
('cigar', 'Cigare', 20, 1, 0.1),
('bat', 'Batte', -1, 1, 1),
('hammer', 'Marteau', -1, 1, 2),
('nightstick', 'Matraque', -1, 1, 1),
('cdvierge', 'CD Vierge', 30, 1, 0.8),
('cddaym', 'CD', 30, 1, 0.8),
('knife', 'Couteau', -1, 1, 0.6),
('ghb', 'GHB', 5, 1, 0.3),
('badgefbi', 'Badge FBI', -1, 1, 0.1),
('crowbar', 'Pied de biche', -1, 1, 0.8),
('pistol', 'Pistolet', -1, 1, 2),
('combatpistol', 'Glock', -1, 1, 3),
('appistol', 'Pistolet Perforant', -1, 1, 2),
('pistol50', 'Desert Eagle', -1, 1, 2),
('microsmg', 'UZI', -1, 1, 3),
('smg', 'MP5A', -1, 1, 6),
('assaultsmg', 'FN P90 (SMG)', -1, 1, 5),
('assaultrifle', 'AK 47', -1, 1, 5),
('carbinerifle', 'M4A1', -1, 1, 4),
('advancedrifle', 'CTAR-21', -1, 1, 5),
('mg', 'PKP Pecheneg', -1, 1, 3),
('combatmg', 'M249E1', -1, 1, 3),
('pumpshotgun', 'Remington 870', -1, 1, 3),
('sawnoffshotgun', 'Mossberg 500', -1, 1, 6),
('assaultshotgun', 'UTAS UTS-15', -1, 1, 5),
('bullpupshotgun', 'FlashBall', -1, 1, 3),
('stungun', 'Taser', -1, 1, 1),
('sniperrifle', 'PSG-1', -1, 1, 6),
('heavysniper', 'M107', -1, 1, 2),
('remotesniper', 'Remote Sniper', -1, 1, 3),
('grenadelauncher', 'Milkor MGL', -1, 1, 4),
('rpg', 'RPG-7', -1, 1, 6),
('stinger', 'Stinger', -1, 1, 3),
('minigun', 'Minigun', -1, 1, 4),
('grenade', 'Grenade', -1, 1, 0.8),
('stickybomb', 'Bombe collante', -1, 1, 0.5),
('smokegrenade', 'Grenade Fumigène', -1, 1, 0.3),
('bzgas', 'Grenade à gaz bz', -1, 1, 0.5),
('molotov', 'Cocktail Molotov', -1, 1, 0.6),
('fireextinguisher', 'Extincteur', -1, 1, 0.7),
('petrolcan', 'Jerrican Essence', -1, 1, 0.4),
('digiscanner', 'Digiscanner', -1, 1, 0.8),
('snspistol', 'Pétoire', -1, 1, 3),
('bottle', 'Bouteille cassée', -1, 1, 0.4),
('gusenberg', 'Thompson SMG', -1, 1, 3),
('specialcarbine', 'G36', -1, 1, 6),
('heavypistol', 'Pistolet Lourd', -1, 1, 2),
('bullpuprifle', 'Type 86-S', -1, 1, 4),
('dagger', 'Dagger', -1, 1, 0.8),
('vintagepistol', 'Pistolet Vintage', -1, 1, 3),
('firework', 'Feu d\'artifice', -1, 1, 0.3),
('musket', 'Brown Bess Mousquet', -1, 1, 6),
('heavyshotgun', 'Saiga-12K', -1, 1, 4),
('marksmanrifle', 'M39 EMR', -1, 1, 5),
('hominglauncher', 'SA-7 Grail', -1, 1, 6),
('proxmine', 'Mine de proximité', -1, 1, 1),
('snowball', 'Boule de neige', 2, 1, 0.4),
('flaregun', 'Lance fusée de détresse', -1, 1, 1.3),
('garbagebag', 'Sac poubelle', -1, 1, 0.2),
('handcuffs', 'Menottes', -1, 1, 0.3),
('combatpdw', 'SIG Sauer MPX', -1, 1, 3),
('marksmanpistol', 'Thompson-Center Contender G2', -1, 1, 5),
('knuckle', 'Poing américain', -1, 1, 1),
('hatchet', 'Hachette', -1, 1, 1),
('railgun', 'Canon éléctrique', -1, 1, 2),
('machete', 'Machette', -1, 1, 1),
('machinepistol', 'TEC-9', -1, 1, 3),
('switchblade', 'Couteau à cran d\'arrêt', -1, 1, 1),
('revolver', 'Revolver', -1, 1, 3),
('dbshotgun', 'DBShotgun', -1, 1, 4),
('compactrifle', 'Micro Draco AK Pistol', -1, 1, 3),
('autoshotgun', 'AA-12', -1, 1, 5),
('battleaxe', 'Hache de combat', -1, 1, 2),
('compactlauncher', 'M79 GL', -1, 1, 3),
('minismg', 'Skorpion Vz. 61', -1, 1, 3),
('pipebomb', 'Bombe Tuyau', -1, 1, 1),
('poolcue', 'Queue de billard', -1, 1, 1),
('wrench', 'Clé à molette', -1, 1, 1),
('flashlight', 'Lampe torche', -1, 1, 0.6),
('parachute', 'Parachute', -1, 1, 1),
('flare', 'Fusée Détresse', -1, 1, 0.6),
('snspistol_mk2', 'Pistolet SNS MK2', -1, 1, 3),
('revolver_mk2', 'Revolver MK2', -1, 1, 4),
('doubleaction', 'Double Action', -1, 1, 3),
('specialcarbine_mk2', 'Carabine Spéciale MK2', -1, 1, 6),
('bullpuprifle_mk2', 'Fusil BullPup MK2', -1, 1, 4),
('pumpshotgun_mk2', 'Fusil à Pompe MK2', -1, 1, 6),
('marksmanrifle_mk2', 'Fulsil de tireur d\'élite MK2', -1, 1, 5),
('assaultrifle_mk2', 'Fusil d\'assaut MK2', -1, 1, 5),
('carbinerifle_mk2', 'Carabine MK2', -1, 1, 4),
('combatmg_mk2', 'MG MK2', -1, 1, 3),
('heavysniper_mk2', 'Snipeur d\'élite MK2', -1, 1, 2),
('pistol_mk2', 'Sig Sauer P226', -1, 1, 3),
('smg_mk2', 'SMG MK2', -1, 1, 6),
('champagne', 'Champagne', -1, 1, 0.3),
('croquettes', 'Croquettes', -1, 1, 0),
('steroids', 'Stéroïdes', 3, 1, 0.8),
('frites', 'Frites', 5, 1, 0.4),
('leurre', 'Leurre', -1, 1, 0.4),
('hamburger', 'Hamburger', -1, 1, 0.6),
('pills', 'Pillules', -1, 1, 0.2),
('dark_case', 'Boite noire', -1, 1, 0.4),
('sushi', 'Sushi', -1, 1, 0.6),
('traceur', 'Traceur', -1, 1, 0.3),
('orange', 'Orange', -1, 1, 0.6),
('bonbon', 'Bonbon', -1, 1, 0.3),
('cape', 'Cape', -1, 1, 0.2),
('sedatif', 'Sédatif', -1, 1, 0.3),
('sportlunch', 'Repas de sport', -1, 1, 0.6),
('protein_shake', 'Shaker aux protéines', -1, 1, 0.6),
('powerade', 'Powerade', -1, 1, 0.6),
('cocktail', 'Cocktail', -1, 1, 0.5),
('prisonnier', 'Tenue de prisonnier', -1, 1, 0.4),
('smoothies', 'Smoothie', -1, 1, 0.6),
('hotdog', 'Hot-Dog', -1, 1, 0.5),
('militaire', 'Tenue militaire', -1, 1, 0.9),
('poison', 'Poison', -1, 1, 0.5),
('soda', 'Soda', -1, 1, 0.6),
('fishburger', 'FishBurger', -1, 1, 0.4),
('karting1', 'Tenue Karting1', -1, 1, 0.5),
('karting2', 'Tenue Karting2', -1, 1, 0.5),
('bullet1', 'Gilet par balle (Niveau 1)', -1, 1, 1),
('bullet2', 'Gilet par balle (Niveau 2)', -1, 1, 1),
('bullet3', 'Gilet par balle (Niveau 3)', -1, 1, 1),
('bullet4', 'Gilet par balle (Niveau 4)', -1, 1, 1),
('skydiving', 'Tenue de saut en parachute', -1, 1, 0.8),
('wct_scope_max', 'Accessoire Lunette améliorée', -1, 1, 0.5),
('splif', 'Splif', -1, 1, 0.3),
('vision', 'Vision Nocture', -1, 1, 0.6),
('blowpipe', 'Châlumeau', -1, 1, 1),
('waterg', 'Eau gazeuse', -1, 1, 0.5),
('huile_pooch', 'Huile en poche', -1, 1, 0.4),
('pistol_ammo', 'Munition 45 ACP', 100, 1, 0.05),
('smg_ammo', 'Munition SMG', 200, 1, 0.05),
('rifle_ammo', 'Munition 7.62', 300, 1, 0.02),
('mg_ammo', 'Munition MG', 100, 1, 0.04),
('shotgun_ammo', 'Munition de pompe', 100, 1, 0.05),
('sniper_ammo', 'Sniper Munition', 50, 1, 0.06),
('minigun_ammo', 'Minigun Munition', 100, 1, 0.03),
('grenadelauncher_ammo', 'Munition de MGL', 100, 1, 0.05),
('grenadelauncher_smoke_ammo', 'Munition de MGL fumigène', 100, 1, 0.06),
('rpg_ammo', 'RPG Munition', 10, 1, 1),
('stinger_ammo', 'Munition stinger', 100, 1, 0.08),
('stickybomb_ammo', 'Munition de bombe collante', 100, 1, 0.2),
('gzgas_ammo', 'Munition Gaz GZ', 100, 1, 0.1),
('flare_ammo', 'Flares', 30, 1, 0.02),
('molotov_ammo', 'Munition Molotov', 100, 1, 0.2),
('pistol_ammo_box', 'Boite Munition Pistolet', 15, 1, 1.2),
('smg_ammo_box', 'Boîte de SMG', 10, 1, 1.2),
('rifle_ammo_box', 'Boite Munition fusil d\'assaut', 15, 1, 0.8),
('shotgun_ammo_box', 'Boîte de Cal.12', 5, 1, 1),
('silencer', 'Silencieux', -1, 1, 1),
('carbon', 'Carbone', -1, 1, 0.4),
('acier', 'Acier', -1, 1, 0.5),
('poudre', 'Boite de poudre', -1, 1, 0.4),
('douille', 'Boite de douille', -1, 1, 0.4),
('katana', 'Katana', -1, 1, 1),
('casino_coins', 'Jetons', 100000, 1, 0.001),
('mower', 'Tondeuse', -1, 1, 0.5),
('covid', 'Masque Covid', -1, 1, 0.2),
('wct_scope_mac2', 'Accessoire Petite lunette', -1, 1, 0.5),
('wct_scope_mac', 'Accessoire Lunette', -1, 1, 0.5),
('wct_scope_lrg2', 'Accessoire Lunette puissante', -1, 1, 0.5),
('wct_scope_lrg', 'Accessoire Lunette', -1, 1, 0.5),
('wct_sb_var2', 'Variante de garde du corps', -1, 1, 0.5),
('wct_sb_var1', 'Variante de gros bonnet', -1, 1, 0.5),
('wct_rev_varg', 'Variante de garde du corps', -1, 1, 0.5),
('wct_rev_varb', 'Variante de gros bonnet', -1, 1, 0.5),
('wct_muzz9', 'Frein de bouche en cloche', -1, 1, 0.5),
('wct_muzz7', 'Frein de bouche fendu', -1, 1, 0.5),
('wct_muzz6', 'Frein de bouche incliné', -1, 1, 0.5),
('wct_muzz5', 'Frein de bouche lourd', -1, 1, 0.5),
('wct_muzz4', 'Frein de bouche de précision', -1, 1, 0.5),
('wct_muzz2', 'Frein de bouche tactique', -1, 1, 0.5),
('wct_muzz1', 'Frein de bouche plat', -1, 1, 0.5),
('wct_muzz', 'Frein de bouche', -1, 1, 0.5),
('wct_knuck_vg', 'Accessoire poing américain Vagos', -1, 1, 0.5),
('wct_knuck_slg', 'Accessoire poing américain Roi', -1, 1, 0.5),
('wct_knuck_pc', 'Accessoire poing américain Joueur', -1, 1, 0.5),
('wct_knuck_lv', 'Accessoire poing américain Amant', -1, 1, 0.5),
('wct_knuck_ht', 'Accessoire poing américain Rageux', -1, 1, 0.5),
('wct_knuck_dmd', 'Accessoire poing américain Roc', -1, 1, 0.5),
('wct_knuck_dlr', 'Accessoire poing américain Arnaqueur', -1, 1, 0.5),
('wct_knuck_bg', 'Accessoire poing américain Ballas', -1, 1, 0.5),
('wct_knuck_02', 'Accessoire poing américain Mac', -1, 1, 0.5),
('wct_holo', 'Viseur holographique', -1, 1, 0.5),
('wct_grip', 'Poignée', -1, 1, 0.5),
('wct_flash', 'Accessoire d\'arme Torche', -1, 1, 0.5),
('wct_comp', 'Compensateur', -1, 1, 0.5),
('wct_clip_tr', 'Munitions traçantes', -1, 1, 0.5),
('wct_clip_inc', 'Munitions incendiaires', -1, 1, 0.5),
('wct_clip_hp', 'Munitions à pointes creuses', -1, 1, 0.5),
('wct_clip_fmj', 'Munitions blindées', -1, 1, 0.5),
('wct_clip_ex', 'Munitions explosives', -1, 1, 0.5),
('wct_clip_drm', 'Accessoire Chargeur tambour', -1, 1, 0.5),
('wct_clip_ap', 'Munitions perforantes', -1, 1, 0.5),
('wct_clip2', 'Chargeur grande capacité', -1, 1, 0.5),
('wct_camo_ind', 'Camouflage Patriotique', -1, 1, 0.5),
('wct_camo_9', 'Camouflage Géométrique', -1, 1, 0.5),
('wct_camo_8', 'Camouflage Zébré', -1, 1, 0.5),
('wct_camo_7', 'Camouflage Léopard', -1, 1, 0.5),
('wct_camo_6', 'Camouflage Perseus', -1, 1, 0.5),
('wct_camo_5', 'Camouflage Sessanta Nove', -1, 1, 0.5),
('wct_camo_4', 'Camouflage Crânien', -1, 1, 0.5),
('wct_camo_3', 'Camouflage forestier', -1, 1, 0.5),
('wct_camo_2', 'Camouflage pinceau', -1, 1, 0.5),
('wct_camo_10', 'Camouflage Détonant', -1, 1, 0.5),
('wct_camo_1', 'Camouflage pixel', -1, 1, 0.5),
('wct_barr2', 'Accessoire Canon lourd', -1, 1, 0.5),
('wct_scope_med2', 'Accessoire Grande lunette', -1, 1, 0.5),
('wct_scope_nv', 'Accessoire Lunette de vision nocturne', -1, 1, 0.5),
('wct_scope_pi', 'Accessoire Lunette Pistolet', -1, 1, 0.5),
('wct_scope_sml', 'Accessoire Lunette', -1, 1, 0.5),
('wct_scope_sml2', 'Accessoire Lunette moyenne', -1, 1, 0.5),
('wct_scope_th', 'Accessoire Lunette thermique', -1, 1, 0.5),
('wct_shell_ap', 'Accessoire Balles en acier', -1, 1, 0.5),
('wct_shell_ex', 'Accessoire Balles explosives', -1, 1, 0.5),
('wct_shell_hp', 'Accessoire Balles Fléchettes', -1, 1, 0.5),
('wct_shell_inc', 'Accessoire Souffle du dragon', -1, 1, 0.5),
('wct_supp', 'Silencieux', -1, 1, 0.5),
('wct_var_etchm', 'Finition métal gravé', -1, 1, 0.5),
('wct_var_gold', 'Finition luxe Yusuf Amir', -1, 1, 0.5),
('wct_var_metal', 'Finition bronze doré', -1, 1, 0.5),
('wct_var_ray18', 'Finition festive', -1, 1, 0.5),
('wct_var_sil', 'Finition perle de platine', -1, 1, 0.5),
('wct_var_wood', 'Finition bois gravé', -1, 1, 0.5),
('ceramicpistol', 'Pistolet Céramique', -1, 1, 2),
('navyrevolver', 'Navy Revolver', -1, 1, 2),
('snow_chain', 'Chaine à neige', -1, 1, 1),
('gadgetpistol', 'Pistolet Perico', -1, 1, 3),
('combatshotgun', 'Spas 12', -1, 1, 3),
('militaryrifle', 'Steyr AUG', -1, 1, 3),
('wct_mrfl_sight', 'Accessoire viseur fusil militaire', -1, 1, 0.5),
('hookah', 'Chicha', -1, 1, 0.6),
('avacoin', 'AvaCoin', -1, 1, 0),
('shit', 'Shit', 100, 1, 0.3),
('shit_pooch', 'Pochon de Shit', 50, 1, 0.4),
('radio', 'Radio', -1, 1, 0.3),
('papier', 'Papier', -1, 1, 0),
('billet_sale', 'Argent Sale', -1, 1, 0),
('skate', 'Skate', -1, 1, 0),
('drone', 'Grand Drone', -1, 1, 0),
('drone2', 'Petit Drone 1', -1, 1, 0),
('drone3', 'Petit Drone 2', -1, 1, 0),
('drone4', 'Petit Drone 3', -1, 1, 0),
('drone5', 'Petit Drone 4', -1, 1, 0),
('drone6', 'Petit Drone 5', -1, 1, 0),
('rcsultan', 'Sultan RS Télécomandée', -1, 1, 0),
('cle', 'Clé USB', -1, 1, 0);

-- --------------------------------------------------------

--
-- Structure de la table `jobs`
--

CREATE TABLE `jobs` (
  `name` varchar(50) NOT NULL,
  `label` varchar(50) DEFAULT NULL,
  `whitelisted` tinyint(1) DEFAULT 1
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `jobs`
--

INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES
('unemployed', 'Chômeur', 0),
('journaliste', 'Journaliste', 1),
('ltdb', 'Ltd', 1),
('taxi', 'Taxi', 1),
('cardealer', 'Concessionnaire', 1),
('police', 'LSPD', 1),
('mechanic', 'Mécano', 1),
('ambulance', 'Ambulance', 1),
('realestateagent', 'Agent immobilier', 1),
('miner', 'Mineur', 1),
('unicorn', 'Unicorn', 1),
('avocat', 'Avocat', 1),
('bennys', 'Benny\'s', 1),
('gouv', 'Gouv', 1),
('bikedealer', 'Concess Moto', 1),
('fisherman', 'Pêcheur', 0),
('slaughterer', 'Abatteur', 0),
('vigneron', 'Vigneron', 1),
('tabac', 'Tabac', 1),
('garbage', 'Eboueur', 0),
('banker', 'Banquier', 1),
('palace', 'Palace', 1),
('lumberjack', 'Bûcheron', 1),
('fueler', 'Raffineur', 1),
('greenmotors', 'GreenMotor\'s', 1),
('tailor', 'Couturier', 0),
('ubereats', 'Uber Eats', 1),
('daymson', 'Ballas Records', 1),
('rebelstudio', 'Rebel Studio', 1),
('ammunation', 'Ammunation', 1),
('barber', 'Coiffeur', 1),
('tattoo', 'Tatoueur', 1),
('casino', 'Casino', 1),
('sixt', 'Sixt', 1),
('event', 'Evenementiel', 1),
('bahamas', 'Bahamas', 1),
('galaxy', 'Galaxy', 1),
('_dev', '_dev', 1),
('burgershot', 'Burgershot', 1),
('cafe', 'Cafe', 1),
('sheriff', 'Sheriff', 1);

-- --------------------------------------------------------

--
-- Structure de la table `job_grades`
--

CREATE TABLE `job_grades` (
  `job_name` varchar(50) DEFAULT NULL,
  `grade` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `label` varchar(50) NOT NULL,
  `salary` int(11) NOT NULL,
  `skin_male` longtext NOT NULL,
  `skin_female` longtext NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `job_grades`
--

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('realestateagent', 2, 'gestion', 'Secrétaire', 75, '{}', '{}'),
('greenmotors', 1, 'expcustom', 'Préparateur', 65, '{}', '{}'),
('greenmotors', 0, 'stagiaire', 'Stagiaire', 50, '{}', '{}'),
('event', 0, 'employee', 'Employée', 25, '{}', '{}'),
('event', 1, 'experimente', 'Expérimenté', 50, '{}', '{}'),
('event', 2, 'chef', 'Chef d\'équipe', 75, '{}', '{}'),
('event', 3, 'boss', 'Patron', 100, '{}', '{}'),
('taxi', 4, 'boss', 'Patron', 0, '{\"eye_color\":0,\"decals_1\":0,\"blemishes_2\":0,\"lipstick_2\":0,\"ears_1\":-1,\"hair_1\":0,\"blush_2\":0,\"face\":0,\"pants_1\":49,\"age_1\":0,\"blemishes_1\":0,\"bproof_2\":0,\"bracelets_1\":-1,\"moles_2\":0,\"tshirt_2\":0,\"bracelets_2\":0,\"shoes_2\":0,\"makeup_1\":0,\"hair_color_2\":0,\"arms\":90,\"sun_2\":0,\"beard_2\":0,\"shoes_1\":61,\"eyebrows_2\":0,\"complexion_1\":0,\"bproof_1\":0,\"helmet_2\":2,\"watches_2\":0,\"hair_color_1\":0,\"blush_3\":0,\"decals_2\":0,\"eyebrows_3\":0,\"tshirt_0\":15,\"makeup_3\":0,\"age_2\":0,\"eyebrows_1\":0,\"hair_2\":0,\"bags_1\":0,\"makeup_4\":0,\"bags_2\":0,\"beard_1\":5,\"bodyb_2\":0,\"shoes\":10,\"watches_1\":3,\"sex\":0,\"blush_1\":0,\"ears_2\":0,\"chest_1\":0,\"chest_2\":0,\"mask_1\":0,\"bodyb_1\":0,\"pants_2\":1,\"chest_3\":0,\"glasses_1\":0,\"lipstick_3\":0,\"lipstick_4\":0,\"glasses_2\":0,\"chain_2\":0,\"eyebrows_4\":0,\"moles_1\":0,\"makeup_2\":0,\"complexion_2\":0,\"tshirt_1\":15,\"skin\":0,\"mask_2\":0,\"arms_2\":0,\"lipstick_1\":0,\"torso_2\":0,\"chain_1\":0,\"helmet_1\":94,\"torso_1\":85,\"beard_4\":0,\"sun_1\":0,\"beard_3\":0}', '{\"hair_2\":0,\"hair_color_2\":0,\"torso_1\":57,\"bags_1\":0,\"helmet_2\":0,\"chain_2\":0,\"eyebrows_3\":0,\"makeup_3\":0,\"makeup_2\":0,\"tshirt_1\":38,\"makeup_1\":0,\"bags_2\":0,\"makeup_4\":0,\"eyebrows_4\":0,\"chain_1\":0,\"lipstick_4\":0,\"bproof_2\":0,\"hair_color_1\":0,\"decals_2\":0,\"pants_2\":1,\"age_2\":0,\"glasses_2\":0,\"ears_2\":0,\"arms\":21,\"lipstick_1\":0,\"ears_1\":-1,\"mask_2\":0,\"sex\":1,\"lipstick_3\":0,\"helmet_1\":-1,\"shoes_2\":0,\"beard_2\":0,\"beard_1\":0,\"lipstick_2\":0,\"beard_4\":0,\"glasses_1\":5,\"bproof_1\":0,\"mask_1\":0,\"decals_1\":1,\"hair_1\":0,\"eyebrows_2\":0,\"beard_3\":0,\"age_1\":0,\"tshirt_2\":0,\"skin\":0,\"torso_2\":0,\"eyebrows_1\":0,\"face\":0,\"shoes_1\":49,\"pants_1\":11}'),
('greenmotors', 2, 'chef', 'Peintre', 75, '{}', '{}'),
('unemployed', 0, 'unemployed', 'RSA', 0, '{}', '{}'),
('sixt', 1, 'novice', 'Novice', 70, '{}', '{}'),
('sixt', 0, 'recruit', 'Recrue', 70, '{}', '{}'),
('sixt', 3, 'boss', 'Patron', 100, '{}', '{}'),
('tattoo', 2, 'boss', 'Boss', 48, '{}', '{}'),
('tattoo', 1, 'confirme', 'Confirmé', 36, '{}', '{}'),
('tattoo', 0, 'apprenti', 'Apprenti', 12, '{}', '{}'),
('barber', 2, 'boss', 'Boss', 50, '{}', '{}'),
('barber', 1, 'coiffeur', 'Coiffeur', 15, '{}', '{}'),
('ammunation', 0, 'stagiaire', 'Stagiaire', 30, '{}', '{}'),
('ammunation', 1, 'employé', 'Employé', 35, '{}', '{}'),
('ammunation', 2, 'professionnel', 'Formateur', 40, '{}', '{}'),
('ammunation', 3, 'second', 'Manager', 40, '{}', '{}'),
('ammunation', 4, 'boss', 'Patron', 70, '{}', '{}'),
('barber', 0, 'barbier', 'Barbier', 15, '{}', '{}'),
('gouv', 0, 'stagiaire', 'Garde du corp', 60, '{}', '{}'),
('gouv', 1, 'gardedc', 'Secrétaire', 80, '{}', '{}'),
('gouv', 2, 'secretaire', 'Huissier', 60, '{}', '{}'),
('gouv', 3, 'coboss', 'Justice', 100, '{}', '{}'),
('casino', 1, 'security', 'Sécurité', 40, '{}', '{}'),
('casino', 2, 'barman', 'Barman', 60, '{}', '{}'),
('casino', 3, 'boss', 'Patron', 80, '{}', '{}'),
('sixt', 2, 'experienced', 'Experimente', 70, '{}', '{}'),
('ltdb', 0, 'recrue', 'Recrue', 15, '{}', '{}'),
('cafe', 1, 'employe', 'Employé', 20, '{}', '{}'),
('ltdb', 2, 'boss', 'Patron', 30, '{}', '{}'),
('cafe', 0, 'recrue', 'Recrue', 15, '{}', '{}'),
('ltdb', 1, 'employe', 'Employé', 20, '{}', '{}'),
('cafe', 2, 'boss', 'Patron', 30, '{}', '{}'),
('sheriff', 2, 'recruit', 'Officier II', 24, '{}', '{}'),
('sheriff', 0, 'recruit', 'Junior', 20, '{}', '{}'),
('sheriff', 1, 'recruit', 'Officier I', 22, '{}', '{}'),
('sheriff', 3, 'officer', 'Officier III', 26, '{}', '{}'),
('sheriff', 4, 'officer', 'Caporal I', 28, '{}', '{}'),
('sheriff', 5, 'officer', 'Caporal II', 30, '{}', '{}'),
('sheriff', 6, 'sergeant', 'Sergent', 32, '{}', '{}'),
('sheriff', 7, 'sergeant', 'Lieutenant', 35, '{}', '{}'),
('sheriff', 8, 'sergeant', 'Captain', 40, '{}', '{}'),
('sheriff', 9, 'sergeant', 'Major', 45, '{}', '{}'),
('gouv', 4, 'boss', 'Gouverneur', 100, '{}', '{}'),
('greenmotors', 4, 'boss', 'Patron', 100, '{}', '{}'),
('palace', 0, 'employe', 'Employé', 80, '{}', '{}'),
('palace', 1, 'vigile', 'Vigile', 80, '{}', '{}'),
('palace', 2, 'danse', 'Manager', 150, '{}', '{}'),
('palace', 3, 'gerant', 'Gérant', 150, '{}', '{}'),
('palace', 4, 'boss', 'Patron', 0, '{}', '{}'),
('banker', 2, 'secu', 'Sécurité Financière', 100, '{}', '{}'),
('taxi', 3, 'uber', 'Manager', 25, '{\"hair_2\":0,\"hair_color_2\":0,\"torso_1\":26,\"bags_1\":0,\"helmet_2\":0,\"chain_2\":0,\"eyebrows_3\":0,\"makeup_3\":0,\"makeup_2\":0,\"tshirt_1\":57,\"makeup_1\":0,\"bags_2\":0,\"makeup_4\":0,\"eyebrows_4\":0,\"chain_1\":0,\"lipstick_4\":0,\"bproof_2\":0,\"hair_color_1\":0,\"decals_2\":0,\"pants_2\":4,\"age_2\":0,\"glasses_2\":0,\"ears_2\":0,\"arms\":11,\"lipstick_1\":0,\"ears_1\":-1,\"mask_2\":0,\"sex\":0,\"lipstick_3\":0,\"helmet_1\":-1,\"shoes_2\":0,\"beard_2\":0,\"beard_1\":0,\"lipstick_2\":0,\"beard_4\":0,\"glasses_1\":0,\"bproof_1\":0,\"mask_1\":0,\"decals_1\":0,\"hair_1\":0,\"eyebrows_2\":0,\"beard_3\":0,\"age_1\":0,\"tshirt_2\":0,\"skin\":0,\"torso_2\":0,\"eyebrows_1\":0,\"face\":0,\"shoes_1\":10,\"pants_1\":24}', '{\"hair_2\":0,\"hair_color_2\":0,\"torso_1\":57,\"bags_1\":0,\"helmet_2\":0,\"chain_2\":0,\"eyebrows_3\":0,\"makeup_3\":0,\"makeup_2\":0,\"tshirt_1\":38,\"makeup_1\":0,\"bags_2\":0,\"makeup_4\":0,\"eyebrows_4\":0,\"chain_1\":0,\"lipstick_4\":0,\"bproof_2\":0,\"hair_color_1\":0,\"decals_2\":0,\"pants_2\":1,\"age_2\":0,\"glasses_2\":0,\"ears_2\":0,\"arms\":21,\"lipstick_1\":0,\"ears_1\":-1,\"mask_2\":0,\"sex\":1,\"lipstick_3\":0,\"helmet_1\":-1,\"shoes_2\":0,\"beard_2\":0,\"beard_1\":0,\"lipstick_2\":0,\"beard_4\":0,\"glasses_1\":5,\"bproof_1\":0,\"mask_1\":0,\"decals_1\":1,\"hair_1\":0,\"eyebrows_2\":0,\"beard_3\":0,\"age_1\":0,\"tshirt_2\":0,\"skin\":0,\"torso_2\":0,\"eyebrows_1\":0,\"face\":0,\"shoes_1\":49,\"pants_1\":11}'),
('realestateagent', 3, 'boss', 'Patron', 100, '{}', '{}'),
('realestateagent', 0, 'location', 'Location', 55, '{}', '{}'),
('mechanic', 0, 'recrue', 'Dépanneur', 10, '{}', '{}'),
('mechanic', 1, 'novice', 'Mécanicien', 10, '{}', '{}'),
('mechanic', 2, 'experimente', 'Expérimenté', 10, '{}', '{}'),
('mechanic', 3, 'chief', 'Chef d\'atelier', 15, '{}', '{}'),
('mechanic', 4, 'boss', 'Patron', 100, '{}', '{}'),
('ambulance', 8, 'boss', 'Directeur', 190, '{\"tshirt_2\":0,\"hair_color_1\":5,\"glasses_2\":3,\"shoes\":9,\"torso_2\":3,\"hair_color_2\":0,\"pants_1\":24,\"glasses_1\":4,\"hair_1\":2,\"sex\":0,\"decals_2\":0,\"tshirt_1\":15,\"helmet_1\":8,\"helmet_2\":0,\"arms\":92,\"face\":19,\"decals_1\":60,\"torso_1\":13,\"hair_2\":0,\"skin\":34,\"pants_2\":5}', '{\"tshirt_2\":3,\"decals_2\":0,\"glasses\":0,\"hair_1\":2,\"torso_1\":73,\"shoes\":1,\"hair_color_2\":0,\"glasses_1\":19,\"skin\":13,\"face\":6,\"pants_2\":5,\"tshirt_1\":75,\"pants_1\":37,\"helmet_1\":57,\"torso_2\":0,\"arms\":14,\"sex\":1,\"glasses_2\":0,\"decals_1\":0,\"hair_2\":0,\"helmet_2\":0,\"hair_color_1\":0}'),
('ambulance', 6, 'legist', 'Légiste', 170, '{\"tshirt_2\":0,\"hair_color_1\":5,\"glasses_2\":3,\"shoes\":9,\"torso_2\":3,\"hair_color_2\":0,\"pants_1\":24,\"glasses_1\":4,\"hair_1\":2,\"sex\":0,\"decals_2\":0,\"tshirt_1\":15,\"helmet_1\":8,\"helmet_2\":0,\"arms\":92,\"face\":19,\"decals_1\":60,\"torso_1\":13,\"hair_2\":0,\"skin\":34,\"pants_2\":5}', '{\"tshirt_2\":3,\"decals_2\":0,\"glasses\":0,\"hair_1\":2,\"torso_1\":73,\"shoes\":1,\"hair_color_2\":0,\"glasses_1\":19,\"skin\":13,\"face\":6,\"pants_2\":5,\"tshirt_1\":75,\"pants_1\":37,\"helmet_1\":57,\"torso_2\":0,\"arms\":14,\"sex\":1,\"glasses_2\":0,\"decals_1\":0,\"hair_2\":0,\"helmet_2\":0,\"hair_color_1\":0}'),
('ambulance', 3, 'doctor', 'Medecin', 130, '{\"tshirt_2\":0,\"hair_color_1\":5,\"glasses_2\":3,\"shoes\":9,\"torso_2\":3,\"hair_color_2\":0,\"pants_1\":24,\"glasses_1\":4,\"hair_1\":2,\"sex\":0,\"decals_2\":0,\"tshirt_1\":15,\"helmet_1\":8,\"helmet_2\":0,\"arms\":92,\"face\":19,\"decals_1\":60,\"torso_1\":13,\"hair_2\":0,\"skin\":34,\"pants_2\":5}', '{\"tshirt_2\":3,\"decals_2\":0,\"glasses\":0,\"hair_1\":2,\"torso_1\":73,\"shoes\":1,\"hair_color_2\":0,\"glasses_1\":19,\"skin\":13,\"face\":6,\"pants_2\":5,\"tshirt_1\":75,\"pants_1\":37,\"helmet_1\":57,\"torso_2\":0,\"arms\":14,\"sex\":1,\"glasses_2\":0,\"decals_1\":0,\"hair_2\":0,\"helmet_2\":0,\"hair_color_1\":0}'),
('ambulance', 0, 'intern', 'Interne', 70, '{\"tshirt_2\":0,\"hair_color_1\":5,\"glasses_2\":3,\"shoes\":9,\"torso_2\":3,\"hair_color_2\":0,\"pants_1\":24,\"glasses_1\":4,\"hair_1\":2,\"sex\":0,\"decals_2\":0,\"tshirt_1\":15,\"helmet_1\":8,\"helmet_2\":0,\"arms\":92,\"face\":19,\"decals_1\":60,\"torso_1\":13,\"hair_2\":0,\"skin\":34,\"pants_2\":5}', '{\"tshirt_2\":3,\"decals_2\":0,\"glasses\":0,\"hair_1\":2,\"torso_1\":73,\"shoes\":1,\"hair_color_2\":0,\"glasses_1\":19,\"skin\":13,\"face\":6,\"pants_2\":5,\"tshirt_1\":75,\"pants_1\":37,\"helmet_1\":57,\"torso_2\":0,\"arms\":14,\"sex\":1,\"glasses_2\":0,\"decals_1\":0,\"hair_2\":0,\"helmet_2\":0,\"hair_color_1\":0}'),
('police', 10, 'boss', 'Commandant', 70, '{}', '{}'),
('police', 0, 'cadet', 'Cadet', 70, '{}', '{}'),
('police', 6, 's3', 'Sergent III', 50, '{}', '{}'),
('police', 8, 'l2', 'Lieutenant II', 60, '{}', '{}'),
('police', 9, 'l3', 'Lieutenant III', 65, '{}', '{}'),
('cardealer', 0, 'recruit', 'Recrue', 10, '{}', '{}'),
('cardealer', 1, 'novice', 'Novice', 20, '{}', '{}'),
('cardealer', 2, 'experienced', 'Experimente', 30, '{}', '{}'),
('cardealer', 3, 'boss', 'Patron', 40, '{}', '{}'),
('taxi', 0, 'recrue', 'Chauffeur', 15, '{\"hair_2\":0,\"hair_color_2\":0,\"torso_2\":73,\"bags_1\":0,\"helmet_2\":0,\"chain_2\":0,\"eyebrows_3\":0,\"makeup_3\":0,\"makeup_2\":0,\"tshirt_2\":73,\"makeup_1\":0,\"bags_2\":0,\"makeup_4\":0,\"eyebrows_4\":0,\"chain_1\":0,\"lipstick_4\":0,\"bproof_2\":0,\"hair_color_1\":0,\"decals_2\":0,\"pants_2\":0,\"age_2\":0,\"glasses_2\":0,\"ears_2\":0,\"arms\":0,\"lipstick_1\":0,\"ears_1\":-1,\"mask_2\":0,\"sex\":0,\"lipstick_3\":0,\"helmet_1\":-1,\"shoes_2\":0,\"beard_0\":0,\"beard_1\":0,\"lipstick_2\":0,\"beard_4\":0,\"glasses_1\":0,\"bproof_1\":0,\"mask_1\":0,\"decals_1\":0,\"hair_1\":0,\"eyebrows_2\":0,\"beard_3\":0,\"age_1\":0,\"tshirt_0\":15,\"skin\":0,\"torso_2\":3,\"eyebrows_1\":0,\"face\":0,\"shoes_1\":10,\"pants_1\":24}', '{\"hair_2\":0,\"hair_color_2\":0,\"torso_1\":57,\"bags_1\":0,\"helmet_2\":0,\"chain_2\":0,\"eyebrows_3\":0,\"makeup_3\":0,\"makeup_2\":0,\"tshirt_1\":38,\"makeup_1\":0,\"bags_2\":0,\"makeup_4\":0,\"eyebrows_4\":0,\"chain_1\":0,\"lipstick_4\":0,\"bproof_2\":0,\"hair_color_1\":0,\"decals_2\":0,\"pants_2\":1,\"age_2\":0,\"glasses_2\":0,\"ears_2\":0,\"arms\":21,\"lipstick_1\":0,\"ears_1\":-1,\"mask_2\":0,\"sex\":1,\"lipstick_3\":0,\"helmet_1\":-1,\"shoes_2\":0,\"beard_2\":0,\"beard_1\":0,\"lipstick_2\":0,\"beard_4\":0,\"glasses_1\":5,\"bproof_1\":0,\"mask_1\":0,\"decals_1\":1,\"hair_1\":0,\"eyebrows_2\":0,\"beard_3\":0,\"age_1\":0,\"tshirt_2\":0,\"skin\":0,\"torso_2\":0,\"eyebrows_1\":0,\"face\":0,\"shoes_1\":49,\"pants_1\":11}'),
('taxi', 1, 'novice', 'Novice', 15, '{\"hair_2\":0,\"hair_color_2\":0,\"torso_1\":32,\"bags_1\":0,\"helmet_2\":0,\"chain_2\":0,\"eyebrows_3\":0,\"makeup_3\":0,\"makeup_2\":0,\"tshirt_1\":31,\"makeup_1\":0,\"bags_2\":0,\"makeup_4\":0,\"eyebrows_4\":0,\"chain_1\":0,\"lipstick_4\":0,\"bproof_2\":0,\"hair_color_1\":0,\"decals_2\":0,\"pants_2\":0,\"age_2\":0,\"glasses_2\":0,\"ears_2\":0,\"arms\":27,\"lipstick_1\":0,\"ears_1\":-1,\"mask_2\":0,\"sex\":0,\"lipstick_3\":0,\"helmet_1\":-1,\"shoes_2\":0,\"beard_2\":0,\"beard_1\":0,\"lipstick_2\":0,\"beard_4\":0,\"glasses_1\":0,\"bproof_1\":0,\"mask_1\":0,\"decals_1\":1,\"hair_1\":0,\"eyebrows_2\":0,\"beard_3\":0,\"age_1\":0,\"tshirt_2\":0,\"skin\":0,\"torso_2\":0,\"eyebrows_1\":0,\"face\":0,\"shoes_1\":10,\"pants_1\":24}', '{\"hair_2\":0,\"hair_color_2\":0,\"torso_1\":57,\"bags_1\":0,\"helmet_2\":0,\"chain_2\":0,\"eyebrows_3\":0,\"makeup_3\":0,\"makeup_2\":0,\"tshirt_1\":38,\"makeup_1\":0,\"bags_2\":0,\"makeup_4\":0,\"eyebrows_4\":0,\"chain_1\":0,\"lipstick_4\":0,\"bproof_2\":0,\"hair_color_1\":0,\"decals_2\":0,\"pants_2\":1,\"age_2\":0,\"glasses_2\":0,\"ears_2\":0,\"arms\":21,\"lipstick_1\":0,\"ears_1\":-1,\"mask_2\":0,\"sex\":1,\"lipstick_3\":0,\"helmet_1\":-1,\"shoes_2\":0,\"beard_2\":0,\"beard_1\":0,\"lipstick_2\":0,\"beard_4\":0,\"glasses_1\":5,\"bproof_1\":0,\"mask_1\":0,\"decals_1\":1,\"hair_1\":0,\"eyebrows_2\":0,\"beard_3\":0,\"age_1\":0,\"tshirt_2\":0,\"skin\":0,\"torso_2\":0,\"eyebrows_1\":0,\"face\":0,\"shoes_1\":49,\"pants_1\":11}'),
('taxi', 2, 'experimente', 'Experimente', 20, '{\"hair_2\":0,\"hair_color_2\":0,\"torso_1\":26,\"bags_1\":0,\"helmet_2\":0,\"chain_2\":0,\"eyebrows_3\":0,\"makeup_3\":0,\"makeup_2\":0,\"tshirt_1\":57,\"makeup_1\":0,\"bags_2\":0,\"makeup_4\":0,\"eyebrows_4\":0,\"chain_1\":0,\"lipstick_4\":0,\"bproof_2\":0,\"hair_color_1\":0,\"decals_2\":0,\"pants_2\":4,\"age_2\":0,\"glasses_2\":0,\"ears_2\":0,\"arms\":11,\"lipstick_1\":0,\"ears_1\":-1,\"mask_2\":0,\"sex\":0,\"lipstick_3\":0,\"helmet_1\":-1,\"shoes_2\":0,\"beard_2\":0,\"beard_1\":0,\"lipstick_2\":0,\"beard_4\":0,\"glasses_1\":0,\"bproof_1\":0,\"mask_1\":0,\"decals_1\":0,\"hair_1\":0,\"eyebrows_2\":0,\"beard_3\":0,\"age_1\":0,\"tshirt_2\":0,\"skin\":0,\"torso_2\":0,\"eyebrows_1\":0,\"face\":0,\"shoes_1\":10,\"pants_1\":24}', '{\"hair_2\":0,\"hair_color_2\":0,\"torso_1\":57,\"bags_1\":0,\"helmet_2\":0,\"chain_2\":0,\"eyebrows_3\":0,\"makeup_3\":0,\"makeup_2\":0,\"tshirt_1\":38,\"makeup_1\":0,\"bags_2\":0,\"makeup_4\":0,\"eyebrows_4\":0,\"chain_1\":0,\"lipstick_4\":0,\"bproof_2\":0,\"hair_color_1\":0,\"decals_2\":0,\"pants_2\":1,\"age_2\":0,\"glasses_2\":0,\"ears_2\":0,\"arms\":21,\"lipstick_1\":0,\"ears_1\":-1,\"mask_2\":0,\"sex\":1,\"lipstick_3\":0,\"helmet_1\":-1,\"shoes_2\":0,\"beard_2\":0,\"beard_1\":0,\"lipstick_2\":0,\"beard_4\":0,\"glasses_1\":5,\"bproof_1\":0,\"mask_1\":0,\"decals_1\":1,\"hair_1\":0,\"eyebrows_2\":0,\"beard_3\":0,\"age_1\":0,\"tshirt_2\":0,\"skin\":0,\"torso_2\":0,\"eyebrows_1\":0,\"face\":0,\"shoes_1\":49,\"pants_1\":11}'),
('sheriff', 10, 'lieutenant', 'Colonel', 50, '{}', '{}'),
('sheriff', 11, 'lieutenant', 'Depute Sheriff I', 55, '{}', '{}'),
('sheriff', 12, 'lieutenant', 'Depute SHeriff II', 60, '{}', '{}'),
('sheriff', 13, 'ssheriff', 'S-Sheriff', 65, '{}', '{}'),
('sheriff', 14, 'boss', 'Sheriff', 70, '{}', '{}'),
('journaliste', 1, 'reporter', 'Reporter', 40, '{}', '{}'),
('journaliste', 0, 'stagiaire', 'Stagiaire', 25, '{}', '{}'),
('journaliste', 2, 'investigator', 'Enqueteur', 55, '{}', '{}'),
('journaliste', 3, 'boss', 'Patron', 75, '{}', '{}'),
('vigneron', 0, 'stagiaire', 'Stagiaire', 50, '{}', '{}'),
('vigneron', 1, 'employe', 'Employe', 65, '{}', '{}'),
('vigneron', 2, 'responsable', 'Responsable', 80, '{}', '{}'),
('bennys', 0, 'stagiaire', 'Stagiaire', 10, '{}', '{}'),
('bennys', 1, 'expcustom', 'Préparateur', 15, '{}', '{}'),
('bennys', 2, 'chef', 'Peintre', 15, '{}', '{}'),
('greenmotors', 3, 'gerant', 'Chef Atelier', 80, '{}', '{}'),
('bennys', 4, 'boss', 'Patron', 45, '{}', '{}'),
('unicorn', 0, 'barman', 'Videur', 30, '{}', '{}'),
('unicorn', 1, 'dancer', 'Service', 40, '{}', '{}'),
('unicorn', 2, 'viceboss', 'Manager', 50, '{}', '{}'),
('unicorn', 3, 'boss', 'Gérant', 100, '{}', '{}'),
('_dev', 0, '_dev', '_dev', 0, '{}', '{}'),
('avocat', 1, 'novice', 'Comis d\'office', 0, '{}', '{}'),
('avocat', 2, 'experimente', 'Experimente', 0, '{}', '{}'),
('avocat', 3, 'chief', 'Gérant', 0, '{}', '{}'),
('avocat', 4, 'boss', 'Patron', 100, '{}', '{}'),
('bikedealer', 0, 'recruit', 'Vendeur', 40, '{}', '{}'),
('bikedealer', 1, 'novice', 'Novice', 45, '{}', '{}'),
('bikedealer', 2, 'experienced', 'Experimente', 50, '{}', '{}'),
('bikedealer', 3, 'boss', 'Patron', 10, '{}', '{}'),
('vigneron', 3, 'boss', 'Patron', 100, '{}', '{}'),
('tabac', 0, 'stagiaire', 'Intérimaire', 10, '{}', '{}'),
('tabac', 1, 'employe', 'Employe', 10, '{}', '{}'),
('tabac', 2, 'responsable', 'Responsable', 10, '{}', '{}'),
('tabac', 3, 'coboss', 'Co-Patron', 10, '{}', '{}'),
('tabac', 4, 'boss', 'Patron', 10, '{}', '{}'),
('lumberjack', 0, 'employee', 'Intérimaire', 10, '{}', '{}'),
('fisherman', 0, 'employee', 'Intérimaire', 10, '{\"tshirt_2\":0,\"shoes\":24,\"torso_2\":1\",\"pants_1\":39,\"decals_2\":0,\"tshirt_1\":15,\"arms\":75,\"decals_1\":0,\"torso_1\":66,\"pants_2\":1}', '{}'),
('fueler', 0, 'employee', 'Intérimaire', 10, '{}', '{}'),
('tailor', 0, 'employee', 'Intérimaire', 10, '{\"mask_1\":0,\"arms\":1,\"glasses_1\":0,\"hair_color_2\":4,\"makeup_1\":0,\"face\":19,\"glasses\":0,\"mask_2\":0,\"makeup_3\":0,\"skin\":29,\"helmet_2\":0,\"lipstick_4\":0,\"sex\":0,\"torso_1\":24,\"makeup_2\":0,\"bags_2\":0,\"chain_2\":0,\"ears_1\":-1,\"bags_1\":0,\"bproof_1\":0,\"shoes_2\":0,\"lipstick_2\":0,\"chain_1\":0,\"tshirt_1\":0,\"eyebrows_3\":0,\"pants_2\":0,\"beard_4\":0,\"torso_2\":0,\"beard_2\":6,\"ears_2\":0,\"hair_2\":0,\"shoes_1\":36,\"tshirt_2\":0,\"beard_3\":0,\"hair_1\":2,\"hair_color_1\":0,\"pants_1\":48,\"helmet_1\":-1,\"bproof_2\":0,\"eyebrows_4\":0,\"eyebrows_2\":0,\"decals_1\":0,\"age_2\":0,\"beard_1\":5,\"shoes\":10,\"lipstick_1\":0,\"eyebrows_1\":0,\"glasses_2\":0,\"makeup_4\":0,\"decals_2\":0,\"lipstick_3\":0,\"age_1\":0}', '{\"mask_1\":0,\"arms\":5,\"glasses_1\":5,\"hair_color_2\":4,\"makeup_1\":0,\"face\":19,\"glasses\":0,\"mask_2\":0,\"makeup_3\":0,\"skin\":29,\"helmet_2\":0,\"lipstick_4\":0,\"sex\":1,\"torso_1\":52,\"makeup_2\":0,\"bags_2\":0,\"chain_2\":0,\"ears_1\":-1,\"bags_1\":0,\"bproof_1\":0,\"shoes_2\":1,\"lipstick_2\":0,\"chain_1\":0,\"tshirt_1\":23,\"eyebrows_3\":0,\"pants_2\":0,\"beard_4\":0,\"torso_2\":0,\"beard_2\":6,\"ears_2\":0,\"hair_2\":0,\"shoes_1\":42,\"tshirt_2\":4,\"beard_3\":0,\"hair_1\":2,\"hair_color_1\":0,\"pants_1\":36,\"helmet_1\":-1,\"bproof_2\":0,\"eyebrows_4\":0,\"eyebrows_2\":0,\"decals_1\":0,\"age_2\":0,\"beard_1\":5,\"shoes\":10,\"lipstick_1\":0,\"eyebrows_1\":0,\"glasses_2\":0,\"makeup_4\":0,\"decals_2\":0,\"lipstick_3\":0,\"age_1\":0}'),
('miner', 0, 'employee', 'Intérimaire', 10, '{\"tshirt_2\":1,\"ears_1\":8,\"glasses_1\":15,\"torso_2\":0,\"ears_2\":2,\"glasses_2\":3,\"shoes_2\":1,\"pants_1\":75,\"shoes_1\":51,\"bags_1\":0,\"helmet_2\":0,\"pants_2\":7,\"torso_1\":71,\"tshirt_1\":59,\"arms\":2,\"bags_2\":0,\"helmet_1\":0}', '{}'),
('slaughterer', 0, 'employee', 'Intérimaire', 10, '{\"age_1\":0,\"glasses_2\":0,\"beard_1\":5,\"decals_2\":0,\"beard_4\":0,\"shoes_2\":0,\"tshirt_2\":0,\"lipstick_2\":0,\"hair_2\":0,\"arms\":67,\"pants_1\":36,\"skin\":29,\"eyebrows_2\":0,\"shoes\":10,\"helmet_1\":-1,\"lipstick_1\":0,\"helmet_2\":0,\"hair_color_1\":0,\"glasses\":0,\"makeup_4\":0,\"makeup_1\":0,\"hair_1\":2,\"bproof_1\":0,\"bags_1\":0,\"mask_1\":0,\"lipstick_3\":0,\"chain_1\":0,\"eyebrows_4\":0,\"sex\":0,\"torso_1\":56,\"beard_2\":6,\"shoes_1\":12,\"decals_1\":0,\"face\":19,\"lipstick_4\":0,\"tshirt_1\":15,\"mask_2\":0,\"age_2\":0,\"eyebrows_3\":0,\"chain_2\":0,\"glasses_1\":0,\"ears_1\":-1,\"bags_2\":0,\"ears_2\":0,\"torso_2\":0,\"bproof_2\":0,\"makeup_2\":0,\"eyebrows_1\":0,\"makeup_3\":0,\"pants_2\":0,\"beard_3\":0,\"hair_color_2\":4}', '{\"age_1\":0,\"glasses_2\":0,\"beard_1\":5,\"decals_2\":0,\"beard_4\":0,\"shoes_2\":0,\"tshirt_2\":0,\"lipstick_2\":0,\"hair_2\":0,\"arms\":72,\"pants_1\":45,\"skin\":29,\"eyebrows_2\":0,\"shoes\":10,\"helmet_1\":-1,\"lipstick_1\":0,\"helmet_2\":0,\"hair_color_1\":0,\"glasses\":0,\"makeup_4\":0,\"makeup_1\":0,\"hair_1\":2,\"bproof_1\":0,\"bags_1\":0,\"mask_1\":0,\"lipstick_3\":0,\"chain_1\":0,\"eyebrows_4\":0,\"sex\":1,\"torso_1\":49,\"beard_2\":6,\"shoes_1\":24,\"decals_1\":0,\"face\":19,\"lipstick_4\":0,\"tshirt_1\":9,\"mask_2\":0,\"age_2\":0,\"eyebrows_3\":0,\"chain_2\":0,\"glasses_1\":5,\"ears_1\":-1,\"bags_2\":0,\"ears_2\":0,\"torso_2\":0,\"bproof_2\":0,\"makeup_2\":0,\"eyebrows_1\":0,\"makeup_3\":0,\"pants_2\":0,\"beard_3\":0,\"hair_color_2\":4}'),
('garbage', 0, 'employee', 'Employee', 10, '{\"tshirt_1\":59,\"torso_1\":89,\"arms\":31,\"pants_1\":36,\"glasses_1\":19,\"decals_2\":0,\"hair_color_2\":0,\"helmet_2\":0,\"hair_color_1\":0,\"face\":2,\"glasses_2\":0,\"torso_2\":1,\"shoes\":35,\"hair_1\":0,\"skin\":0,\"sex\":0,\"glasses_1\":19,\"pants_2\":0,\"hair_2\":0,\"decals_1\":0,\"tshirt_2\":0,\"helmet_1\":5}', '{\"tshirt_1\":36,\"torso_1\":0,\"arms\":68,\"pants_1\":30,\"glasses_1\":15,\"decals_2\":0,\"hair_color_2\":0,\"helmet_2\":0,\"hair_color_1\":0,\"face\":27,\"glasses_2\":0,\"torso_2\":11,\"shoes\":26,\"hair_1\":5,\"skin\":0,\"sex\":1,\"glasses_1\":15,\"pants_2\":2,\"hair_2\":0,\"decals_1\":0,\"tshirt_2\":0,\"helmet_1\":19}'),
('daymson', 1, 'manager', 'Manager', 50, '{}', '{}'),
('daymson', 2, 'gerant', 'Gérant', 80, '{}', '{}'),
('daymson', 3, 'boss', 'Patron', 100, '{}', '{}'),
('ubereats', 0, 'recrue', 'Stagiaire', 15, '{}', '{}'),
('ubereats', 1, 'novice', 'Livreur', 20, '{}', '{}'),
('ubereats', 2, 'employe', 'Cuisinier', 25, '{}', '{}'),
('ubereats', 3, 'experimente', 'Expérimenté', 40, '{}', '{}'),
('ubereats', 4, 'chief', 'Chef cuisto', 75, '{}', '{}'),
('ubereats', 5, 'boss', 'Gérant', 100, '{}', '{}'),
('bennys', 3, 'gerant', 'Chef Atelier', 17, '{}', '{}'),
('banker', 1, 'banker', 'Banquier', 75, '{}', '{}'),
('banker', 3, 'resp', 'Responsable', 150, '{}', '{}'),
('banker', 4, 'boss', 'Directeur', 200, '{}', '{}'),
('rebelstudio', 0, 'stagiaire', 'Stagiaire', 1, '{}', '{}'),
('rebelstudio', 1, 'membre', 'Membre', 1, '{}', '{}'),
('rebelstudio', 2, 'artiste', 'Artiste', 1, '{}', '{}'),
('rebelstudio', 3, 'chef', 'Chef d’équipe', 20, '{}', '{}'),
('rebelstudio', 4, 'gerant', 'Gérant', 1, '{}', '{}'),
('rebelstudio', 5, 'boss', 'Patron', 1, '{}', '{}'),
('casino', 0, 'employee', 'Employé', 20, '{}', '{}'),
('banker', 0, 'secu', 'Agent de sécurité', 50, '{}', '{}'),
('ambulance', 2, 'ambulance', 'Infirmier Senior', 100, '{\"tshirt_2\":0,\"hair_color_1\":5,\"glasses_2\":3,\"shoes\":9,\"torso_2\":3,\"hair_color_2\":0,\"pants_1\":24,\"glasses_1\":4,\"hair_1\":2,\"sex\":0,\"decals_2\":0,\"tshirt_1\":15,\"helmet_1\":8,\"helmet_2\":0,\"arms\":92,\"face\":19,\"decals_1\":60,\"torso_1\":13,\"hair_2\":0,\"skin\":34,\"pants_2\":5}', '{\"tshirt_2\":3,\"decals_2\":0,\"glasses\":0,\"hair_1\":2,\"torso_1\":73,\"shoes\":1,\"hair_color_2\":0,\"glasses_1\":19,\"skin\":13,\"face\":6,\"pants_2\":5,\"tshirt_1\":75,\"pants_1\":37,\"helmet_1\":57,\"torso_2\":0,\"arms\":14,\"sex\":1,\"glasses_2\":0,\"decals_1\":0,\"hair_2\":0,\"helmet_2\":0,\"hair_color_1\":0}'),
('ambulance', 1, 'infirm', 'Infirmier', 90, '{\"tshirt_2\":0,\"hair_color_1\":5,\"glasses_2\":3,\"shoes\":9,\"torso_2\":3,\"hair_color_2\":0,\"pants_1\":24,\"glasses_1\":4,\"hair_1\":2,\"sex\":0,\"decals_2\":0,\"tshirt_1\":15,\"helmet_1\":8,\"helmet_2\":0,\"arms\":92,\"face\":19,\"decals_1\":60,\"torso_1\":13,\"hair_2\":0,\"skin\":34,\"pants_2\":5}', '{\"tshirt_2\":3,\"decals_2\":0,\"glasses\":0,\"hair_1\":2,\"torso_1\":73,\"shoes\":1,\"hair_color_2\":0,\"glasses_1\":19,\"skin\":13,\"face\":6,\"pants_2\":5,\"tshirt_1\":75,\"pants_1\":37,\"helmet_1\":57,\"torso_2\":0,\"arms\":14,\"sex\":1,\"glasses_2\":0,\"decals_1\":0,\"hair_2\":0,\"helmet_2\":0,\"hair_color_1\":0}'),
('ambulance', 4, 'doctor_ch', 'Medecin-Chirurgien', 150, '{\"tshirt_2\":0,\"hair_color_1\":5,\"glasses_2\":3,\"shoes\":9,\"torso_2\":3,\"hair_color_2\":0,\"pants_1\":24,\"glasses_1\":4,\"hair_1\":2,\"sex\":0,\"decals_2\":0,\"tshirt_1\":15,\"helmet_1\":8,\"helmet_2\":0,\"arms\":92,\"face\":19,\"decals_1\":60,\"torso_1\":13,\"hair_2\":0,\"skin\":34,\"pants_2\":5}', '{\"tshirt_2\":3,\"decals_2\":0,\"glasses\":0,\"hair_1\":2,\"torso_1\":73,\"shoes\":1,\"hair_color_2\":0,\"glasses_1\":19,\"skin\":13,\"face\":6,\"pants_2\":5,\"tshirt_1\":75,\"pants_1\":37,\"helmet_1\":57,\"torso_2\":0,\"arms\":14,\"sex\":1,\"glasses_2\":0,\"decals_1\":0,\"hair_2\":0,\"helmet_2\":0,\"hair_color_1\":0}'),
('ambulance', 5, 'doctor_chef', 'Medecin-Chef', 160, '{\"tshirt_2\":0,\"hair_color_1\":5,\"glasses_2\":3,\"shoes\":9,\"torso_2\":3,\"hair_color_2\":0,\"pants_1\":24,\"glasses_1\":4,\"hair_1\":2,\"sex\":0,\"decals_2\":0,\"tshirt_1\":15,\"helmet_1\":8,\"helmet_2\":0,\"arms\":92,\"face\":19,\"decals_1\":60,\"torso_1\":13,\"hair_2\":0,\"skin\":34,\"pants_2\":5}', '{\"tshirt_2\":3,\"decals_2\":0,\"glasses\":0,\"hair_1\":2,\"torso_1\":73,\"shoes\":1,\"hair_color_2\":0,\"glasses_1\":19,\"skin\":13,\"face\":6,\"pants_2\":5,\"tshirt_1\":75,\"pants_1\":37,\"helmet_1\":57,\"torso_2\":0,\"arms\":14,\"sex\":1,\"glasses_2\":0,\"decals_1\":0,\"hair_2\":0,\"helmet_2\":0,\"hair_color_1\":0}'),
('ambulance', 7, 'chief_doctor', 'Chirurgien', 180, '{\"tshirt_2\":0,\"hair_color_1\":5,\"glasses_2\":3,\"shoes\":9,\"torso_2\":3,\"hair_color_2\":0,\"pants_1\":24,\"glasses_1\":4,\"hair_1\":2,\"sex\":0,\"decals_2\":0,\"tshirt_1\":15,\"helmet_1\":8,\"helmet_2\":0,\"arms\":92,\"face\":19,\"decals_1\":60,\"torso_1\":13,\"hair_2\":0,\"skin\":34,\"pants_2\":5}', '{\"tshirt_2\":3,\"decals_2\":0,\"glasses\":0,\"hair_1\":2,\"torso_1\":73,\"shoes\":1,\"hair_color_2\":0,\"glasses_1\":19,\"skin\":13,\"face\":6,\"pants_2\":5,\"tshirt_1\":75,\"pants_1\":37,\"helmet_1\":57,\"torso_2\":0,\"arms\":14,\"sex\":1,\"glasses_2\":0,\"decals_1\":0,\"hair_2\":0,\"helmet_2\":0,\"hair_color_1\":0}'),
('police', 1, 'offi1', 'Officier I', 80, '{}', '{}'),
('police', 2, 'offi2', 'Officier II', 30, '{}', '{}'),
('police', 3, 'offi3', 'Officier III', 35, '{}', '{}'),
('police', 4, 's1', 'Sergent I', 40, '{}', '{}'),
('police', 5, 's2', 'Sergent II', 45, '{}', '{}'),
('police', 7, 'l1', 'Lieutenant I', 55, '{}', '{}'),
('bahamas', 1, 'vigile', 'Vigile', 40, '{}', '{}'),
('bahamas', 0, 'employe', 'Employé', 30, '{}', '{}'),
('bahamas', 2, 'danse', 'Manager', 50, '{}', '{}'),
('bahamas', 3, 'gerant', 'Gérant', 60, '{}', '{}'),
('bahamas', 4, 'boss', 'Patron', 80, '{}', '{}'),
('galaxy', 0, 'employe', 'Employé', 80, '{}', '{}'),
('galaxy', 1, 'vigile', 'Vigile', 80, '{}', '{}'),
('galaxy', 2, 'danse', 'Manager', 150, '{}', '{}'),
('galaxy', 3, 'gerant', 'Gérant', 150, '{}', '{}'),
('galaxy', 4, 'boss', 'Patron', 0, '{}', '{}'),
('avocat', 0, 'recrue', 'Apprenti', 0, '{}', '{}'),
('burgershot', 0, 'recrue', 'Stagiaire', 0, '{}', '{}'),
('burgershot', 1, 'novice', 'Livreur', 20, '{}', '{}'),
('burgershot', 2, 'employe', 'Cuisinier', 30, '{}', '{}'),
('burgershot', 3, 'experimente', 'Expérimenté', 40, '{}', '{}'),
('burgershot', 4, 'chief', 'Chef cuisto', 75, '{}', '{}'),
('burgershot', 5, 'boss', 'Gérant', 100, '{}', '{}');

-- --------------------------------------------------------

--
-- Structure de la table `jsfour_criminalrecord`
--

CREATE TABLE `jsfour_criminalrecord` (
  `offense` varchar(160) NOT NULL,
  `date` varchar(255) DEFAULT NULL,
  `institution` varchar(255) DEFAULT NULL,
  `charge` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `term` varchar(255) DEFAULT NULL,
  `classified` int(2) NOT NULL DEFAULT 0,
  `discord` varchar(255) DEFAULT NULL,
  `dob` varchar(255) DEFAULT NULL,
  `warden` varchar(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `jsfour_criminaluserinfo`
--

CREATE TABLE `jsfour_criminaluserinfo` (
  `discord` varchar(160) NOT NULL,
  `aliases` varchar(255) DEFAULT NULL,
  `recordid` varchar(255) DEFAULT NULL,
  `weight` varchar(255) DEFAULT NULL,
  `eyecolor` varchar(255) DEFAULT NULL,
  `haircolor` varchar(255) DEFAULT NULL,
  `firstname` varchar(255) DEFAULT NULL,
  `lastname` varchar(255) DEFAULT NULL,
  `dob` varchar(255) DEFAULT NULL,
  `sex` varchar(255) DEFAULT NULL,
  `height` varchar(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `licenses`
--

CREATE TABLE `licenses` (
  `type` varchar(60) NOT NULL,
  `label` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `licenses`
--

INSERT INTO `licenses` (`type`, `label`) VALUES
('aircraft', 'Permis Avion'),
('boating', 'Permis Bateau'),
('dmv', 'Code de la route'),
('drive', 'Permis de conduire'),
('drive_bike', 'Permis moto'),
('drive_truck', 'Permis camion'),
('weapon', 'Permis de port d\'arme');

-- --------------------------------------------------------

--
-- Structure de la table `licenses_points`
--

CREATE TABLE `licenses_points` (
  `id` int(11) NOT NULL,
  `owner` varchar(64) NOT NULL,
  `firstname` varchar(64) NOT NULL,
  `lastname` varchar(64) NOT NULL,
  `type` varchar(64) NOT NULL,
  `points` int(11) NOT NULL,
  `created` date NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `lrp_registromedico`
--

CREATE TABLE `lrp_registromedico` (
  `offense` varchar(160) NOT NULL,
  `date` varchar(255) DEFAULT NULL,
  `institution` varchar(255) DEFAULT NULL,
  `charge` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `term` varchar(255) DEFAULT NULL,
  `classified` int(2) NOT NULL DEFAULT 0,
  `discord` varchar(255) DEFAULT NULL,
  `dob` varchar(255) DEFAULT NULL,
  `warden` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `lrp_registromedicoinfo`
--

CREATE TABLE `lrp_registromedicoinfo` (
  `discord` varchar(160) NOT NULL,
  `aliases` varchar(255) DEFAULT NULL,
  `recordid` varchar(255) DEFAULT NULL,
  `weight` varchar(255) DEFAULT NULL,
  `eyecolor` varchar(255) DEFAULT NULL,
  `haircolor` varchar(255) DEFAULT NULL,
  `firstname` varchar(255) DEFAULT NULL,
  `lastname` varchar(255) DEFAULT NULL,
  `dob` varchar(255) DEFAULT NULL,
  `sex` varchar(255) DEFAULT NULL,
  `height` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `owned_properties`
--

CREATE TABLE `owned_properties` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `price` double NOT NULL,
  `rented` int(11) NOT NULL,
  `owner` varchar(60) NOT NULL,
  `society` varchar(64) DEFAULT NULL,
  `other_keys` text DEFAULT NULL,
  `soldby` varchar(50) DEFAULT NULL,
  `vehicleInGarage` varchar(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `owned_properties`
--

INSERT INTO `owned_properties` (`id`, `name`, `price`, `rented`, `owner`, `society`, `other_keys`, `soldby`, `vehicleInGarage`) VALUES
(4, 'Madrazo', 30000, 0, '', NULL, '', 'realestateagent', NULL),
(5, 'mannschaft', 15000, 0, '', NULL, '', 'realestateagent', NULL),
(6, 'bloods', 8000, 0, '', NULL, '', 'realestateagent', NULL),
(8, 'vercetti', 40000, 0, '', NULL, '', 'realestateagent', NULL),
(9, 'ballas', 13000, 0, '', NULL, '', 'realestateagent', NULL),
(24, 'vercettistock', 95000, 0, '', NULL, '', 'realestateagent', NULL),
(25, 'lspdcoffre', 30000, 0, '', NULL, '', 'realestateagent', NULL),
(26, 'appart_ruelle1', 100000, 0, '', NULL, '', 'realestateagent', NULL),
(27, 'appart_alta1', 50000, 0, '', NULL, '', 'realestateagent', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `owned_vehicles`
--

CREATE TABLE `owned_vehicles` (
  `owner` varchar(30) NOT NULL,
  `state` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Etat de la voiture',
  `garageperso` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Garage Personnel',
  `plate` varchar(12) NOT NULL,
  `vehicle` longtext DEFAULT NULL,
  `type` varchar(20) NOT NULL DEFAULT 'car',
  `job` varchar(20) DEFAULT NULL,
  `stored` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `phone_app_chat`
--

CREATE TABLE `phone_app_chat` (
  `id` int(11) NOT NULL,
  `channel` varchar(20) NOT NULL,
  `message` varchar(255) NOT NULL,
  `time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `phone_calls`
--

CREATE TABLE `phone_calls` (
  `id` int(11) NOT NULL,
  `owner` varchar(10) NOT NULL DEFAULT '' COMMENT 'Num tel proprio',
  `num` varchar(10) NOT NULL DEFAULT '' COMMENT 'Num reférence du contact',
  `incoming` int(11) NOT NULL COMMENT 'Défini si on est à l''origine de l''appels',
  `time` timestamp NOT NULL DEFAULT current_timestamp(),
  `accepts` int(11) NOT NULL COMMENT 'Appels accepter ou pas'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `phone_messages`
--

CREATE TABLE `phone_messages` (
  `id` int(11) NOT NULL,
  `transmitter` varchar(10) NOT NULL DEFAULT '',
  `receiver` varchar(10) NOT NULL,
  `message` varchar(255) NOT NULL DEFAULT '0',
  `time` timestamp NOT NULL DEFAULT current_timestamp(),
  `isRead` int(11) NOT NULL DEFAULT 0,
  `owner` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `phone_users_contacts`
--

CREATE TABLE `phone_users_contacts` (
  `id` int(11) NOT NULL,
  `discord` varchar(60) CHARACTER SET utf8mb4 DEFAULT NULL,
  `number` varchar(10) CHARACTER SET utf8mb4 DEFAULT NULL,
  `display` varchar(64) CHARACTER SET utf8mb4 NOT NULL DEFAULT '-1'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `phone_users_contacts2`
--

CREATE TABLE `phone_users_contacts2` (
  `id` int(11) NOT NULL,
  `sim` varchar(60) CHARACTER SET utf8mb4 DEFAULT NULL,
  `number` varchar(10) CHARACTER SET utf8mb4 DEFAULT NULL,
  `display` varchar(64) CHARACTER SET utf8mb4 NOT NULL DEFAULT '-1'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `police_bracelet`
--

CREATE TABLE `police_bracelet` (
  `id` int(11) NOT NULL,
  `target` varchar(64) DEFAULT NULL,
  `info` varchar(64) DEFAULT NULL,
  `lastPosition` varchar(256) NOT NULL DEFAULT '[]',
  `isActive` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `properties`
--

CREATE TABLE `properties` (
  `id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `label` varchar(255) DEFAULT NULL,
  `entering` varchar(255) DEFAULT NULL,
  `exit` varchar(255) DEFAULT NULL,
  `inside` varchar(255) DEFAULT NULL,
  `outside` varchar(255) DEFAULT NULL,
  `interiorId` int(11) NOT NULL DEFAULT 0,
  `ipls` varchar(255) DEFAULT '[]',
  `gateway` varchar(255) DEFAULT NULL,
  `is_single` int(11) DEFAULT NULL,
  `is_room` int(11) DEFAULT NULL,
  `is_gateway` int(11) UNSIGNED DEFAULT NULL,
  `open_house_radius` int(11) NOT NULL DEFAULT -1,
  `room_menu` varchar(255) DEFAULT NULL,
  `clothing_menu` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `soldby` varchar(50) DEFAULT NULL,
  `price` int(11) NOT NULL DEFAULT 0,
  `poids` int(11) NOT NULL DEFAULT 100,
  `garage` varchar(255) DEFAULT NULL,
  `GarageType` int(1) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `properties`
--

INSERT INTO `properties` (`id`, `name`, `label`, `entering`, `exit`, `inside`, `outside`, `interiorId`, `ipls`, `gateway`, `is_single`, `is_room`, `is_gateway`, `open_house_radius`, `room_menu`, `clothing_menu`, `type`, `soldby`, `price`, `poids`, `garage`, `GarageType`) VALUES
(49, 'appart_alta1', 'Appart Alta Street 1', '{\"y\":-82.86,\"z\":71.47,\"x\":144.5}', '{\"y\":-1007.18,\"z\":-102.01,\"x\":266.11}', '{\"y\":-1002.8,\"z\":-100.01,\"x\":265.31}', '{\"y\":-82.86,\"z\":73.47,\"x\":144.5}', 0, '[]', NULL, 1, 1, 0, -1, '{\"y\":-1002.86,\"z\":-100.01,\"x\":261.86}', '{\"y\":-1003.55,\"z\":-100.01,\"x\":259.9}', 'SimpleAppart', 'realestateagent', 100000, 350, '{\"y\":-76.53,\"z\":64.3,\"x\":129.37}', 3),
(48, 'appart_ruelle1', 'Appart Ruelle 1', '{\"z\":28.38,\"y\":-1032.73,\"x\":15.91}', '{\"z\":-100.2,\"y\":-1011.91,\"x\":346.69}', '{\"z\":-99.2,\"y\":-1011.91,\"x\":346.69}', '{\"z\":30.38,\"y\":-1032.73,\"x\":15.91}', 148225, '[]', NULL, 1, 1, 0, -1, '{\"z\":-100.2,\"y\":-999.31,\"x\":351.44}', '{\"z\":-100.15,\"y\":-994.26,\"x\":350.69}', 'MidCost', 'realestateagent', 100000, 300, '{\"z\":29.49,\"y\":-1032.05,\"x\":32.43}', 3),
(47, 'lspdcoffre', 'lspdcoffre', '{\"z\":29.69,\"y\":-1000.9,\"x\":486.86}', '{\"z\":-40.01,\"y\":-3099.66,\"x\":1104.54}', '{\"z\":-39.01,\"y\":-3099.54,\"x\":1102.38}', '{\"z\":31.69,\"y\":-1000.9,\"x\":486.86}', -60, '[]', NULL, 1, 1, 0, -1, '{\"z\":-40.01,\"y\":-3101.23,\"x\":1089.22}', NULL, 'LittleWarehouse', 'realestateagent', 30000, 500, '{\"z\":30.69,\"y\":-1015.19,\"x\":483.49}', 1),
(46, 'vercettistock', 'vercettistock', '{\"x\":-3035.88,\"z\":11.82,\"y\":78.46}', '{\"x\":1104.54,\"z\":-40.01,\"y\":-3099.66}', '{\"x\":1102.38,\"z\":-39.01,\"y\":-3099.54}', '{\"x\":-3035.88,\"z\":13.82,\"y\":78.46}', -60, '[]', NULL, 1, 1, 0, -1, '{\"x\":1089.22,\"z\":-40.01,\"y\":-3101.23}', NULL, 'LittleWarehouse', 'realestateagent', 95000, 500, '{\"x\":-2998.41,\"z\":21.66,\"y\":63.54}', 1),
(45, 'locuraentrepot', 'locuraentrepot', '{\"z\":31.79,\"x\":455.22,\"y\":-1579.71}', '{\"z\":-40.01,\"x\":1104.54,\"y\":-3099.66}', '{\"z\":-39.01,\"x\":1102.38,\"y\":-3099.54}', '{\"z\":33.79,\"x\":455.22,\"y\":-1579.71}', -60, '[]', NULL, 1, 1, 0, -1, '{\"z\":-40.01,\"x\":1089.22,\"y\":-3101.23}', NULL, 'LittleWarehouse', 'realestateagent', 95000, 500, '{\"z\":40.02,\"x\":453.09,\"y\":-1590.37}', 1),
(44, 'LocuraAppartQG', 'locura1', '{\"y\":-1558.94,\"z\":31.79,\"x\":430.78}', '{\"y\":-1007.18,\"z\":-102.01,\"x\":266.11}', '{\"y\":-1002.8,\"z\":-100.01,\"x\":265.31}', '{\"y\":-1558.94,\"z\":33.79,\"x\":430.78}', 0, '[]', NULL, 1, 1, 0, -1, '{\"y\":-1002.86,\"z\":-100.01,\"x\":261.86}', '{\"y\":-1003.55,\"z\":-100.01,\"x\":259.9}', 'SimpleAppart', 'realestateagent', 50000, 250, '{\"y\":-1559.0,\"z\":29.27,\"x\":422.59}', 3),
(34, 'bloods', 'bloods', '{\"x\":-1555.05,\"y\":-381.32,\"z\":40.98}', '{\"x\":151.57,\"y\":-1007.52,\"z\":-100.0}', '{\"x\":151.57,\"y\":-1007.52,\"z\":-99.0}', '{\"x\":-1555.05,\"y\":-381.32,\"z\":42.98}', 0, '[]', NULL, 1, 1, 0, -1, '{\"x\":153.74,\"y\":-1002.71,\"z\":-100.0}', '{\"x\":153.9,\"y\":-1001.0,\"z\":-100.0}', 'LowCost', 'realestateagent', 8000, 250, '{\"x\":-1563.71,\"y\":-387.56,\"z\":41.98}', 3),
(35, 'Madrazo', 'madrazo', '{\"x\":1413.9,\"y\":1115.89,\"z\":113.84}', '{\"x\":1104.54,\"y\":-3099.66,\"z\":-40.01}', '{\"x\":1102.38,\"y\":-3099.54,\"z\":-39.01}', '{\"x\":1413.9,\"y\":1115.89,\"z\":115.84}', -60, '[]', NULL, 1, 1, 0, -1, '{\"x\":1089.22,\"y\":-3101.23,\"z\":-40.01}', NULL, 'LittleWarehouse', 'realestateagent', 25000, 500, '{\"x\":1401.67,\"y\":1116.64,\"z\":114.84}', 3),
(36, 'mannschaft', 'mannschaft', '{\"z\":48.39,\"x\":-1819.04,\"y\":-373.98}', '{\"z\":-100.2,\"x\":346.69,\"y\":-1011.91}', '{\"z\":-99.2,\"x\":346.69,\"y\":-1011.91}', '{\"z\":50.39,\"x\":-1819.04,\"y\":-373.98}', 148225, '[]', NULL, 1, 1, 0, -1, '{\"z\":-100.2,\"x\":351.44,\"y\":-999.31}', '{\"z\":-100.15,\"x\":350.69,\"y\":-994.26}', 'MidCost', 'realestateagent', 15000, 250, '{\"z\":49.27,\"x\":-1845.4,\"y\":-366.0}', 3),
(38, 'vercetti', 'vercetti', '{\"x\":-3022.81,\"y\":82.39,\"z\":10.61}', '{\"x\":980.61,\"y\":56.59,\"z\":115.16}', '{\"x\":980.61,\"y\":56.59,\"z\":116.16}', '{\"x\":-3022.81,\"y\":82.39,\"z\":12.61}', -90, '[]', NULL, 1, 1, 0, -1, '{\"x\":973.65,\"y\":77.09,\"z\":115.18}', '{\"x\":984.92,\"y\":60.19,\"z\":115.16}', 'CasinoPenthouse', 'realestateagent', 40000, 500, '{\"x\":-3004.12,\"y\":85.46,\"z\":11.61}', 2),
(39, 'ballas', 'ballas', '{\"x\":114.11,\"y\":-1960.78,\"z\":20.34}', '{\"x\":266.11,\"y\":-1007.18,\"z\":-102.01}', '{\"x\":265.31,\"y\":-1002.8,\"z\":-100.01}', '{\"x\":114.11,\"y\":-1960.78,\"z\":22.34}', 0, '[]', NULL, 1, 1, 0, -1, '{\"x\":261.86,\"y\":-1002.86,\"z\":-100.01}', '{\"x\":259.9,\"y\":-1003.55,\"z\":-100.01}', 'SimpleAppart', 'realestateagent', 13000, 500, '{\"x\":116.61,\"y\":-1950.1,\"z\":20.75}', 3);

-- --------------------------------------------------------

--
-- Structure de la table `rented_bikes`
--

CREATE TABLE `rented_bikes` (
  `vehicle` varchar(60) NOT NULL,
  `plate` varchar(12) NOT NULL,
  `player_name` varchar(255) NOT NULL,
  `base_price` int(11) NOT NULL,
  `rent_price` int(11) NOT NULL,
  `owner` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `rented_vehicles`
--

CREATE TABLE `rented_vehicles` (
  `vehicle` varchar(60) NOT NULL,
  `plate` varchar(12) NOT NULL,
  `player_name` varchar(255) NOT NULL,
  `base_price` int(11) NOT NULL,
  `rent_price` int(11) NOT NULL,
  `owner` varchar(30) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `rented_vehicles`
--

INSERT INTO `rented_vehicles` (`vehicle`, `plate`, `player_name`, `base_price`, `rent_price`, `owner`) VALUES
('Novak', 'RENTUKRO', 'Keran Davis | namek', 125000, 10, 'discord:196038039611375616');

-- --------------------------------------------------------

--
-- Structure de la table `report`
--

CREATE TABLE `report` (
  `id` int(11) NOT NULL,
  `type` varchar(255) NOT NULL,
  `sonid` varchar(200) NOT NULL,
  `reporteur` varchar(255) DEFAULT NULL,
  `nomreporter` varchar(255) DEFAULT NULL,
  `raison` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `saved_cameras`
--

CREATE TABLE `saved_cameras` (
  `id` int(255) NOT NULL,
  `name` varchar(50) NOT NULL DEFAULT 'AUCUN',
  `groups` varchar(50) NOT NULL DEFAULT '0',
  `modelhash` int(30) DEFAULT NULL,
  `coords` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '{}'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `sheriff_bracelet`
--

CREATE TABLE `sheriff_bracelet` (
  `id` int(11) NOT NULL,
  `target` varchar(64) DEFAULT NULL,
  `info` varchar(64) DEFAULT NULL,
  `lastPosition` varchar(256) NOT NULL DEFAULT '[]',
  `isActive` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `shops`
--

CREATE TABLE `shops` (
  `id` int(11) NOT NULL,
  `store` varchar(100) NOT NULL,
  `item` varchar(100) NOT NULL,
  `price` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `shops`
--

INSERT INTO `shops` (`id`, `store`, `item`, `price`) VALUES
(29, 'LTDgasoline', 'kebab', 25),
(28, 'RobsLiquor', 'radio', 250),
(27, 'RobsLiquor', 'bread', 10),
(26, 'RobsLiquor', 'water', 10),
(25, 'LTDgasoline', 'bread', 10),
(24, 'LTDgasoline', 'water', 10),
(23, 'ToolsMag', 'hifi', 500),
(22, 'ToolsMag', 'brolly', 100),
(21, 'ToolsMag', 'hazmat1', 2500),
(20, 'ToolsMag', 'hazmat2', 2500),
(19, 'ToolsMag', 'hazmat3', 2500),
(18, 'ToolsMag', 'hazmat4', 2500),
(17, 'ToolsMag', 'magazine', 50),
(16, 'ToolsMag', 'mask_swim', 150),
(15, 'ToolsMag', 'skydiving', 3000),
(14, 'ToolsMag', 'jumelles', 1000),
(13, 'LTDgasoline', 'covid', 10),
(12, 'RobsLiquor', 'covid', 10),
(11, 'LTDgasoline', 'croquettes', 100),
(10, 'RobsLiquor', 'croquettes', 100),
(9, 'LTDgasoline', 'radio', 100),
(8, 'LTDgasoline', 'radio', 250),
(7, 'TwentyFourSeven', 'croquettes', 100),
(6, 'TwentyFourSeven', 'covid', 10),
(5, 'TwentyFourSeven', 'radio', 100),
(4, 'TwentyFourSeven', 'soda', 25),
(3, 'TwentyFourSeven', 'water', 10),
(2, 'TwentyFourSeven', 'kebab', 25),
(1, 'TwentyFourSeven', 'bread', 10),
(30, 'RobsLiquor', 'kebab', 25),
(31, 'LTDgasoline', 'soda', 25),
(32, 'RobsLiquor', 'soda', 25);

-- --------------------------------------------------------

--
-- Structure de la table `simcards`
--

CREATE TABLE `simcards` (
  `id` int(11) NOT NULL,
  `owner` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `type` int(11) NOT NULL DEFAULT 0,
  `number` int(11) NOT NULL,
  `active` tinyint(4) DEFAULT 1,
  `callPlan` int(11) NOT NULL DEFAULT 0,
  `smsPlan` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `sixt_current_vehicles`
--

CREATE TABLE `sixt_current_vehicles` (
  `id` int(11) NOT NULL,
  `vehicle` varchar(255) NOT NULL,
  `price` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `sixt_rented_vehicles`
--

CREATE TABLE `sixt_rented_vehicles` (
  `vehicle` varchar(60) NOT NULL,
  `plate` varchar(12) NOT NULL,
  `firstname` varchar(255) NOT NULL,
  `lastname` varchar(255) NOT NULL,
  `base_price` int(11) NOT NULL,
  `rent_price` int(11) NOT NULL,
  `owner` varchar(30) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `sixt_vehicles`
--

CREATE TABLE `sixt_vehicles` (
  `name` varchar(60) NOT NULL,
  `model` varchar(60) NOT NULL,
  `price` int(11) NOT NULL,
  `category` varchar(60) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `sixt_vehicles`
--

INSERT INTO `sixt_vehicles` (`name`, `model`, `price`, `category`) VALUES
('A45', 'a45amg', 5000, 'mercedes'),
('Gt63s', 'rmodgt63', 5000, 'mercedes'),
('g65', 'g65amg', 5000, 'mercedes'),
('C63', 'c63coupe', 5000, 'mercedes'),
('E63', 'e63amg', 5000, 'mercedes'),
('RS6', 'rs62', 5000, 'audi'),
('R8', 'r820', 5000, 'audi'),
('Q8', 'q820', 5000, 'audi'),
('Rs3', 'rs318', 5000, 'audi'),
('458', '458', 5000, 'ferrari'),
('250gto62', '250gto62', 5000, 'ferrari'),
('Urus', 'urus', 5000, 'lambo'),
('Aventadors', 'aventadors', 5000, 'lambo'),
('Macan', 'pm19', 5000, 'porsche'),
('Panam', 'panamera17turbo', 5000, 'porsche'),
('ClioV', 'ren_clio_5', 5000, 'autres'),
('BB', 'bbentayga', 5000, 'autres'),
('Golf7r', 'golf75r', 5000, 'autres'),
('RR', 'wraith', 5000, 'autres'),
('Range', '18Velar', 5000, 'autres'),
('M4comp', 'm4comp', 5000, 'bmw'),
('I8', 'rmodmi8', 5000, 'bmw'),
('M8', 'bmwm8', 5000, 'bmw'),
('M4Gts', 'rmodm4gts', 5000, 'bmw');

-- --------------------------------------------------------

--
-- Structure de la table `sixt_vehicle_categories`
--

CREATE TABLE `sixt_vehicle_categories` (
  `name` varchar(60) NOT NULL,
  `label` varchar(60) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `sixt_vehicle_categories`
--

INSERT INTO `sixt_vehicle_categories` (`name`, `label`) VALUES
('mercedes', 'Mercedes'),
('audi', 'Audi'),
('bmw', 'BMW'),
('ferrari', 'Ferrari'),
('lambo', 'Lambo'),
('moto', 'Moto'),
('porsche', 'Porsche'),
('autres', 'Autres');

-- --------------------------------------------------------

--
-- Structure de la table `trucks`
--

CREATE TABLE `trucks` (
  `name` varchar(60) NOT NULL,
  `model` varchar(60) NOT NULL,
  `price` int(11) NOT NULL,
  `category` varchar(60) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `trucks`
--

INSERT INTO `trucks` (`name`, `model`, `price`, `category`) VALUES
('Airport Bus', 'airbus', 50000, 'trans'),
('Benson', 'benson', 55000, 'box'),
('Biff', 'biff', 30000, 'other'),
('Boxville 1', 'boxville', 45000, 'box'),
('Boxville 2', 'boxville2', 45000, 'box'),
('Boxville 3', 'boxville3', 45000, 'box'),
('Boxville 4', 'boxville4', 45000, 'box'),
('Dozer', 'bulldozer', 20000, 'other'),
('Bus', 'bus', 50000, 'trans'),
('Dashound', 'coach', 50000, 'trans'),
('Hauler', 'hauler', 100000, 'haul'),
('Kenworth T440 Box', 'kenwort40b', 125000, 'customtrucks'),
('Kenworth T440 Dump', 'kenwort40d', 125000, 'customtrucks'),
('Kenworth T660', 'kenwort60s', 130000, 'customtrucks'),
('Kenworth T700', 'kenwort70s', 135000, 'customtrucks'),
('Mixer 1', 'mixer', 30000, 'other'),
('Mixer 2', 'mixer2', 30000, 'other'),
('Mule 1', 'mule', 40000, 'box'),
('Mule 2', 'mule2', 40000, 'box'),
('Mule 3', 'mule3', 40000, 'box'),
('Packer', 'packer', 100000, 'haul'),
('Festival Bus', 'pbus2', 125000, 'trans'),
('Peterbilt 289', 'petbilt289', 140000, 'customtrucks'),
('Phantom', 'phantom', 105000, 'haul'),
('Phantom Custom', 'phantom3', 110000, 'haul'),
('Pounder', 'pounder', 55000, 'box'),
('Rental Bus', 'rentalbus', 35000, 'trans'),
('Rubble', 'rubble', 30000, 'other'),
('Scrap Truck', 'scrap', 10000, 'other'),
('Tipper 1', 'tiptruck', 30000, 'other'),
('Tipper 2', 'tiptruck2', 30000, 'other'),
('Tour Bus', 'tourbus', 35000, 'trans'),
('Field Master', 'tractor2', 15000, 'other');

-- --------------------------------------------------------

--
-- Structure de la table `truck_categories`
--

CREATE TABLE `truck_categories` (
  `name` varchar(60) NOT NULL,
  `label` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `truck_categories`
--

INSERT INTO `truck_categories` (`name`, `label`) VALUES
('box', 'Boxed Trucks'),
('customtrucks', 'Custom Trucks'),
('haul', 'Haulers'),
('other', 'Other Trucks'),
('trans', 'Transport Trucks');

-- --------------------------------------------------------

--
-- Structure de la table `truck_inventory`
--

CREATE TABLE `truck_inventory` (
  `id` int(11) NOT NULL,
  `item` varchar(100) NOT NULL,
  `itemt` varchar(100) NOT NULL,
  `count` int(11) NOT NULL,
  `plate` varchar(8) NOT NULL,
  `name` varchar(255) NOT NULL,
  `owned` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Structure de la table `users`
--

CREATE TABLE `users` (
  `discord` varchar(64) COLLATE utf8mb4_bin NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_bin DEFAULT '',
  `skin` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `job` varchar(255) COLLATE utf8mb4_bin DEFAULT 'unemployed',
  `job_grade` int(11) DEFAULT 0,
  `faction` varchar(50) COLLATE utf8mb4_bin DEFAULT 'resid',
  `faction_grade` int(11) DEFAULT 0,
  `position` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `group` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `status` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `is_dead` tinyint(1) DEFAULT 0,
  `firstname` varchar(50) COLLATE utf8mb4_bin DEFAULT '',
  `lastname` varchar(50) COLLATE utf8mb4_bin DEFAULT '',
  `dateofbirth` varchar(25) COLLATE utf8mb4_bin DEFAULT '',
  `sex` varchar(10) COLLATE utf8mb4_bin DEFAULT '',
  `height` varchar(5) COLLATE utf8mb4_bin DEFAULT '',
  `phone_number` int(50) DEFAULT 0,
  `last_property` int(11) DEFAULT NULL,
  `tattoos` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `pet` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `vote` varchar(254) COLLATE utf8mb4_bin DEFAULT NULL,
  `inventory` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `accounts` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `last_update` datetime NOT NULL DEFAULT current_timestamp(),
  `insert_time` datetime NOT NULL DEFAULT current_timestamp(),
  `droppedInProperty` varchar(30) COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Structure de la table `user_licenses`
--

CREATE TABLE `user_licenses` (
  `id` int(11) NOT NULL,
  `type` varchar(60) NOT NULL,
  `owner` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Structure de la table `user_parkings`
--

CREATE TABLE `user_parkings` (
  `id` int(11) NOT NULL,
  `identifier` varchar(255) DEFAULT NULL,
  `plate` varchar(60) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `zone` longtext DEFAULT NULL,
  `vehicle` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `vehicles`
--

CREATE TABLE `vehicles` (
  `name` varchar(60) NOT NULL,
  `model` varchar(60) NOT NULL,
  `price` int(11) NOT NULL,
  `category` varchar(60) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `vehicles`
--

INSERT INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES
('Buccaneer', 'buccaneer', 12740, 'muscle'),
('Buccaneer Rider', 'buccaneer2', 16640, 'muscle'),
('Chino', 'chino', 10140, 'muscle'),
('Chino Luxe', 'chino2', 11440, 'muscle'),
('Coquette BlackFin', 'coquette3', 96135, 'muscle'),
('Dominator', 'dominator', 27040, 'muscle'),
('Dukes', 'dukes', 14560, 'muscle'),
('Gauntlet', 'gauntlet', 19240, 'muscle'),
('Hotknife', 'hotknife', 17680, 'muscle'),
('Faction', 'faction', 17160, 'muscle'),
('Faction Rider', 'faction2', 18200, 'muscle'),
('Faction XL', 'faction3', 11960, 'muscle'),
('Nightshade', 'nightshade', 104975, 'muscle'),
('Phoenix', 'phoenix', 23400, 'muscle'),
('Picador', 'picador', 11440, 'muscle'),
('Sabre Turbo', 'sabregt', 15600, 'muscle'),
('Sabre GT', 'sabregt2', 17680, 'muscle'),
('Slam Van', 'slamvan3', 8476, 'muscle'),
('Tampa', 'tampa', 12480, 'muscle'),
('Virgo', 'virgo', 12960, 'muscle'),
('Vigero', 'vigero', 14600, 'muscle'),
('Voodoo', 'voodoo', 4095, 'muscle'),
('Blista', 'blista', 4550, 'compacts'),
('Brioso R/A', 'brioso', 8400, 'compacts'),
('Issi', 'issi2', 2502, 'compacts'),
('Panto', 'panto', 4200, 'compacts'),
('Prairie', 'prairie', 8320, 'compacts'),
('Bison', 'bison', 31000, 'vans'),
('Bobcat XL', 'bobcatxl', 25500, 'vans'),
('Burrito', 'burrito3', 10400, 'vans'),
('Gang Burrito', 'gburrito2', 26000, 'vans'),
('Camper', 'camper', 31200, 'vans'),
('Lost Burrito', 'gburrito', 21500, 'vans'),
('Journey', 'journey', 15600, 'vans'),
('Minivan', 'minivan', 9100, 'vans'),
('Moonbeam', 'moonbeam', 9360, 'vans'),
('Moonbeam Rider', 'moonbeam2', 11440, 'vans'),
('Paradise', 'paradise', 10140, 'vans'),
('Rumpo', 'rumpo', 12000, 'vans'),
('Rumpo Trail', 'rumpo3', 25000, 'vans'),
('Surfer', 'surfer', 9360, 'vans'),
('Youga', 'youga', 9620, 'vans'),
('Youga Classique', 'youga2', 9360, 'vans'),
('Asea', 'asea', 8840, 'sedans'),
('Cognoscenti', 'cognoscenti', 17825, 'sedans'),
('Emperor', 'emperor', 5915, 'sedans'),
('Fugitive', 'fugitive', 9880, 'sedans'),
('Glendale', 'glendale', 9880, 'sedans'),
('Intruder', 'intruder', 8580, 'sedans'),
('Premier', 'premier', 5915, 'sedans'),
('Primo Custom', 'primo2', 14000, 'sedans'),
('Regina', 'regina', 3185, 'sedans'),
('Schafter', 'schafter2', 77350, 'sedans'),
('Limousine', 'stretch', 110500, 'sedans'),
('Super Diamond', 'superd', 55250, 'sedans'),
('Tailgater', 'tailgater', 10920, 'sedans'),
('Warrener', 'warrener', 8840, 'sedans'),
('Washington', 'washington', 13520, 'sedans'),
('Baller', 'baller2', 66300, 'suvs'),
('Baller Sport', 'baller3', 66300, 'suvs'),
('Cavalcade', 'cavalcade2', 8840, 'suvs'),
('Contender', 'contender', 110500, 'suvs'),
('Dubsta', 'dubsta', 36400, 'suvs'),
('Dubsta Luxuary', 'dubsta2', 122400, 'suvs'),
('Fhantom', 'fq2', 14000, 'suvs'),
('Granger', 'granger', 26000, 'suvs'),
('Gresley', 'gresley', 12792, 'suvs'),
('Huntley S', 'huntley', 60775, 'suvs'),
('Landstalker', 'landstalker', 75000, 'suvs'),
('Mesa', 'mesa', 10400, 'suvs'),
('Mesa Trail', 'mesa3', 31200, 'suvs'),
('Patriot', 'patriot', 65000, 'suvs'),
('Radius', 'radi', 11000, 'suvs'),
('Rocoto', 'rocoto', 36400, 'suvs'),
('Seminole', 'seminole', 9360, 'suvs'),
('XLS', 'xls', 44200, 'suvs'),
('Btype', 'btype', 88400, 'sportsclassics'),
('Btype Luxe', 'btype3', 110500, 'sportsclassics'),
('Btype Hotroad', 'btype2', 119000, 'sportsclassics'),
('Casco', 'casco', 108290, 'sportsclassics'),
('Coquette Classic', 'coquette2', 69135, 'sportsclassics'),
('Manana', 'manana', 8320, 'sportsclassics'),
('Monroe', 'monroe', 104975, 'sportsclassics'),
('Pigalle', 'pigalle', 23660, 'sportsclassics'),
('Stinger', 'stinger', 88400, 'sportsclassics'),
('Stinger GT', 'stingergt', 110500, 'sportsclassics'),
('Stirling GT', 'feltzer3', 140400, 'sportsclassics'),
('Z-Type', 'ztype', 194400, 'sportsclassics'),
('Bifta', 'bifta', 9360, 'offroad'),
('Bf Injection', 'bfinjection', 13520, 'offroad'),
('Blazer', 'blazer', 5700, 'offroad'),
('Blazer Sport', 'blazer4', 7500, 'offroad'),
('Brawler', 'brawler', 122400, 'offroad'),
('Dubsta 6x6', 'dubsta3', 44200, 'offroad'),
('Dune Buggy', 'dune', 9360, 'offroad'),
('Guardian', 'guardian', 82875, 'offroad'),
('Rebel', 'rebel2', 11440, 'offroad'),
('Sandking', 'sandking', 36400, 'offroad'),
('Cognoscenti Cabrio', 'cogcabrio', 77350, 'coupes'),
('Exemplar', 'exemplar', 49725, 'coupes'),
('F620', 'f620', 60775, 'coupes'),
('Felon', 'felon', 44200, 'coupes'),
('Felon GT', 'felon2', 36000, 'coupes'),
('Jackal', 'jackal', 44200, 'coupes'),
('Oracle XS', 'oracle2', 48000, 'coupes'),
('Sentinel', 'sentinel', 22880, 'coupes'),
('Sentinel XS', 'sentinel2', 27880, 'coupes'),
('Windsor', 'windsor', 82400, 'coupes'),
('Windsor Drop', 'windsor2', 94900, 'coupes'),
('Zion', 'zion', 26000, 'coupes'),
('Zion Cabrio', 'zion2', 31200, 'coupes'),
('9F', 'ninef', 110500, 'sports'),
('9F Cabrio', 'ninef2', 101660, 'sports'),
('Alpha', 'alpha', 49725, 'sports'),
('Banshee', 'banshee', 57350, 'sports'),
('Bestia GTS', 'bestiagts', 110500, 'sports'),
('Buffalo', 'buffalo', 26640, 'sports'),
('Buffalo S', 'buffalo2', 52800, 'sports'),
('Carbonizzare', 'carbonizzare', 107100, 'sports'),
('Comet', 'comet2', 104975, 'sports'),
('Coquette', 'coquette', 82875, 'sports'),
('Elegy', 'elegy2', 99450, 'sports'),
('Feltzer', 'feltzer2', 83427, 'sports'),
('Furore GT', 'furoregt', 110500, 'sports'),
('Fusilade', 'fusilade', 15600, 'sports'),
('Jester', 'jester', 88400, 'sports'),
('Khamelion', 'khamelion', 82875, 'sports'),
('Kuruma', 'kuruma', 60775, 'sports'),
('Lynx', 'lynx', 104975, 'sports'),
('Mamba', 'mamba', 112200, 'sports'),
('Massacro', 'massacro', 112200, 'sports'),
('Penumbra', 'penumbra', 14560, 'sports'),
('Rapid GT', 'rapidgt', 93925, 'sports'),
('Rapid GT 2', 'rapidgt2', 96135, 'sports'),
('Schafter V12', 'schafter3', 71825, 'sports'),
('Seven 70', 'seven70', 107100, 'sports'),
('Surano', 'surano', 99450, 'sports'),
('Tropos', 'tropos', 88400, 'sports'),
('Verlierer', 'verlierer2', 107100, 'sportsclassics'),
('Adder', 'adder', 405200, 'super'),
('Banshee 900R', 'banshee2', 122400, 'super'),
('Bullet', 'bullet', 99450, 'super'),
('Cheetah', 'cheetah', 122400, 'super'),
('Entity XF', 'entityxf', 202500, 'super'),
('Infernus', 'infernus', 122400, 'super'),
('Osiris', 'osiris', 117300, 'super'),
('Pfister', 'pfister811', 396900, 'super'),
('Reaper', 'reaper', 172800, 'super'),
('Turismo R', 'turismor', 202950, 'super'),
('Vacca', 'vacca', 122400, 'super'),
('Zentorno', 'zentorno', 183600, 'super'),
('Futo', 'futo', 12480, 'sports'),
('Jester Classic', 'jester3', 75140, 'sportsclassics'),
('Ardent', 'ardent', 200000, 'sportsclassics'),
('Schlagen GT', 'schlagen', 183600, 'sports'),
('Retinue', 'retinue', 23920, 'sportsclassics'),
('Rapid GT3', 'rapidgt3', 104975, 'sportsclassics'),
('Yosemite', 'yosemite', 82322, 'muscle'),
('Pariah', 'pariah', 117300, 'sports'),
('Stromberg', 'stromberg', 170000, 'sportsclassics'),
('SC 1', 'sc1', 183600, 'super'),
('riata', 'riata', 36400, 'offroad'),
('Hermes', 'hermes', 55250, 'muscle'),
('Savestra', 'savestra', 24960, 'sportsclassics'),
('Streiter', 'streiter', 155250, 'suvs'),
('Kamacho', 'kamacho', 44200, 'offroad'),
('GT 500', 'gt500', 112200, 'sportsclassics'),
('Z190', 'z190', 88400, 'sportsclassics'),
('Viseris', 'viseris', 205000, 'sportsclassics'),
('Comet 5', 'comet5', 112200, 'sports'),
('Revolter', 'revolter', 88400, 'sports'),
('Sentinel Classic', 'sentinel3', 75000, 'sportsclassics'),
('Hustler', 'hustler', 20800, 'muscle'),
('Toros', 'toros', 140400, 'suvs'),
('Blade', 'blade', 10400, 'muscle'),
('Neo', 'neo', 194400, 'sports'),
('Gauntlet Sport', 'gauntlet4', 99450, 'muscle'),
('Caracara 2', 'caracara2', 115000, 'offroad'),
('Novak', 'Novak', 111500, 'suvs'),
('Locust', 'locust', 107100, 'sports'),
('Hellion', 'hellion', 75000, 'offroad'),
('Dynasty', 'Dynasty', 9880, 'sportsclassics'),
('Gauntlet 3', 'gauntlet3', 31200, 'muscle'),
('Zion Classic', 'zion3', 80000, 'sportsclassics'),
('Nebula', 'nebula', 18920, 'sportsclassics'),
('8F Drafter', 'drafter', 112200, 'sports'),
('Tulip', 'tulip', 9880, 'muscle'),
('Elegy Retro Custom', 'elegy', 170000, 'sportsclassics'),
('Asbo', 'asbo', 3412, 'compacts'),
('Everon', 'everon', 110000, 'offroad'),
('jb7002', 'jb7002', 250000, 'sportsclassics'),
('kanjo', 'kanjo', 15600, 'compacts'),
('Komoda', 'komoda', 107100, 'sports'),
('Outlaw', 'outlaw', 12480, 'offroad'),
('Rebla GTS', 'rebla', 250000, 'suvs'),
('Retinue2', 'retinue2', 24400, 'sportsclassics'),
('Rhapsody', 'rhapsody', 4550, 'compacts'),
('Sugoi', 'sugoi', 64090, 'sports'),
('Vagrant', 'vagrant', 26000, 'offroad'),
('VSTR', 'vstr', 112200, 'sports'),
('Sanchez Sport', 'sanchez2', 5400, 'motorcycles'),
('Sanchez', 'sanchez', 5100, 'motorcycles'),
('Ruffian', 'ruffian', 5400, 'motorcycles'),
('PCJ-600', 'pcj', 4800, 'motorcycles'),
('Nightblade', 'nightblade', 12600, 'motorcycles'),
('Nemesis', 'nemesis', 6000, 'motorcycles'),
('Manchez', 'manchez', 6000, 'motorcycles'),
('Innovation', 'innovation', 14000, 'motorcycles'),
('Hexer', 'hexer', 7800, 'motorcycles'),
('Hakuchou', 'hakuchou', 17500, 'motorcycles'),
('Gargoyle', 'gargoyle', 10500, 'motorcycles'),
('Fixter (velo)', 'fixter', 400, 'motorcycles'),
('Vespa', 'faggio2', 3200, 'motorcycles'),
('Faggio', 'faggio', 1600, 'motorcycles'),
('Esskey', 'esskey', 5400, 'motorcycles'),
('Enduro', 'enduro', 6000, 'motorcycles'),
('Double T', 'double', 14000, 'motorcycles'),
('Defiler', 'defiler', 9000, 'motorcycles'),
('Daemon High', 'daemon2', 6000, 'motorcycles'),
('Daemon', 'daemon', 5600, 'motorcycles'),
('Cruiser (velo)', 'cruiser', 300, 'motorcycles'),
('Cliffhanger', 'cliffhanger', 8400, 'motorcycles'),
('Chimera', 'chimera', 21000, 'motorcycles'),
('Carbon RS', 'carbonrs', 14000, 'motorcycles'),
('BMX (velo)', 'bmx', 350, 'motorcycles'),
('BF400', 'bf400', 9600, 'motorcycles'),
('Bati 801RR', 'bati2', 16800, 'motorcycles'),
('Bati 801', 'bati', 14000, 'motorcycles'),
('Bagger', 'bagger', 16100, 'motorcycles'),
('Avarus', 'avarus', 10500, 'motorcycles'),
('Akuma', 'AKUMA', 11200, 'motorcycles'),
('Sanctus', 'sanctus', 8450, 'motorcycles'),
('Scorcher (velo)', 'scorcher', 700, 'motorcycles'),
('Sovereign', 'sovereign', 16100, 'motorcycles'),
('Thrust', 'thrust', 14000, 'motorcycles'),
('Tri bike (velo)', 'tribike3', 550, 'motorcycles'),
('Vader', 'vader', 6000, 'motorcycles'),
('Vortex', 'vortex', 7500, 'motorcycles'),
('Woflsbane', 'wolfsbane', 7200, 'motorcycles'),
('Zombie', 'zombiea', 7000, 'motorcycles'),
('Zombie Luxuary', 'zombieb', 7700, 'motorcycles');

-- --------------------------------------------------------

--
-- Structure de la table `vehicle_categories`
--

CREATE TABLE `vehicle_categories` (
  `name` varchar(60) NOT NULL,
  `label` varchar(60) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `vehicle_categories`
--

INSERT INTO `vehicle_categories` (`name`, `label`) VALUES
('compacts', 'Compacts'),
('coupes', 'Coupés'),
('sedans', 'Sedans'),
('sports', 'Sports'),
('sportsclassics', 'Sports Classics'),
('super', 'Super'),
('muscle', 'Muscle'),
('offroad', 'Off Road'),
('suvs', 'SUVs'),
('vans', 'Vans'),
('import', 'Importé'),
('dlc', 'DLC'),
('motorcycles', 'Motos');

-- --------------------------------------------------------

--
-- Structure de la table `vehicle_keys`
--

CREATE TABLE `vehicle_keys` (
  `id` int(11) NOT NULL,
  `discord` varchar(255) NOT NULL,
  `label` varchar(255) DEFAULT NULL,
  `value` varchar(50) DEFAULT NULL,
  `NB` int(11) DEFAULT 0,
  `time` datetime DEFAULT curtime()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Structure de la table `vehicle_sold`
--

CREATE TABLE `vehicle_sold` (
  `client` varchar(50) NOT NULL,
  `model` varchar(50) NOT NULL,
  `plate` varchar(50) NOT NULL,
  `soldby` varchar(50) NOT NULL,
  `date` varchar(50) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `addon_account`
--
ALTER TABLE `addon_account`
  ADD PRIMARY KEY (`name`);

--
-- Index pour la table `addon_account_data`
--
ALTER TABLE `addon_account_data`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `Index 3` (`account_name`,`owner`);

--
-- Index pour la table `addon_inventory`
--
ALTER TABLE `addon_inventory`
  ADD PRIMARY KEY (`name`);

--
-- Index pour la table `addon_inventory_items`
--
ALTER TABLE `addon_inventory_items`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `index_addon_inventory_items_inventory_name_name_owner` (`inventory_name`,`name`,`owner`) USING BTREE,
  ADD KEY `index_addon_inventory_items_inventory_name_name` (`inventory_name`,`name`),
  ADD KEY `index_addon_inventory_inventory_name` (`inventory_name`);

--
-- Index pour la table `aircrafts`
--
ALTER TABLE `aircrafts`
  ADD PRIMARY KEY (`model`);

--
-- Index pour la table `aircraft_categories`
--
ALTER TABLE `aircraft_categories`
  ADD PRIMARY KEY (`name`);

--
-- Index pour la table `baninfo`
--
ALTER TABLE `baninfo`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `bank_history`
--
ALTER TABLE `bank_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Index 2` (`discord`);

--
-- Index pour la table `banlist`
--
ALTER TABLE `banlist`
  ADD PRIMARY KEY (`license`);

--
-- Index pour la table `banlisthistory`
--
ALTER TABLE `banlisthistory`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `bikedealer_vehicles`
--
ALTER TABLE `bikedealer_vehicles`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `bikes`
--
ALTER TABLE `bikes`
  ADD PRIMARY KEY (`model`);

--
-- Index pour la table `bike_categories`
--
ALTER TABLE `bike_categories`
  ADD PRIMARY KEY (`name`);

--
-- Index pour la table `bike_sold`
--
ALTER TABLE `bike_sold`
  ADD PRIMARY KEY (`plate`);

--
-- Index pour la table `billing`
--
ALTER TABLE `billing`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `boats`
--
ALTER TABLE `boats`
  ADD PRIMARY KEY (`model`);

--
-- Index pour la table `boat_categories`
--
ALTER TABLE `boat_categories`
  ADD PRIMARY KEY (`name`);

--
-- Index pour la table `cardealer_vehicles`
--
ALTER TABLE `cardealer_vehicles`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `crash_data`
--
ALTER TABLE `crash_data`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `datastore`
--
ALTER TABLE `datastore`
  ADD PRIMARY KEY (`name`);

--
-- Index pour la table `datastore_data`
--
ALTER TABLE `datastore_data`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `Index 3` (`name`,`owner`),
  ADD KEY `index_datastore_data_name` (`name`);

--
-- Index pour la table `factions`
--
ALTER TABLE `factions`
  ADD PRIMARY KEY (`name`);

--
-- Index pour la table `faction_grades`
--
ALTER TABLE `faction_grades`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `fine_types`
--
ALTER TABLE `fine_types`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `fine_types_gouv`
--
ALTER TABLE `fine_types_gouv`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `groups_cameras`
--
ALTER TABLE `groups_cameras`
  ADD PRIMARY KEY (`name`),
  ADD KEY `label` (`label`);

--
-- Index pour la table `h4ci_report`
--
ALTER TABLE `h4ci_report`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`name`);

--
-- Index pour la table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`name`);

--
-- Index pour la table `job_grades`
--
ALTER TABLE `job_grades`
  ADD KEY `job_name` (`job_name`);

--
-- Index pour la table `jsfour_criminalrecord`
--
ALTER TABLE `jsfour_criminalrecord`
  ADD PRIMARY KEY (`offense`);

--
-- Index pour la table `jsfour_criminaluserinfo`
--
ALTER TABLE `jsfour_criminaluserinfo`
  ADD PRIMARY KEY (`discord`) USING BTREE;

--
-- Index pour la table `licenses`
--
ALTER TABLE `licenses`
  ADD PRIMARY KEY (`type`);

--
-- Index pour la table `licenses_points`
--
ALTER TABLE `licenses_points`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `lrp_registromedico`
--
ALTER TABLE `lrp_registromedico`
  ADD PRIMARY KEY (`offense`);

--
-- Index pour la table `lrp_registromedicoinfo`
--
ALTER TABLE `lrp_registromedicoinfo`
  ADD PRIMARY KEY (`discord`) USING BTREE;

--
-- Index pour la table `owned_properties`
--
ALTER TABLE `owned_properties`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `owned_vehicles`
--
ALTER TABLE `owned_vehicles`
  ADD PRIMARY KEY (`plate`),
  ADD KEY `Index 2` (`owner`);

--
-- Index pour la table `phone_app_chat`
--
ALTER TABLE `phone_app_chat`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `phone_calls`
--
ALTER TABLE `phone_calls`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_phone_calls_simcards` (`owner`),
  ADD KEY `FK_phone_calls_simcards_2` (`num`);

--
-- Index pour la table `phone_messages`
--
ALTER TABLE `phone_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `transmitter_index` (`transmitter`),
  ADD KEY `receiver_index` (`receiver`);

--
-- Index pour la table `phone_users_contacts`
--
ALTER TABLE `phone_users_contacts`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `phone_users_contacts2`
--
ALTER TABLE `phone_users_contacts2`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sim` (`sim`),
  ADD KEY `number` (`number`),
  ADD KEY `display` (`display`);

--
-- Index pour la table `police_bracelet`
--
ALTER TABLE `police_bracelet`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `properties`
--
ALTER TABLE `properties`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `Unique names` (`name`) USING BTREE;

--
-- Index pour la table `rented_bikes`
--
ALTER TABLE `rented_bikes`
  ADD PRIMARY KEY (`plate`);

--
-- Index pour la table `rented_vehicles`
--
ALTER TABLE `rented_vehicles`
  ADD PRIMARY KEY (`plate`);

--
-- Index pour la table `report`
--
ALTER TABLE `report`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `saved_cameras`
--
ALTER TABLE `saved_cameras`
  ADD PRIMARY KEY (`id`),
  ADD KEY `name` (`name`),
  ADD KEY `coords` (`coords`(768)),
  ADD KEY `group` (`groups`),
  ADD KEY `modelhash` (`modelhash`);

--
-- Index pour la table `sheriff_bracelet`
--
ALTER TABLE `sheriff_bracelet`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `shops`
--
ALTER TABLE `shops`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `simcards`
--
ALTER TABLE `simcards`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `number` (`number`),
  ADD KEY `owner` (`owner`);

--
-- Index pour la table `sixt_current_vehicles`
--
ALTER TABLE `sixt_current_vehicles`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `sixt_rented_vehicles`
--
ALTER TABLE `sixt_rented_vehicles`
  ADD PRIMARY KEY (`plate`);

--
-- Index pour la table `sixt_vehicles`
--
ALTER TABLE `sixt_vehicles`
  ADD PRIMARY KEY (`model`);

--
-- Index pour la table `sixt_vehicle_categories`
--
ALTER TABLE `sixt_vehicle_categories`
  ADD PRIMARY KEY (`name`);

--
-- Index pour la table `trucks`
--
ALTER TABLE `trucks`
  ADD PRIMARY KEY (`model`);

--
-- Index pour la table `truck_categories`
--
ALTER TABLE `truck_categories`
  ADD PRIMARY KEY (`name`);

--
-- Index pour la table `truck_inventory`
--
ALTER TABLE `truck_inventory`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `item` (`item`,`plate`);

--
-- Index pour la table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`discord`),
  ADD KEY `Index 2` (`name`);

--
-- Index pour la table `user_licenses`
--
ALTER TABLE `user_licenses`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `user_parkings`
--
ALTER TABLE `user_parkings`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `vehicles`
--
ALTER TABLE `vehicles`
  ADD PRIMARY KEY (`model`);

--
-- Index pour la table `vehicle_categories`
--
ALTER TABLE `vehicle_categories`
  ADD PRIMARY KEY (`name`);

--
-- Index pour la table `vehicle_keys`
--
ALTER TABLE `vehicle_keys`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `vehicle_sold`
--
ALTER TABLE `vehicle_sold`
  ADD PRIMARY KEY (`plate`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `addon_account_data`
--
ALTER TABLE `addon_account_data`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=64;

--
-- AUTO_INCREMENT pour la table `addon_inventory_items`
--
ALTER TABLE `addon_inventory_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2094;

--
-- AUTO_INCREMENT pour la table `baninfo`
--
ALTER TABLE `baninfo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `bank_history`
--
ALTER TABLE `bank_history`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `banlisthistory`
--
ALTER TABLE `banlisthistory`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=499;

--
-- AUTO_INCREMENT pour la table `bikedealer_vehicles`
--
ALTER TABLE `bikedealer_vehicles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1051;

--
-- AUTO_INCREMENT pour la table `billing`
--
ALTER TABLE `billing`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `cardealer_vehicles`
--
ALTER TABLE `cardealer_vehicles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2382;

--
-- AUTO_INCREMENT pour la table `crash_data`
--
ALTER TABLE `crash_data`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT pour la table `datastore_data`
--
ALTER TABLE `datastore_data`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT pour la table `faction_grades`
--
ALTER TABLE `faction_grades`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=141;

--
-- AUTO_INCREMENT pour la table `fine_types`
--
ALTER TABLE `fine_types`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT pour la table `fine_types_gouv`
--
ALTER TABLE `fine_types_gouv`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `h4ci_report`
--
ALTER TABLE `h4ci_report`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT pour la table `licenses_points`
--
ALTER TABLE `licenses_points`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `owned_properties`
--
ALTER TABLE `owned_properties`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT pour la table `phone_app_chat`
--
ALTER TABLE `phone_app_chat`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT pour la table `phone_calls`
--
ALTER TABLE `phone_calls`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10827;

--
-- AUTO_INCREMENT pour la table `phone_messages`
--
ALTER TABLE `phone_messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26261;

--
-- AUTO_INCREMENT pour la table `phone_users_contacts`
--
ALTER TABLE `phone_users_contacts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1978;

--
-- AUTO_INCREMENT pour la table `phone_users_contacts2`
--
ALTER TABLE `phone_users_contacts2`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `police_bracelet`
--
ALTER TABLE `police_bracelet`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT pour la table `properties`
--
ALTER TABLE `properties`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=50;

--
-- AUTO_INCREMENT pour la table `report`
--
ALTER TABLE `report`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `saved_cameras`
--
ALTER TABLE `saved_cameras`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `sheriff_bracelet`
--
ALTER TABLE `sheriff_bracelet`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `shops`
--
ALTER TABLE `shops`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT pour la table `simcards`
--
ALTER TABLE `simcards`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=939;

--
-- AUTO_INCREMENT pour la table `sixt_current_vehicles`
--
ALTER TABLE `sixt_current_vehicles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1165;

--
-- AUTO_INCREMENT pour la table `truck_inventory`
--
ALTER TABLE `truck_inventory`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3419;

--
-- AUTO_INCREMENT pour la table `user_licenses`
--
ALTER TABLE `user_licenses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5010;

--
-- AUTO_INCREMENT pour la table `user_parkings`
--
ALTER TABLE `user_parkings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1168;

--
-- AUTO_INCREMENT pour la table `vehicle_keys`
--
ALTER TABLE `vehicle_keys`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
