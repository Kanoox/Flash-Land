Markers = {
    threadActive = false,
    subscribed = {},
    init = function()
        Citizen.CreateThread(function()
            Markers.threadActive = true 
            while true do
                local itv = 500
                local p = GetEntityCoords(PlayerPedId())
                for id,m in pairs(Markers.subscribed) do
                    local dist = GetDistanceBetweenCoords(p, m.position, true)
                    if dist < m.drawDist then 
                        itv = 1 
                        DrawMarker(20, m.position.x, m.position.y, m.position.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.5, 0.5, m.color.r, m.color.g, m.color.b, 100, false, true, 2, true, false, false, false)
                        if dist < m.itrDist then
                            if m.condition == nil then
                                RageUI.Text({
                                    message = m.help,
                                    time_display = 100,
                                })
                                if IsControlJustPressed(1, 51) then m.interact() end
                            else
                                if m.condition == "vehicle" then
                                    if IsPedInAnyVehicle(PlayerPedId(), false) then
                                        RageUI.Text({
                                            message = m.help,
                                            time_display = 100,
                                        })
                                        if IsControlJustPressed(1, 51) then m.interact() end
                                    end
                                elseif m.condition == "boss" then
                                    if ESX.PlayerData.job.grade_name == "boss" or ESX.PlayerData.job.grade_name == "captain" then
                                        RageUI.Text({
                                            message = m.help,
                                            time_display = 100,
                                        })
                                        if IsControlJustPressed(1, 51) then m.interact() end
                                    end
                                end
                            end
                        end
                    end
                end
                Citizen.Wait(itv)
            end
        end)
    end,


    add = function(id,data)
        Markers.list[id] = {
            position = data.position,
            drawDist = data.drawDist,
            itrDist = data.itrDist,
            color = data.color,
            condition = data.condition,
            help = data.help,
            interact = data.interact
        }
        

    end,

    delete = function(id)
        Markers.list[id] = nil
    end,

    subscribe = function(id)
        Markers.subscribed[id] = Markers.list[id]
    end,

    unsubscribe = function(id)
        Markers.subscribed[id] = nil
    end,
    
    list = {
        ["police_clothes"] = {
            position = vector3(461.83, -999.15, 30.68),
            drawDist = 20,
            itrDist = 1.5,
            color = {r = 50, g = 50, b = 204},
            condition = nil,
            help = "Appuyez sur [~b~E~s~] pour accéder aux vestiaires",
            interact = function()
                openClothesLSPDMenu()
            end,
        },

        ["police_armory"] = {
            position = vector3(479.11, -996.80, 30.69), 
            drawDist = 20,
            itrDist = 1.5,
            color = {r = 50, g = 50, b = 204},
            condition = nil,
            help = "Appuyez sur [~b~E~s~] pour accéder à l'armurerie",
            interact = function()
                openArmoryLSPDMenu()
            end,
        },


        ["police_boss"] = {
            position = vector3(460.49, -985.05, 30.70),
            drawDist = 25,
            itrDist = 1.5,
            color = {r = 255, g = 0, b = 0},
            condition = "boss",
            help = "Appuyez sur [~b~E~s~] pour gérer la société",
            interact = function()
                TriggerEvent('fl_society:openBossMenu', 'police', function(data, menu)
					menu.close()
				end, {})
            end,
        },

        ["police_perquise"] = {
            position = vector3(474.93, -994.65, 26.27),
            drawDist = 20,
            itrDist = 1.5,
            color = {r = 221, g = 74, b = 237},
            condition = nil,
            help = "Appuyez sur [~b~E~s~] pour accéder au stock",
            interact = function()
                openPerquiseStockMenu()
            end,
        },
        
    },
}

flCore.markers = Markers