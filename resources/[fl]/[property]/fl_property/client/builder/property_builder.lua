local outside = nil
local entering = nil
local garage = nil
local price = nil
local selectedPropertyIndex = 1
local selectedSoldbyIndex = 1
local beforeTeleport = nil
local cam = nil
local index = { enter = 1, garage = 1, typePreview = 1, typeInterior = 1, numberPlaces = 1, coffre = 1 }

local MenuAgenceImmo = false
local propertyEnter = nil
local propertyName, propertyLabel, propertyMarker, InPreview  = nil, nil, {}, false

local itemsSoldby = {'realestateagent', 'gouv', '_dev', 'casino'}

local properties = {
	{
		type = 'MidCost',
		name = 'Abordable',

		ipl = '[]',
		inside = vector3(346.69,-1011.91,-99.2),
		exit = vector3(346.69,-1011.91,-99.2),
		roomMenu = vector3(351.44,-999.31,-99.2), 
		MinimumPrice = 10000,
		MaximumPoids = 300,
		isSingle = 1,
		isRoom = 1,
		isGateway = 0,
		interiorId = 148225,
		clothingMenu = vector3(350.69, -994.26, -99.15),

		cam = {
			focus = vector3(338.4, -994.37, -97.92),
			rot = vector3(0.0, 0.0, 216.58),
		},
	},
	{
		type = 'SimpleAppart',
		name = 'Apparts',

		ipl = '[]',
		inside = vector3(265.307, -1002.802, -100.008),
		exit = vector3(266.11, -1007.18, -101.012),
		roomMenu = vector3(261.86, -1002.86, -99.01),
		MinimumPrice = 12500,
		MaximumPoids = 350,
		isSingle = 1,
		isRoom = 1,
		isGateway = 0,
		interiorId = 0,
		clothingMenu = vector3(259.9, -1003.55, -99.01),

		cam = {
			focus = vector3(257.26, -995.26, -97.58),
			rot = vector3(-20.0, 0.0, 225.58),
		},
	},
	{
		type = 'LowCost',
		name = 'Motel',

		ipl = '[]',
		inside = vector3(151.57, -1007.52, -99.0),
		exit = vector3(151.57, -1007.52, -99.0),
		roomMenu = vector3(153.74, -1002.71, -99.0),
		MinimumPrice = 7500,
		MaximumPoids = 250,
		isSingle = 1,
		isRoom = 1,
		isGateway = 0,
		interiorId = 0,
		clothingMenu = vector3(153.9, -1001.0, -99.0),

		cam = {
			focus = vector3(151.57, -1007.52, -99.0),
			rot = vector3(0.0, 0.0, 329.0),
		},
	},
	--[[{
		type = 'ShitWarehouse',
		name = 'Entrepot (Merdique)',

		ipl = '[]',
		inside = vector3(1134.36, -1622.61, 29.91),
		exit = vector3(1134.34, -1624.16, 28.91),
		roomMenu = vector3(1134.05, -1613.31, 28.91),
		MinimumPrice = 1500,
		isSingle = 1,
		isRoom = 1,
		isGateway = 0,
		interiorId = -60,
		clothingMenu = nil,

		cam = {
			focus = vector3(1134.36, -1622.61, 29.91),
			rot = vector3(0.0, 0.0, 355.68),
		},
	},]]--
	{
		type = 'BigWarehouse',
		name = 'Entrepot (grand)',

		ipl = '[]',
		inside = vector3(1026.32, -3100.31, -39.01),
		exit = vector3(1027.09, -3101.83, -39.01),
		roomMenu = vector3(994.1, -3100.19, -39.01),
		MinimumPrice = 45000,
		MaximumPoids = 700,
		isSingle = 1,
		isRoom = 1,
		isGateway = 0,
		interiorId = -60,
		clothingMenu = nil,

		cam = {
			focus = vector3(1026.8707, -3099.8710, -38.9998),
			rot = vector3(0.0, 0.0, 85.68),
		},
	},
	{
		type = 'MidWarehouse',
		name = 'Entrepot (moyen)',

		ipl = '[]',
		inside = vector3(1070.2, -3101.96, -39.01),
		exit = vector3(1072.67, -3102.63, -39.01),
		roomMenu = vector3(1049.09, -3100.4, -39.01),
		MinimumPrice = 35000,
		MaximumPoids = 600,
		isSingle = 1,
		isRoom = 1,
		isGateway = 0,
		interiorId = -60,
		clothingMenu = nil,

		cam = {
			focus = vector3(1072.8447, -3100.0390, -39.0),
			rot = vector3(0.0, 0.0, 91.85),
		},
	},
	{
		type = 'LittleWarehouse',
		name = 'Entrepot (petit)',

		ipl = '[]',
		inside = vector3(1102.38, -3099.54, -39.01),
		exit = vector3(1104.54, -3099.66, -39.01),
		roomMenu = vector3(1089.22, -3101.23, -39.01),
		MinimumPrice = 25000,
		MaximumPoids = 500,
		isSingle = 1,
		isRoom = 1,
		isGateway = 0,
		interiorId = -60,
		clothingMenu = nil,

		cam = {
			focus = vector3(1104.72, -3100.07, -39.0),
			rot = vector3(0.0, 0.0, 88.76),
		},
	},
	{
		type = 'House1',
		name = 'Maison1',

		ipl = '[]',
		inside = vector3(-200, -250, 1600) + vector3(2.17, -19.31, 2.3),
		exit = vector3(-200, -250, 1600) + vector3(2.17, -19.31, 1.8),
		roomMenu = vector3(-200, -250, 1600) + vector3(-8.19, -8.72, 1.2),
		MinimumPrice = 12500,
		MaximumPoids = 300,
		isSingle = 1,
		isRoom = 1,
		isGateway = 0,
		interiorId = 0,
		clothingMenu = vector3(-200, -250, 1600) + vector3(-9.92, -6.5, 4.6),

		cam = {
			focus = vector3(-200, -250, 1600) + vector3(6.17, 7.69, 2),
			rot = vector3(0.0, 0.0, 132.0),
		},
	},
	{
		type = 'House2',
		name = 'Maison2',

		ipl = '[]',
		inside = vector3(-200, -150, 1600) + vector3(2.17, -19.31, 2.3),
		exit = vector3(-200, -150, 1600) + vector3(2.17, -19.31, 1.8),
		roomMenu = vector3(-200, -150, 1600) + vector3(-8.19, -8.72, 1.2),
		MinimumPrice = 12500,
		MaximumPoids = 300,
		isSingle = 1,
		isRoom = 1,
		isGateway = 0,
		interiorId = 0,
		clothingMenu = vector3(-200, -150, 1600) + vector3(-9.92, -6.5, 4.6),

		cam = {
			focus = vector3(-200, -150, 1600) + vector3(6.17, 7.69, 2),
			rot = vector3(0.0, 0.0, 132.0),
		},
	},
	{
		type = 'House3',
		name = 'Maison3',

		ipl = '[]',
		inside = vector3(-250, -250, 1600) + vector3(2.17, -19.31, 2.3),
		exit = vector3(-250, -250, 1600) + vector3(2.17, -19.31, 1.8),
		roomMenu = vector3(-250, -250, 1600) + vector3(-8.19, -8.72, 1.2),
		MinimumPrice = 12500,
		MaximumPoids = 300,
		isSingle = 1,
		isRoom = 1,
		isGateway = 0,
		interiorId = 0,
		clothingMenu = vector3(-250, -250, 1600) + vector3(-9.92, -6.5, 4.6),

		cam = {
			focus = vector3(-250, -250, 1600) + vector3(6.17, 7.69, 2),
			rot = vector3(0.0, 0.0, 132.0),
		},
	},
	{
		type = 'House4',
		name = 'Maison4',

		ipl = '[]',
		inside = vector3(-250, -200, 1600) + vector3(2.17, -19.31, 2.3),
		exit = vector3(-250, -200, 1600) + vector3(2.17, -19.31, 1.8),
		roomMenu = vector3(-250, -200, 1600) + vector3(-8.19, -8.72, 1.2),
		MinimumPrice = 12500,
		MaximumPoids = 300,
		isSingle = 1,
		isRoom = 1,
		isGateway = 0,
		interiorId = 0,
		clothingMenu = vector3(-250, -200, 1600) + vector3(-9.92, -6.5, 4.6),

		cam = {
			focus = vector3(-250, -200, 1600) + vector3(6.17, 7.69, 2),
			rot = vector3(0.0, 0.0, 132.0),
		},
	},
	{
		type = 'House5',
		name = 'Maison5',

		ipl = '[]',
		inside = vector3(-150, -200, 1600) + vector3(2.17, -19.31, 2.3),
		exit = vector3(-150, -200, 1600) + vector3(2.17, -19.31, 1.8),
		roomMenu = vector3(-150, -200, 1600) + vector3(-8.19, -8.72, 1.2),
		MinimumPrice = 12500,
		MaximumPoids = 300,
		isSingle = 1,
		isRoom = 1,
		isGateway = 0,
		interiorId = 0,
		clothingMenu = vector3(-150, -200, 1600) + vector3(-9.92, -6.5, 4.6),

		cam = {
			focus = vector3(-150, -200, 1600) + vector3(6.17, 7.69, 2),
			rot = vector3(0.0, 0.0, 132.0),
		},
	},
	{
		type = 'House6',
		name = 'Maison6',

		ipl = '[]',
		inside = vector3(-250, -150, 1600) + vector3(2.17, -19.31, 2.3),
		exit = vector3(-250, -150, 1600) + vector3(2.17, -19.31, 1.8),
		roomMenu = vector3(-250, -150, 1600) + vector3(-8.19, -8.72, 1.2),
		MinimumPrice = 12500,
		MaximumPoids = 300,
		isSingle = 1,
		isRoom = 1,
		isGateway = 0,
		interiorId = 0,
		clothingMenu = vector3(-250, -150, 1600) + vector3(-9.92, -6.5, 4.6),

		cam = {
			focus = vector3(-250, -150, 1600) + vector3(6.17, 7.69, 2),
			rot = vector3(0.0, 0.0, 132.0),
		},
	},
	{
		type = 'House7',
		name = 'Maison7',

		ipl = '[]',
		inside = vector3(-150, -250, 1600) + vector3(2.17, -19.31, 2.3),
		exit = vector3(-150, -250, 1600) + vector3(2.17, -19.31, 1.8),
		roomMenu = vector3(-150, -250, 1600) + vector3(-8.19, -8.72, 1.2),
		MinimumPrice = 12500,
		MaximumPoids = 300,
		isSingle = 1,
		isRoom = 1,
		isGateway = 0,
		interiorId = 0,
		clothingMenu = vector3(-150, -250, 1600) + vector3(-9.92, -6.5, 4.6),

		cam = {
			focus = vector3(-150, -250, 1600) + vector3(6.17, 7.69, 2),
			rot = vector3(0.0, 0.0, 132.0),
		},
	},
	{
		type = 'HouseO1',
		name = 'Orange1',

		ipl = '[]',
		inside = vector3(-200, -250, 1700) + vector3(-16.96, 3.81, 7.41),
		exit = vector3(-200, -250, 1700) + vector3(-16.96, 3.81, 7.21),
		roomMenu = vector3(-200, -250, 1700) + vector3(-9.25, 6.89, 7.21),
		MinimumPrice = 12500,
		MaximumPoids = 300,
		isSingle = 1,
		isRoom = 1,
		isGateway = 0,
		interiorId = 0,
		clothingMenu = vector3(-200, -250, 1700) + vector3(3.46, 6.31, 1.01),

		cam = {
			focus = vector3(-200, -250, 1700) + vector3(11.82, -3.55, 5.81),
			rot = vector3(0.0, 0.0, 45.0),
		},
	},
	--[[ 	{
		type = 'HouseO2',
		name = 'Orange2',

		ipl = '[]',
		inside = vector3(-250, -250, 1700) + vector3(0,0,0),
		exit = vector3(-250, -250, 1700) + vector3(0,0,0),
		roomMenu = vector3(-250, -250, 1700) + vector3(0,0,0),
		isSingle = 1,
		isRoom = 1,
		isGateway = 0,
		interiorId = 0,
		clothingMenu = nil,

		cam = {
			focus = vector3(-250, -250, 1700) + vector3(0,0,0),
			rot = vector3(0.0, 0.0, 45.0),
		},
	}, ]]
	{
		type = 'HouseS1',
		name = 'Stilts1',

		ipl = '[]',
		inside = vector3(-150, -250, 1700) + vector3(0,0,1),
		exit = vector3(-150, -250, 1700) + vector3(0,0,1),
		roomMenu = vector3(-150, -250, 1700) + vector3(0,0,1),
		MinimumPrice = 12500,
		MaximumPoids = 300,
		isSingle = 1,
		isRoom = 1,
		isGateway = 0,
		interiorId = 0,
		clothingMenu = nil,

		cam = {
			focus = vector3(-150, -250, 1700) + vector3(0,0,1),
			rot = vector3(0.0, 0.0, 45.0),
		},
	},
	--[[ 	{
		type = 'HouseS2',
		name = 'Stilts2',

		ipl = '[]',
		inside = vector3(-150, -200, 1700) + vector3(0,0,1),
		exit = vector3(-150, -200, 1700) + vector3(0,0,1),
		roomMenu = vector3(-150, -200, 1700) + vector3(0,0,1),
		isSingle = 1,
		isRoom = 1,
		isGateway = 0,
		interiorId = 0,
		clothingMenu = nil,

		cam = {
			focus = vector3(-150, -200, 1700) + vector3(0,0,1),
			rot = vector3(0.0, 0.0, 45.0),
		},
	}, ]]
	{
		type = 'Office1',
		name = 'Bureau1',

		ipl = '[]',
		inside = vector3(-200, -150, 1700) + vector3(0,0,1),
		exit = vector3(-200, -150, 1700) + vector3(0,0,1),
		roomMenu = vector3(-200, -150, 1700) + vector3(0,0,1),
		MinimumPrice = 12500,
		MaximumPoids = 300,
		isSingle = 1,
		isRoom = 1,
		isGateway = 0,
		interiorId = 0,
		clothingMenu = nil,

		cam = {
			focus = vector3(-200, -150, 1700) + vector3(0,0,1),
			rot = vector3(0.0, 0.0, 45.0),
		},
	},
	{
		type = 'Office1',
		name = 'Bureau2',

		ipl = '[]',
		inside = vector3(-150, -150, 1700) + vector3(0,0,1),
		exit = vector3(-150, -150, 1700) + vector3(0,0,1),
		roomMenu = vector3(-150, -150, 1700) + vector3(0,0,1),
		MinimumPrice = 12500,
		MaximumPoids = 300,
		isSingle = 1,
		isRoom = 1,
		isGateway = 0,
		interiorId = 0,
		clothingMenu = nil,

		cam = {
			focus = vector3(-150, -150, 1700) + vector3(0,0,1),
			rot = vector3(0.0, 0.0, 105),
		},
	},
	{
		type = 'Company1',
		name = 'BureauEntreprise1',

		ipl = '[]',
		inside = vector3(-150, -400, 1600) + vector3(0,-10.59,1),
		exit = vector3(-150, -400, 1600) + vector3(0,-10.6,1),
		roomMenu = vector3(-150, -400, 1600) + vector3(-12.6, 14.0, 1.0),
		MinimumPrice = 12500,
		MaximumPoids = 300,
		isSingle = 1,
		isRoom = 1,
		isGateway = 0,
		interiorId = 0,
		clothingMenu = vector3(-150, -400, 1600) + vector3(-6.96, 5.45, 1),

		cam = {
			focus = vector3(-150, -400, 1600) + vector3(3.93,16.43,2),
			rot = vector3(0.0, 0.0, 105),
		},
	},
	{
		type = 'Company2',
		name = 'BureauEntreprise2',

		ipl = '[]',
		inside = vector3(-150, -450, 1600) + vector3(0,-10.59,1),
		exit = vector3(-150, -450, 1600) + vector3(0,-10.6,1),
		roomMenu = vector3(-150, -450, 1600) + vector3(-12.6, 14.0, 1.0),
		MinimumPrice = 12500,
		MaximumPoids = 300,
		isSingle = 1,
		isRoom = 1,
		isGateway = 0,
		interiorId = 0,
		clothingMenu = vector3(-150, -450, 1600) + vector3(-6.96, 5.45, 1),

		cam = {
			focus = vector3(-150, -450, 1600) + vector3(3.93, 16.43, 2),
			rot = vector3(0.0, 0.0, 105),
		},
	},
	{
		type = 'Company3',
		name = 'BureauEntreprise3',

		ipl = '[]',
		inside = vector3(-150, -350, 1600) + vector3(0,-10.59,1),
		exit = vector3(-150, -350, 1600) + vector3(0,-10.6,1),
		roomMenu = vector3(-150, -350, 1600) + vector3(-12.6, 14.0, 1.0),
		MinimumPrice = 12500,
		MaximumPoids = 300,
		isSingle = 1,
		isRoom = 1,
		isGateway = 0,
		interiorId = 0,
		clothingMenu = vector3(-150, -350, 1600) + vector3(-6.96, 5.45, 1),

		cam = {
			focus = vector3(-150, -350, 1600) + vector3(3.93,16.43,2),
			rot = vector3(0.0, 0.0, 105),
		},
	},
	{
		type = 'Company4',
		name = 'BureauEntreprise4',

		ipl = '[]',
		inside = vector3(-200, -350, 1600) + vector3(0,-10.59,1),
		exit = vector3(-200, -350, 1600) + vector3(0,-10.6,1),
		roomMenu = vector3(-200, -350, 1600) + vector3(-12.6, 14.0, 1.0),
		MinimumPrice = 12500,
		MaximumPoids = 300,
		isSingle = 1,
		isRoom = 1,
		isGateway = 0,
		interiorId = 0,
		clothingMenu = vector3(-200, -350, 1600) + vector3(-6.96, 5.45, 1),

		cam = {
			focus = vector3(-200, -350, 1600) + vector3(3.93,16.43,2),
			rot = vector3(0.0, 0.0, 105),
		},
	},
	{
		type = 'Company5',
		name = 'BureauEntreprise5',

		ipl = '[]',
		inside = vector3(-200, -450, 1600) + vector3(0,-10.59,1),
		exit = vector3(-200, -450, 1600) + vector3(0,-10.6,1),
		roomMenu = vector3(-200, -450, 1600) + vector3(-12.6, 14.0, 1.0),
		MinimumPrice = 12500,
		MaximumPoids = 300,
		isSingle = 1,
		isRoom = 1,
		isGateway = 0,
		interiorId = 0,
		clothingMenu = vector3(-200, -450, 1600) + vector3(-6.96, 5.45, 1),

		cam = {
			focus = vector3(-200, -450, 1600) + vector3(3.93,16.43,2),
			rot = vector3(0.0, 0.0, 105),
		},
	},
	{
		type = 'Company6',
		name = 'BureauEntreprise6',

		ipl = '[]',
		inside = vector3(-250, -450, 1600) + vector3(0,-10.59,1),
		exit = vector3(-250, -450, 1600) + vector3(0,-10.6,1),
		roomMenu = vector3(-250, -450, 1600) + vector3(-12.6, 14.0, 1.0),
		MinimumPrice = 12500,
		MaximumPoids = 300,
		isSingle = 1,
		isRoom = 1,
		isGateway = 0,
		interiorId = 0,
		clothingMenu = vector3(-250, -450, 1600) + vector3(-6.96, 5.45, 1),

		cam = {
			focus = vector3(-250, -450, 1600) + vector3(3.93,16.43,2),
			rot = vector3(0.0, 0.0, 105),
		},
	},
	{
		type = 'Company7',
		name = 'BureauEntreprise7',

		ipl = '[]',
		inside = vector3(-250, -400, 1600) + vector3(0,-10.59,1),
		exit = vector3(-250, -400, 1600) + vector3(0,-10.6,1),
		roomMenu = vector3(-250, -400, 1600) + vector3(-12.6, 14.0, 1.0),
		MinimumPrice = 12500,
		MaximumPoids = 300,
		isSingle = 1,
		isRoom = 1,
		isGateway = 0,
		interiorId = 0,
		clothingMenu = vector3(-250, -400, 1600) + vector3(-6.96, 5.45, 1),

		cam = {
			focus = vector3(-250, -400, 1600) + vector3(3.93,16.43,2),
			rot = vector3(0.0, 0.0, 105),
		},
	},
	{
		type = 'Company8',
		name = 'BureauEntreprise8',

		ipl = '[]',
		inside = vector3(-250, -350, 1600) + vector3(0,-10.59,1),
		exit = vector3(-250, -350, 1600) + vector3(0,-10.6,1),
		roomMenu = vector3(-250, -350, 1600) + vector3(-12.6, 14.0, 1.0),
		MinimumPrice = 12500,
		MaximumPoids = 300,
		isSingle = 1,
		isRoom = 1,
		isGateway = 0,
		interiorId = 0,
		clothingMenu = vector3(-250, -350, 1600) + vector3(-6.96, 5.45, 1),

		cam = {
			focus = vector3(-250, -350, 1600) + vector3(3.93,16.43,2),
			rot = vector3(0.0, 0.0, 105),
		},
	},
	{
		type = 'Office',
		name = 'BureauJournaliste1',

		ipl = '[]',
		inside = vector3(1171.71, -3196.49, -39.01),
		exit = vector3(1173.39, -3196.31, -39.01),
		roomMenu = vector3(1162.01, -3197.42, -39.01),
		MinimumPrice = 12500,
		MaximumPoids = 300,
		isSingle = 1,
		isRoom = 1,
		isGateway = 0,
		interiorId = 0,
		clothingMenu = nil,

		cam = {
			focus = vector3(1168.86, -3199.07, -37.6),
			rot = vector3(0.0, 0.0, 67.46),
		},
	},
	{
		type = 'Bunker1',
		name = 'Bunker1',

		ipl = '[]',
		inside = vector3(460.34, 4816.45, -59.0),
		exit = vector3(460.34, 4816.45, -59.0),
		roomMenu = vector3(430.58, 4825.34, -59.0),
		MinimumPrice = 50000,
		MaximumPoids = 1000,
		isSingle = 1,
		isRoom = 1,
		isGateway = 0,
		interiorId = -100,
		clothingMenu = vector3(460.55, 4830.96, -58.99),

		cam = {
			focus = vector3(469.87, 4825.26, -56.43),
			rot = vector3(0.0, 0.0, 205.82),
		},
	},
	{
		type = 'Bunker2',
		name = 'Bunker2',

		ipl = '[]',
		inside = vector3(895.4, -3245.67, -98.25),
		exit = vector3(895.4, -3245.67, -98.25),
		roomMenu = vector3(834.18, -3242.14, -98.7),
		MinimumPrice = 50000,
		MaximumPoids = 1000,
		isSingle = 1,
		isRoom = 1,
		isGateway = 0,
		interiorId = -100,
		clothingMenu = vector3(905.03, -3238.16, -98.29),

		cam = {
			focus = vector3(893.8, -3246.73, -96.18),
			rot = vector3(0.0, 0.0, 73.63),
		},
	},
	{
		type = 'Bunker3',
		name = 'Bunker3',

		ipl = '[]',
		inside = vector3(-1507.71, -3024.41, -79.24),
		exit = vector3(-1507.71, -3024.41, -79.24),
		roomMenu = vector3(-1507.74, -3031.11, -79.24),
		MinimumPrice = 50000,
		MaximumPoids = 1000,
		isSingle = 1,
		isRoom = 1,
		isGateway = 0,
		interiorId = -100,
		clothingMenu = nil,

		cam = {
			focus = vector3(-1507.79, -3036.34, -77.84),
			rot = vector3(0.0, 0.0, 356.82),
		},
	},
	{
		type = 'Hangar1',
		name = 'Hangar1',

		ipl = '[]',
		inside = vector3(-1282.56, -2961.84, -48.49),
		exit = vector3(-1282.56, -2961.84, -48.49),
		roomMenu = vector3(-1240.9, -3001.83, -42.89),
		MinimumPrice = 38000,
		MaximumPoids = 750,
		isSingle = 1,
		isRoom = 1,
		isGateway = 0,
		interiorId = -110,
		clothingMenu = nil,

		cam = {
			focus = vector3(-1287.1, -2994.07, -45.34),
			rot = vector3(0.0, 0.0, 250.04),
		},
	},
	{
		type = 'CasinoPenthouse',
		name = 'CasinoPenthouse',

		ipl = '[]',
		inside = vector3(980.61, 56.59, 116.16),
		exit = vector3(980.61, 56.59, 116.16),
		roomMenu = vector3(973.65, 77.09, 116.18),
		MinimumPrice = 39000,
		MaximumPoids = 750,
		isSingle = 1,
		isRoom = 1,
		isGateway = 0,
		interiorId = -90,
		clothingMenu = vector3(984.92, 60.19, 116.16),

		cam = {
			focus = vector3(948.83, 26.03, 116.16),
			rot = vector3(0.0, 0.0, 155.04),
		},
	},
	{
		type = 'Arcade',
		name = 'Arcade',

		ipl = '[]',
		inside = vector3(2737.89, -374.54, -47.99),
		exit = vector3(2737.89, -374.54, -47.99),
		roomMenu = vector3(-2728.02, -389.34, -48.99),
		MinimumPrice = 42500,
		MaximumPoids = 700,
		isSingle = 1,
		isRoom = 1,
		isGateway = 0,
		interiorId = -140,
		clothingMenu = vector3(2726.51, -377.6, -47.39),

		cam = {
			focus = vector3(2723.96, -380.71, -46.63),
			rot = vector3(-20.0, 0.0, 237.76),
		},
	},
}

GarageType = {
	[1] = { 
		Name = '2', 
		value = 1,
		Coords = {179.32, -1008.21, -97.2, 60.36}, 
		Places = { 
			vector4(175.46, -1002.98, -99.42, 179.0),
			vector4(171.29, -1003.11, -99.42, 179.0),
		},

	},

	[2] = { 
		Name = '6', 
		value = 2,
		Coords = {206.8, -1007.16, -97.31, 55.0}, 
		Places = {
			vector4(202.66, -1004.43, -99.42, 125.3),
			vector4(203.13, -1000.6, -99.42, 122.5),
			vector4(202.99, -997.07, -99.42, 122.69),
			vector4(194.28, -1004.38, -99.42, 235.97),
			vector4(193.73, -1000.19, -99.42, 242.26),
			vector4(193.86, -996.57, -99.42, 241.42)
		}
	},

	[3] = { 
		Name = '10', 
		value = 3,
		Coords = {221.66, -1005.92, -98.13, 335.0}, 
		Places = {
			vector4(223.05, -1000.93, -99.42, 235.8),
			vector4(222.88, -995.54, -99.42, 235.8),
			vector4(222.92, -990.4, -99.42, 235.8),
			vector4(223.12, -984.33, -99.42, 235.8),
			vector4(223.46, -978.42, -99.42, 235.8),
			vector4(233.5, -1000.67, -99.42, 110.0),
			vector4(233.65, -995.8, -99.42, 110.0),
			vector4(233.75, -990.54, -99.42, 110.0),
			vector4(233.44, -985.54, -99.42, 110.0),
			vector4(233.19, -980.28, -99.42, 110.0)
		}
	}
}

Citizen.CreateThread(function()
	while true do
		local sleep = 500

		if (entering ~= nil and not beforeTeleport) then
			sleep = 0
			DrawMarker(1, entering.x, entering.y, entering.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 0.5, 100, 200, 100, 100, false, true, 2, false, nil, nil, false)
		end

		if (garage ~= nil and not beforeTeleport) then
			sleep = 0
			DrawMarker(36, garage.x, garage.y, garage.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.7, 0, 180, 100, 125, false, true, 2, false, nil, nil, false)
		end

		if selectedPropertyIndex and beforeTeleport then
			sleep = 0
			local selectProperty = properties[selectedPropertyIndex]

			DrawMarker(1, selectProperty.exit - vector3(0, 0, 1), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 0.5, 200, 100, 100, 100, false, true, 2, false, nil, nil, false)
			DrawMarker(29, selectProperty.roomMenu, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 100, 200, 100, 100, false, true, 2, false, nil, nil, false)
			DrawMarker(20, selectProperty.clothingMenu, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 123, 123, 123, 100, false, true, 2, false, nil, nil, false)
		end
		Wait(sleep)
	end
end)

local function ColorNotification(msg, bgColor)
	SetNotificationBackgroundColor(bgColor)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(msg)
	DrawNotification(false, true)
end

local function PlaceHere(type)
	local playersCoords = GetEntityCoords(PlayerPedId())
	if type == 'entree' then
		propertyEnter = {x = ESX.Math.Round(playersCoords.x, 4), y = ESX.Math.Round(playersCoords.y, 4), z = ESX.Math.Round(playersCoords.z-1.0, 4)}
		if beforeTeleport then
			ESX.ShowNotification('~r~Placer le point dans une rue ! Pas dans un logement ...')
			return
		end
		entering = GetEntityCoords(PlayerPedId()) - vector3(0,0,1)
		outside = entering + vector3(0, 0, 2)
	elseif type == 'garage' then
		propertyGarage = {x = ESX.Math.Round(playersCoords.x, 4), y = ESX.Math.Round(playersCoords.y, 4), z = ESX.Math.Round(playersCoords.z, 4)}
		if beforeTeleport then
			ESX.ShowNotification('~r~Placer le point dans une rue ! Pas dans un logement ...')
			return
		end
		garage = GetEntityCoords(PlayerPedId()) 
	end

	local streetHash, crossingRoadHash = GetStreetNameAtCoord(playersCoords.x, playersCoords.y, playersCoords.z)
	local streetName = GetStreetNameFromHashKey(streetHash)
	local crossingRoad = GetStreetNameFromHashKey(crossingRoadHash)
	local crossingRoadTxt = ''

	if crossingRoadHash ~= 0 then
		crossingRoadTxt = '~s~\nIntersection: ~g~' .. tostring(crossingRoad)
	end

	ESX.ShowNotification('Rue: ~g~' .. tostring(streetName) .. crossingRoadTxt)
	ESX.ShowNotification('Zone : ~b~' .. GetLabelText(GetNameOfZone(playersCoords)))
end

local function GoToPoint(type)
	if type == 'entree' then
		if propertyEnter then 
			SetEntityCoords(PlayerPedId(), propertyEnter.x, propertyEnter.y, propertyEnter.z)
		else
			ColorNotification("Veuillez placer l'entrée avant de vouloir vous téléportez dessus", 6)
		end
	elseif type == 'garage' then
		if propertyGarage then 
			SetEntityCoords(PlayerPedId(), propertyGarage.x, propertyGarage.y, propertyGarage.z)
		else
			ColorNotification("Veuillez placer le garage avant de vouloir vous téléportez dessus", 6)
		end
	end
end




RMenu.Add("fl_agenceimmo", "fl_agenceimmo_main", RageUI.CreateMenu("Dynasty 8","Menu principal"))
RMenu:Get("fl_agenceimmo", "fl_agenceimmo_main"):SetStyleSize(0)
RMenu:Get("fl_agenceimmo", "fl_agenceimmo_main").Closed = function()
	MenuAgenceImmo = false
	Destroy()
end

RMenu.Add('fl_builder', 'fl_builder_main', RageUI.CreateSubMenu(RMenu:Get("fl_agenceimmo", "fl_agenceimmo_main"), "Dynasty 8","Editeur de logement."))
RMenu:Get("fl_builder", "fl_builder_main"):SetStyleSize(0)
RMenu:Get('fl_builder', 'fl_builder_main').Closed = function()
	propertyLabel = nil
	propertyName = nil
	entering = nil
	garage = nil
	outside = nil
end

RMenu.Add('fl_propertyannonce', 'fl_propertyannonce_main', RageUI.CreateSubMenu(RMenu:Get("fl_agenceimmo", "fl_agenceimmo_main"), "Dynasty 8","Annonces."))
RMenu:Get("fl_propertyannonce", "fl_propertyannonce_main"):SetStyleSize(0)
RMenu:Get('fl_propertyannonce', 'fl_propertyannonce_main').Closed = function()
end

RegisterCommand('openMenuAgentImmo', function()
	if ESX.IsPlayerLoaded() then
		if GetEntityHealth(PlayerPedId()) > 0 and ESX.PlayerData.job and ESX.PlayerData.job.name == 'realestateagent' or ESX.PlayerData.job.name == '_dev' then
			openMenuAgenceImmobiliereBuilder()
		end
	end
end, false)
  
RegisterKeyMapping('openMenuAgentImmo', 'Menu agence immo', 'keyboard', 'F6')

local AgenceImmo = {
	list = {
		"Placer ici",
		"S'y rendre"
	},
	entree = 1,
	garage = 1
}



function openMenuAgenceImmobiliereBuilder()
	if not MenuAgenceImmo then 
        MenuAgenceImmo = true
		RageUI.Visible(RMenu:Get('fl_agenceimmo', 'fl_agenceimmo_main'), true)
		local propertiesNames = {}
		for _, property in pairs(properties) do
			table.insert(propertiesNames, property.name)
		end

		local NumberPlacesInGarage = {}
		for i = 1,3 do
			table.insert(NumberPlacesInGarage, GarageType[i].Name)
		end

		local fps = ESX.PlayerData.job.grade_name

		Citizen.CreateThread(function()
			while MenuAgenceImmo do

				RageUI.IsVisible(RMenu:Get("fl_agenceimmo",'fl_agenceimmo_main'),true,true,true,function()
					RageUI.Separator('↓ ~y~Intéractions citoyens ~s~↓')
					
					RageUI.ButtonWithStyle("Annonces", 'Accédez aux annonces', { RightLabel = "→" }, true, function(_,_,s)
					end, RMenu:Get('fl_propertyannonce', 'fl_propertyannonce_main'))
					
					RageUI.Separator('↓ ~o~Intéractions de biens ~s~↓')

					RageUI.ButtonWithStyle("Papiers d\'acquisition d\'un bien", 'Signez des papiers pour acquérir un bien.', { RightLabel = "→" }, true, function(_,_,s)
					end, RMenu:Get("fl_builder", "fl_builder_main"))	
					

				end, function()    
				end, 1)

				RageUI.IsVisible(RMenu:Get("fl_propertyannonce",'fl_propertyannonce_main'),true,true,true,function()
					RageUI.Separator('↓ ~y~Annonces ~s~↓')

					RageUI.ButtonWithStyle("Annonce ouvert", "Annoncez que l\'agence est ouverte.", {RightLabel = "→"}, true, function(Hovered, Active, Selected)
						if (Selected) then   
							TriggerServerEvent('fl_society:adFromClient', 'stoneagency', 'L\'Agence Immobilière ~g~ouverte~s~ ! N\'hésitez pas à venir nous voir.', true)
						end
					end)

					RageUI.ButtonWithStyle("Annonce recrutement", "Annoncez des recrutements de l\'agence", {RightLabel = "→"}, true, function(Hovered, Active, Selected)
						if (Selected) then   
							TriggerServerEvent('fl_society:adFromClient', 'stoneagency', 'L\'Agence Immobilière ~g~rectute~s~ ! N\'hésitez pas à venir postuler.', true)
						end
					end)

					if fps == 'boss' then
						RageUI.ButtonWithStyle("Message aux employés", "Ecrivez un message aux agents immobiliers", {RightLabel = "→"}, true, function(Hovered, Active, Selected)
							if (Selected) then   
								local info = 'patron'
								local message = OpenKeyboardText('Veuillez mettre le messsage à envoyer')
								TriggerServerEvent('fl_property:patronmess', info, message)
							end
						end)
					end
				end, function()    
				end, 1)

				RageUI.IsVisible(RMenu:Get("fl_builder",'fl_builder_main'),true,true,true,function()
					RageUI.Separator('↓ ~y~Gestion de biens ~s~↓')

					RageUI.List('Position - ~o~Entrée', AgenceImmo.list ,AgenceImmo.entree, 'Emplacement de l\'entrée.', {}, true, function(_, _, s, i)
						if i == 1 then
							if s then
								PlaceHere('entree')
							end
						elseif i == 2 then
							if s then
								GoToPoint('entree')
							end
						end
						AgenceImmo.entree = i;
					end)

					RageUI.List('Position - ~o~Garage', AgenceImmo.list ,AgenceImmo.garage, 'Emplacement du garage.', {}, true, function(_, _, s, i)
						if i == 1 then
							if s then
								PlaceHere('garage')
							end
						elseif i == 2 then
							if s then
								GoToPoint('garage')
							end
						end
						AgenceImmo.garage = i;
					end)

					RageUI.List('Nombre de place dans le garage', NumberPlacesInGarage , index.numberPlaces, 'Nombre de places.', {}, true, function(_, _, s, i)
						if s then
							print(json.encode(GarageType[i].value))
						end
						index.numberPlaces = i;
					end)


					RageUI.List('Type d\'intérieur :', propertiesNames ,index.typeInterior, 'Choisissez le type d\'intérieur.', {}, true, function(h, a, s, i)
						if s then
							InPreview = true
							Cam(properties[index.typeInterior].cam)
							if beforeTeleport then
								SetEntityCoords(PlayerPedId(), beforeTeleport)
								beforeTeleport = nil
							end
						end
						index.typeInterior = i;
					end)

					if InPreview then
						RageUI.ButtonWithStyle("Quitter le mode preview", 'Appuyez ici pour quitter la preview.', {}, true, function(_,_,s)
							if s then
								Destroy()
								InPreview = false
							end
						end)
					end
					

					RageUI.Separator('↓ ~b~Informations générales ~s~↓')
					RageUI.ButtonWithStyle("Nom", 'Entrez un nom pour la propriété !', { RightLabel = propertyName and propertyName or "Aucun"}, true, function(_,_,s)
						if s then
							name = OpenKeyboardText("Entrer le nom de la propriété :")
							if name then 
								propertyName = string.lower(name)
							end
						end
					end)

					RageUI.ButtonWithStyle("Label", 'Entrez le nom de la propriété !', { RightLabel = propertyLabel and propertyLabel or "Aucun"}, true, function(_,_,s)
						if s then
							label = OpenKeyboardText("Entrer le label que vous voulez mettre :")
							if label then 
								propertyLabel = label
							end
						end
					end)

					RageUI.ButtonWithStyle("Prix", 'Prix minimum à l\'achat : ~r~'..properties[index.typeInterior].MinimumPrice..'', { RightLabel = propertyPrice and propertyPrice or "Aucun"}, true, function(_,_,s)
						if s then
							price = tonumber(OpenKeyboardText("Entrez le prix :"))
							if price then
								if price >= properties[index.typeInterior].MinimumPrice then
									propertyPrice = ""..price.." ~g~$"
								else
									price = nil
									ESX.ShowNotification('Valeur minimale d\'un '..properties[index.typeInterior].name.. ' : ~r~'..properties[index.typeInterior].MinimumPrice..' $')
								end
							else
								ESX.ShowNotification('~r~Valeur incorrecte !')
							end
						end
					end)

					RageUI.List('Vente par :', itemsSoldby ,selectedSoldbyIndex, 'Choisissez qui peut vendre ce bien', {}, true, function(_, _, s, i)
						selectedSoldbyIndex = i;
					end)

					RageUI.ButtonWithStyle("Poids du coffre ~o~(en KG)~s~", 'Poids maximum : ~r~'..properties[index.typeInterior].MaximumPoids..' KG', { RightLabel = PoidsProperty and PoidsProperty or "Aucun"}, true, function(_,_,s)
						if s then
							poids = tonumber(OpenKeyboardText("Entrer le poids (en KG !):"))
							if poids then
								if poids <= properties[index.typeInterior].MaximumPoids then
									PoidsProperty = ""..poids..""
								else
									ESX.ShowNotification('Poids max d\'un coffre de '..properties[index.typeInterior].name.. ' : ~r~'..properties[index.typeInterior].MaximumPoids..' KG')
									poids = nil
								end
							else
								ESX.ShowNotification('~r~Valeur incorrecte !')
							end
						end
					end)

					RageUI.ButtonWithStyle("Confirmer", 'Entrez le nom de la propriété !', { Color = { BackgroundColor = {0,100,0,255}, HightLightColor = {0,150,0,255}}}, true, function(_,_,s)
						if s then
							if label ~= nil and entering ~= nil and outside ~= nil and poids ~= nil and garage ~= nil then
								local selectProperty = properties[index.typeInterior]
								local GaragePlaces = GarageType[index.numberPlaces].value

								local clothing = nil
								if selectProperty.clothingMenu then
									clothing = selectProperty.clothingMenu - vector3(0, 0, 1)
								end

								TriggerServerEvent('fl_property_util:save',
									selectProperty.type,
									name,
									label,
									entering,
									selectProperty.exit - vector3(0, 0, 1),
									selectProperty.inside,
									outside,
									selectProperty.interiorId,
									selectProperty.ipl,
									selectProperty.isSingle,
									selectProperty.isRoom,
									selectProperty.isGateway,
									selectProperty.roomMenu - vector3(0, 0, 1),
									price,
									clothing,
									itemsSoldby[selectedSoldbyIndex], 
									poids,
									garage,
									GaragePlaces
								)

								if beforeTeleport then
									SetEntityCoords(PlayerPedId(), beforeTeleport)
									beforeTeleport = nil
								end

								label = nil
								entering = nil
								outside = nil
								garage = nil
								RageUI.CloseAll()
								MenuAgenceImmo = false
							else
								ESX.ShowNotification('~r~Echec lors de la création de la propriété.')
							end
						end
					end)

                end, function()    
                end, 1)


				Wait(1)
			end
		end)
	end
end

AddEventHandler('onResourceStop', function(resourceName)
	if resourceName ~= GetCurrentResourceName() then return end
	if beforeTeleport then
		ESX.ShowNotification('~r~Redémarrage du script...')
		SetEntityCoords(PlayerPedId(), beforeTeleport)
		beforeTeleport = nil
	end

	if cam ~= nil then
		ESX.ShowNotification('~r~Redémarrage du script...')
		Destroy()
	end
end)

RegisterNetEvent('fl_property:messagepatron')
AddEventHandler('fl_property:messagepatron', function(service, message)
	if message ~= nil then
		ESX.ShowAdvancedNotification('Message du patron', '~b~Information', 'Message: ~g~'..message..'', 'CHAR_ESTATE_AGENT', 8)
	end
end)