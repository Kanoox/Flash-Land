Config = {}
settings             = {}
Config.Locale = 'fr'
cfg = {}
cfg.CheckOwnership = true -- If true, Only owner of vehicle can store items in trunk.
cfg.AllowPolice = true -- If true, police will be able to search players' trunks.
Config.BankSavingPercentage = 2.5
Config.MarkerType                 = 1
Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 0.5 }
Config.MarkerColor                = { r = 50, g = 50, b = 204 }
cfg.DrawDistance2               = 50.0
cfg.MarkerColor2                = { r = 102, g = 0, b = 102 }
cfg.MarkerSize2                 = { x = 2.5, y = 2.5, z = 1.0 }
cfg.ReviveReward2               = 0  -- revive reward, set to 0 if you don't want it enabled
cfg.AntiCombatLog2              = true -- enable anti-combat logging?
cfg.LoadIpl2                    = false -- disable if you're using fivem-ipl or other IPL loaders
cfg.RemoveWeaponsAfterRPDeath    = true
cfg.RemoveCashAfterRPDeath       = true
cfg.RemoveItemsAfterRPDeath      = false
cfg.ShowDeathTimer               = true
cfg.EarlyRespawn                 = false
cfg.RespawnFine                  = true
cfg.RespawnFineAmount            = 1000
cfg.Limit = 25000
cfg.DefaultWeight = 1000


cfg = {

	DrawDistance = 100,
	
	Locale = "fr",

	Price = 250,

	-- This is the multiplier of price to pay when the car is damaged
	-- 100% damaged means 1000 * Multiplier
	-- 50% damaged means 500 * Multiplier
	-- Etc.
	RepairMultiplier = 1, 
	
	BlipInfos = {
		Sprite = 290,
		Color = 38 
	},
	
	BlipPound = {
		Sprite = 67,
		Color = 64 
	}
}

cfg.Teleporters = {
	['Agent immo'] = {
		['Job'] = 'none',
		['Enter'] = { 
			['x'] = -198.742, 
			['y'] = -575.025, 
			['z'] = 40.489,
		},

		['Exit'] = {
			['x'] = -141.392, 
			['y'] = -621.0451, 
			['z'] = 168.8224, 
		}
	},
	['Weed'] = {
		['Job'] = 'none',
		['Enter'] = {
			['x'] = 135.152, 
			['y'] = 323.151, 
			['z'] = 116.652,
		},

		['Exit'] = {
			['x'] = 1065.468, 
			['y'] = -3183.480, 
			['z'] = -40.163, 
		}
	},
	['Blanchiment'] = {
		['Job'] = 'none',
		['Enter'] = {
			['x'] = 1192.222, 
			['y'] = -1268.135, 
			['z'] = 35.179,
		},

		['Exit'] = {
			['x'] = 1138.107, 
			['y'] = -3198.294, 
			['z'] = -39.665, 
		}
	},
	['Meth Recolte'] = {
		['Job'] = 'none',
		['Enter'] = {
			['x'] = 1728.751, 
			['y'] = 3851.224, 
			['z'] = 34.782,
		},

		['Exit'] = {
			['x'] = 997.378, 
			['y'] = -3200.713, 
			['z'] = -36.393, 
		}
	},
	['Bahamas Bar'] = {
		['Job'] = 'bahamas',
		['Enter'] = {
			['x'] = -1389.483, 
			['y'] = -591.824, 
			['z'] = 30.319,
		},

		['Exit'] = {
			['x'] = -1385.613, 
			['y'] = -606.713, 
			['z'] = 30.319, 
		}
	},
	['Bahamas Bar 2'] = {
		['Job'] = 'bahamas',
		['Enter'] = {
			['x'] = -1385.990, 
			['y'] = -627.282, 
			['z'] = 30.819,
		},

		['Exit'] = {
			['x'] = -1371.545, 
			['y'] = -625.778, 
			['z'] = 30.819, 
		}
	},
}

cfg.EMS = {
	HospitalInteriorInside1 = {
		PosEMS	= { x = 344.271, y = -1394.483, z = 32.50 },
		TypeEMS = -1
	},
	HospitalInteriorInside2 = { -- Roof outlet
  PosEMS	= { x = 333.1,	y = -1434.9, z = 45.5 },
  TypeEMS = -1
	},
	AmbulanceActions = { -- Cloakroom
  PosEMS	= { x = 301.413, y = -598.784, z = 42.284 },
  TypeEMS = 1
	},
	Pharmacy = {
		PosEMS	= { x = 306.715, y = -600.968, z = 42.283 },
		Size  = { x = 1.0, y = 1.0, z = 1.8 },
		TypeEMS = 1
	},
}

cfg.Garages = {

	Garage_Centre = {
		Pos = {x=135.129, y=-1049.823, z=28.151},--x=-280.990, y=-888.184, z=31.31--x=-273.041, y= -891.990, z= 31.080
		Size  = {x = 1.0, y = 1.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Marker = 36,
		SpawnPoint = {
			Pos = {x=103.856, y=-1077.327, z=29.192}, 
			Color = {r=0,g=255,b=0},
			Size  = {x = 1.0, y = 1.0, z = 1.0},
			Heading=341.489,
			Marker = 36
		},
		DeletePoint = {
			Pos = {x=134.452, y=-1052.767, z=29.163}, 
			Color = {r=255,g=0,b=0},
			Size  = {x = 1.0, y = 1.0, z = 1.0},
			Marker = 36,

		},
		MunicipalPoundPoint = {
			Pos = {x=483.816, y=-1319.087, z=28.251},
			Color = {r=25,g=25,b=112},
			Size  = {x = 1.0, y = 1.0, z = 1.0},
			Marker = 25
		},
		SpawnMunicipalPoundPoint = {
			Pos = {x=490.942, y=-1313.067, z=27.964},
			Color = {r=0,g=255,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = -1,
			Heading=299.42
		},
	},

	Garage_Cayo = {
		Pos = {x=4449.479, y= -4486.152, z= 4.219},--x=-280.990, y=-888.184, z=31.31--x=-273.041, y= -891.990, z= 31.080
		Size  = {x = 1.0, y = 1.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Marker = 36,
		SpawnPoint = {
			Pos = {x=4449.479, y= -4486.152, z= 4.219},
			Color = {r=0,g=255,b=0},
			Size  = {x = 1.0, y = 1.0, z = 1.0},
			Heading=195.498,
			Marker = 36
		},
		DeletePoint = {
			Pos = {x=4453.117, y=-4496.736, z=4.197},
			Color = {r=255,g=0,b=0},
			Size  = {x = 1.0, y = 1.0, z = 1.0},
			Marker = 36,

		},
		MunicipalPoundPoint = {
			Pos = {x=5051.516, y=-4595.531, z=2.901},
			Color = {r=25,g=25,b=112},
			Size  = {x = 1.0, y = 1.0, z = 1.0},
			Marker = 39
		},
		SpawnMunicipalPoundPoint = {
			Pos = {x=5049.568, y=-4608.965, z=2.014},
			Color = {r=0,g=255,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = -1,
			Heading=106.111
		},
	},

	Garage_Paleto = {
		Pos = {x=105.359, y=6613.586, z=31.1273},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Marker = 36,
		SpawnPoint = {
			Pos = {x=128.7822, y= 6622.9965, z= 31.8828},
			Color = {r=0,g=255,b=0},
			Size  = {x = 1.0, y = 1.0, z = 1.0},
			Marker = 36
		},
		DeletePoint = {
			Pos = {x=126.3572, y=6608.4150, z=31.9565},
			Color = {r=255,g=0,b=0},
			Size  = {x = 1.0, y = 1.0, z = 1.0},
			Marker = 36
		},
		MunicipalPoundPoint = {
			Pos = {x=-185.187, y=6272.027, z=31.580},
			Color = {r=25,g=25,b=112},
			Size  = {x = 1.0, y = 1.0, z = 1.0},
			Marker = 39
		},
		SpawnMunicipalPoundPoint = {
			Pos = {x=-199.160, y=6274.180, z=30.580},
			Color = {r=0,g=255,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = -1
		},
	},

	Garage_Poissoniers = {
		Pos = {x = -3147.46,y = 1103.54,z = 19.70 },
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Marker = 36,
		SpawnPoint = {
			Pos = {x = -3147.46,y = 1103.54,z = 20.80 },
			Color = {r=0,g=255,b=0},
			Size  = {x = 1.0, y = 1.0, z = 1.0},
			Marker = 36
		},
		DeletePoint = {
			Pos = {x = -3150.829,y = 1096.44,z = 20.80 },
			Color = {r=255,g=0,b=0},
			Size  = {x = 1.0, y = 1.0, z = 1.0},
			Marker = 36
		},
		MunicipalPoundPoint = {
			Pos = {x = -3158.2180,y = 1127.9536,z = 20.84 },
			Color = {r=25,g=25,b=112},
			Size  = {x = 1.0, y = 1.0, z = 1.0},
			Marker = 39
		},
		SpawnMunicipalPoundPoint = {
			Pos = {x = -3157.599,y = 1140.87,z = 20.10 },
			Color = {r=0,g=255,b=0},
			Size  = {x = 1.0, y = 1.0, z = 1.0},
			Marker = -1
		},
	},

	Garage_SandyShore = {
		Pos = {x = 1501.2,y = 3762.19,z = 33.0 },
		Size  = {x = 1.0, y = 1.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Marker = 36,
		SpawnPoint = {
			Pos = {x = 1497.15,y = 3761.37,z = 34.07 },
			Color = {r=0,g=255,b=0},
			Size  = {x = 1.0, y = 1.0, z = 1.0},
			Marker = 36
		},
		DeletePoint = {
			Pos = {x = 1504.1,y = 3765.55,z = 34.10 },
			Color = {r=255,g=0,b=0},
			Size  = {x = 1.0, y = 1.0, z = 1.0},
			Marker = 36
		},
		MunicipalPoundPoint = {
			Pos = {x = 1561.6000976563,y = 3522.8583984375,z = 35.789356231689 },
			Color = {r=25,g=25,b=112},
			Size  = {x = 1.0, y = 1.0, z = 1.0},
			Marker = 39
		},
		SpawnMunicipalPoundPoint = {
			Pos = {x = 1551.8347167969,y = 3518.1003417969,z = 34.988235473633 },
			Color = {r=0,g=255,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = -1
		},
	},
  	Garage_Aeroport = {
		Pos = {x = -977.21661376953,y = -2710.3798828125,z = 13.853487014771 },
		Size  = {x = 1.0, y = 1.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Marker = 36,
		SpawnPoint = {
			Pos = {x = -977.21661376953,y = -2710.3798828125,z = 13.953487014771 },
			Color = {r=0,g=255,b=0},
			Size  = {x = 1.0, y = 1.0, z = 1.0},
			Marker = 36
		},
		DeletePoint = {
			Pos = {x = -966.88208007813,y = -2709.9028320313,z = 13.93367729187 },
			Color = {r=255,g=0,b=0},
			Size  = {x = 1.0, y = 1.0, z = 1.0},
			Marker = 36
		},
		MunicipalPoundPoint = {
			Pos = {x = -1041.4571533203,y = -2676.3471679688,z = 13.830760002136 },
			Color = {r=25,g=25,b=112},
			Size  = {x = 1.0, y = 1.0, z = 1.0},
			Marker = 39
		},
		SpawnMunicipalPoundPoint = {
			Pos = {x = -1048.3468017578,y = -2669.771484375,z = 12.830758094788 },
			Color = {r=0,g=255,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = -1
		},
	},
	Garage_Central = {
		Pos = {x = 195.38171386719,y = -933.64733886719,z = 24.278621673584 },
		Size  = {x = 1.0, y = 1.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Marker = 36,
		SpawnPoint = {
			Pos = {x = 203.57913208008,y = -984.58001708984,z = 29.141815185547 },
			Color = {r=0,g=255,b=0},
			Size  = {x = 1.0, y = 1.0, z = 1.0},
			Marker = 36
		},
		DeletePoint = {
			Pos = {x = 190.12413024902,y = -931.93310546875,z = 24.282772064209 },
			Color = {r=255,g=0,b=0},
			Size  = {x = 1.0, y = 1.0, z = 1.0},
			Marker = 36
		},
		MunicipalPoundPoint = {
			Pos = {x = -1041.4571533203,y = -2676.3471679688,z = 13.830760002136 },
			Color = {r=25,g=25,b=112},
			Size  = {x = 1.0, y = 1.0, z = 1.0},
			Marker = 39
		},
		SpawnMunicipalPoundPoint = {
			Pos = {x = -1048.3468017578,y = -2669.771484375,z = 12.830758094788 },
			Color = {r=0,g=255,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = -1
		},
	},

}

cfg.TabacZones = {
	TabacBlondFarm = {
		Pos   = {x = 2871.274, y = 4580.724, z = 46.277},
		Size  = {x = 3.5, y = 3.5, z = 2.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Récolte tabac blond",
		Type  = 1
	},
	TabacBrunFarm = {
		Pos   = {x = 2895.200, y = 4593.318, z = 46.858},
		Size  = {x = 3.5, y = 3.5, z = 2.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Récolte tabac brun",
		Type  = 1
	},
	TraitementTabacBlond = {
		Pos   = {x = 903.699, y = 3586.889, z = 32.391},
		Size  = {x = 3.5, y = 3.5, z = 2.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Traitement tabac blond",
		Type  = 1
	},
	TraitementTabacBrun = {
		Pos   = {x = 245.05, y = 370.53, z = 104.79},
		Size  = {x = 3.5, y = 3.5, z = 2.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Traitement tabac brun",
		Type  = 1
	},
	VenteTabac = {
        Pos   = {x = -394.442, y = 208.520, z = 82.396},
        Size  = {x = 3.5, y = 3.5, z = 2.0},
        Color = {r = 136, g = 243, b = 216},
        Name  = "Vente de tabac",
        Type  = 1
    },
	CraftingCigarette = {
		Pos   = { x = 1191.869, y = -3303.677, z = 6.087 },
		Size  = { x = 1.6, y = 1.6, z = 1.0 },
		Color = {r = 136, g = 243, b = 216},
		Name  = "Création des Cigarettes",
		Type  = 1,
	},
}

cfg.VigneZones = {
	Garage = {
		Pos   = {x = 30.781, y = -899.359, z = 28.992},
		Size  = {x = 3.5, y = 3.5, z = 2.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Garage vigneron",
		Blip = 50,
		Type  = 1
	},
	RaisinFarm = {
		Pos   = {x = -1818.147, y = 2149.235, z = 116.337},
		Size  = {x = 3.5, y = 3.5, z = 2.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Récolte de raisin",
		Blip = 85,
		Type  = 1
	},
	RaisinFarm2 = {
		Pos   = {x = -1849.815, y = 2158.892, z = 115.081},
		Size  = {x = 3.5, y = 3.5, z = 2.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Récolte de raisin",
		Blip = 85,
		Type  = 1
	},
	TraitementVin = {
		Pos   = {x = -53.116, y = 1903.248, z = 194.361},
		Size  = {x = 3.5, y = 3.5, z = 2.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Traitement du Vin",
		Blip = 85,
		Type  = 1
	},
	TraitementJus = {
		Pos   = {x = 811.337, y = 2179.402, z = 51.388},
		Size  = {x = 3.5, y = 3.5, z = 2.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Traitement du Jus de raisin",
		Blip = 85,
		Type  = 1
	},
	SellFarm = {
		Pos   = {x = -158.737, y = -54.651, z = 53.396},
		Size  = {x = 3.5, y = 3.5, z = 2.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Vente des produits",
		Blip = 85,
		Type  = 1
	},
	SellFarm2 = {
        Pos   = {x = -394.442, y = 208.520, z = 82.396},
        Size  = {x = 3.5, y = 3.5, z = 2.0},
        Color = {r = 136, g = 243, b = 216},
        Name  = "Vente de Grand Cru",
		Blip = 85,
        Type  = 1
    },
}

cfg.Shops = {
	vector3(-814.3, -183.8, 36.6),
	vector3(136.8, -1708.4, 28.3),
	vector3(-1282.6, -1116.8, 6.0),
	vector3(1931.5, 3729.7, 31.8),
	vector3(1212.8, -472.9, 65.2),
	vector3(-32.9, -152.3, 56.1),
	vector3(-278.1, 6228.5, 30.7)
}

cfg.UseESX = true
cfg.JerryCanCost = 100
cfg.RefillCost = 100
cfg.FuelDecor = "_FUEL_LEVEL"
cfg.DisableKeys = {0, 22, 23, 24, 29, 30, 31, 37, 44, 56, 82, 140, 166, 167, 168, 170, 288, 289, 311, 323}
cfg.EnableHUD = false
cfg.ShowNearestGasStationOnly = false
cfg.ShowAllGasStations = true
cfg.CostMultiplier = 2.0
cfg.Strings = {
	ExitVehicle = "Sortir du véhicule pour mettre de l'essence",
	EToRefuel = "~r~Appuyez sur ~g~E ~w~pour faire le plein",
	JerryCanEmpty = "~r~La jerricane est pleine",
	FullTank = "~r~Le réservoir est plein",
	PurchaseJerryCan = "Appuyez sur ~g~E ~w~pour acheter une jerricane ~g~$" .. cfg.JerryCanCost,
	CancelFuelingPump = "Appuyez sur ~g~E ~w~pour arrêter",
	CancelFuelingJerryCan = "Appuyez sur ~g~E ~w~pour arrêter",
	NotEnoughCash = "Pas assez d'espèces",
	RefillJerryCan = "Appuyez sur ~g~E ~w~ pour remplir la jerricane ",
	NotEnoughCashJerryCan = "Pas assez d'espèces",
	JerryCanFull = "La jerricane est pleine",
	TotalCost = "Total",
}
cfg.PumpModels = {
	[-2007231801] = true,
	[1339433404] = true,
	[1694452750] = true,
	[1933174915] = true,
	[-462817101] = true,
	[-469694731] = true,
	[-164877493] = true
}
cfg.Blacklist = {
	--"Adder",
	--276773164
}
cfg.RemoveHUDForBlacklistedVehicle = true
cfg.Classes = {
	[0] = 1.0, -- Compacts
	[1] = 1.0, -- Sedans
	[2] = 1.0, -- SUVs
	[3] = 1.0, -- Coupes
	[4] = 1.0, -- Muscle
	[5] = 1.0, -- Sports Classics
	[6] = 1.0, -- Sports
	[7] = 1.0, -- Super
	[8] = 1.0, -- Motorcycles
	[9] = 1.0, -- Off-road
	[10] = 0.5, -- Industrial
	[11] = 0.5, -- Utility
	[12] = 1.0, -- Vans
	[13] = 0.0, -- Cycles
	[14] = 1.0, -- Boats
	[15] = 1.0, -- Helicopters
	[16] = 1.0, -- Planes
	[17] = 0.5, -- Service
	[18] = 0.5, -- Emergency
	[19] = 1.0, -- Military
	[20] = 0.5, -- Commercial
	[21] = 1.0, -- Trains
}
cfg.FuelUsage = {
	[1.0] = 0.3,
	[0.9] = 0.3,
	[0.8] = 0.3,
	[0.7] = 0.3,
	[0.6] = 0.3,
	[0.5] = 0.3,
	[0.4] = 0.3,
	[0.3] = 0.3,
	[0.2] = 0.3,
	[0.1] = 0.3,
	[0.0] = 0.3,
}
cfg.GasStations = {
	vector3(49.4187, 2778.793, 58.043),
	vector3(263.894, 2606.463, 44.983),
	vector3(1039.958, 2671.134, 39.550),
	vector3(1207.260, 2660.175, 37.899),
	vector3(2539.685, 2594.192, 37.944),
	vector3(2679.858, 3263.946, 55.240),
	vector3(2005.055, 3773.887, 32.403),
	vector3(1687.156, 4929.392, 42.078),
	vector3(1701.314, 6416.028, 32.763),
	vector3(179.857, 6602.839, 31.868),
	vector3(-94.4619, 6419.594, 31.489),
	vector3(-2554.996, 2334.40, 33.078),
	vector3(-1800.375, 803.661, 138.651),
	vector3(-1437.622, -276.747, 46.207),
	vector3(-2096.243, -320.286, 13.168),
	vector3(-724.619, -935.1631, 19.213),
	vector3(-526.019, -1211.003, 18.184),
	vector3(-70.2148, -1761.792, 29.534),
	vector3(265.648, -1261.309, 29.292),
	vector3(819.653, -1028.846, 26.403),
	vector3(1208.951, -1402.567,35.224),
	vector3(1181.381, -330.847, 69.316),
	vector3(620.843, 269.100, 103.089),
	vector3(2581.321, 362.039, 108.468),
	vector3(176.631, -1562.025, 29.263),
	vector3(176.631, -1562.025, 29.263),
	vector3(-319.292, -1471.715, 30.549),
	vector3(1784.324, 3330.55, 41.253)
}

cfg.Map = {
	{name="~b~Aéroport",color=15, id=90, size = 0.6, x = -1044.2636, y = -2749.4445, z = 21.3634 },
	{name="Fourrière",color=49, id=477, size = 0.6, x=482.896, y = -1316.557, z =28.301},
	{name="Fourrière",color=49, id=477, size = 0.6, x=-185.187, y = 6272.027, z =30.580},
	{name="Fourrière",color=49, id=477, size = 0.6, x=-3158.8347167969, y = 1127.1069335938, z =46.61901473999},
	{name="Fourrière",color=49, id=477, size = 0.6, x=1561.6000976563, y = 3522.8583984375, z =34.789356231689},
	{name="Fourrière",color=49, id=477, size = 0.6, x=-1041.4571533203, y = -2676.3471679688, z =12.830760002136},
	{name="Garage",color=42, id=290, size = 0.6, x=105.758, y =6613.619, z =31.014},
	{name="Garage",color=42, id=290, size = 0.6, x=-275.012, y = -892.670, z =31.014},
	{name="Garage",color=42, id=290, size = 0.6, x=-3147.758, y =1103.619, z =20.014},
	{name="Garage",color=42, id=290, size = 0.6, x=1501.758, y =3762.619, z =33.014},
	{name="Garage",color=42, id=290, size = 0.6, x=-977.758, y =-2710.619, z =12.014},
	{name="~r~Centre pénitentier",color=81, id=252, size = 0.6, x = 1816.352, y = 2610.441, z = 44.901},
	{name="~b~SSMC",color=3, id=61, size = 0.6, x = 1835.001, y = 3677.582, z = 33.271},
	{name="Night Club",color=8, id=614, size = 0.6, x = -302.250, y = 6260.206, z = 30.508},
	{name="Diamond Casino",color=38, id=679, size = 0.6, x = 921.331, y = 47.280, z = 80.092},
	{name="Prison",color=1, id=677, size = 0.8, x = 713.957, y = 141.734, z = 80.092},
	{name="Gouvernement",color=0, id=419, size = 1.0, x = -1282.398, y = -563.638, z = 30.712},
}

settings.green 				  = 56108
settings.grey 				      = 8421504
settings.red 					  = 16711680
settings.orange 				  = 16744192
settings.blue 				      = 2061822
settings.purple 				  = 11750815
settings.webhook                 = "https://discord.com/api/webhooks/756985408696615063/XXmhwGAylq4tbiYzwo16vt8c-rRldJ-HXYK1iLV-dEiNmdxmmkIYVGbqPLak2J6gE7Ux"


settings = {
	LogKills = true, -- Log when a player kill an other player.
	LogEnterPoliceVehicle = true, -- Log when an player enter in a police vehicle.
	LogEnterBlackListedVehicle = true, -- Log when a player enter in a blacklisted vehicle.
	LogPedJacking = true, -- Log when a player is jacking a car
	LogChatServer = true, -- Log when a player is talking in the chat , /command works too.
	LogLoginServer = true, -- Log when a player is connecting/disconnecting to the server.
	LogItemTransfer = true, -- Log when a player is giving an item.
	LogWeaponTransfer = true, -- Log when a player is giving a weapon.
	LogMoneyTransfer = true, -- Log when a player is giving money
	LogMoneyBankTransfert = true, -- Log when a player is giving money from bankaccount

}



blacklistedModels = {
	"APC",
	"BARRACKS",
	"BARRACKS2",
	"RHINO",
	"CRUSADER",
	"CARGOBOB",
	"SAVAGE",
	"TITAN",
	"LAZER",
	"LAZER",
}

cfg.WhitelistedCops = {
	'police',
}
cfg.Timer = 1
cfg.ShowCopsMisbehave = true
cfg.BlipGunRadius = 50.0
cfg.BlipJackingTime = 15
cfg.CarJackingAlert = true
cfg.GunshotAlert = true

cfg.InfiniteLocks		= false  -- Should one lockpick last forever?
cfg.LockTime			    = 60     -- In seconds, how long should lockpicking take?
cfg.AlarmTime            = 60     -- Second to have the alarm activated once vehicle is lockpicked
cfg.JammedHandbrakeTime  = 10     -- Second to have the handbrake jammed
cfg.IgnoreAbort			= true   -- Remove lockpick from inventory even if user aborts lockpicking?
cfg.AllowMecano			= true   -- Allow mechanics to use this lockpick?
cfg.NPCVehiclesLocked    = true   -- Locks all vehicles (MUST HAVE SOME SORT OF LOCKSYSTEM FOR OWNED CAR) Will be adding a check for owned vehicle in the future. 
cfg.percentage           = 100	 -- In percentage
cfg.CallCops             = true   -- Set to true if you want cops to be alerted when lockpicking a vehicle no matter what the outcome is.
cfg.CallCopsPercent      = 1      -- (min1) if 1 then cops will be called every time=100%, 2=50%, 3=33%, 4=25%, 5=20%.
cfg.chance               = 0      -- chance of being unlocked in percentage

cfg.blacklist = { -- vehicles that will always be locked when spawned naturally
  "T20",
  "police",
  "police2",
  "sheriff3",
  "sheriff2",
  "sheriff",
  "riot",
  "fbi",
  "hwaycar2",
  "hwaycar3",
  "hwaycar10",
  "hwaycar",
  "polf430",
  "policeb",
  "police7",
  "RHINO"
}

cfg.job_whitelist = {
"police",
"ambulance"
}

cfg.ZonesMechanic = {
	VehicleDelivery = {
		Pos   = { x = -184.871, y = -1293.658, z = 31.2959 },
		Size  = { x = 20.0, y = 20.0, z = 3.0 },
		Color = { r = 204, g = 204, b = 0 },
		Type  = 1
	}
}

cfg.Towables = {
	vector3(-2480.9, -212.0, 17.4),
	vector3(-2723.4, 13.2, 15.1),
	vector3(-3169.6, 976.2, 15.0),
	vector3(-3139.8, 1078.7, 20.2),
	vector3(-1656.9, -246.2, 54.5),
	vector3(-1586.7, -647.6, 29.4),
	vector3(-1036.1, -491.1, 36.2),
	vector3(-1029.2, -475.5, 36.4),
	vector3(75.2, 164.9, 104.7),
	vector3(-534.6, -756.7, 31.6),
	vector3(487.2, -30.8, 88.9),
	vector3(-772.2, -1281.8, 4.6),
	vector3(-663.8, -1207.0, 10.2),
	vector3(719.1, -767.8, 24.9),
	vector3(-971.0, -2410.4, 13.3),
	vector3(-1067.5, -2571.4, 13.2),
	vector3(-619.2, -2207.3, 5.6),
	vector3(1192.1, -1336.9, 35.1),
	vector3(-432.8, -2166.1, 9.9),
	vector3(-451.8, -2269.3, 7.2),
	vector3(939.3, -2197.5, 30.5),
	vector3(-556.1, -1794.7, 22.0),
	vector3(591.7, -2628.2, 5.6),
	vector3(1654.5, -2535.8, 74.5),
	vector3(1642.6, -2413.3, 93.1),
	vector3(1371.3, -2549.5, 47.6),
	vector3(383.8, -1652.9, 37.3),
	vector3(27.2, -1030.9, 29.4),
	vector3(229.3, -365.9, 43.8),
	vector3(-85.8, -51.7, 61.1),
	vector3(-4.6, -670.3, 31.9),
	vector3(-111.9, 92.0, 71.1),
	vector3(-314.3, -698.2, 32.5),
	vector3(-366.9, 115.5, 65.6),
	vector3(-592.1, 138.2, 60.1),
	vector3(-1613.9, 18.8, 61.8),
	vector3(-1709.8, 55.1, 65.7),
	vector3(-521.9, -266.8, 34.9),
	vector3(-451.1, -333.5, 34.0),
	vector3(322.4, -1900.5, 25.8)
}

for k,v in ipairs(cfg.Towables) do
	cfg.ZonesMechanic['Towable' .. k] = {
		Pos   = v,
		Size  = { x = 1.5, y = 1.5, z = 1.0 },
		Color = { r = 204, g = 204, b = 0 },
		Type  = -1
	}
end

cfg.localWeight = {

    alive_chicken           = 250,
    slaughtered_chicken     = 250,
    packaged_chicken        = 1000,
    fish                    = 1000,
    stone                   = 1000,
    washed_stone            = 250,
    copper                  = 200,
    iron                    = 150,
    gold                    = 330,
    diamond                 = 30,
    wood                    = 250,
    cutted_wood             = 250,
    packaged_plank          = 300,
    petrol                  = 12000,
    petrol_raffin           = 12000,
    essence                 = 12000,
    wool                    = 500,
    fabric                  = 1000,
    clothe                  = 700,
    goldmedal               = 1,
    silvermedal             = 1,
    bronzemedal             = 1,
    water                   = 150,
    bread                   = 150,
    contrat                 = 1000,
    armor                   = 1000,
    cutting_pliers          = 500,
    handcuff                = 500,
    bandage                 = 500,
    medikit                 = 1000,
    weed                    = 500,
    weed_pooch              = 2500,
    coke                    = 500,
    coke_pooch              = 2500,
    meth                    = 500,
    meth_pooch              = 2500,
    opium                   = 500,
    opium_pooch             = 2500,
    meat                    = 500,
    leather                 = 500,
    firstaidkit             = 1500,
    defibrillateur          = 5000,
    gazbottle               = 500,
    fixtool                 = 8000,
    carotool                = 8000,
    blowpipe                = 1000,
    fixkit                  = 1000,
    carokit                 = 1000,
    fishbait                = 1000,
    fishingrod              = 500,
    shark                   = 1000,
    turtle                  = 1000,
    turtlebait              = 1000,
    clip                    = 5000,
    pizza                   = 500,
    scratchoff              = 10,
    scratchoff_used         = 10,
    jewels                  = 2000,
    WEAPON_NIGHTSTICK       = 500,
    WEAPON_STUNGUN          = 1000,
    WEAPON_FLASHLIGHT       = 500,
    WEAPON_FLAREGUN         = 1000,
    WEAPON_FLARE            = 1000,
    WEAPON_COMBATPISTOL     = 2500,
    WEAPON_HEAVYPISTOL      = 4000,
    WEAPON_ASSAULTSMG       = 7000,
    WEAPON_COMBATPDW        = 7000,
    WEAPON_BULLPUPRIFLE     = 8000,
    WEAPON_PUMPSHOTGUN      = 8000,
    WEAPON_BULLPUPSHOTGUN   = 10000,
    WEAPON_CARBINERIFLE     = 10000,
    WEAPON_ADVANCEDRIFLE    = 10000,
    WEAPON_MARKSMANRRIFLE   = 15000,
    WEAPON_SNIPERRIFLE      = 15000,
    WEAPON_FIREEXTINGUISHER = 1500, 
    GADGET_PARACHUTE        = 5000,
    WEAPON_BAT              = 1500,
    WEAPON_PISTOL           = 5000,
    money                   = 10,
	black_money             = 10,
}

cfg.VehicleLimit = {
    [0] = 30000, --Compact
    [1] = 40000, --Sedan
    [2] = 100000, --SUV
    [3] = 40000, --Coupes
    [4] = 40000, --Muscle
    [5] = 25000, --Sports Classics
    [6] = 40000, --Sports
    [7] = 5000, --Super
    [8] = 0, --Motorcycles
    [9] = 150000, --Off-road
    [10] = 800000, --Industrial
    [11] = 100000, --Utility
    [12] = 150000, --Vans
    [13] = 0, --Cycles
    [14] = 100000, --Boats
    [15] = 0, --Helicopters
    [16] = 0, --Planes
    [17] = 40000, --Service
    [18] = 350000, --Emergency
    [19] = 0, --Military
    [20] = 350000, --Commercial
    [21] = 0, --Trains

}

cfg.VehicleModel = {

    brickade    = 1500000, --Commercial
    rallytruck  = 1500000, --Commercial
    armarello  = 1000000, --Commercial
    hauler  = 1000000, --Commercial
    ramvan  = 1000000, --Commercial
    phantom  = 800000, --Commercial
    phantomhd  = 800000, --Commercial
    vnl780  = 800000, --Commercial
    guardian    = 350000, --Vans

}

cfg.VehiclePlate = {
	taxi        = "TAXI",
	cop         = "LSPD",
	ambulance   = "EMS0",
	mecano	    = "MECA",
}

cfg.ShowFreemode = true				--set to false to show only chat notification
cfg.ShowMessage = false				--for chat notification
cfg.CountDownNotification = true		--countdown notification
cfg.CountDownChat = false		--countdown in chat
cfg.FreemodeTime = 8				--time to show freemode
cfg.Wait = 10 * 1000				--time to wait, 1 * 1000 = 1 second
cfg.One = 5