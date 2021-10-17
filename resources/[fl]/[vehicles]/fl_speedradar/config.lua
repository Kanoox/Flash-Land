Config = {}

Config.BillPrice = 100 -- $

Config.Radars = {
	{
		Name = 'Sandy Ouest',
		Pos = vector3(-1033.73, 5356.09, 43.22),
		PropPos = vector3(-1030.61, 5341.2, 45.38),
		MinSpeed = 150,
		Range = 40,
	},
	{
		Name = 'Sandy Est',
		Pos = vector3(1837.07, 6347.23, 39.18),
		PropPos = vector3(1845.41, 6369.61, 42.39),
		MinSpeed = 150,
		Range = 40,
	},
	{
		Name = 'LS Highway Est',
		Pos = vector3(1373.17, 661.3, 79.65),
		PropPos = vector3(1385.69, 652.12, 81.78),
		MinSpeed = 150,
		Range = 40,
	},
	{
		Name = 'LS Highway Ouest',
		Pos = vector3(-2986.87, 127.78, 17.34),
		PropPos = vector3(-2992.61, 125.22, 16.47),-- Doublé
		MinSpeed = 150,
		Range = 40,
	},
	{
		Name = 'LS Highway Raffinerie',
		Pos = vector3(2867.98, 4185.26, 52.0),
		PropPos = vector3(2871.48, 4185.7, 52.04), -- Doublé
		MinSpeed = 150,
		Range = 40,
	},
	{
		Name = 'Beach Tunnel',
		Pos = vector3(-1468.83, -777.71, 11.38),
		PropPos = vector3(-141.56, -764.4, 12.91), -- Doublé + bug vu que dans un MLO
		MinSpeed = 150,
		Range = 40,
	},
	{
		Name = 'Beach Tunnel',
		Pos = vector3(-1338.65, -729.72, 11.38), -- Pas cohérent ?
		MinSpeed = 150,
		Range = 40,
	},
	{
		Name = 'PillBox Medical Avenue',
		Pos = vector3(416.6, -551.47, 28.76),
		PropPos = vector3(422.5, -529.06, 30.36),
		MinSpeed = 130,
		Range = 10,
	},
	{
		Name = 'Pole Emploie Avenue',
		Pos = vector3(-184.91, -888.0, 29.23),
		PropPos = vector3(-208.68, -902.27, 31.01),
		MinSpeed = 130,
		Range = 20,
	},
	{
		Name = 'Skatepark Avenue',
		Pos = vector3(-886.9, -910.31, 15.81),
		PropPos = vector3(-882.47, -940.19, 17.02),
		MinSpeed = 130,
		Range = 20,
	},
}

Config.WhiteListedModels = {
	-- LSPD
	`polchar`,
	`explorer`,
	`poltaurus`,
	`polvic`,
	`17fusionrb`,
	`police`,
	`police2`,
	`police3`,
	`police4`,
	`policeb`,
	`policefelon`,
	`polmav`,
	`policet`,
	`pranger`,
	`riot`,
	`riot2`,
	`sheriff`,
	`sheriff2`,
	`pbus`,
	`fbi`,

	-- EMS
	`ambulance`,
	`romero`,
	`firetruk`,
}