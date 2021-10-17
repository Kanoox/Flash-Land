Config = {}
Config.DrawDistance = 15.0
Config.Locale = 'fr'

-- Taxi
Config.NPCTaxiJobEarnings = {min = 400, max = 500}
Config.MinimumTaxiDistance = 2000 -- Minimum NPC job destination distance from the pickup in GTA units, a higher number prevents nearby destinations.

Config.AuthorizedTaxiVehicles = {
	{	model = 'taxi',
		label = 'Taxi'
	}
}

Config.Zones1 = {
	VehicleTaxiSpawner = {
		Pos = vector3(909.32, -164.38, 74.2),
		Size = vector3(1.0, 1.0, 1.0),
		Color = {r = 204, g = 204, b = 0},
		Type = 36, Rotate = true
	},
	VehicleSpawnTaxiPoint = {
		Pos = vector3(907.48, -167.26, 73.75),
		Size = vector3(1.5, 1.5, 1.0),
		Type = -1, Rotate = false,
		Heading = 225.0
	},
	VehicleTaxiDeleter = {
		Pos = vector3(906.98, -167.43, 73.25),
		Size = vector3(3.0, 3.0, 0.25),
		Color = {r = 255, g = 0, b = 0},
		Type = 1, Rotate = false
	},
	TaxiActions = {
		Pos = vector3(906.52, -151.07, 74.17),
		Size = vector3(1.0, 1.0, 1.0),
		Color = {r = 204, g = 204, b = 0},
		Type = 20, Rotate = true
	},
	CloakroomTaxi = {
		Pos = vector3(893.27, -162.58, 76.89),
		Size = vector3(1.0, 1.0, 1.0),
		Color = {r = 204, g = 204, b = 0},
		Type = 21, Rotate = true
	}
}

Config.JobTaxiLocations = {
	vector3(293.5, -590.2, 42.7),
	vector3(253.4, -375.9, 44.1),
	vector3(120.8, -300.4, 45.1),
	vector3(-38.4, -381.6, 38.3),
	vector3(-107.4, -614.4, 35.7),
	vector3(-252.3, -856.5, 30.6),
	vector3(-236.1, -988.4, 28.8),
	vector3(-277.0, -1061.2, 25.7),
	vector3(-576.5, -999.0, 21.8),
	vector3(-602.8, -952.6, 21.6),
	vector3(-790.7, -961.9, 14.9),
	vector3(-912.6, -864.8, 15.0),
	vector3(-1069.8, -792.5, 18.8),
	vector3(-1306.9, -854.1, 15.1),
	vector3(-1468.5, -681.4, 26.2),
	vector3(-1380.9, -452.7, 34.1),
	vector3(-1326.3, -394.8, 36.1),
	vector3(-1383.7, -270.0, 42.5),
	vector3(-1679.6, -457.3, 39.4),
	vector3(-1812.5, -416.9, 43.7),
	vector3(-2043.6, -268.3, 23.0),
	vector3(-2186.4, -421.6, 12.7),
	vector3(-1862.1, -586.5, 11.2),
	vector3(-1859.5, -617.6, 10.9),
	vector3(-1635.0, -988.3, 12.6),
	vector3(-1284.0, -1154.2, 5.3),
	vector3(-1126.5, -1338.1, 4.6),
	vector3(-867.9, -1159.7, 5.0),
	vector3(-847.5, -1141.4, 6.3),
	vector3(-722.6, -1144.6, 10.2),
	vector3(-575.5, -318.4, 34.5),
	vector3(-592.3, -224.9, 36.1),
	vector3(-559.6, -162.9, 37.8),
	vector3(-535.0, -65.7, 40.6),
	vector3(-758.2, -36.7, 37.3),
	vector3(-1375.9, 21.0, 53.2),
	vector3(-1320.3, -128.0, 48.1),
	vector3(-1285.7, 294.3, 64.5),
	vector3(-1245.7, 386.5, 75.1),
	vector3(-760.4, 285.0, 85.1),
	vector3(-626.8, 254.1, 81.1),
	vector3(-563.6, 268.0, 82.5),
	vector3(-486.8, 272.0, 82.8),
	vector3(88.3, 250.9, 108.2),
	vector3(234.1, 344.7, 105.0),
	vector3(435.0, 96.7, 99.2),
	vector3(482.6, -142.5, 58.2),
	vector3(762.7, -786.5, 25.9),
	vector3(809.1, -1290.8, 25.8),
	vector3(490.8, -1751.4, 28.1),
	vector3(432.4, -1856.1, 27.0),
	vector3(164.3, -1734.5, 28.9),
	vector3(-57.7, -1501.4, 31.1),
	vector3(52.2, -1566.7, 29.0),
	vector3(310.2, -1376.8, 31.4),
	vector3(182.0, -1332.8, 28.9),
	vector3(-74.6, -1100.6, 25.7),
	vector3(-887.0, -2187.5, 8.1),
	vector3(-749.6, -2296.6, 12.5),
	vector3(-1064.8, -2560.7, 19.7),
	vector3(-1033.4, -2730.2, 19.7),
	vector3(-1018.7, -2732.0, 13.3),
	vector3(797.4, -174.4, 72.7),
	vector3(508.2, -117.9, 60.8),
	vector3(159.5, -27.6, 67.4),
	vector3(-36.4, -106.9, 57.0),
	vector3(-355.8, -270.4, 33.0),
	vector3(-831.2, -76.9, 37.3),
	vector3(-1038.7, -214.6, 37.0),
	vector3(1918.4, 3691.4, 32.3),
	vector3(1820.2, 3697.1, 33.5),
	vector3(1619.3, 3827.2, 34.5),
	vector3(1418.6, 3602.2, 34.5),
	vector3(1944.9, 3856.3, 31.7),
	vector3(2285.3, 3839.4, 34.0),
	vector3(2760.9, 3387.8, 55.7),
	vector3(1952.8, 2627.7, 45.4),
	vector3(1051.4, 474.8, 93.7),
	vector3(866.4, 17.6, 78.7),
	vector3(319.0, 167.4, 103.3),
	vector3(88.8, 254.1, 108.2),
	vector3(-44.9, 70.4, 72.4),
	vector3(-115.5, 84.3, 70.8),
	vector3(-384.8, 226.9, 83.5),
	vector3(-578.7, 139.1, 61.3),
	vector3(-651.3, -584.9, 34.1),
	vector3(-571.8, -1195.6, 17.9),
	vector3(-1513.3, -670.0, 28.4),
	vector3(-1297.5, -654.9, 26.1),
	vector3(-1645.5, 144.6, 61.7),
	vector3(-1160.6, 744.4, 154.6),
	vector3(-798.1, 831.7, 204.4)
}

-- Palace
Config.ZonesPalace = {
	PalaceActions = {
		Pos = vector3(0, 0, 0),
		Size = vector3(1.0, 1.0, 1.5),
		Color = {r = 150, g = 0, b = 150},
		Type = 25
	},

	BossActionsPalace = {
		Pos = vector3(0, 0, 0),
		Size = vector3(1.0, 1.0, 1.5),
		Color = {r = 150, g = 0, b = 150},
		Type = 25
	},
}


--Galaxy
Config.ZonesGalaxy = {
	GalaxyActions = {
		Pos = vector3(351.75, 287.04, 91.2),
		Size = vector3(1.0, 1.0, 1.5),
		Color = {r = 150, g = 0, b = 150},
		Type = 25
	},

	BossActionsGalaxy = {
		Pos = vector3(390.79, 270.39, 95.0),
		Size = vector3(1.0, 1.0, 1.5),
		Color = {r = 150, g = 0, b = 150},
		Type = 25
	},
}

--Bahams
Config.ZonesBahamas = {
	BahamasActions = {
		Pos = vector3(-1386.73, -608.55, 29.4),
		Size = vector3(1.0, 1.0, 1.5),
		Color = {r = 150, g = 0, b = 150},
		Type = 25
	},

	BossActionsBahamas = {
		Pos = vector3(-1364.11, -623.32, 30.33),
		Size = vector3(1.0, 1.0, 1.5),
		Color = {r = 150, g = 0, b = 150},
		Type = 25
	},
}

--LTD
Config.ZonesLTDB = {
	LTDBActions = {
		Pos = vector3(-47.47, -1759.16, 29.42),
		Size = vector3(1.0, 1.0, 1.5),
		Color = {r = 150, g = 0, b = 150},
		Type = 25
	},

	BossActionsLTDB = {
		Pos = vector3(-26.91, -1750.79, 29.42),
		Size = vector3(1.0, 1.0, 1.5),
		Color = {r = 150, g = 0, b = 150},
		Type = 25
	},
}


-- Daymson
Config.Zones3 = {
	DaymsonActions = {
		Pos = vector3(-437.412, 163.855, 77.35),
		Size = vector3(1.0, 1.0, 1.5),
		Color = {r = 204, g = 204, b = 0},
		Type = 25
	},

	BossActionsDaymson = {
		Pos = vector3(-437.378, 159.354, 77.35),
		Size = vector3(1.0, 1.0, 1.5),
		Color = {r = 0, g = 240, b = 0},
		Type = 25
	},

	HarvestDaymson = {
		Pos = vector3(-977.277, -265.294, 37.45),
		Size = vector3(1.0, 1.0, 2.5),
		Color = {r = 0, g = 240, b = 0},
		Type = 25
	},

	DaymsonCraft = {
		Pos = vector3(-439.739, 148.450, 77.75),
		Size = vector3(1.0, 1.0, 2.5),
		Color = {r = 204, g = 204, b = 0},
		Type = 25
	},

	DaymsonSellFarm = {
		Pos = vector3(248.423, 156.194, 104.176),
		Size = vector3(1.0, 1.0, 1.0),
		Color = {r = 0, g = 240, b = 0},
		Type = 25
	},

	VehicleSpawnDaymsonMenu = {
		Pos = vector3(-455.81,  191.359, 74.339),
		Size = vector3(1.0, 1.0, 1.5),
		Color = {r = 0, g = 240, b = 0},
		Type = 25
	},

	VehicleSpawnDaymsonPoint = {
		Pos = vector3(-460.949, 193.908, 74.239),
		Size = vector3(1.5, 1.5, 1.0),
		Type = -1
	},

	VehicleDaymsonDeleter = {
		Pos = vector3(-468.119, 195.566, 74.239),
		Size = vector3(2.0, 2.0, 1.5),
		Color = {r = 240, g = 0, b = 0},
		Type = 1
	}
}

-- Tabac
Config.Zones4 = {

	TabacActions = {
		Pos = vector3(2347.77, 3121.75, 47.25),
		Size = vector3(1.0, 1.0, 1.5),
		Color = {r = 230, g = 20, b = 255},
		Type = 25
	},

	BossActionsTabac = {
		Pos = vector3(2338.93, 3125.64, 47.25),
		Size = vector3(1.0, 1.0, 1.5),
		Color = {r = 230, g = 20, b = 255},
		Type = 25
	},

	HarvestTabac = {
		Pos = vector3(509.63, 6469.52, 29.85),
		Size = vector3(1.0, 1.0, 2.0),
		Color = {r = 230, g = 20, b = 255},
		Type = 25
	},

	TabacCraft = {
		Pos = vector3(2343.62, 3146.55, 47.25),
		Size = vector3(1.0, 1.0, 2.0),
		Color = {r = 230, g = 20, b = 255},
		Type = 25
	},

	TabacCraft2 = {
		Pos = vector3(2347.78, 3145.89, 47.25),
		Size = vector3(1.0, 1.0, 2.0),
		Color = {r = 230, g = 20, b = 255},
		Type = 25
	},

	TabacSellFarm = {
		Pos = vector3(-702.94, -917.06, 19.21),
		Size = vector3(1.0, 1.0, 1.0),
		Color = {r = 240, g = 0, b = 0},
		Type = 29
	},

	TabacSellFarm2 = {
		Pos = vector3(-1469.64, -366.57, 40.2),
		Size = vector3(1.0, 1.0, 1.0),
		Color = {r = 240, g = 0, b = 0},
		Type = 29
	},

	VehicleSpawnTabacMenu = {
		Pos = vector3(2361.66,  3119.19, 48.2),
		Size = vector3(1.0, 1.0, 1.0),
		Color = {r = 230, g = 20, b = 255},
		Type = 36
	},

	VehicleSpawnTabacPoint = {
		Pos = vector3(2363.89, 3113.38, 48.41),
		Size = vector3(1.5, 1.5, 1.5),
		Type = -1
	},

	VehicleTabacDeleter = {
		Pos = vector3(2361.1, 3113.78, 48.2),
		Size = vector3(1.5, 1.5, 1.5),
		Color = {r = 240, g = 0, b = 0},
		Type = 36
	}
}

-- Vigneron
Config.Zones5 = {

	VigneronActions = {
		Pos = vector3(-1928.74, 2059.92, 139.95),
		Size = vector3(1.0, 1.0, 1.5),
		Color = {r = 113, g = 0, b = 127},
		Type = 25
	},
	BossActionsVigneron = {
		Pos = vector3(-1838.37, 2216.76, 86.87),
		Size = vector3(1.0, 1.0, 1.5),
		Color = {r = 113, g = 0, b = 127},
		Type = 25
	},
	HarvestVigneron = {
		Pos = vector3(-1812.03, 2209.36, 90.65),
		Size = vector3(1.0, 1.0, 2.5),
		Color = {r = 113, g = 0, b = 127},
		Type = 25
	},
	HarvestVigneron2 = {
		Pos = vector3(-1809.004, 2209.35, 91.251),
		Size = vector3(1.0, 1.0, 2.5),
		Color = {r = 113, g = 0, b = 127},
		Type = 25
	},
	VigneronCraft = {
		Pos = vector3(-1933.69, 2039.27, 139.9),
		Size = vector3(1.0, 1.0, 2.5),
		Color = {r = 113, g = 0, b = 127},
		Type = 25
	},
	VigneronSellFarm = {
		Pos = vector3(1129.92, -989.27, 45.96),
		Size = vector3(1.0, 1.0, 1.0),
		Color = {r = 240, g = 0, b = 0},
		Type = 29
	},
	VigneronSellFarm2 = {
		Pos = vector3(-893.81, -1162.35, 4.91),
		Size = vector3(1.0, 1.0, 1.0),
		Color = {r = 240, g = 0, b = 0},
		Type = 29
	},
	VehicleSpawnVigneronMenu = {
		Pos = vector3(-1924.52,  2050.35, 140.83),
		Size = vector3(1.0, 1.0, 1.0),
		Color = {r = 113, g = 0, b = 127},
		Type = 36
	},
	VehicleSpawnVigneronPoint = {
		Pos = vector3(-1920.09, 2048.51, 140.73),
		Size = vector3(1.5, 1.5, 1.0),
		Type = -1
	},
	VehicleVigneronDeleter = {
		Pos = vector3(-1922.17, 2049.03, 140.73),
		Size = vector3(1.5, 1.5, 1.5),
		Color = {r = 240, g = 0, b = 0},
		Type = 36
	}
}

-- Benny's
Config.Zones10 = {
	bennysActions = {
		Pos = vector3(-214.75, -1331.09, 23.14-0.9),
		Size = vector3(1.0, 1.0, 1.5),
		Color = {r = 0, g = 0, b = 250},
		Type = 25
	},
	BossActionsbennys = {
		Pos = vector3(-198.32, -1341.43, 34.0),
		Size = vector3(1.0, 1.0, 1.5),
		Color = {r = 0, g = 0, b = 250},
		Type = 25
	},
}

Config.ZonesRebelStudio = {

	Actions = {
		Pos = vector3(727.96, 2535.03, 73.51),
		Size = vector3(1.0, 1.0, 1.5),
		Color = {r = 204, g = 204, b = 0},
		Type = 25,
	},

	BossActions = {
		Pos = vector3(716.29, 2523.99, 73.51),
		Size = vector3(1.0, 1.0, 1.5),
		Color = {r = 0, g = 240, b = 0},
		Type = 25,
	},
}

Config.ZonesJournaliste = {
	Actions = {
		Pos = vector3(-589.86, -935.21, 23.1),
		Size = vector3(1.0, 1.0, 1.5),
		Color = {r = 204, g = 204, b = 0},
		Type = 25,
	},

	BossActions = {
		Pos = vector3(-593.06, -918.42, 23.2),
		Size = vector3(1.0, 1.0, 1.5),
		Color = {r = 0, g = 240, b = 0},
		Type = 25,
	},
}

Config.ZonesBurgershot = {
	Actions = {
		Pos = vector3(-1197.87, -891.97, 14.0),
		Size = vector3(1.0, 1.0, 1.5),
		Color = {r = 204, g = 204, b = 0},
		Type = 25,
	},

	BossActions = {
		Pos = vector3(-1198.72, -901.46, 14.0),
		Size = vector3(1.0, 1.0, 1.5),
		Color = {r = 0, g = 240, b = 0},
		Type = 25,
	},
}

Config.ZonesTequilala = {
	TequilalaActions = {
		Pos = vector3(-561.85, 289.11, 82.18),
		Size = vector3(1.0, 1.0, 1.5),
		Color = {r = 150, g = 0, b = 150},
		Type = 25
	},

	BossActionsTequilala = {
		Pos = vector3(-576.56, 286.95, 79.18),
		Size = vector3(1.0, 1.0, 1.5),
		Color = {r = 150, g = 0, b = 150},
		Type = 25
	},
}

Config.ZonesEvent = {
	Actions = {
		Pos = vector3(-1055.5, -241.25, 43.1),
		Size = vector3(1.0, 1.0, 1.5),
		Color = {r = 204, g = 204, b = 0},
		Type = 25,
	},

	BossActions = {
		Pos = vector3(-1053.62, -233.12, 43.1),
		Size = vector3(1.0, 1.0, 1.5),
		Color = {r = 0, g = 240, b = 0},
		Type = 25,
	},
}

--cafe
Config.Zonescafe = {
	Actions = {
		Pos = vector3(269.71, -819.38, 29.4),
		Size = vector3(1.5, 1.5, 1.5),
		Color = {r = 204, g = 204, b = 0},
		Type = 25,
	},

	BossActions = {
		Pos = vector3(264.14, -817.12, 29.4),
		Size = vector3(1.5, 1.5, 1.5),
		Color = {r = 0, g = 240, b = 0},
		Type = 25,
	},
}