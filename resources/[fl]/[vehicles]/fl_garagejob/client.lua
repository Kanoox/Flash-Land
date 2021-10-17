local lastExitedVeh = nil
RMenu.Add('rGarage', 'main', RageUI.CreateMenu("Garage", ""))
RMenu:Get('rGarage', 'main'):SetSubtitle("~b~Garage de service")
RMenu:Get('rGarage', 'main').EnableMouse = false
RMenu:Get('rGarage', 'main').Closed = function() end

local garage = {
    {
        job = "event",
        pos = vector3(-1096.59, -254.63, 37.69),
        sortieDeVeh = {
            {pos = vector3(-1099.73, -262.71, 37.66), heading = 209.13},
        },
        vehs = {
            {nom = 'Speedo2', spawn = 'speedo2'},
            {nom = 'Caddy (EVENT UNIQUEMENT)', spawn = 'caddy'},
            {nom = 'Kart (EVENT UNIQUEMENT)', spawn = 'veto'},
            {nom = 'Kart2 (EVENT UNIQUEMENT)', spawn = 'veto2'},
            {nom = 'Bus de ville', spawn = 'bus'},
            {nom = 'Bus concert', spawn = 'pbus2'},
            {nom = 'Bus evenement', spawn = 'tourbus'},
            {nom = 'Outlaw', spawn = 'outlaw'},
            {nom = 'Bifta', spawn = 'bifta'},
            {nom = 'Sanchez', spawn = 'sanchez'},
            {nom = 'BMX', spawn = 'bmx'},
            {nom = 'Vélo de course', spawn = 'tribike'},
            {nom = 'Hélico 1 place', spawn = 'havok'},
            {nom = 'Hélico Sparrow', spawn = 'seasparrow2'},
            {nom = 'Hélico Buzzard', spawn = 'buzzard2'},
        },
    },
    {
        job = "confe",
        pos = vector3(4454.49, -4470.83, 4.33),
        sortieDeVeh = {
            {pos = vector3(4455.83, -4480.53, 4.4), heading = 206.67},
            {pos = vector3(4453.18, -4481.52, 4.4), heading = 206.67},
            {pos = vector3(4448.23, -4483.28, 4.4), heading = 206.67},
            {pos = vector3(4443.31, -4484.65, 4.4), heading = 206.67},
            {pos = vector3(4447.87, -4486.17, 4.4), heading = 206.67},
        },
        vehs = {
            {nom = 'Tout terrain Winky', spawn = 'winky'},
            {nom = 'Manchez', spawn = 'manchez2'},
            {nom = 'Camion Vetir', spawn = 'vetir'},
            {nom = 'Quad Verus', spawn = 'verus'},
        },
    },
    {
        job = "unicorn",
        pos = vector3(137.177, -1278.757, 29.5),
        sortieDeVeh = {
            {pos = vector3(138.436, -1263.095, 28.6), heading = 207.0},
        },
        vehs = {
            {spawn = 'rumpo', nom = 'Van'},
            {spawn = 'Oracle2', nom = 'Patron'},
        },
    },
    {
        job = "ammunation",
        pos = vector3(-2.49, -1110.31, 28.79),
        sortieDeVeh = {
            {pos = vector3(-9.50, -1113.73, 28.25), heading = 156.94},
        },
        vehs = {
            {nom = 'Boxville Ammunation', spawn = 'aboxville'},
            {nom = 'Burrito Ammunation', spawn = 'aburrito'},
            {nom = 'Stockade Ammunation', spawn = 'astockade'},
        },
    },
    {
        job = "burgershot",
        pos = vector3(-1178.38, -891.69, 13.75),
        sortieDeVeh = {
            {pos = vector3(-1165.48, -888.06, 13.52), heading = 120.84},
            {pos = vector3(-1163.79, -891.39, 13.52), heading = 120.45},
        },
        vehs = {
            {nom = 'Boxville', spawn = 'boxville2'},
            {nom = 'faggio', spawn = 'faggio2'}
        },
    },
    {
        job = "banker",
        pos = vector3(-1224.79, -837.61, 29.41),
        sortieDeVeh = {
            {pos = vector3(-1219.96, -831.9, 29.41), heading = 41.39},
        },
        Marker = {
            type = 34,
            x = 1.5,
            y = 1.5,
            z = 1.5,
            r = 255,
            g = 255,
            b = 255,
            a = 100,
        },
        vehs = {
            {
                nom = "Hélicoptère",
                spawn = "frogger",
            },
            {
                nom = "Hélicoptère de luxe",
                spawn = "swift2",
            },
            {
                nom = "Hélicoptère de luxe léger",
                spawn = "volatus",
            },
            {
                nom = "Havok",
                spawn = "havok",
            },
        },
    },
    {
        job = "banker",
        pos = vector3(-1272.58, -810.79, 17.13),
        sortieDeVeh = {
            {pos = vector3(-1287.56, -814.43, 17.32), heading = 315.29},
            {pos = vector3(-1290.62, -811.27, 17.54), heading = 315.29},
            {pos = vector3(-1292.58, -808.45, 17.58), heading = 315.29},
        },
        vehs = {
            {
                nom = "Stockade",
                spawn = "stockade",
            },
            {
                nom = "Brickade",
                spawn = "brickade",
            },
            {
                nom = "SuperD",
                spawn = "superd",
            },
            {
                nom = "Intruder",
                spawn = "intruder",
                props = {
                    color1 = 27,
                    color2 = 27,
                },
            },
            {
                nom = "Beejay XL",
                spawn = "bjxl",
                props = {
                    color1 = 27,
                    color2 = 27,
                },
            },
        },
    },
    --GreenMotors
    {
        job = "greenmotors",
        pos = vector3(937.51, -987.28, 38.40),
        sortieDeVeh = {
            {pos = vector3(927.16, -994.93, 37.52), heading = 95.04},
            {pos = vector3(908.22, -995.95, 35.45), heading = 91.38},
        },
        vehs = {
            {
                nom = "Plateau",
                spawn = "flatbed",
            },
            {
                nom = "Dépaneuse",
                spawn = "towtruck",
            },
        },
    },
    {
        job = "journaliste",
        pos = vector3(-576.82, -928.87, 36.83),
        sortieDeVeh = {
            {pos = vector3(-582.7, -930.82, 36.83), heading = 95.55},
        },
        Marker = {
            type = 34,
            x = 1.5,
            y = 1.5,
            z = 1.5,
            r = 255,
            g = 255,
            b = 255,
            a = 100,
        },
        vehs = {
            {
                nom = "Hélicoptère",
                spawn = "newsfrog",
            },
        },
    },
    {
        job = "journaliste",
        pos = vector3(-543.64, -888.29, 25.14),
        sortieDeVeh = {
            {pos = vector3(-547.16, -892.78, 24.57), heading = 192.6},
            {pos = vector3(-539.44, -890.79, 24.81), heading = 192.6},
        },
        vehs = {
            {
                nom = "Van WeazelNews",
                spawn = "newsvan2",
                props = {
                    modLivery = 0,
                }
            },
            {
                nom = "Stanier",
                spawn = "stanier",
            },
        },
    },
    {
        job = "casino",
        pos = vector3(935.98, 0.16, 78.76),
        sortieDeVeh = {
            {pos = vector3(934.54, -5.05, 78.76), heading = 145.65},
            {pos = vector3(931.7, -2.99, 78.76), heading = 145.65},
        },
        vehs = {
            {
                nom = "Limousine",
                spawn = "stretch",
            },
            {
                nom = "Baller",
                spawn = "baller4",
            },
        },
    },
    {
        job = "casino",
        pos = vector3(971.14, 38.53, 123.12),
        sortieDeVeh = {
            {pos = vector3(966.0, 42.35, 123.13), heading = 56.0},
        },
        Marker = {
            type = 34,
            x = 1.5,
            y = 1.5,
            z = 1.5,
            r = 255,
            g = 255,
            b = 255,
            a = 100,
        },
        vehs = {
            {
                nom = "Hélicoptère de luxe",
                spawn = "swift2",
            },
            {
                nom = "Hélicoptère de luxe léger",
                spawn = "volatus",
            },
            {
                nom = "Hélicoptère carbone",
                spawn = "supervolito2",
            },
            {
                nom = "Havok",
                spawn = "havok",
            },
        },
    },
    {
        job = "ubereats",
        pos = vector3(39.05, -1022.36, 29.5),
        sortieDeVeh = {
            {pos = vector3(30.94, -1024.65, 29.45), heading = 250.0},
            {pos = vector3(28.4, -1027.03, 29.45), heading = 250.0},
            {pos = vector3(27.45, -1029.52, 29.45), heading = 250.0},
            {pos = vector3(26.71, -1031.69, 29.45), heading = 250.0},
        },
        vehs = {
            {
                nom = "Scooter livreur",
                spawn = "faggio2",
            },
        },
    },

    --Police Sud
    {
        job = "police",
        pos = vector3(458.14, -1008.32, 28.29),
        sortieDeVeh = {
            {pos = vector3(449.41, -1024.42, 28.65), heading = 3.65},
            {pos = vector3(445.41, -1025.18, 28.65), heading = 3.65},
            {pos = vector3(442.58, -1025.76, 28.71), heading = 3.65},
            {pos = vector3(438.83, -1025.71, 28.78), heading = 3.65},
        },

        vehs = {
            {
                nom = "Crown Victoria",
                spawn = "police",
                props = {
                    modTurbo = true,
                },
            },
            {
                nom = "SUV",
                spawn = "police3",
                props = {
                    modTurbo = true,
                },
            },

            {
                nom = "Crown Banalisé",
                spawn = "police4",
                props = {
                    modTurbo = true,
                },
            },

            {
                nom = "Felon Banalisé",
                spawn = "policefelon",
                props = {
                    modTurbo = true,
                },
            },
            {
                nom = "Pinnacle",
                spawn = "pinnaclep",
                props = {
                    modTurbo = true,
                },
            },
            {
                nom = "Dodge Charger",
                spawn = "police2b",
                props = {
                    modTurbo = true,
                },
            },
            {
                nom = "Vapid",
                spawn = "police3slick",
                props = {
                    modTurbo = true,
                },
            },
            {
                nom = "Vapid Banalisé",
                spawn = "police3umk",
                props = {
                    modTurbo = true,
                },
            },
            {
                nom = "Fugitive",
                spawn = "policefug",
                props = {
                    modTurbo = true,
                },
            },
            {
                nom = "Fugitive Banalisé",
                spawn = "policefug2",
                props = {
                    modTurbo = true,
                },
            },
            {
                nom = "Jackal",
                spawn = "police2",
                props = {
                    modTurbo = true,
                },
            },
            {
                nom = "Moto",
                spawn = "policeb",
            },
            {
                nom = "Moto 2 (En réparation)",
                spawn = "policec",
            },
            {
                nom = "Vélo",
                spawn = "scorcher",
            },
        },
    },
    {
        job = "police",
        pos = vector3(461.31, -981.61, 25.7),
        sortieDeVeh = {
            {pos = vector3(452.28, -991.9, 25.7), heading = 358.17},
            {pos = vector3(443.07, -981.37, 25.7), heading = 82.17},
            {pos = vector3(431.54, -989.76, 25.7), heading = 182.17},
        },

        vehs = {
            {
                nom = "Bus pénitancier",
                spawn = "pbus",
            },
            {
                nom = "Véhicule Blindé",
                spawn = "riot",
            },
            {
                nom = "Felon Transporter",
                spawn = "policet",
            },
            {
                nom = "Anti-Emeute",
                spawn = "riot2",
            },
        },
    },
    {
        job = "police",
        pos = vector3(462.12, -991.62, 25.7),
        sortieDeVeh = {
            {pos = vector3(446.42, -996.83, 25.7), heading = 87.15},
            {pos = vector3(446.65, -994.19, 25.7), heading = 87.15},
            {pos = vector3(446.14, -991.62, 25.7), heading = 87.15},
            {pos = vector3(446.19, -989.07, 25.7), heading = 87.15},
            {pos = vector3(446.28, -986.24, 25.7), heading = 87.15},
            {pos = vector3(450.22, -975.99, 25.7), heading = 83.15},
            {pos = vector3(436.05, -976.0, 25.7), heading = 83.15},
        },

        vehs = {
            {
                nom = "Crown Victoria",
                spawn = "polvic",
                props = {
                    modTurbo = true,
                },
            },
            {
                nom = "Dogde Charger",
                spawn = "polchar",
                props = {
                    modTurbo = true,
                },
            },
            {
                nom = "Police Interceptor",
                spawn = "poltaurus",
                props = {
                    modTurbo = true,
                },
            },

            {
                nom = "Ford Mondéo",
                spawn = "17fusionrb",
                props = {
                    modTurbo = true,
                },
            },
            {
                nom = "SUV",
                spawn = "explorer",
                props = {
                    modTurbo = true,
                },
            },

            {
                nom = "Banalisé",
                spawn = "fbi",
                props = {
                    modTurbo = true,
                },
            },

            {
                nom = "VictoriaCrown Banalisé",
                spawn = "police4",
                props = {
                    modTurbo = true,
                },
            },
            {
                nom = "Moto",
                spawn = "policeb",
            },
            {
                nom = "Vélo",
                spawn = "scorcher",
            },
        },
    },
    { --MRPD Heli
        job = "police",
        pos = vector3(456.42, -981.2, 43.59),
        sortieDeVeh = {
            {pos = vector3(450.08, -982.31, 43.59), heading = 94.3},
        },
        Marker = {
            type = 34,
            x = 1.5,
            y = 1.5,
            z = 1.5,
            r = 0,
            g = 0,
            b = 150,
            a = 100,
        },
        vehs = {
            {
                nom = "Police Maverick",
                spawn = "polmav",
                props = {
                    modLivery = 0,
                },
            },
        },
    },

    --Sheriff Nord
    {
        job = "sheriff",
        pos = vector3(-459.16, 6012.55, 31.49),
        sortieDeVeh = {
            {pos = vector3(-462.90, 6009.47, 30.99), heading = 85.43},
            {pos = vector3(-459.14, 6005.52, 30.99), heading = 86.18},
            {pos = vector3(-455.43, 6001.78, 30.99), heading = 85.89},
            {pos = vector3(-452.19, 5998.31, 30.99), heading = 85.96},
        },
        vehs = {
            {
                nom = "Cruiser",
                spawn = "sheriff",
                props = {
                    modTurbo = true,
                }
            },
            {
                nom = "Granger",
                spawn = "pranger",
                props = {
                    modTurbo = true,
                }
            },
            {
                nom = "Bus pénitancier",
                spawn = "pbus",
                props = {
                    modTurbo = true,
                },
            },
            {
                nom = "Véhicule Blindé",
                spawn = "riot",
            },
            {
                nom = "Anti-Emeute",
                spawn = "riot2",
            },
            {
                nom = "Vélo",
                spawn = "scorcher",
            },
        },
    },

    { --NORD Heli
    job = "sheriff",
    pos = vector3(-464.59, 5998.66, 31.25),
    sortieDeVeh = {
        {pos = vector3(-475.03, 5988.8, 31.3), heading = 135.0},
    },
    Marker = {
        type = 34,
        x = 1.5,
        y = 1.5,
        z = 1.5,
        r = 0,
        g = 0,
        b = 150,
        a = 100,
    },
    vehs = {
        {
            nom = "Police Maverick",
            spawn = "polmav",
            props = {
                modLivery = 0,
            },
        },
    },
},

    --Police Plage
    {
        job = "police",
        pos = vector3(-1622.41, -1171.24, 2.65),
        sortieDeVeh = {
            {pos = vector3(-1620.20, -1174.63, 1.0), heading = 131.26},
        },
        vehs = {
            {
                nom = "Beateau Police",
                spawn = "predator",
            },
        },
    },

    -- Hopital
    {
        job = "ambulance",
        pos = vector3(294.46, -600.1, 43.15),
        sortieDeVeh = {
                {pos = vector3(292.95, -609.52, 42.85), heading = 68.25},
                {pos = vector3(294.41, -606.2, 42.85), heading = 68.94},
            },
        vehs = {
            {
                nom = "Ambulance",
                spawn = "ambulance",
            },
            {
                nom = "Corbillard",
                spawn = "romero",
            },
            {
                nom = "SUV",
                spawn = "fddurango",
            },
            {
                nom = "Dodge",
                spawn = "ems",
            },
            {
                nom = "Camion Pompier",
                spawn = "firetruk",
            },
        },
    },

    {
        job = "ambulance",
        pos = vector3(338.46, -586.79, 74.16),
        sortieDeVeh = {
                {pos = vector3(350.36, -588.80, 74.55), heading = 286.67},
            },
        vehs = {
            {
                nom = "Maverick",
                spawn = "polmav",
                props = {
                    modLivery = 1,
                },
            },
        },
        Marker = {
            type = 34,
            x = 1.5,
            y = 1.5,
            z = 1.5,
            r = 100,
            g = 150,
            b = 150,
            a = 100,
        }
    },


   -- Ambulance Plage
    {
        job = "ambulance",
        pos = vector3(-1622.41, -1171.24, 2.65),
        sortieDeVeh = {
            {pos = vector3(-1620.20, -1174.63, 1.0), heading = 131.26},
            },
        vehs = {
            {
                nom = "JetSki Lifeguard",
                spawn = "seashark2",
            },
        },
    },

    {
        job = "gouv",
        pos = vector3(-581.58, -126.97, 34.12),
        sortieDeVeh = {
            {pos = vector3(-575.98, -133.18, 35.72), heading = 203.42},
            {pos = vector3(-580.56, -137.62, 36.13), heading = 204.33},
        },
        vehs = {
            {
                nom = "Baller blindé",
                spawn = "baller5",
            },
            {
                nom = "Véhicule Présidentiel",
                spawn = "onebeast",
            },
        },
    },

    {
        job = "gouv",
        pos = vector3(2504.8, -341.2, 118.02),
        sortieDeVeh = {
            {pos = vector3(2510.6, -342.0, 118.1), heading = 10.0},
        },
        Marker = {
            type = 34,
            x = 1.5,
            y = 1.5,
            z = 1.5,
            r = 0,
            g = 0,
            b = 150,
            a = 100,
        },
        vehs = {
            {
                nom = "Volatus",
                spawn = "volatus",
            },
        },
    },

}

local GarageActuelData = {}
Citizen.CreateThread(function()
    for k,v in pairs(garage) do
        if v.Marker == nil then
            v.Marker = {
                type = 36,
                x = 1.5,
                y = 1.5,
                z = 1.5,
                r = 255,
                g = 255,
                b = 255,
                a = 160,
            }
        end
    end
    while true do
        local sleep = 300
        local pCoords = GetEntityCoords(PlayerPedId())

        for k,v in pairs(garage) do
            if ESX.PlayerData.job.name == v.job or ESX.PlayerData.faction.name == v.job then
                local distance = #(v.pos - pCoords)

                if distance < 30 then
                    DrawMarker(v.Marker.type, v.pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x, v.Marker.y, v.Marker.z, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, true, nil, nil, false)
                    sleep = 0
                end

                if distance < 2.0 then
                    sleep = 0
                    ESX.ShowHelpNotification("Appuie sur ~INPUT_PICKUP~ pour ouvrir le garage")
                    if IsControlJustReleased(1, 38) then
                        GarageActuelData = v
                        RageUI.Visible(RMenu:Get('rGarage', 'main'), not RageUI.Visible(RMenu:Get('rGarage', 'main')))

                        while RageUI.Visible(RMenu:Get('rGarage', 'main')) do
                            RageUI.DrawContent({ header = true, glare = true, instructionalButton = true }, function()
                                RageUI.Button("Ranger ce véhicule", nil, { RightLabel = "→→→" }, true, function(_, _, Selected)
                                    if Selected then
                                        RangerVeh()
                                        RageUI.CloseAll()
                                    end
                                end)

                                for k,v in pairs(GarageActuelData.vehs) do
                                    RageUI.Button(v.nom, nil, {}, true, function(_, _, Selected)
                                        if Selected then
                                            local found, coords, heading = CheckSpawnData(GarageActuelData.sortieDeVeh)
                                            if found then
                                                ESX.Game.SpawnVehicle(v.spawn, coords, heading, function(vehicle)
                                                    lastExitedVeh = vehicle
                                                    for i = 0,14 do
                                                       SetVehicleExtra(vehicle, i, 0)
                                                    end
                                                    if v.props then
                                                        ESX.Game.SetVehicleProperties(vehicle, v.props)
                                                    end
                                                    TriggerServerEvent('fl_controlvehicle:giveKey', GetVehicleNumberPlateText(vehicle))
                                                end)
                                            end
                                            RageUI.CloseAll()
                                        end
                                    end)
                                end
                            end, function()
                                ---Panels
                            end)
                            Citizen.Wait(0)
                        end
                    end
                end
            end
        end

        Wait(sleep)
    end
end)

function CheckSpawnData(data)
    local found = false
    local essai = 0
    local pos = vector3(10.0, 10.10, 10.10)
    local heading = 0.0
    while not found do
        Wait(100)
        local r = math.random(1, #data)
        local _pos = data[r]
        if ESX.Game.IsSpawnPointClear(_pos.pos, 2.0) then
            pos = _pos.pos
            heading = _pos.heading
            found = true
        end
        essai = essai + 1
        if essai > #data * 2 then
            break
        end
    end
    return found, pos, heading
end

function RangerVeh()
    local vehicule = 0
    local closest = 5000
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        vehicule = GetVehiclePedIsIn(PlayerPedId(), false)
    else
        vehicule = GetVehiclePedIsIn(PlayerPedId(), true)
    end

    if vehicule == 0 or vehicule == nil then
        vehicule, closest = ESX.Game.GetClosestVehicle()
        if closest > 8.0 then
            vehicule = nil
        end
    end

    if vehicule == 0 or vehicule == nil then
        vehicule = lastExitedVeh
        if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(vehicule)) > 40 then
            vehicule = nil
        end
    end

    if vehicule ~= 0 and vehicule ~= nil then
        TriggerServerEvent('fl_controlvehicle:deleteKeyJobs', GetVehicleNumberPlateText(vehicule), NetworkGetNetworkIdFromEntity(vehicule))
    end
end