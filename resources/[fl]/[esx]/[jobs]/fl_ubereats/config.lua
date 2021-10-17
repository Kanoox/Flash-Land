Config = {}
Config.DrawDistance = 20.0
Config.Locale = 'fr'

Config.Zones = {
	Cloakrooms = {
		Pos = {x = 40.05, y = -1010.20, z = 29.488},
		Size = {x = 1.0, y = 1.0, z = 1.0},
		Color = {r = 255, g = 187, b = 255},
		Type = 20,
	},

	Vaults = {
		Pos = {x = 42.88, y = -1011.32, z = 29.5},
		Size = {x = 1.0, y = 1.0, z = 1.0},
		Color = {r = 30, g = 144, b = 255},
		Type = 29,
	},

	Fridge = {
		Pos = {x = 43.82, y = -1008.22, z = 29.288},
		Size = {x = 1.0, y = 1.0, z = 1.0},
		Color = { r = 248, g = 248, b = 255},
		Type = 20,
	},

	BossActions = {
		Pos = {x = 43.70, y = -1005.68, z = 29.288},
		Size = {x = 1.0, y = 1.0, z = 1.0},
		Color = {r = 0, g = 100, b = 0},
		Type = 22,
	},
}

Config.Uniforms = {
	ubereats_outfit = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 40,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 40,
			['pants_1'] = 28,   ['pants_2'] = 2,
			['shoes_1'] = 38,   ['shoes_2'] = 4,
			['chain_1'] = 118,  ['chain_2'] = 0
		},
		female = {
			['tshirt_1'] = 3,   ['tshirt_2'] = 0,
			['torso_1'] = 8,    ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 5,
			['pants_1'] = 44,   ['pants_2'] = 4,
			['shoes_1'] = 0,    ['shoes_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 2
		}
	},
}
