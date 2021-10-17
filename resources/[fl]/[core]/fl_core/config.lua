Config = {}
Config.Locale = 'fr' -- Localisation

Config.CurrencyPrefix = '$' -- Ex. $ for USD - will be in front of the price
Config.CurrencySuffix = '' -- Ex. DKK for Danish Kroner - will be behind the price, remember a space in the start.

Config.Zones = {
    BikeRental = {
        Enable = true, -- Enable/Disable Bike Rental
        Name = _U('bikerental_blip'), -- Blip Name
        DrawDistance = 150.0, -- DrawDistance lower is better! (controles how fare away you should be before the marker on the ground is drawn)
        MarkerType = 25, -- Marker Type https://forum.fivem.net/t/drawmarker-pictures-for-dev/99136
        ZoneSize = {x = 2.0, y = 2.0, z = 2.0}, -- Zone Size (How large the ring is)
        MarkerColor = {r = 0, g = 255, b = 255}, -- Marker Color RGB
        RentetMarkerColor = {r = 255, g = 0, b = 0}, -- Marker Color when bike is rentet
        BlipSprite = 77, -- Map Marker Icon http://gtaxscripting.blogspot.com/2016/05/gta-v-blips-id-and-image.html
        BlipScale = 0.6, -- Size of Map Marker
        BlipColor = 2, -- Map Marker Color
        EnableBlips = false, -- Enable/Disable Map Markers
        Free = false, -- Controle if bike rental is free
        Multiplier = 5, -- Multiplie the renting price, if bike is not returned (Bike Rental resets on server restart)
        MenuTitle = _U('menu_title_bikerental'), -- Menu Title
        ItemType = 'vehicle', -- Item Type (This one is not used currently, but is intended to be used if script is expanded)
        MenuActions = {
            MenuTrigger = 'bikerental_menu', -- Menu Trigger
            MenuMessage = _U('press_bikerental_menu'), -- Menu Help Text
        },
        Items = { -- Item, label, and price used for the menu
            {item = 'BMX', label = 'BMX', price = 15},
        },
        Pos = { -- Zone positions
            {x = -246.980, y = -339.820, z = 29.000},
            {x = -1262.36, y = -1438.98, z = 3.45},
            {x = -248.95, y = -1528.82, z = 30.62},
            {x = 1808.5, y = 3676.96, z = 33.31},
            {x = -839.99, y = 5402.05, z = 33.64},
            {x = -1027.59, y = -2737.32, z = 19.18},
            {x = -173.172, y = -806.665, z = 30.536},
        }
    },

    Basejumping = {
        Enable = true, -- Enable/Disable Basejumping
        Name = _U('basejumping_blip'), -- Blip Name
        DrawDistance = 15.0, -- DrawDistance lower is better! (controles how fare away you should be before the marker on the ground is drawn)
        MarkerType = 40, -- Marker Type https://forum.fivem.net/t/drawmarker-pictures-for-dev/99136
        ZoneSize = {x = 2.0, y = 2.0, z = 2.0}, -- Zone Size (How large the ring is)
        MarkerColor = {r = 0, g = 100, b = 100}, -- Marker Color RGB
        BlipSprite = 94, -- Map Marker Icon http://gtaxscripting.blogspot.com/2016/05/gta-v-blips-id-and-image.html
        BlipScale = 0.6, -- Size of Map Marker
        BlipColor = 3, -- Map Marker Color
        EnableBlips = true, -- Enable/Disable Map Markers
        Free = false, -- Controle if bike rental is free
        MenuTitle = _U('menu_title_basejumping'), -- Menu Title
        ItemType = 'weapon', -- Item Type (Is in use dont change or it will break)
        MenuActions = {
            MenuTrigger = 'basejumping_menu', -- Menu Trigger
            MenuMessage = _U('press_basejumping_menu'), -- Menu Help Text
        },
        Items = { -- Item, label, and price used for the menu
            {item = 'parachute', label = 'Parachute', price = 100},
        },
        Pos = { -- Zone positions
            {x = 451.45, y = 5587.85, z = 781.35},
            {x = -1136.27, y = 4659.88, z = 244.15},
            {x = 1665.17, y = -28.0, z = 197.15},
            {x = -119.97, y = -977.51, z = 304.55},
            {x = -543.86, y = -2226.02, z = 122.55},
        },
        TelePos = { -- Basejump TP locations (used to launch the player for basejumping)
            {x = 446.74, y = 5587.83, z = 791.2, h = 85.5},
            {x = -1146.22, y = 4660.92, z = 243.89, h = 88.5},
            {x = 1659.73, y = -29.98, z = 208.23, h = 103.5},
            {x = -118.81, y = -979.88, z = 304.24, h = 207.5},
            {x = -539.62, y = -2228.61, z = 122.36, h = 237.5},
        }
    }
}
