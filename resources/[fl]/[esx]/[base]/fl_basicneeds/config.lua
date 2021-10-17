Config = {}
Config.Locale = 'fr'

Config.TickTime = 100
Config.UpdateClientTime = 5000

Config.TimeBetweenDrugs = 10 * 60 * 1000
Config.DrugsEffectDuration = 60 * 1000

Config.Usables = {
	vin = {
		name = 'Verre de vin',
		anim = {
			action = 'onDrink',
			prop = 'prop_sh_wine_glass',
		},
		thirst = 120000,
		drunk = 10000,
	},

	champagne = {
		name = 'Bouteille de champagne',
		anim = {
			action = 'onDrink',
			prop = 'prop_sh_wine_glass',
		},
		thirst = 120000,
		drunk = 10000,
	},

	tequila = {
		name = 'Verre de tequila',
		anim = {
			action = 'onDrink',
			prop = 'prop_cs_shot_glass',
		},
		thirst = 125000,
		drunk = 10000,
	},

	whisky = {
		name = 'Verre de Whisky',
		anim = {
			action = 'onDrink',
			prop = 'prop_drink_whisky',
		},
		thirst = 120000,
		drunk = 10000,
	},

	beer = {
		name = 'Canette de bière',
		anim = {
			action = 'onDrink',
			prop = 'prop_ld_flow_bottle',
		},
		thirst = 120000,
		drunk = 10000,
	},

	mojito = {
		name = 'Verre de mojito',
		anim = {
			action = 'onDrink',
			prop = 'prop_cocktail',
		},
		thirst = 130000,
		drunk = 5000,
	},

	rhum = {
		name = 'Verre de Rhum',
		anim = {
			action = 'onDrink',
			prop = 'prop_drink_whisky',
		},
		thirst = 120000,
		drunk = 10000,
	},

	vodka = {
		name = 'Verre de Vodka',
		anim = {
			action = 'onDrink',
			prop = 'prop_shots_glass_cs',
		},
		thirst = 120000,
		drunk = 10000,
	},

	martini = {
		name = 'Verre de Martini Blanc',
		anim = {
			action = 'onDrink',
			prop = 'prop_shots_glass_cs',
		},
		thirst = 120000,
		drunk = 10000,
	},

	pepsi = {
		name = 'Canette de Pepsi',
		anim = {
			action = 'onDrink',
			prop = 'prop_ecola_can',
		},
		thirst = 150000,
	},

	sevenup = {
		name = 'Canette de SevenUp',
		anim = {
			action = 'onDrink',
			prop = 'prop_ld_can_01',
		},
		thirst = 150000,
	},

	caprisun = {
		name = 'Caprisun',
		anim = {
			action = 'onDrink',
			prop = 'prop_ecola_can',
		},
		thirst = 150000,
	},

	cocacola = {
		name = 'Canette de Coca-Cola',
		anim = {
			action = 'onDrink',
			prop = 'prop_ecola_can',
		},
		thirst = 150000,
	},

	fanta = {
		name = 'Canette de Fanta',
		anim = {
			action = 'onDrink',
			prop = 'prop_orang_can_01',
		},
		thirst = 150000,
	},

	sprite = {
		name = 'Canette de Sprite',
		anim = {
			action = 'onDrink',
			prop = 'prop_ld_can_01',
		},
		thirst = 150000,
	},

	orangina = {
		name = 'Canette d\'Orangina',
		anim = {
			action = 'onDrink',
			prop = 'prop_orang_can_01',
		},
		thirst = 150000,
	},

	cocktail = {
		name = 'Cocktail sans alcool',
		anim = {
			action = 'onDrink',
			prop = 'prop_cocktail',
		},
		thirst = 170000,
	},

	soda = {
		name = 'Canette de soda',
		anim = {
			action = 'onDrink',
			prop = 'prop_orang_can_01',
		},
		thirst = 150000,
	},

	water = {
		name = 'Petit bouteille d\'eau',
		anim = {
			action = 'onDrink',
			prop = 'prop_ld_flow_bottle',
		},
		thirst = 50000,
	},

	eau_arom = {
		name = 'Verre de diabolo',
		anim = {
			action = 'onDrink',
			prop = 'prop_ld_flow_bottle',
		},
		thirst = 150000,
	},

	milk = {
		name = 'Verre de lait',
		anim = {
			action = 'onDrink',
			prop = 'prop_ld_flow_bottle',
		},
		thirst = 120000,
	},

	smoothies = {
		name = 'Smoothie',
		anim = {
			action = 'onDrink',
			prop = 'prop_ld_flow_bottle',
		},
		thirst = 120000,
	},

	icetea = {
		name = 'Canette d\'Ice-Tea',
		anim = {
			action = 'onDrink',
			prop = 'prop_ld_flow_bottle',
		},
		thirst = 170000,
	},

	jusraisin = {
		name = 'Jus de raisin',
		anim = {
			action = 'onDrink',
			prop = 'prop_ld_flow_bottle',
		},
		thirst = 200000,
	},

	chocolate = {
		name = 'Chocolat chaud',
		anim = {
			action = 'onDrink',
			prop = 'prop_ld_flow_bottle',
		},
		thirst = 180000,
	},

	cafe = {
		name = 'Café',
		anim = {
			action = 'onDrink',
			prop = 'prop_ld_flow_bottle',
		},
		thirst = 100000,
	},

	jusfruit = {
		name = 'Jus de fruit',
		anim = {
			action = 'onDrink',
			prop = 'prop_ld_flow_bottle',
		},
		thirst = 180000,
	},

	energy = {
		name = 'RedBull',
		anim = {
			action = 'onDrink',
			prop = 'prop_ld_flow_bottle',
		},
		thirst = 175000,
	},

	orangejus = {
		name = 'Jus d\'organge',
		anim = {
			action = 'onDrink',
			prop = 'prop_ld_flow_bottle',
		},
		thirst = 175000,
	},

	drpepper = {
		name = 'DrPepper',
		anim = {
			action = 'onDrink',
			prop = 'prop_ld_flow_bottle',
		},
		thirst = 155000,
	},

	hamburger = {
		name = 'Hamburger',
		anim = {
			action = 'onEat',
			prop = 'prop_cs_burger_01',
		},
		hunger = 600000,
	},

	cheeseburger = {
		name = 'CheeseBurger',
		anim = {
			action = 'onEat',
			prop = 'prop_cs_burger_01',
		},
		hunger = 600000,
	},

	sushi = {
		name = 'Sushi',
		anim = {
			action = 'onEat',
			prop = 'prop_cs_burger_01',
		},
		hunger = 300000,
	},

	donuts_chocolat = {
		name = 'Donuts au chocolat',
		anim = {
			action = 'onEat',
			prop = 'prop_cs_burger_01',
		},
		hunger = 200000,
		thirst = -100000,
	},

	donuts_fraise = {
		name = 'Donuts fraise',
		anim = {
			action = 'onEat',
			prop = 'prop_cs_burger_01',
		},
		hunger = 250000,
		thirst = -100000,
	},

	bread = {
		name = 'Sandwich',
		anim = {
			action = 'onEat',
			prop = 'prop_sandwich_01',
		},
		hunger = 150000,
	},

	frites = {
		name = 'Frites',
		anim = {
			action = 'onEat',
			prop = 'prop_sandwich_01',
		},
		hunger = 250000,
	},

	tacos = {
		name = 'Tacos',
		anim = {
			action = 'onEat',
			prop = 'prop_sandwich_01',
		},
		hunger = 250000,
	},

	kebab = {
		name = 'Kebab',
		anim = {
			action = 'onEat',
			prop = 'prop_sandwich_01',
		},
		hunger = 300000,
	},

	fishburger = {
		name = 'FishBurger',
		anim = {
			action = 'onEat',
			prop = 'prop_cs_burger_01',
		},
		hunger = 400000,
	},

	hotdog = {
		name = 'Hotdog',
		anim = {
			action = 'onEat',
			prop = 'prop_cs_hotdog_01',
		},
		hunger = 400000,
	},

	pizza = {
		name = 'Pizza',
		anim = {
			action = 'onEat',
			prop = 'prop_sandwich_01',
		},
		hunger = 250000,
	},

	orange = {
		name = 'Orange',
		anim = {
			action = 'onEat',
			prop = 'prop_sandwich_01',
		},
		hunger = 100000,
		thirst = 50000,
	},

	bonbon = {
		name = 'Bonbon',
		anim = {
			action = 'onEat',
			prop = 'prop_sandwich_01',
		},
		hunger = 100000,
		thirst = -100000,
	},

}