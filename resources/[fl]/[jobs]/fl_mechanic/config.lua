Config = {}
Config.Locale = 'fr'
Config.DrawDistance = 100
Config.NPCSpawnDistance = 500.0
Config.NPCNextToDistance = 25.0
Config.NPCJobEarnings = { min = 30, max = 60 }

Config.Vehicles = {
	'adder',
	'asea',
	'asterope',
	'banshee',
	'buffalo'
}

Config.Zones = {
	MechanicActions = {
		Pos = vector3(-346.85885620117, -133.65524291992, 38.009643554688),
		Size = {x = 1.2, y = 1.2, z = 1.0},
		Color = {r = 0, g = 255, b = 0},
		Type = 1
	},
	MechanicCloakroom = {
		Pos = vector3(-321.37121582031, -137.94145202637, 38.009654998779),
		Size = {x = 1.2, y = 1.2, z = 1.0},
		Color = {r = 0, g = 255, b = 0},
		Type = 1
	},
	MechanicVehicles = {
		Pos = vector3(-310.30627441406, -109.07145690918, 38.016330718994),
		Size = {x = 1.2, y = 1.2, z = 1.0},
		Color = {r = 0, g = 255, b = 0},
		Type = 1
	},
	Garage = {
		Pos = vector3(-322.85229492188, -146.30198669434, 38.015693664551),
		Size = {x = 1.2, y = 1.2, z = 1.0},
		Color = {r = 0, g = 255, b = 0},
		Type  = 1
	},
	Craft = {
		Pos = vector3(-315.40579223633, -124.14283752441, 38.01575088501),
		Size = {x = 1.2, y = 1.2, z = 1.0},
		Color = {r = 0, g = 255, b = 0},
		Type = 1
	},
	VehicleSpawnPoint = {
		Pos = vector4(-315.38616943359, -107.93185424805, 38.015686035156, 68.393348693848),
		Size = {x = 1.5, y = 1.5, z = 1.0},
		Type = -1
	},
	VehicleDeleter = {
		Pos = vector3(-315.38616943359, -107.93185424805, 38.015686035156-1),
		Size = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 255, g = 0, b = 0},
		Type = 1
	},
	VehicleDelivery = {
		Pos = vector3(-334.71838378906, -138.64218139648, 38.009666442871),
		Size = {x = 20.0, y = 20.0, z = 3.0},
		Color = {r = 204, g = 204, b = 0},
		Type = -1
	}
}

Config.Towables = {
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

for k,v in ipairs(Config.Towables) do
	Config.Zones['Towable' .. k] = {
		Pos = v,
		Size = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Type = -1
	}
end