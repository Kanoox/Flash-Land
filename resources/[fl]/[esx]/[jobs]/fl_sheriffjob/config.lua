Config = {}

Config.DrawDistance = 100.0
Config.MarkerType = 1
Config.MarkerSize = {x = 1.5, y = 1.5, z = 0.5}
Config.MarkerColor = {r = 50, g = 50, b = 204}

Config.Locale = 'fr'

Config.WhitelistedCops = {
	'sheriff',
}

Config.ArmoryWeapons = {
	{ ["item"] = "assaultsmg", ["type"] = "rifle" },
	{ ["item"] = "specialcarbine", ["type"] = "rifle" },
	{ ["item"] = "pumpshotgun", ["type"] = "rifle" }
}

Config.PrefixBracelet = 'bracelet_'

Config.Armory = { ["x"] = -577.54, ["y"] = -114.59, ["z"] = -50.88, ["h"] = 109.78 }
Config.ArmoryPed = { ["x"] = 480.73, ["y"] = -996.68, ["z"] = 30.69, ["h"] = 81.84, ["hash"] = "s_m_y_cop_01" }

Config.sheriffStations = {
	LSPD = {

		Blip = {
			Coords = vector3(-445.88, 6014.07, 31.72),
			Sprite = 60,
			Display = 4,
			Scale = 0.7,
			Colour = 52
		},

		Cloakrooms = {
			vector3(-452.97, 6013.81, 30.75),
			--vector3(461.4, -998.86, 30.69),
			--vector3(461.55, -996.3, 30.69),
		},

		Armories = {
			vector3(-437.45, 6001.24, 30.7160),
			--vector3(485.54, -995.65, 30.69),
			--vector3(486.88, -997.2, 30.69),
		},

		Stock = {									--A MODIFIER--
			vector3(-439.33, 6009.94, 26.99),
		},

		BossActions = {
			vector3(-447.2, 6014.15, 35.51),
		}
	},

	--[[VESPUCI = {

		Blip = {
			Coords = vector3(-1086.02, -821.85, 30.71),
			Sprite = -1,
			Display = -1,
			Scale = 0,
			Colour = 38
		},

		Cloakrooms = {
			vector3(-1092.54, -826.43, 26.83),
			vector3(-1095.29, -833.4, 14.28),
		},

		Armories = {
			vector3(-1099.01, -826.12, 14.28),
			vector3(-1102.04, -829.53, 14.28),
		},

		Stock = {
			vector3(-1088.31, -821.19, 11.04),
			vector3(-1079.29, -815.21, 11.04),
			vector3(-1086.01, -810.9, 11.04),
			vector3(-1091.26, -815.43, 11.04),
		},

		BossActions = {
			vector3(-1115.18, -832.14, 34.36),
		}
	},---]]

}

-- CHECK SKINCHANGER CLIENT MAIN.LUA for matching elements
Config.Uniforms = {

	tenu_lspd = {
		male = {
			['tshirt_1'] = 56,  ['tshirt_2'] = 0,
			['torso_1'] = 190,   ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 30,  ['bags_1'] = 52,
			['pants_1'] = 32,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['mask_1'] = -1,  ['mask_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 38,  ['tshirt_2'] = 0,
			['torso_1'] = 200,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 75,  ['bags_1'] = 52,
			['pants_1'] = 35,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['mask_1'] = -1,  ['mask_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},

	tenu_ma = {
		male = {
			['tshirt_1'] = 38,  ['tshirt_2'] = 0,
			['torso_1'] = 200,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 75,
			['pants_1'] = 35,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['mask_1'] = -1,  ['mask_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 38,  ['tshirt_2'] = 0,
			['torso_1'] = 200,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 75,
			['pants_1'] = 35,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['mask_1'] = -1,  ['mask_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},

	tenu_swatgr = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 50,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 41,   ['bags_1'] = 46,
			['pants_1'] = 31,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 126,  ['helmet_2'] = 0,
			['mask_1'] = 52,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['bproof_1'] = 7,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 43,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 41,   ['bags_1'] = 46,
			['pants_1'] = 31,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 126,  ['helmet_2'] = 0,
			['mask_1'] = 56,
			['chain_1'] = 1,    ['chain_2'] = 0,
			['bproof_1'] = 7,  ['bproof_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},

	bullet_wear = {
		male = {
			['bproof_1'] = 7,  ['bproof_2'] = 0
		},
		female = {
			['bproof_1'] = 7,  ['bproof_2'] = 0
		}
	}

}