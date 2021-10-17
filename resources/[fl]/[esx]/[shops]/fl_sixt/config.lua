Config = {}
Config.DrawDistance = 15.0
Config.MarkerColor = { r = 120, g = 120, b = 240 }
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
		Pos = { x = -1011.72, y = -2683.09, z = 12.98 },
		Size = { x = 1.5, y = 1.5, z = 1.0 },
		Type = 1
	},
	ShopInside = {
		Pos = { x = -1007.44, y = -2677.49, z = 12.98 },
		Size = { x = 1.5, y = 1.5, z = 1.0 },
		Heading = 328.0,
		Type = -1
	},
	ShopOutside = {
		Pos = { x = -996.46, y = -2658.46, z = 12.98 },
		Size = { x = 1.5, y = 1.5, z = 1.0 },
		Heading = 330.0,
		Type = -1
	},
	BossActions = {
		Pos = { x = -1015.76, y = -2692.26, z = 12.98 },
		Size = { x = 1.5, y = 1.5, z = 1.0 },
		Type = -1
	},
	GiveBackVehicle = {
		Pos = { x = -985.39, y = -2642.88, z = 12.98 },
		Size = { x = 3.0, y = 3.0, z = 1.0 },
		Type = (Config.EnablePlayerManagement and 1 or -1)
	},
}