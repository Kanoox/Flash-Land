Config = {}
Config.Locale = 'fr'

Config.PoundPrice = {
	car = 1000,
	boat = 3000,
	aircraft = 7500,
}

Config.DrawDistance = 40.0

Config.BlipGarage = {
	Color = 38,
	Display = 2,
	Scale = 0.7
}

Config.BlipGaragePrivate = {
	Sprite = 290,
	Color = 53,
	Display = 2,
	Scale = 0.7
}

Config.BlipPound = {
	Sprite = 67,
	Color = 64,
	Display = 2,
	Scale = 0.7
}

Config.PointMarker = {
	r = 0, g = 255, b = 0, -- Green Color
	x = 1.5, y = 1.5, z = 1.0  -- Standard Size Circle
}

Config.DeleteMarker = {
	r = 255, g = 0, b = 0, -- Red Color
	x = 3.5, y = 3.5, z = 0.7  -- Big Size Circle
}

Config.PoundMarker = {
	r = 0, g = 0, b = 100, -- Blue Color
	x = 1.5, y = 1.5, z = 1.0  -- Standard Size Circle
}

Config.Garages = {
	Garage_Sandy = {
		Type = 'car',
		GaragePoint = vector3(1737.59, 3710.2, 34.14),
		SpawnPoint = vector4(1737.84, 3719.28, 33.04, 21.22),
		DeletePoint = vector3(1722.66, 3713.74, 33.21)
	},
	Garage_Paleto = {
		Type = 'car',
		GaragePoint = vector3(105.359, 6613.586, 32.3973),
		SpawnPoint = vector4(128.7822, 6622.9965, 30.7828, 315.01),
		DeletePoint = vector3(126.3572, 6608.4150, 30.8565)
	},
	Garage_Central = {
		Type = 'car',
		GaragePoint = vector3(215.45, -809.96, 30.74),
		SpawnPoint = vector4(230.93, -799.79, 29.95, 159.29),
		DeletePoint = vector3(224.58, -757.53, 29.50)
	},
	Garage_Prison = {
		Type = 'car',
		GaragePoint = vector3(1846.56, 2585.86, 45.67),
		SpawnPoint = vector4(1855.11, 2592.72, 44.67, 274.8),
		DeletePoint = vector3(1855.21, 2615.3, 34.67)
	},
	Garage_RaceTrack = {
		Type = 'car',
		GaragePoint = vector3(1212.32, 339.94, 81.99),
		SpawnPoint = vector4(1199.02, 330.92, 80.99, 144.86),
		DeletePoint = vector3(1207.9, 343.8, 80.99)
	},
	Garage_DelPerro = {
		Type = 'car',
		GaragePoint = vector3(-2026.967, -469.887, 11.402),
		SpawnPoint = vector4(-2026.967, -469.887, 10.502, 319.86),
		DeletePoint = vector3(-2034.7, -463.0, 10.406)
	},
	Garage_AeroportLS = {
		Type = 'car',
		GaragePoint = vector3(-977.216, -2710.379, 13.853),
		SpawnPoint = vector4(-977.216, -2710.379, 13.853, 346.05),
		DeletePoint = vector3(-966.8, -2709.9, 12.8)
	},
	Garage_NightClub = {
		Type = 'car',
		GaragePoint = vector3(-340.893, 266.831, 85.679),
		SpawnPoint = vector4(-341.989, 271.862, 85.535, 269.65),
		DeletePoint = vector3(-334.5, 300.9, 84.81)
	},
	Garage_ShopPlage = {
		Type = 'car',
		GaragePoint = vector3(-3047.690, 590.298, 7.762),
		SpawnPoint = vector4(-3051.117, 597.080, 6.762, 287.03),
		DeletePoint = vector3(-3049.3, 610.1, 6.1)
	},
	Garage_Bennys = {
		Type = 'car',
		GaragePoint = vector3(-192.56, -1280.79, 31.28),
		SpawnPoint = vector4(-190.67, -1285.38, 30.64, 269.83),
		DeletePoint = vector3(-191.1, -1290.64, 31.3-1)
	},
	Garage_Cayo = {
		Type = 'car',
		GaragePoint = vector3(4987.45, -5146.04, 2.47),
		SpawnPoint = vector4(4985.86, -5149.64, 1.88, 192.40),
		DeletePoint = vector3(4985.86, -5149.64, 1.88-1)
	},


	Garage_CayoDock = {
		Type = 'boat',
		GaragePoint = vector3(4949.91, -5151.73, 2.46),
		SpawnPoint = vector4(4943.29, -5142.65, 0.12, 67.16),
		DeletePoint = vector3(4943.29, -5142.65, 0.12)
	},
	Garage_CayoDock2 = {
		Type = 'boat',
		GaragePoint = vector3(5153.41, -4656.53, 1.44),
		SpawnPoint = vector4(5147.48, -4659.83, 0.8, 174.15),
		DeletePoint = vector3(5157.14, -4660.17, 0.8)

	},
	Garage_LSDock = {
		Type = 'boat',
		GaragePoint = vector3(-737.74, -1326.63, 1.6),
		SpawnPoint = vector4(-718.87, -1320.18, -0.47, 45.0),
		DeletePoint = vector3(-731.15, -1334.71, -0.47)
	},
	Garage_SandyDock = {
		Type = 'boat',
		GaragePoint = vector3(1333.2, 4269.92, 31.5),
		SpawnPoint = vector4(1334.61, 4264.68, 29.86, 87.0),
		DeletePoint = vector3(1323.73, 4269.94, 29.86)
	},
	Garage_PaletoDock = {
		Type = 'boat',
		GaragePoint = vector3(-283.74, 6629.51, 7.3),
		SpawnPoint = vector4(-290.46, 6622.72, -0.47, 52.0),
		DeletePoint = vector3(-304.66, 6607.36, -0.47-1)
	},


	Garage_LSAirport = {
		Type = 'aircraft',
		GaragePoint = vector3(-1617.14, -3145.52, 13.99),
		SpawnPoint = vector4(-1657.99, -3134.38, 12.99, 330.11),
		DeletePoint = vector3(-1642.12, -3144.25, 12.99)
	},
	Garage_SandyAirport = {
		Type = 'aircraft',
		GaragePoint = vector3(1723.84, 3288.29, 41.16),
		SpawnPoint = vector4(1710.85, 3259.06, 40.69, 104.66),
		DeletePoint = vector3(1714.45, 3246.75, 40.07)
	},
	Garage_GrapeseedAirport = {
		Type = 'aircraft',
		GaragePoint = vector3(2152.83, 4797.03, 41.19),
		SpawnPoint = vector4(2122.72, 4804.85, 40.78, 115.04),
		DeletePoint = vector3(2082.36, 4806.06, 40.07)
	},
}

Config.Pounds = {
	Pound_LosSantos = {
		Type = 'car',
		PoundPoint = vector3(408.61, -1625.47, 29.29),
		SpawnPoint = vector4(405.64, -1643.4, 27.61, 229.54)
	},
	Pound_Sandy = {
		Type = 'car',
		PoundPoint = vector3(1651.38, 3804.84, 38.65),
		SpawnPoint = vector4(1627.84, 3788.45, 33.77, 308.53)
	},
	Pound_Paleto = {
		Type = 'car',
		PoundPoint = vector3(-234.82, 6198.65, 31.94),
		SpawnPoint = vector4(-230.08, 6190.24, 30.49, 140.24)
	},
	Pound_LSDock = {
		Type = 'boat',
		PoundPoint = vector3(-738.67, -1400.43, 5.0),
		SpawnPoint = vector4(-738.33, -1381.51, 0.12, 137.85)
	},
	Pound_SandyDock = {
		Type = 'boat',
		PoundPoint = vector3(1299.36, 4217.93, 33.91),
		SpawnPoint = vector4(1294.35, 4226.31, 29.86, 345.0)
	},
	Pound_PaletoDock = {
		Type = 'boat',
		PoundPoint = vector3(-270.2, 6642.43, 7.36),
		SpawnPoint = vector4(-290.38, 6638.54, -0.47, 130.0)
	},
	Pound_LSAirport = {
		Type = 'aircraft',
		PoundPoint = vector3(-1243.0, -3391.92, 12.94),
		SpawnPoint = vector4(-1272.27, -3382.46, 12.94, 330.25)
	},
}

Config.PrivateCarGarages = {
	Garage_S13 = {
		Private = "faction_s13",
		GaragePoint = vector3(1410.78, 1115.31, 113.84),
		SpawnPoint = vector4(1415.55, 1118.37, 114.84, 90),
		DeletePoint = vector3(1404.81, 1118.18, 114.23),
	},
	Garage_Ballas = {
		Private = "faction_ballas",
		GaragePoint = vector3(90.84, -1959.64, 19.88),
		SpawnPoint = vector4(90.24, -1965.84, 20.14, 0.0),
		DeletePoint = vector3(90.24, -1965.84, 20.14),
	},
	Garage_Mara = {
		Private = "faction_mara",
		GaragePoint = vector3(1414.81, -1496.31, 60.02),
		SpawnPoint = vector4(1416.58, -1503.29, 60.16, 180),
		DeletePoint = vector3(1409.78, -1505.76, 59.55-1),
	},
	Garage_Bloods = {
		Private = "faction_bloods",
		GaragePoint = vector3(-1569.59, -235.36, 49.47),
		SpawnPoint = vector4(-1569.16, -241.95, 49.46, 157.27),
		DeletePoint = vector3(-1573.84, -236.18, 49.09),
	},
	Garage_Haitian = {
		Private = "faction_haitian",
		GaragePoint = vector3(-1421.77, -641.24, 28.67),
		SpawnPoint = vector4(-1422.29, -645.95, 28.65, 213.07),
		DeletePoint = vector3(-1422.29, -645.95, 28.65),
	},
	Garage_Families = {
		Private = "faction_families",
		GaragePoint = vector3(-25.03, -1433.82, 30.62),
		SpawnPoint = vector4(-24.96, -1441.02, 30.65, 180),
		DeletePoint = vector3(-25.27, -1427.48, 30.66),
	},
	Garage_Vagos = {
		Private = "faction_vagos",
		GaragePoint = vector3(301.54, -2024.42, 20.34),
		SpawnPoint = vector4(306.24, -2024.06, 20.33, 316),
		DeletePoint = vector3(306.24, -2024.06, 20.33-1),
	},
	Garage_Soa = {
		Private = "faction_soa",
		GaragePoint = vector3(486.51, 4819.79, -58.38),
		SpawnPoint = vector4(-389.69, 4347.65, 56.55, 190.96),
		DeletePoint = vector3(-389.69, 4347.65, 56.0),
	},
	Garage_ConfeVilla = {
		Private = "faction_confe",
		GaragePoint = vector3(4971.7, -5715.23, 19.91),
		SpawnPoint = vector4(4976.58, -5713.26, 19.89, 323.61),
		DeletePoint = vector3(4985.51, -5703.32, 18.89),
	},
	Garage_ConfeVillaH = {
		Private = "faction_confe",
		Type = 'aircraft',
		GaragePoint = vector3(4904.26, -5738.18, 26.35),
		SpawnPoint = vector4(4890.27, -5737.11, 26.35, 161.1),
		DeletePoint = vector3(4882.87, -5731.07, 25.35),
	},
	Garage_CayoPerico = {
		Private = "faction_confe",
		GaragePoint = vector3(4464.53, -4469.43, 4.24),
		SpawnPoint = vector4(4472.2, -4467.89, 4.24, 198.11),
		DeletePoint = vector3(4468.07, -4463.62, 4.25 - 1)
	},
	Garage_CayoPericoHangar = {
		Private = "faction_confe",
		Type = 'aircraft',
		GaragePoint = vector3(4435.88, -4473.66, 4.33),
		SpawnPoint = vector4(4458.47, -4507.54, 4.18, 103.87),
		DeletePoint = vector3(4451.74, -4494.12, 4.2-1)
	},
	-- Maze Bank Building Garages
	Garage_MazeBankBuilding = {
		Private = "MazeBankBuilding",
		GaragePoint = vector3(-60.38, -790.31, 44.23),
		SpawnPoint = vector4(-44.031, -787.363, 43.186, 254.322),
		DeletePoint = vector3(-58.88, -778.625, 43.175)
	},
	Garage_OldSpiceWarm = {
		Private = "OldSpiceWarm",
		GaragePoint = vector3(-60.38, -790.31, 44.23),
		SpawnPoint = vector4(-44.031, -787.363, 43.186, 254.322),
		DeletePoint = vector3(-58.88, -778.625, 43.175)
	},
	Garage_OldSpiceClassical = {
		Private = "OldSpiceClassical",
		GaragePoint = vector3(-60.38, -790.31, 44.23),
		SpawnPoint = vector4(-44.031, -787.363, 43.186, 254.322),
		DeletePoint = vector3(-58.88, -778.625, 43.175)
	},
	Garage_OldSpiceVintage = {
		Private = "OldSpiceVintage",
		GaragePoint = vector3(-60.38, -790.31, 44.23),
		SpawnPoint = vector4(-44.031, -787.363, 43.186, 254.322),
		DeletePoint = vector3(-58.88, -778.625, 43.175)
	},
	Garage_ExecutiveRich = {
		Private = "ExecutiveRich",
		GaragePoint = vector3(-60.38, -790.31, 44.23),
		SpawnPoint = vector4(-44.031, -787.363, 43.186, 254.322),
		DeletePoint = vector3(-58.88, -778.625, 43.175)
	},
	Garage_ExecutiveCool = {
		Private = "ExecutiveCool",
		GaragePoint = vector3(-60.38, -790.31, 44.23),
		SpawnPoint = vector4(-44.031, -787.363, 43.186, 254.322),
		DeletePoint = vector3(-58.88, -778.625, 43.175)
	},
	Garage_ExecutiveContrast = {
		Private = "ExecutiveContrast",
		GaragePoint = vector3(-60.38, -790.31, 44.23),
		SpawnPoint = vector4(-44.031, -787.363, 43.186, 254.322),
		DeletePoint = vector3(-58.88, -778.625, 43.175)
	},
	Garage_PowerBrokerIce = {
		Private = "PowerBrokerIce",
		GaragePoint = vector3(-60.38, -790.31, 44.23),
		SpawnPoint = vector4(-44.031, -787.363, 43.186, 254.322),
		DeletePoint = vector3(-58.88, -778.625, 43.175)
	},
	Garage_PowerBrokerConservative = {
		Private = "PowerBrokerConservative",
		GaragePoint = vector3(-60.38, -790.31, 44.23),
		SpawnPoint = vector4(-44.031, -787.363, 43.186, 254.322),
		DeletePoint = vector3(-58.88, -778.625, 43.175)
	},
	Garage_PowerBrokerPolished = {
		Private = "PowerBrokerPolished",
		GaragePoint = vector3(-60.38, -790.31, 44.23),
		SpawnPoint = vector4(-44.031, -787.363, 43.186, 254.322),
		DeletePoint = vector3(-58.88, -778.625, 43.175)
	},
	-- End of Maze Bank Building Garages
	-- Start of Lom Bank Garages
	Garage_LomBank = {
		Private = "LomBank",
		GaragePoint = vector3(-1545.17, -566.24, 25.85),
		SpawnPoint = vector4(-1551.88, -581.383, 24.708, 331.176),
		DeletePoint = vector3(-1538.564, -576.049, 24.708)
	},
	Garage_LBOldSpiceWarm = {
		Private = "LBOldSpiceWarm",
		GaragePoint = vector3(-1545.17, -566.24, 25.85),
		SpawnPoint = vector4(-1551.88, -581.383, 24.708, 331.176),
		DeletePoint = vector3(-1538.564, -576.049, 24.708)
	},
	Garage_LBOldSpiceClassical = {
		Private = "LBOldSpiceClassical",
		GaragePoint = vector3(-1545.17, -566.24, 25.85),
		SpawnPoint = vector4(-1551.88, -581.383, 24.708, 331.176),
		DeletePoint = vector3(-1538.564, -576.049, 24.708)
	},
	Garage_LBOldSpiceVintage = {
		Private = "LBOldSpiceVintage",
		GaragePoint = vector3(-1545.17, -566.24, 25.85),
		SpawnPoint = vector4(-1551.88, -581.383, 24.708, 331.176),
		DeletePoint = vector3(-1538.564, -576.049, 24.708)
	},
	Garage_LBExecutiveRich = {
		Private = "LBExecutiveRich",
		GaragePoint = vector3(-1545.17, -566.24, 25.85),
		SpawnPoint = vector4(-1551.88, -581.383, 24.708, 331.176),
		DeletePoint = vector3(-1538.564, -576.049, 24.708)
	},
	Garage_LBExecutiveCool = {
		Private = "LBExecutiveCool",
		GaragePoint = vector3(-1545.17, -566.24, 25.85),
		SpawnPoint = vector4(-1551.88, -581.383, 24.708, 331.176),
		DeletePoint = vector3(-1538.564, -576.049, 24.708)
	},
	Garage_LBExecutiveContrast = {
		Private = "LBExecutiveContrast",
		GaragePoint = vector3(-1545.17, -566.24, 25.85),
		SpawnPoint = vector4(-1551.88, -581.383, 24.708, 331.176),
		DeletePoint = vector3(-1538.564, -576.049, 24.708)
	},
	Garage_LBPowerBrokerIce = {
		Private = "LBPowerBrokerIce",
		GaragePoint = vector3(-1545.17, -566.24, 25.85),
		SpawnPoint = vector4(-1551.88, -581.383, 24.708, 331.176),
		DeletePoint = vector3(-1538.564, -576.049, 24.708)
	},
	Garage_LBPowerBrokerConservative = {
		Private = "LBPowerBrokerConservative",
		GaragePoint = vector3(-1545.17, -566.24, 25.85),
		SpawnPoint = vector4(-1551.88, -581.383, 24.708, 331.176),
		DeletePoint = vector3(-1538.564, -576.049, 24.708)
	},
	Garage_LBPowerBrokerPolished = {
		Private = "LBPowerBrokerPolished",
		GaragePoint = vector3(-1545.17, -566.24, 25.85),
		SpawnPoint = vector4(-1551.88, -581.383, 24.708, 331.176),
		DeletePoint = vector3(-1538.564, -576.049, 24.708)
	},
	-- End of Lom Bank Garages
	-- Start of Maze Bank West Garages
	Garage_MazeBankWest = {
		Private = "MazeBankWest",
		GaragePoint = vector3(-1368.14, -468.01, 31.6),
		SpawnPoint = vector4(-1376.93, -474.32, 30.5, 97.95),
		DeletePoint = vector3(-1362.065, -471.982, 30.5)
	},
	Garage_MBWOldSpiceWarm = {
		Private = "MBWOldSpiceWarm",
		GaragePoint = vector3(-1368.14, -468.01, 31.6),
		SpawnPoint = vector4(-1376.93, -474.32, 30.5, 97.95),
		DeletePoint = vector3(-1362.065, -471.982, 30.5)
	},
	Garage_MBWOldSpiceClassical = {
		Private = "MBWOldSpiceClassical",
		GaragePoint = vector3(-1368.14, -468.01, 31.6),
		SpawnPoint = vector4(-1376.93, -474.32, 30.5, 97.95),
		DeletePoint = vector3(-1362.065, -471.982, 30.5)
	},
	Garage_MBWOldSpiceVintage = {
		Private = "MBWOldSpiceVintage",
		GaragePoint = vector3(-1368.14, -468.01, 31.6),
		SpawnPoint = vector4(-1376.93, -474.32, 30.5, 97.95),
		DeletePoint = vector3(-1362.065, -471.982, 30.5)
	},
	Garage_MBWExecutiveRich = {
		Private = "MBWExecutiveRich",
		GaragePoint = vector3(-1368.14, -468.01, 31.6),
		SpawnPoint = vector4(-1376.93, -474.32, 30.5, 97.95),
		DeletePoint = vector3(-1362.065, -471.982, 30.5)
	},
	Garage_MBWExecutiveCool = {
		Private = "MBWExecutiveCool",
		GaragePoint = vector3(-1368.14, -468.01, 31.6),
		SpawnPoint = vector4(-1376.93, -474.32, 30.5, 97.95),
		DeletePoint = vector3(-1362.065, -471.982, 30.5)
	},
	Garage_MBWExecutiveContrast = {
		Private = "MBWExecutiveContrast",
		GaragePoint = vector3(-1368.14, -468.01, 31.6),
		SpawnPoint = vector4(-1376.93, -474.32, 30.5, 97.95),
		DeletePoint = vector3(-1362.065, -471.982, 30.5)
	},
	Garage_MBWPowerBrokerIce = {
		Private = "MBWPowerBrokerIce",
		GaragePoint = vector3(-1368.14, -468.01, 31.6),
		SpawnPoint = vector4(-1376.93, -474.32, 30.5, 97.95),
		DeletePoint = vector3(-1362.065, -471.982, 30.5)
	},
	Garage_MBWPowerBrokerConvservative = {
		Private = "MBWPowerBrokerConvservative",
		GaragePoint = vector3(-1368.14, -468.01, 31.6),
		SpawnPoint = vector4(-1376.93, -474.32, 30.5, 97.95),
		DeletePoint = vector3(-1362.065, -471.982, 30.5)
	},
	Garage_MBWPowerBrokerPolished = {
		Private = "MBWPowerBrokerPolished",
		GaragePoint = vector3(-1368.14, -468.01, 31.6),
		SpawnPoint = vector4(-1376.93, -474.32, 30.5, 97.95),
		DeletePoint = vector3(-1362.065, -471.982, 30.5)
	},
	-- End of Maze Bank West Garages
	-- Start of Intergrity Way Garages
	Garage_IntegrityWay = {
		Private = "IntegrityWay",
		GaragePoint = vector3(-14.1, -614.93, 35.86),
		SpawnPoint = vector4(-7.351, -635.1, 34.724, 66.632),
		DeletePoint = vector3(-37.575, -620.391, 34.073)
	},
	Garage_IntegrityWay28 = {
		Private = "IntegrityWay28",
		GaragePoint = vector3(-14.1, -614.93, 35.86),
		SpawnPoint = vector4(-7.351, -635.1, 34.724, 66.632),
		DeletePoint = vector3(-37.575, -620.391, 34.073)
	},
	Garage_IntegrityWay30 = {
		Private = "IntegrityWay30",
		GaragePoint = vector3(-14.1, -614.93, 35.86),
		SpawnPoint = vector4(-7.351, -635.1, 34.724, 66.632),
		DeletePoint = vector3(-37.575, -620.391, 34.073)
	},
	-- End of Intergrity Way Garages
	-- Start of Dell Perro Heights Garages
	Garage_DellPerroHeights = {
		Private = "DellPerroHeights",
		GaragePoint = vector3(-1477.15, -517.17, 34.74),
		SpawnPoint = vector4(-1483.16, -505.1, 31.81, 299.89),
		DeletePoint = vector3(-1452.612, -508.782, 30.582)
	},
	Garage_DellPerroHeightst4 = {
		Private = "DellPerroHeightst4",
		GaragePoint = vector3(-1477.15, -517.17, 34.74),
		SpawnPoint = vector4(-1483.16, -505.1, 31.81, 299.89),
		DeletePoint = vector3(-1452.612, -508.782, 30.582)
	},
	Garage_DellPerroHeightst7 = {
		Private = "DellPerroHeightst7",
		GaragePoint = vector3(-1477.15, -517.17, 34.74),
		SpawnPoint = vector4(-1483.16, -505.1, 31.81, 299.89),
		DeletePoint = vector3(-1452.612, -508.782, 30.582)
	},
	-- End of Dell Perro Heights Garages
	-- Start of Milton Drive Garages
	Garage_MiltonDrive = {
		Private = "MiltonDrive",
		GaragePoint = vector3(-795.96, 331.83, 85.5),
		SpawnPoint = vector4(-800.496, 333.468, 84.5, 180.494),
		DeletePoint = vector3(-791.755, 333.468, 84.5)
	},
	Garage_Modern1Apartment = {
		Private = "Modern1Apartment",
		GaragePoint = vector3(-795.96, 331.83, 85.5),
		SpawnPoint = vector4(-800.496, 333.468, 84.5, 180.494),
		DeletePoint = vector3(-791.755, 333.468, 84.5)
	},
	Garage_Modern2Apartment = {
		Private = "Modern2Apartment",
		GaragePoint = vector3(-795.96, 331.83, 85.5),
		SpawnPoint = vector4(-800.496, 333.468, 84.5, 180.494),
		DeletePoint = vector3(-791.755, 333.468, 84.5)
	},
	Garage_Modern3Apartment = {
		Private = "Modern3Apartment",
		GaragePoint = vector3(-795.96, 331.83, 85.5),
		SpawnPoint = vector4(-800.496, 333.468, 84.5, 180.494),
		DeletePoint = vector3(-791.755, 333.468, 84.5)
	},
	Garage_Mody1Apartment = {
		Private = "Mody1Apartment",
		GaragePoint = vector3(-795.96, 331.83, 85.5),
		SpawnPoint = vector4(-800.496, 333.468, 84.5, 180.494),
		DeletePoint = vector3(-791.755, 333.468, 84.5)
	},
	Garage_Mody2Apartment = {
		Private = "Mody2Apartment",
		GaragePoint = vector3(-795.96, 331.83, 85.5),
		SpawnPoint = vector4(-800.496, 333.468, 84.5, 180.494),
		DeletePoint = vector3(-791.755, 333.468, 84.5)
	},
	Garage_Mody3Apartment = {
		Private = "Mody3Apartment",
		GaragePoint = vector3(-795.96, 331.83, 85.5),
		SpawnPoint = vector4(-800.496, 333.468, 84.5, 180.494),
		DeletePoint = vector3(-791.755, 333.468, 84.5)
	},
	Garage_Vibrant1Apartment = {
		Private = "Vibrant1Apartment",
		GaragePoint = vector3(-795.96, 331.83, 85.5),
		SpawnPoint = vector4(-800.496, 333.468, 84.5, 180.494),
		DeletePoint = vector3(-791.755, 333.468, 84.5)
	},
	Garage_Vibrant2Apartment = {
		Private = "Vibrant2Apartment",
		GaragePoint = vector3(-795.96, 331.83, 85.5),
		SpawnPoint = vector4(-800.496, 333.468, 84.5, 180.494),
		DeletePoint = vector3(-791.755, 333.468, 84.5)
	},
	Garage_Vibrant3Apartment = {
		Private = "Vibrant3Apartment",
		GaragePoint = vector3(-795.96, 331.83, 85.5),
		SpawnPoint = vector4(-800.496, 333.468, 84.5, 180.494),
		DeletePoint = vector3(-791.755, 333.468, 84.5)
	},
	Garage_Sharp1Apartment = {
		Private = "Sharp1Apartment",
		GaragePoint = vector3(-795.96, 331.83, 85.5),
		SpawnPoint = vector4(-800.496, 333.468, 84.5, 180.494),
		DeletePoint = vector3(-791.755, 333.468, 84.5)
	},
	Garage_Sharp2Apartment = {
		Private = "Sharp2Apartment",
		GaragePoint = vector3(-795.96, 331.83, 85.5),
		SpawnPoint = vector4(-800.496, 333.468, 84.5, 180.494),
		DeletePoint = vector3(-791.755, 333.468, 84.5)
	},
	Garage_Sharp3Apartment = {
		Private = "Sharp3Apartment",
		GaragePoint = vector3(-795.96, 331.83, 85.5),
		SpawnPoint = vector4(-800.496, 333.468, 84.5, 180.494),
		DeletePoint = vector3(-791.755, 333.468, 84.5)
	},
	Garage_Monochrome1Apartment = {
		Private = "Monochrome1Apartment",
		GaragePoint = vector3(-795.96, 331.83, 85.5),
		SpawnPoint = vector4(-800.496, 333.468, 84.5, 180.494),
		DeletePoint = vector3(-791.755, 333.468, 84.5)
	},
	Garage_Monochrome2Apartment = {
		Private = "Monochrome2Apartment",
		GaragePoint = vector3(-795.96, 331.83, 85.5),
		SpawnPoint = vector4(-800.496, 333.468, 84.5, 180.494),
		DeletePoint = vector3(-791.755, 333.468, 84.5)
	},
	Garage_Monochrome3Apartment = {
		Private = "Monochrome3Apartment",
		GaragePoint = vector3(-795.96, 331.83, 85.5),
		SpawnPoint = vector4(-800.496, 333.468, 84.5, 180.494),
		DeletePoint = vector3(-791.755, 333.468, 84.5)
	},
	Garage_Seductive1Apartment = {
		Private = "Seductive1Apartment",
		GaragePoint = vector3(-795.96, 331.83, 85.5),
		SpawnPoint = vector4(-800.496, 333.468, 84.5, 180.494),
		DeletePoint = vector3(-791.755, 333.468, 84.5)
	},
	Garage_Seductive2Apartment = {
		Private = "Seductive2Apartment",
		GaragePoint = vector3(-795.96, 331.83, 85.5),
		SpawnPoint = vector4(-800.496, 333.468, 84.5, 180.494),
		DeletePoint = vector3(-791.755, 333.468, 84.5)
	},
	Garage_Seductive3Apartment = {
		Private = "Seductive3Apartment",
		GaragePoint = vector3(-795.96, 331.83, 85.5),
		SpawnPoint = vector4(-800.496, 333.468, 84.5, 180.494),
		DeletePoint = vector3(-791.755, 333.468, 84.5)
	},
	Garage_Regal1Apartment = {
		Private = "Regal1Apartment",
		GaragePoint = vector3(-795.96, 331.83, 85.5),
		SpawnPoint = vector4(-800.496, 333.468, 84.5, 180.494),
		DeletePoint = vector3(-791.755, 333.468, 84.5)
	},
	Garage_Regal2Apartment = {
		Private = "Regal2Apartment",
		GaragePoint = vector3(-795.96, 331.83, 85.5),
		SpawnPoint = vector4(-800.496, 333.468, 84.5, 180.494),
		DeletePoint = vector3(-791.755, 333.468, 84.5)
	},
	Garage_Regal3Apartment = {
		Private = "Regal3Apartment",
		GaragePoint = vector3(-795.96, 331.83, 85.5),
		SpawnPoint = vector4(-800.496, 333.468, 84.5, 180.494),
		DeletePoint = vector3(-791.755, 333.468, 84.5)
	},
	Garage_Aqua1Apartment = {
		Private = "Aqua1Apartment",
		GaragePoint = vector3(-795.96, 331.83, 85.5),
		SpawnPoint = vector4(-800.496, 333.468, 84.5, 180.494),
		DeletePoint = vector3(-791.755, 333.468, 84.5)
	},
	Garage_Aqua2Apartment = {
		Private = "Aqua2Apartment",
		GaragePoint = vector3(-795.96, 331.83, 85.5),
		SpawnPoint = vector4(-800.496, 333.468, 84.5, 180.494),
		DeletePoint = vector3(-791.755, 333.468, 84.5)
	},
	Garage_Aqua3Apartment = {
		Private = "Aqua3Apartment",
		GaragePoint = vector3(-795.96, 331.83, 85.5),
		SpawnPoint = vector4(-800.496, 333.468, 84.5, 180.494),
		DeletePoint = vector3(-791.755, 333.468, 84.5)
	},
	-- End of Milton Drive Garages
	-- Start of Single Garages
	Garage_RichardMajesticApt2 = {
		Private = "RichardMajesticApt2",
		GaragePoint = vector3(-887.5, -349.58, 34.534),
		SpawnPoint = vector4(-886.03, -343.78, 33.534, 206.79),
		DeletePoint = vector3(-894.324, -349.326, 33.534)
	},
	Garage_WildOatsDrive = {
		Private = "WildOatsDrive",
		GaragePoint = vector3(-178.65, 503.45, 136.85),
		SpawnPoint = vector4(-189.98, 505.8, 133.48, 282.62),
		DeletePoint = vector3(-189.28, 500.56, 132.93)
	},
	Garage_WhispymoundDrive = {
		Private = "WhispymoundDrive",
		GaragePoint = vector3(123.65, 565.75, 184.04),
		SpawnPoint = vector4(130.11, 571.47, 182.42, 270.71),
		DeletePoint = vector3(131.97, 566.77, 181.95)
	},
	Garage_NorthConkerAvenue2044 = {
		Private = "NorthConkerAvenue2044",
		GaragePoint = vector3(348.18, 443.01, 147.7),
		SpawnPoint = vector4(358.397, 437.064, 144.277, 285.911),
		DeletePoint = vector3(351.383, 438.865, 145.66)
	},
	Garage_NorthConkerAvenue2045 = {
		Private = "NorthConkerAvenue2045",
		GaragePoint = vector3(370.69, 430.76, 145.11),
		SpawnPoint = vector4(392.88, 434.54, 142.17, 264.94),
		DeletePoint = vector3(389.72, 429.95, 141.81)
	},
	Garage_HillcrestAvenue2862 = {
		Private = "HillcrestAvenue2862",
		GaragePoint = vector3(-688.71, 597.57, 143.64),
		SpawnPoint = vector4(-683.72, 609.88, 143.28, 338.06),
		DeletePoint = vector3(-685.259, 601.083, 142.365)
	},
	Garage_HillcrestAvenue2868 = {
		Private = "HillcrestAvenue2868",
		GaragePoint = vector3(-752.753, 624.901, 142.2),
		SpawnPoint = vector4(-749.32, 628.61, 141.48, 197.14),
		DeletePoint = vector3(-754.286, 631.581, 141.2)
	},
	Garage_HillcrestAvenue2874 = {
		Private = "HillcrestAvenue2874",
		GaragePoint = vector3(-859.01, 695.95, 148.93),
		SpawnPoint = vector4(-863.681, 698.72, 147.052, 341.77),
		DeletePoint = vector3(-855.66, 698.77, 147.81)
	},
	Garage_MadWayneThunder = {
		Private = "MadWayneThunder",
		GaragePoint = vector3(-1290.95, 454.52, 97.66),
		SpawnPoint = vector4(-1297.62, 459.28, 96.48, 285.652),
		DeletePoint = vector3(-1298.088, 468.952, 96.0)
	},
	Garage_TinselTowersApt12 = {
		Private = "TinselTowersApt12",
		GaragePoint = vector3(-616.74, 56.38, 43.736),
		SpawnPoint = vector4(-620.588, 60.102, 42.736, 109.316),
		DeletePoint = vector3(-621.128, 52.691, 42.735)
	},
	-- End of Single Garages

	-- New properties

	Garage_MichaelHouse = {
		Private = 'MichaelHouse',
		GaragePoint = vector3(-819.61, 180.78, 71.8564),
		SpawnPoint = vector4(-817.67, 185.40, 71.350, 125.07),
		DeletePoint = vector3(-815.12, 162.44, 70.3396),
	},

	Garage_IndianaOffice = {
		Private = 'IndianaOffice',
		GaragePoint = vector3(-1017.24, -494.66, 37.1334),
		SpawnPoint = vector4(-1023.54, -496.44, 35.9503, 94.61),
		DeletePoint = vector3(-1030.51, -488.06, 35.9516),
	},

	Garage_FranklinHouse = {
		Private = 'FranklinHouse',
		GaragePoint = vector3(17.70, 551.89, 176.679),
		SpawnPoint = vector4(16.71, 548.45, 175.21, 94.61),
		DeletePoint = vector3(2.59, 542.96, 173.639),
	},

	Garage_FloydHouse = {
		Private = 'FloydHouse',
		GaragePoint = vector3(-1148.27, -1523.78, 4.35),
		SpawnPoint = vector4(-1153.02, -1527.87, 3.24, 38.28),
		DeletePoint = vector3(-1150.19, -1533.55, 3.24),
	},

	Garage_VillaNormandyDrive = {
		Private = 'VillaNormandyDrive',
		GaragePoint = vector3(-749.03, 817.8, 213.437),
		SpawnPoint = vector4(-745.44, 818.94, 212.459, 38.28),
		DeletePoint = vector3(-748.28, 815.04, 212.49),
	},

	Garage_BuenVinoRoad1 = {
		Private = 'BuenVinoRoad1',
		GaragePoint = vector3(-2588.38, 1927.86, 167.313),
		SpawnPoint = vector4(-2591.07, 1930.46, 166.300, 280.28),
		DeletePoint = vector3(-2596.99, 1930.43, 166.307),
	},

	Garage_SkateParkCortesStreet = {
		Private = 'SkateParkCortesStreet',
		GaragePoint = vector3(-1343.55, -1214.75, 5.942),
		SpawnPoint = vector4(-1343.03, -1209.78, 3.49, 280.28),
		DeletePoint = vector3(-1350.06, -1209.45, 3.33),
	},

	Garage_BarbarenoRoad = {
		Private = 'BarbarenoRoad',
		GaragePoint = vector3(-3198.62, 1159.95, 9.65),
		SpawnPoint = vector4(-3194.15, 1159.68, 8.45, 167.95),
		DeletePoint = vector3(-3199.19, 1154.44, 8.65),
	},

	Garage_MountGordo = {
		Private = 'MountGordo',
		GaragePoint = vector3(3328.94, 5164.93, 18.5617),
		SpawnPoint = vector4(3334.16, 5161.06, 17.3013, 144.8),
		DeletePoint = vector3(3321.11, 5156.23, 17.3809),
	},

	Garage_BeachLanderOffice = {
		Private = 'BeachLanderOffice',
		GaragePoint = vector3(-1894.67, -563.90, 11.7824),
		SpawnPoint = vector4(-1899.56, -561.51, 10.8003, 317.92),
		DeletePoint = vector3(-1904.37, -558.61, 10.8067),
	},

	Garage_MarlowDrive = {
		Private = 'MarlowDrive',
		GaragePoint = vector3(-120.84, 1010.36, 235.739),
		SpawnPoint = vector4(-123.68, 1007.55, 234.73, 203.75),
		DeletePoint = vector3(-131.49, 1004.38, 234.73),
	},

}