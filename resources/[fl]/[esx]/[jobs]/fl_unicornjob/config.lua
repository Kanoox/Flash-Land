Config = {}
Config.DrawDistance = 20.0
Config.Locale = 'fr'

Config.MissCraft = 10 -- %

Config.Zones = {

    Cloakrooms = {
        Pos = {x = 109.52, y = -1304.92, z = 29.26},
        Size = {x = 1.5, y = 1.5, z = 1.0},
        Color = {r = 255, g = 187, b = 255},
        Type = 20,
    },

    Vaults = {
        Pos = {x = 99.78, y = -1312.28, z = 29.26},
        Size = {x = 1.3, y = 1.3, z = 1.0},
        Color = {r = 30, g = 144, b = 255},
        Type = 20,
    },

    Fridge = {
        Pos = {x = 130.01, y = -1278.73, z = 29.26},
        Size = {x = 1.6, y = 1.6, z = 1.0},
        Color = { r = 248, g = 248, b = 255},
        Type = 20,
    },

    BossActions = {
        Pos = {x = 97.87, y = -1304.15, z = 29.26},
        Size = {x = 1.5, y = 1.5, z = 1.0},
        Color = {r = 0, g = 100, b = 0},
        Type = 20,
    },

    SellFarm = {
		  Pos = {x =967.158, y = 1.843, z = 79.70},
		  Size = {x = 1.5, y = 1.5, z = 1.0},
		  Color = {r = 136, g = 243, b = 216},
		  Type = 20
    },

-----------------------
-------- SHOPS --------

    Flacons = {
        Name = "Achats Alcool",
        Pos = {x = 128.90, y = -1280.24, z = 29.26},
        Size = {x = 1.0, y = 1.0, z = 1.0},
        Color = {r = 238, g = 0, b = 0},
        Type = 20,
        Items = {
            {name = 'jager', label = _U('jager'), price = 5},
            {name = 'vodka', label = _U('vodka'), price = 5},
            {name = 'rhum', label = _U('rhum'), price = 5},
            {name = 'whisky', label = _U('whisky'), price = 5},
            {name = 'tequila', label = _U('tequila'), price = 5},
            {name = 'martini', label = _U('martini'), price = 5}
        },
    },

    NoAlcool = {
        Name = "Achats Soft",
        Pos = {x = 129.70, y = -1281.662, z = 29.26},
        Size = {x = 1.0, y = 1.0, z = 1.0},
        Color = {r = 238, g = 110, b = 0},
        Type = 20,
        Items = {
            {name = 'cocacola', label = _U('coca'), price = 2},
            {name = 'caprisun', label = _U('caprisun'), price = 2},
            {name = 'fanta', label = _U('fanta'), price = 2},
            {name = 'jusfruit', label = _U('jusfruit'), price = 2},
            {name = 'icetea', label = _U('icetea'), price = 2},
            {name = 'redbull', label = _U('redbull'), price = 2},
            {name = 'drpepper', label = _U('drpepper'), price = 2},
            {name = 'limonade', label = _U('limonade'), price = 2}
        },
    },

    Apero = {
        Name = "Achats Apéros",
        Pos = {x = 130.34, y = -1285.55, z = 29.27},
        Size = {x = 1.0, y = 1.0, z = 1.0},
        Color = {r = 142, g = 125, b = 76},
        Type = 20,
        Items = {
            { name = 'bolcacahuetes', label = _U('bolcacahuetes'), price = 4},
            { name = 'bolnoixcajou', label = _U('bolnoixcajou'), price = 4},
            { name = 'bolpistache', label = _U('bolpistache'), price = 4},
            { name = 'bolchips', label = _U('bolchips'), price = 4},
            { name = 'saucisson', label = _U('saucisson'), price = 4},
            { name = 'grapperaisin', label = _U('grapperaisin'), price = 4},
            { name = 'ice', label = _U('ice'), price = 2},
            { name = 'menthe', label = _U('menthe'), price = 2}
        },
    },
}

Config.Uniforms = {
  barman_outfit = {
    male = {
        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
        ['torso_1'] = 40,   ['torso_2'] = 0,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms'] = 40,
        ['pants_1'] = 28,   ['pants_2'] = 2,
        ['shoes_1'] = 38,   ['shoes_2'] = 4,
        ['chain_1'] = 118,  ['chain_2'] = 0
    },
    female = {
        ['tshirt_1'] = 3,   ['tshirt_2'] = 0,
        ['torso_1'] = 8,    ['torso_2'] = 2,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms'] = 5,
        ['pants_1'] = 44,   ['pants_2'] = 4,
        ['shoes_1'] = 0,    ['shoes_2'] = 0,
        ['chain_1'] = 0,    ['chain_2'] = 2
    }
  },
  dancer_outfit_1 = {
    male = {
        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
        ['torso_1'] = 15,   ['torso_2'] = 0,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms'] = 40,
        ['pants_1'] = 61,   ['pants_2'] = 9,
        ['shoes_1'] = 16,   ['shoes_2'] = 9,
        ['chain_1'] = 118,  ['chain_2'] = 0
    },
    female = {
        ['tshirt_1'] = 3,   ['tshirt_2'] = 0,
        ['torso_1'] = 22,   ['torso_2'] = 0,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms'] = 4,
        ['pants_1'] = 22,   ['pants_2'] = 0,
        ['shoes_1'] = 18,   ['shoes_2'] = 0,
        ['chain_1'] = 61,   ['chain_2'] = 1
    }
  },
  dancer_outfit_2 = {
    male = {
        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
        ['torso_1'] = 62,   ['torso_2'] = 0,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms'] = 14,
        ['pants_1'] = 4,    ['pants_2'] = 0,
        ['shoes_1'] = 34,   ['shoes_2'] = 0,
        ['chain_1'] = 118,  ['chain_2'] = 0
    },
    female = {
        ['tshirt_1'] = 3,   ['tshirt_2'] = 0,
        ['torso_1'] = 22,   ['torso_2'] = 2,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms'] = 4,
        ['pants_1'] = 20,   ['pants_2'] = 2,
        ['shoes_1'] = 18,   ['shoes_2'] = 2,
        ['chain_1'] = 0,    ['chain_2'] = 0
    }
  },
  dancer_outfit_3 = {
    male = {
        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
        ['torso_1'] = 15,   ['torso_2'] = 0,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms'] = 15,
        ['pants_1'] = 4,    ['pants_2'] = 0,
        ['shoes_1'] = 34,   ['shoes_2'] = 0,
        ['chain_1'] = 118,  ['chain_2'] = 0
    },
    female = {
        ['tshirt_1'] = 3,   ['tshirt_2'] = 0,
        ['torso_1'] = 22,   ['torso_2'] = 1,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms'] = 15,
        ['pants_1'] = 19,   ['pants_2'] = 1,
        ['shoes_1'] = 19,   ['shoes_2'] = 3,
        ['chain_1'] = 0,    ['chain_2'] = 0
    }
  },
  dancer_outfit_4 = {
    male = {
        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
        ['torso_1'] = 15,   ['torso_2'] = 0,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms'] = 15,
        ['pants_1'] = 61,   ['pants_2'] = 5,
        ['shoes_1'] = 34,   ['shoes_2'] = 0,
        ['chain_1'] = 118,  ['chain_2'] = 0
    },
    female = {
        ['tshirt_1'] = 3,   ['tshirt_2'] = 0,
        ['torso_1'] = 82,   ['torso_2'] = 0,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms'] = 15,
        ['pants_1'] = 63,   ['pants_2'] = 11,
        ['shoes_1'] = 41,   ['shoes_2'] = 11,
        ['chain_1'] = 0,    ['chain_2'] = 0
    }
  },
  dancer_outfit_5 = {
    male = {
        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
        ['torso_1'] = 15,   ['torso_2'] = 0,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms'] = 15,
        ['pants_1'] = 21,   ['pants_2'] = 0,
        ['shoes_1'] = 34,   ['shoes_2'] = 0,
        ['chain_1'] = 118,  ['chain_2'] = 0
    },
    female = {
        ['tshirt_1'] = 3,   ['tshirt_2'] = 0,
        ['torso_1'] = 15,   ['torso_2'] = 5,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms'] = 15,
        ['pants_1'] = 63,   ['pants_2'] = 2,
        ['shoes_1'] = 41,   ['shoes_2'] = 2,
        ['chain_1'] = 0,    ['chain_2'] = 0
    }
  },
  dancer_outfit_6 = {
    male = {
        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
        ['torso_1'] = 15,   ['torso_2'] = 0,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms'] = 15,
        ['pants_1'] = 81,   ['pants_2'] = 0,
        ['shoes_1'] = 34,   ['shoes_2'] = 0,
        ['chain_1'] = 118,  ['chain_2'] = 0
    },
    female = {
        ['tshirt_1'] = 3,   ['tshirt_2'] = 0,
        ['torso_1'] = 18,   ['torso_2'] = 3,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms'] = 15,
        ['pants_1'] = 63,   ['pants_2'] = 10,
        ['shoes_1'] = 41,   ['shoes_2'] = 10,
        ['chain_1'] = 0,    ['chain_2'] = 0
    }
  },
  dancer_outfit_7 = {
    male = {
        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
        ['torso_1'] = 15,   ['torso_2'] = 0,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms'] = 40,
        ['pants_1'] = 61,   ['pants_2'] = 9,
        ['shoes_1'] = 16,   ['shoes_2'] = 9,
        ['chain_1'] = 118,  ['chain_2'] = 0
    },
    female = {
        ['tshirt_1'] = 3,   ['tshirt_2'] = 0,
        ['torso_1'] = 111,  ['torso_2'] = 6,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms'] = 15,
        ['pants_1'] = 63,   ['pants_2'] = 6,
        ['shoes_1'] = 41,   ['shoes_2'] = 6,
        ['chain_1'] = 0,    ['chain_2'] = 0
    }
  }
}
