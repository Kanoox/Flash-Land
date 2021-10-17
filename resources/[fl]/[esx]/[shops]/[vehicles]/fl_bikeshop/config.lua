Config = {}
Config.DrawDistance = 15.0
Config.ResellPercentage = 50
Config.Locale = 'fr'
Config.LicenseEnable = true -- require people to own drivers license when buying vehicles? Only applies if EnablePlayerManagement is disabled.

-- looks like this: 'LLL NNN'
-- The maximum plate length is 8 chars (including spaces & symbols), don't go past it!
Config.PlateLetters = 3
Config.PlateNumbers = 3
Config.PlateUseSpace = true

Config.Zones = {
	ShopEntering = {
		Pos = { x = 967.73, y = -116.28, z = 74.35-1 },
		Size = { x = 1.5, y = 1.5, z = 0.2 },
		MarkerColor = { r = 255, g = 255, b = 255, a = 200 },
		Type = 1
	},
	ShopInside = {
		Pos = { x = 970.41, y = -117.43, z = 73.82-1 },
		Size = { x = 1.5, y = 1.5, z = 1.0 },
		MarkerColor = { r = 120, g = 120, b = 240, a = 100 },
		Heading = 296.25,
		Type = -1
	},
	ShopOutside = {
		Pos = { x = 967.22, y = -117.72, z = 73.82-1 },
		Size = { x = 1.5, y = 1.5, z = 1.0 },
		MarkerColor = { r = 120, g = 120, b = 240, a = 100 },
		Heading = 359.42,
		Type = -1
	},
	BossActions = {
		Pos = { x = 986.52, y = -92.67, z = 74.85 },
		Size = { x = 1.5, y = 1.5, z = 1.0 },
		MarkerColor = { r = 0, g = 240, b = 0, a = 125 },
		Type = -1
	},
	GiveBackVehicle = {
		Pos = { x = 297.09, y = -1179.15, z = 28.75-1 },
		Size = { x = 3.0, y = 3.0, z = 2.0 },
		MarkerColor = { r = 255, g = 0, b = 0, a = 50 },
		Type = 37
	},
	ResellVehicle = {
		Pos = { x = 953.78, y = -133.59, z = 74.46-1 },
		Size = { x = 3.0, y = 3.0, z = 2.0 },
		MarkerColor = { r = 255, g = 0, b = 0, a = 50 },
		Type = 37
	}
}