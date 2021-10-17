Config = {}
Config.MoneyInAtm = 35000
Config.MoneyVariation = 4000

Config.BankSavingPercentage = 5.0

Config.AtmRewardMin = 60
Config.AtmRewardMax = 120

Config.AtmHackRewardMin = 100
Config.AtmHackRewardMax = 200


Config.Banks = {
	blaineCounty = { -- Paleto
		holdupPosition = vector3(-107.0, 6474.8, 31.6),
		actionPositions = {
			vector3(-111.9, 6471.1, 31.6),
		},
		guichetPositions = {
			vector3(-113.70, 6469.80, 31.6),
			vector3(-111.48, 6467.74, 31.6),
		},
		reward = math.random(80000,95000),
		nameofbank = "Blaine County Savings",
		npc = {
			{model = 'a_m_m_business_01', pos = vector4(-111.07, 6470.11, 30.63, 136)},
			{model = 'a_m_m_business_01', pos = vector4(-114.42, 6464.78, 30.2, -50), scenario = 'PROP_HUMAN_SEAT_CHAIR'},
			{model = 'cs_casey', pos = vector4(-103.06, 6471.73, 30.63, 158), anim = 'mini@strip_club@idles@bouncer@base', dict = 'base'},
		},
	},
	fleecaSandy = { -- Sandy Shores
		holdupPosition = vector3(1176.8, 2711.8, 38.1),
		actionPositions = {
			vector3(1175.06, 2708.9, 38.1),
		},
		guichetPositions = {
			vector3(1175.36, 2706.29, 38.1),
		},
		reward = math.random(80000,95000),
		nameofbank = "Fleeca Sandy Shores",
		npc = {
			{model = 'a_m_m_business_01', pos = vector4(1176.51, 2708.25, 37.09, 178)},
		},
	},
	pacific = { -- Pacific Standard (Vinewood)
		holdupPosition = vector3(255.0, 225.8, 102.0),
		actionPositions = {
			vector3(260.1, 204.3, 110.25),
		},
		guichetPositions = {
			vector3(241.0, 224.12, 106.29),
			vector3(242.5, 223.58, 106.29),

			vector3(246.1, 222.35, 106.29),
			vector3(248.07, 221.63, 106.29),

			vector3(251.03, 220.54, 106.29),
			vector3(253.28, 219.7, 106.29),
		},
		reward = math.random(200000,300000),
		nameofbank = "Pacific Standard",
		npc = {
			{model = 'a_m_m_business_01', pos = vector4(247.32, 225.17, 105.29, 156)},
			{model = 'a_m_m_business_01', pos = vector4(252.31, 223.33, 105.29, 147)},
			{model = 'cs_casey', pos = vector4(236.32, 212.38, 105.29, 18), anim = 'mini@strip_club@idles@bouncer@base', dict = 'base'},
			{model = 'cs_casey', pos = vector4(263.31, 222.57, 105.28, 122), anim = 'mini@strip_club@idles@bouncer@base', dict = 'base'},
			{model = 'cs_casey', pos = vector4(264.83, 219.95, 100.68, 330), anim = 'mini@strip_club@idles@bouncer@base', dict = 'base'},
			{model = 'a_m_m_business_01', pos = vector4(257.69, 211.74, 104.85, 74), scenario = 'PROP_HUMAN_SEAT_CHAIR'},
		},
	},
	fleecaBeach = { -- Boulevard Del Perro (Beach)
		holdupPosition = vector3(-1212.2, -336.0, 37.8),
		actionPositions = {
			vector3(-1212.0, -332.7, 37.8),
		},
		guichetPositions = {
			vector3(-1212.9, -330.37, 37.8),
		},
		reward = math.random(80000,95000),
		nameofbank = "Fleeca Beach",
		npc = {
			{model = 'a_m_m_business_01', pos = vector4(-1213.39, -332.67, 36.78, 0)},
		},
	},
	fleeca2 = { -- Great Ocean Highway (West Highway)
		holdupPosition = vector3(-2957.6, 481.4, 15.7),
		actionPositions = {
			vector3(-2960.4, 483.2, 15.7),
		},
		guichetPositions = {
			vector3(-2963.32, 482.32, 15.7),
		},
		reward = math.random(80000,95000),
		nameofbank = "Fleeca Bank (Highway)",
		npc = {
			{model = 'a_m_m_business_01', pos = vector4(-2961.14, 481.5, 14.7, 86)},
		},
	},
	fleecaHospital = { -- Hawick Avenue (Near Hospital)
		holdupPosition = vector3(310.5, -283.1, 54.16),
		actionPositions = {
			vector3(313.67, -281.12, 54.16),
		},
		guichetPositions = {
			vector3(314.19, -278.0, 54.16),
		},
		reward = math.random(80000,95000),
		nameofbank = "Fleeca Bank (Hawick Avenue)",
		npc = {
			{model = 'a_m_m_business_01', pos = vector4(312.29, -280.05, 53.16, 341)},
		},
	},
	fleecaGouv = {
		holdupPosition = vector3(-354.26, -53.85, 49.04),
		actionPositions = {
			vector3(-352.24, -51.8, 49.04),
		},
		guichetPositions = {
			vector3(-351.0, -49.0, 49.04), -- Hawick Avenue (Near Gouv, center)
		},
		reward = math.random(80000,95000),
		nameofbank = "Fleeca Gov Bank (Hawick Avenue)",
		npc = {
			{model = 'a_m_m_business_01', pos = vector4(-352.9, -50.81, 48.04, 352)},
		},
	},
	fleecaCentralPark = {
		holdupPosition = vector3(147.0, -1044.9, 29.37),
		actionPositions = {
			vector3(149.1, -1042.6, 29.37),
		},
		guichetPositions = {
			vector3(149.01, -1040.0, 29.37), -- Vespuci Boulevard (Near central park)
		},
		reward = math.random(80000,95000),
		nameofbank = "Fleeca Central Park",
		npc = {
			{model = 'a_m_m_business_01', pos = vector4(148.01, -1041.57, 28.37, 349)},
		},
	},
--	delPerro = {
--		holdupPosition = vector3(-1309.93, -810.92, 17.15),
--		actionPositions = {
--			vector3(-1310.0, -820.07, 17.15),
--		},
--		guichetPositions = {
--			vector3(-1306.37, -823.09, 17.15),
--			vector3(-1308.1, -824.5, 17.15),
--			vector3(-1309.75, -825.84, 17.15),
--		},
--		reward = math.random(50000,90000),
--		nameofbank = "Del Perro",
--		npc = {
--			{model = 'a_m_m_business_01', pos = vector4(-1311.56, -822.79, 16.15, 225.12)},
--		},
--	},
}

Config.ATMProps = {
	`prop_atm_01`,
	`prop_atm_02`,
	`prop_atm_03`,
	`prop_fleeca_atm`,
}

Config.FleecaDoors = {
	-131754413,
}

Config.FreezedHashes = {
	297107423,
}

Config.ATMLocations = {}