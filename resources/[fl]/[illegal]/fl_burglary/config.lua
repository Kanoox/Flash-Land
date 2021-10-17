Config = {}

Config.LockPickTime = 50 -- Time in ms for lockpicking the door to break in. 1000ms = 1 second.
Config.LockTime = 2 -- Time for police to lock the door.
Config.SearchTime = 10000 -- Time in ms for searching in the house. 1000ms = 1 second.
Config.CopsRequired = 3 -- Amount of cops required to be able to lockpick a house.
Config.EnableHouseText = false -- Here you can change if you want there to be text above the marker for the house name. For instance "Didion Drive 1" above the marker at that house.
Config.LockPickItem = "phone" -- Item you need to have to be able to break in.
Config.PoliceCameras = true -- You can enable/disable the ability for police to use cameras for houses that are broken in to.

Config.LootTable = { -- The items you are able to get.
    { -- tier 1 50%
        "water", -- if you write nothing then you won't find anything.
    },
    { -- tier 2 20%
        "jewels",
    },
    { -- tier 3 15%
        "jewels",
    },
    { -- tier 4 10%
        "hifi",
    },
    { -- tier 5 5%
        "nightvision"
    }
}

Config.CameraComputer = vector3(440.8, -997.61, 34.97)

Config.Interiors = {
    House = {
        Exit = vector3(346.512, -1013.23, -99.1949), -- This is where the exit inside the house is.
        Lootables = { -- Here are the loot spots in the house. Position and heading for the player.
            Drawer = {
                Pos = vector3(346.124, -1001.71, -99.1949),
                Heading = 96.6739,
            },
            BookShelf = {
                Pos = vector3(345.378, -997.116, -99.1949),
                Heading = 275.776,
            },
            Shelf = {
                Pos = vector3(340.90, -1003.63, -99.1927),
                Heading = 186.47,
            },
            TvTable = {
                Pos = vector3(338.204, -996.692, -99.1927),
                Heading = 92.9356,
            },
            CoffeeTable = {
                Pos = vector3(340.616, -996.619, -99.1927),
                Heading = 274.846,
            },
            Cabinets = {
                Pos = vector3(342.246, -1003.23, -99.1927),
                Heading = 178.26,
            },
            Wardrobe = {
                Pos = vector3(350.668, -993.594, -99.1988),
                Heading = 4.35137,
            },
            BedTable = {
                Pos = vector3(349.276, -994.936, -99.1977),
                Heading = 89.1515,
            },
            Sink = {
                Pos = vector3(347.233, -994.099, -99.1971),
                Heading = 89.1515,
            },
        },
        Cameras = { -- Don't touch this if you don't know what you are doing.
            {
                Pos = vector3(348.244, -1003.31, -97.4928),
                Rotation = vector3(-25.1368, 0.0, -219.498)
            },
            { -- Bedroom door - Second Camera
                Pos = vector3(348.427, -998.278, -97.3477),
                Rotation = vector3(-32.224, 0.0, 129.541)
            },
            { -- Living Room - Third Camera
                Pos = vector3(337.598, -992.751953125, -97.3477),
                Rotation = vector3(-30.2955, 0.0, 234.079)
            },
            { -- Bedroom - Fourth Camera
                Pos = vector3(352.838, -999.986, -97.3477),
                Rotation = vector3(-28.4469, 0.0, 409.511809811)
            }
        }
    },
}

Config.Coords = {
    [1] =  {
        Pos = vector3(-7.22, 409.2, 120.13),
        Heading = 76.61,
        Info = ' Didion Drive 1',
        HouseType = "House"
    },
    [2] =  {
        Pos = vector3(-73.12, 427.51, 113.04),
        Heading = 157.75,
        Info = ' Didion Drive 2',
        HouseType = "House"
    },
    [3] =  {
        Pos = vector3(-166.83, 425.11, 111.8),
        Heading = 15.34,
        Info = ' Didion Drive 3',
        HouseType = "House"
    },
    [4] =  {
        Pos = vector3(38.08, 365.11, 116.05),
        Heading = 221.39,
        Info = ' Didion Drive 4',
        HouseType = "House"
    },
    [5] =  {
        Pos = vector3(-214.09, 399.86, 111.31),
        Heading = 13.43,
        Info = ' Didion Drive 5',
        HouseType = "House"
    },
    [6] =  {
        Pos = vector3(-239.04, 381.64, 112.62),
        Heading = 111.63,
        Info = ' Didion Drive 6',
        HouseType = "House"
    },
    [7] =  {
        Pos = vector3(-297.74, 380.3, 112.1),
        Heading = 11.17,
        Info = ' Didion Drive 7',
        HouseType = "House"
    },
    [8] =  {
        Pos = vector3(-328.28, 369.99, 110.01),
        Heading = 20.95,
        Info = ' Didion Drive 8',
        HouseType = "House"
    },
    [9] =  {
        Pos = vector3(-371.8, 344.28, 109.95),
        Heading = 3.39,
        Info = ' Didion Drive 9',
        HouseType = "House"
    },
    [10] =  {
        Pos = vector3(-408.92, 341.67, 108.91),
        Heading = 274.84,
        Info = ' Didion Drive 10',
        HouseType = "House"
    },
    [11] =  {
        Pos = vector3(-444.27, 343.86, 105.39),
        Heading = 184.95,
        Info = ' Didion Drive 11',
        HouseType = "House"
    },
    [12] =  {
        Pos = vector3(-468.94, 329.99, 104.49),
        Heading = 241.99,
        Info = ' Didion Drive 12',
        HouseType = "House"
    },
    [13] =  {
        Pos = vector3(-305.22, 431.56, 110.31),
        Heading = 10.16,
        Info = ' Cox Way 1',
        HouseType = "House"
    },
    [14] =  {
        Pos = vector3(-371.86, 408.06, 110.6),
        Heading = 115.71,
        Info = ' Cox Way 2',
        HouseType = "House"
    },
    [15] =  {
        Pos = vector3(-400.54, 427.2, 112.35),
        Heading = 246.04,
        Info = ' Cox Way 3',
        HouseType = "House"
    },
    [16] =  {
        Pos = vector3(-451.53, 395.61, 104.78),
        Heading = 85.78,
        Info = ' Cox Way 4',
        HouseType = "House"
    },
    [17] =  {
        Pos = vector3(-477.33, 413.03, 103.13),
        Heading = 185.61,
        Info = ' Cox Way 5',
        HouseType = "House"
    },
    [18] =  {
        Pos = vector3(-500.49, 398.66, 98.15),
        Heading = 54.31,
        Info = ' Cox Way 6',
        HouseType = "House"
    },
    [19] =  {
        Pos = vector3(-516.95, 433.19, 97.81),
        Heading = 130.67,
        Info = ' Cox Way 7',
        HouseType = "House"
    },
    [20] =  {
        Pos = vector3(-561.08, 403.19, 101.81),
        Heading = 17.43,
        Info = ' Milton Road 1',
        HouseType = "House"
    },
    [21] =  {
        Pos = vector3(-595.7, 393.54, 101.89),
        Heading = 3.1,
        Info = ' Milton Road 2',
        HouseType = "House"
    },
    [22] =  {
        Pos = vector3(-615.57, 399.15, 101.24),
        Heading = 5.39,
        Info = ' Milton Road 3',
        HouseType = "House"
    },
    [23] =  {
        Pos = vector3(223.17, 514.43, 140.77),
        Heading = 38.98,
        Info = ' Wild Oats Drive 1',
        HouseType = "House"
    },

    [24] =  {
        Pos = vector3(-500.27, 552.37, 120.43),
        Heading = 326.56,
        Info = ' Didion Drive 21',
        HouseType = "House"
    },

    [25] =  {
        Pos = vector3(118.82, 494.01, 147.35),
        Heading = 106.07,
        Info = ' Wild Oats Drive 3',
        HouseType = "House"
    },
    [26] =  {
        Pos = vector3(106.9, 467.73, 147.38),
        Heading = 2.1,
        Info = ' Wild Oats Drive 4',
        HouseType = "House"
    },
    [27] =  {
        Pos = vector3(80.21, 485.85, 148.21),
        Heading = 208.96,
        Info = ' Wild Oats Drive 5',
        HouseType = "House"
    },
    [28] =  {
        Pos = vector3(57.84, 450.05, 147.04),
        Heading = 328.16,
        Info = ' Wild Oats Drive 6',
        HouseType = "House"
    },
    [29] =  {
        Pos = vector3(42.98, 468.72, 148.1),
        Heading = 169.75,
        Info = ' Wild Oats Drive 7',
        HouseType = "House"
    },
    [30] =  {
        Pos = vector3(-7.79, 468.12, 145.86),
        Heading = 341.41,
        Info = ' Wild Oats Drive 8',
        HouseType = "House"
    },
    [31] =  {
        Pos = vector3(-66.83, 490.18, 144.89),
        Heading = 338.4,
        Info = ' Wild Oats Drive 9',
        HouseType = "House"
    },
    [32] =  {
        Pos = vector3(-109.87, 502.01, 143.48),
        Heading = 347.61,
        Info = ' Wild Oats Drive 10',
        HouseType = "House"
    },
    [33] =  {
        Pos = vector3(-174.76, 502.6, 137.43),
        Heading = 91.98,
        Info = ' Wild Oats Drive 11',
        HouseType = "House"
    },
    [34] =  {
        Pos = vector3(-230.26, 488.43, 128.77),
        Heading = 1.71,
        Info = ' Wild Oats Drive 12',
        HouseType = "House"
    },
    [36] =  {
        Pos = vector3(232.01, 672.55, 189.95),
        Heading = 38.31,
        Info = ' Whispymound Drive 1',
        HouseType = "House"
    },
    [37] =  {
        Pos = vector3(216.04, 620.57, 187.64),
        Heading = 71.57,
        Info = ' Whispymound Drive 2',
        HouseType = "House"
    },
    [38] =  {
        Pos = vector3(184.86, 571.73, 183.34),
        Heading = 284.56,
        Info = ' Whispymound Drive 3',
        HouseType = "House"
    },
    [39] =  {
        Pos = vector3(128.18, 566.05, 183.96),
        Heading = 3.58,
        Info = ' Whispymound Drive 4',
        HouseType = "House"
    },
    [40] =  {
        Pos = vector3(84.89, 561.77, 182.78),
        Heading = 1.88,
        Info = ' Whispymound Drive 5',
        HouseType = "House"
    },
    [41] =  {
        Pos = vector3(45.75, 556.64, 180.09),
        Heading = 18.32,
        Info = ' Whispymound Drive 6',
        HouseType = "House"
    },
    [43] =  {
        Pos = vector3(228.52, 765.89, 204.79),
        Heading = 59.33,
        Info = ' Kimble Hill Drive 1',
        HouseType = "House"
    },
    [44] =  {
        Pos = vector3(-126.46, 588.54, 204.72),
        Heading = 359.66,
        Info = ' Kimble Hill Drive 2',
        HouseType = "House"
    },
    [45] =  {
        Pos = vector3(-185.28, 591.2, 197.83),
        Heading = 357.1,
        Info = ' Kimble Hill Drive 3',
        HouseType = "House"
    },
    [46] =  {
        Pos = vector3(-189.57, 617.86, 199.67),
        Heading = 190.04,
        Info = ' Kimble Hill Drive 4',
        HouseType = "House"
    },
    [47] =  {
        Pos = vector3(-232.61, 589.02, 190.54),
        Heading = 353.79,
        Info = ' Kimble Hill Drive 5',
        HouseType = "House"
    },
    [48] =  {
        Pos = vector3(-256.67, 632.44, 187.81),
        Heading = 75.18,
        Info = ' Kimble Hill Drive 6',
        HouseType = "House"
    },
    [49] =  {
        Pos = vector3(-293.54, 600.83, 181.58),
        Heading = 348.16,
        Info = ' Kimble Hill Drive 7',
        HouseType = "House"
    },
    [50] =  {
        Pos = vector3(-299.18, 635.27, 175.69),
        Heading = 118.75,
        Info = ' Kimble Hill Drive 8',
        HouseType = "House"
    },
    [51] =  {
        Pos = vector3(-339.79, 668.58, 172.79),
        Heading = 254.73,
        Info = ' Kimble Hill Drive 9',
        HouseType = "House"
    },
    [52] =  {
        Pos = vector3(-340.03, 625.84, 171.36),
        Heading = 57.48,
        Info = ' Kimble Hill Drive 10',
        HouseType = "House"
    },
    [53] =  {
        Pos = vector3(-400.12, 664.99, 163.84),
        Heading = 352.99,
        Info = ' Kimble Hill Drive 11',
        HouseType = "House"
    },
    [54] =  {
        Pos = vector3(-445.88, 685.71, 152.96),
        Heading = 202.25,
        Info = ' Kimble Hill Drive 12',
        HouseType = "House"
    },
    [55] =  {
        Pos = vector3(-476.73, 648.15, 144.39),
        Heading = 14.58,
        Info = ' Kimble Hill Drive 13',
        HouseType = "House"
    },
    [56] =  {
        Pos = vector3(-595.47, 530.13, 107.76),
        Heading = 196.13,
        Info = ' Picture Perfect Drive 1',
        HouseType = "House"
    },
    [57] =  {
        Pos = vector3(-580.6, 492.09, 108.91),
        Heading = 10.17,
        Info = ' Picture Perfect Drive 2',
        HouseType = "House"
    },
    [58] =  {
        Pos = vector3(-622.94, 489.34, 108.85),
        Heading = 5.51,
        Info = ' Picture Perfect Drive 3',
        HouseType = "House"
    },
    [59] =  {
        Pos = vector3(-640.95, 519.88, 109.69),
        Heading = 182.77,
        Info = ' Picture Perfect Drive 4',
        HouseType = "House"
    },
    [60] =  {
        Pos = vector3(-667.47, 472.42, 114.14),
        Heading = 13.3,
        Info = ' Picture Perfect Drive 5',
        HouseType = "House"
    },
    [61] =  {
        Pos = vector3(-679.0, 512.16, 113.53),
        Heading = 197.35,
        Info = ' Picture Perfect Drive 6',
        HouseType = "House"
    },
    [62] =  {
        Pos = vector3(-721.23, 490.13, 109.39),
        Heading = 208.02,
        Info = ' Picture Perfect Drive 7',
        HouseType = "House"
    },
    [63] =  {
        Pos = vector3(-718.16, 449.2, 106.91),
        Heading = 20.93,
        Info = ' Picture Perfect Drive 8',
        HouseType = "House"
    },
    [64] =  {
        Pos = vector3(-784.21, 459.01, 100.18),
        Heading = 212.24,
        Info = ' Picture Perfect Drive 9',
        HouseType = "House"
    },
    [65] =  {
        Pos = vector3(-762.31, 431.49, 100.2),
        Heading = 15.68,
        Info = ' Picture Perfect Drive 10',
        HouseType = "House"
    },
    [66] =  {
        Pos = vector3(-824.95, 422.82, 92.13),
        Heading = 6.05,
        Info = ' Picture Perfect Drive 11',
        HouseType = "House"
    },
    [67] =  {
        Pos = vector3(-559.45, 663.99, 145.49),
        Heading = 337.57,
        Info = ' Normandy Drive 1',
        HouseType = "House"
    },
    [68] =  {
        Pos = vector3(-564.36, 684.27, 146.42),
        Heading = 203.91,
        Info = ' Normandy Drive 2',
        HouseType = "House"
    },
    [69] =  {
        Pos = vector3(-605.93, 672.75, 151.6),
        Heading = 345.9,
        Info = ' Normandy Drive 3',
        HouseType = "House"
    },
    [70] =  {
        Pos = vector3(-708.57, 712.76, 162.21),
        Heading = 272.94,
        Info = ' Normandy Drive 4',
        HouseType = "House"
    },
}