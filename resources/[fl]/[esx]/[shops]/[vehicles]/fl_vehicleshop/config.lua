Config = {}
Config.DrawDistance = 15.0
Config.MarkerColor = { r = 120, g = 120, b = 240 }
Config.ResellPercentage = 70
Config.Locale = 'fr'
Config.LicenseEnable = true -- require people to own drivers license when buying vehicles? Only applies if EnablePlayerManagement is disabled.

-- looks like this: 'LLL NNN'
-- The maximum plate length is 8 chars (including spaces & symbols), don't go past it!
Config.PlateLetters = 3
Config.PlateNumbers = 3
Config.PlateUseSpace = true

Config.Zones = {
	ShopEntering = {
		Pos = { x = -30.54, y = -1106.81, z = 26.42-1 },
		Size = { x = 1.5, y = 1.5, z = 1.0 },
		Type = 1
	},
	ShopInside = {
		Pos = { x = -46.74, y = -1096.15, z = 25.82 },
		Size = { x = 1.5, y = 1.5, z = 1.0 },
		Heading = 25.82,
		Type = -1
	},
	ShopOutside = {
		Pos = { x = -45.25, y = -1081.09, z = 26.09 },
		Size = { x = 1.5, y = 1.5, z = 1.0 },
		Heading = 26.69,
		Type = -1
	},
	BossActions = {
		Pos = { x = -31.69, y = -1113.56, z = 26.42-1 },
		Size = { x = 1.5, y = 1.5, z = 1.0 },
		Type = -1
	},
	GiveBackVehicle = {
		Pos = { x = -9.47, y = -1096.23, z = 26.67 },
		Size = { x = 3.0, y = 3.0, z = 1.0 },
		Type = 1
	},
	ResellVehicle = {
		Pos = { x = -42.68, y = -1082.77, z = 26.68-1 },
		Size = { x = 3.0, y = 3.0, z = 1.0 },
		Type = 1
	}
}