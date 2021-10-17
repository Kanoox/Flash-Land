Config = {}
Config.Locale = 'fr'
Config.DrawDistance = 15.0
Config.MarkerColor = {r = 120, g = 120, b = 240}
Config.ResellPercentage = 50 -- Sets the Resell Percentage | Example: $100 Car will resell for $75
Config.LicenseEnable = true -- Require people to own a Aircraft License when buying Vehicles?
Config.LicensePrice = 50000 -- Sets the License Price if Config.LicenseEnable is true
-- looks like this: 'LLL NNN'
-- The maximum plate length is 8 chars (including spaces & symbols), don't go past it!
Config.PlateLetters = 3
Config.PlateNumbers = 3
Config.PlateUseSpace = true

Config.Zones = {
	ShopEntering = { -- Marker for Accessing Shop
		Pos = {x = -940.06, y = -2963.15, z = 18.85},
		Size = {x = 1.5, y = 1.5, z = 1.0},
		Type = 1
	},
	ShopInside = { -- Marker for Viewing Vehicles
		Pos = {x = -1874.76, y = -3137.59, z = 14.94}, -- { x = -1075.01, y = -2933.22, z = 14.55 },
		Size = {x = 1.5, y = 1.5, z = 1.0},
		Heading = 333.95, -- 59.9
		Type = -1
	},
	ShopOutside = { -- Marker for Purchasing Vehicles
		Pos = {x = -965.25, y = -2983.56, z = 14.55},
		Size = {x = 1.5, y = 1.5, z = 1.0},
		Heading = 59.9,
		Type = -1
	},
	ResellVehicle = { -- Marker for Selling Vehicles
		Pos = {x = -1003.24, y = -2920.79, z = 12.95},
		Size = {x = 3.0, y = 3.0, z = 1.0},
		Type = 1
	}
}