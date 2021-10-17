Config = {}
Config.MarkerType = 27
Config.DrawDistance = 100.0
Config.MarkerColor  = {r = 0, g = 208, b = 255}
Config.RequiredCops = 3
Config.Locale = 'fr'

Config.Drugs = {'meth', 'coke', 'weed', 'shit'}

Config.HarvestTime = 10 * 1000
Config.TransformTime = 15 * 1000

Config.Zones = {
	{
		drug = 'coke',
		harvest = vector3(2061.67, 4914.25, 41.08),
		transform = vector3(1093.09, -3196.94, -38.99),
		size = 5.5,
	},
	{
		drug = 'meth',
		harvest = vector3(1008.62, -3200.47, -39.99),
		transform = vector3(1015.17, -3194.95, -39.99),
		size = 5.5,
	},
	{
		drug = 'weed',
		harvest = vector3(1948.18, 4853.44, 45.52),
		transform = vector3(1036.32, -3204.04, -38.17),
		size = 5.5,
	},
	{
		drug = 'shit',
		harvest = vector3(1893.5, 4800.18, 44.92),
		transform = vector3(1539.07, 1704.71, 109.66),
		size = 5.5,
	},



	-- Cayo Perico
	{
		drug = 'weed',
		harvest = vector3(5346.36, -5326.03, 37.81),
		transform = vector3(4924.47, -5244.49, 2.52),
		size = 15.0,
	},
	{
		drug = 'coke',
		harvest = vector3(5398.69, -5199.99, 32.69),
		transform = vector3(1095.06, -3197.04, 38.99),
		size = 15.0,
	},
}