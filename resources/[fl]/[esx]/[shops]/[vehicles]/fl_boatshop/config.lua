Config = {}
Config.Locale = 'fr'
Config.DrawDistance = 15.0
Config.MarkerColor = { r = 120, g = 120, b = 240 }
Config.ResellPercentage = 50 -- Sets the Resell Percentage | Example: $100 Car will resell for $75
Config.LicenseEnable = true -- Require people to own a Boating License when buying Vehicles?
Config.LicensePrice = 10000 -- Sets the License Price if Config.LicenseEnable is true

-- looks like this: 'LLL NNN'
-- The maximum plate length is 8 chars (including spaces & symbols), don't go past it!
Config.PlateLetters = 3
Config.PlateNumbers = 3
Config.PlateUseSpace = true

Config.Zones = {
	ShopEntering = { -- Marker for Accessing Shop
		Pos = {x = -714.357421875, y = -1297.3057861328, z = 4.1019196510315},
		Size = {x = 1.5, y = 1.5, z = 1.0},
		Type = 1
	},
	ShopInside = { -- Marker for Viewing Vehicles
		Pos = {x = -716.17, y = -1350.74, z = -0.48},
		Size = {x = 1.5, y = 1.5, z = 1.0},
		Heading = 138.4,
		Type = -1
	},
	ShopOutside = { -- Marker for Purchasing Vehicles
		Pos = {x = -717.73089599609, y = -1339.2368164063, z = -0.39563521742821},
		Size = {x = 1.5, y = 1.5, z = 1.0},
		Heading = 90.0,
		Type = -1
	},
	ResellVehicle = { -- Marker for Selling Vehicles
		Pos = {x = -725.38537597656, y = -1327.8604736328, z = -0.47477427124977},
		Size = {x = 3.0, y = 3.0, z = 1.0},
		Type = 1
	}
}