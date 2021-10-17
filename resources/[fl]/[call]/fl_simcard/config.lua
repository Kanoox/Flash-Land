Config = {}

Config.ItemPrefix = 'simcard_'

Config.UseAnimation = true
Config.TimeToChange = 10

Config.PhonePrice = 200
Config.GpsPrice = 100

Config.MaxSubscription = 4

Config.Sims = {

	-- Legal Subscription

	[0] = {
		Name = 'Abonnement forfait illimité',
		OneTimeBuy = 500,
		DaySubscription = 50,

		Prefix = 555,
		DefaultCallPlan = -1,
		DefaultSmsPlan = -1,
	},

	[1] = {
		Name = 'Abonnement forfait 1',
		OneTimeBuy = 300,
		DaySubscription = 30,

		Prefix = 555,
		DefaultCallPlan = 10 * 60,
		DefaultSmsPlan = 25,
	},

	-- Legal Prepaid

	[10] = {
		Name = 'Sim prépayé 1',
		OneTimeBuy = 200,

		Prefix = 444,
		DefaultCallPlan = 5 * 60,
		DefaultSmsPlan = 10,
	},

	[11] = {
		Name = 'Sim prépayé 2',
		OneTimeBuy = 300,

		Prefix = 444,
		DefaultCallPlan = 15 * 60,
		DefaultSmsPlan = 30,
	},

	[12] = {
		Name = 'Sim prépayé 3',
		OneTimeBuy = 400,

		Prefix = 444,
		DefaultCallPlan = 40 * 60,
		DefaultSmsPlan = 80,
	},

	-- Illegal

	[20] = {
		Name = 'Sim crypté',
		Illegal = true,
		OneTimeBuy = 5000,

		Prefix = 999,
		DefaultCallPlan = 40 * 60,
		DefaultSmsPlan = 80,
	},
}

Config.Shops = {

	{
		name = 'DigitalDen',
		shop = vector3(393.18, -832.59, 29.29),
		npc = {
			{model = 'a_m_m_business_01', pos = vector4(392.67, -831.99, 29.29-1, 224.39)},
		},
	},

	{
		name = 'Magasin d\'électronique',
		shop = vector3(2749.95, 3488.57, 55.67),
		npc = {
			{model = 'a_m_m_business_01', pos = vector4(2751.39, 3488.06, 54.66, 64.57)},
		},
		hide = true,
	},

	{
		name = 'Michael Dorto',
		shop = vector3(2330.5, 2571.87, 46.68),
		npc = {
			{model = 'ig_rashcosvki', pos = vector4(2329.87, 2569.77, 45.68, 336.18)},
		},
		hide = true,
		illegal = true,
	},

}

Config.Computers = {

}