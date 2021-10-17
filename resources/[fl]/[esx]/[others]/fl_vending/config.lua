Config = {}

Config.DispenseDict = {"mini@sprunk", "plyr_buy_drink_pt1"}
Config.PocketAnims = {"mp_common_miss", "put_away_coke"}

Config.Machines = {
	{
		model = `prop_vend_soda_01`, -- Model name
		item = "cocacola", -- Database item name
		name = "Coca-Cola", -- Friendly display name
		prop = "prop_ecola_can", -- Prop to spawn falling in machine
		price = 35 -- Purchase price
	},
	{
		model = `prop_vend_soda_02`,
		item = "sprite",
		name = "Sprite ",
		prop = "prop_ld_can_01",
		price = 35
	},
	{
		model = `prop_vend_snak_01`,
		item = "chocolate",
		name = "Chocolat",
		prop = "prop_candy_pqs",
		price = 35
	}
}