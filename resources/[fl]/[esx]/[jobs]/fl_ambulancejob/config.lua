Config = {}

Config.DrawDistance = 15.0
Config.Marker = {type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false}
Config.ReviveReward = 125  -- revive reward, set to 0 if you don't want it enabled
Config.AntiCombatLog = true -- enable anti-combat logging?
Config.Locale = 'fr'

Config.EarlyRespawnTimer = 8 * 60 * 1000  -- Time til respawn is available
Config.BleedoutTimer = 30 * 60 * 1000 -- Time til the player bleeds out

Config.RespawnPoint = {coords = vector3(324.61, -593.45, 43.28), heading = 78.70}

Config.Hospitals = {

	CentralLosSantos = {
		Blip = {
			coords = vector3(296.23, -585.18, 43.28),
			sprite = 61,
			scale = 0.8,
			color = 2
		},
		AmbulanceActions = {
			vector3(299.30, -598.32, 43.28-1),
			vector3(1835.24, 3683.88, 34.27),
		},
		Pharmacies = {
			vector3(306.64, -601.27, 43.28-1)
		},
	},

	North = {
		Blip = {
			coords = vector3(-246.18, 6330.88, 32.43),
			sprite = 61,
			scale = 0.8,
			color = 2,
		},
		AmbulanceActions = {
			vector3(-248.72, 6330.28, 32.43),
		},
		Pharmacies = {
			vector3(-247.88, 6332.65, 32.43)
		},
	},
}
