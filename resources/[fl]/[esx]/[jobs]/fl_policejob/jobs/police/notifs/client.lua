local blip
Notif = Notif or {}


RegisterNetEvent("iCore:getCallMsg")
AddEventHandler("iCore:getCallMsg", function(msg, coords, xPlayer)
    if inServicePolice then 
        ESX.ShowAdvancedNotification("Centrale", "~b~Appel d'urgence : 911", msg, "CHAR_CALL911", 2)
        Notif:ShowMessage("~g~Y~s~ pour accepter l'appel\n~r~X ~s~pour refuser l'appel")

        Citizen.CreateThread(function()
            while true do
                breakThread = nil
                Wait(5)
                time = 6000
                time = time - 5

                if IsControlJustPressed(0, 246) then
                    if blip then
                        RemoveBlip(blip)
                        blip = nil
                    end
                    Notif:ShowMessage("~g~Vous avez pris l'appel")
                    TriggerServerEvent("iCore:tookCall")
                    blip = createBlip(coords, 42, 1, "Alerte LSPD", true, 0.5)
                    while blip do
                        local pPed = GetPlayerPed(-1)
                        local pPos = GetEntityCoords(pPed)
                        local dist = Vdist2(pPos, coords)

                        if dist < 50.0 then
                            Notif:ShowMessage("~g~Vous êtes arrivé à destination")
                            RemoveBlip(blip)
                            blip = nil    
                            break
                        end
                        Wait(500)
                    end
                    break
                end

                if IsControlJustPressed(0, 73) then
                    Notif:ShowMessage("~r~Vous avez refusé l'appel")
                    break
                end

                if time <= 0 then
                    breakThread = true
                    break
                end

                if breakThread then
                    break
                end
            end
        end)
    end
end)

RegisterNetEvent("iCore:getCallTir")
AddEventHandler("iCore:getCallTir", function(coords)
    if inServicePolice then 
        local district = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z))
        ESX.ShowAdvancedNotification("Centrale", "~b~Appel d'urgence : 911", "Un ~b~civil~s~ a vu quelqu'un tiré !\nLes tirs viennent de : ~b~" .. district, "CHAR_CALL911", 2)
        Notif:ShowMessage("~g~Y~s~ pour accepter l'appel\n~r~A ~s~pour refuser l'appel")

        Citizen.CreateThread(function()
            while true do
                breakThread = nil
                Wait(5)
                time = 6000
                time = time - 5

                if IsControlJustPressed(0, 246) then
                    if blip then
                        RemoveBlip(blip)
                        blip = nil
                    end
                    Notif:ShowMessage("~g~Vous avez pris l'appel")
                    TriggerServerEvent("iCore:tookCall")
                    blip = createBlip(coords, 42, 1, "Alerte LSPD", true, 0.5)
                    while blip do
                        local time = 500
                        local pPed = GetPlayerPed(-1)
                        local pPos = GetEntityCoords(pPed)
                        local dist = Vdist2(pPos, coords)

                        if dist < 150.0 then
                            Notif:ShowMessage("~g~Vous êtes arrivé à destination")
                            RemoveBlip(blip)
                            blip = nil    
                            break
                        end
                        Wait(time)
                    end
                    break
                end

                if IsControlJustPressed(0, 34) then
                    Notif:ShowMessage("~r~Vous avez refusé l'appel")
                    Wait(500)
                    break
                end

                if time <= 0 then
                    breakThread = true
                    break
                end

                if breakThread then
                    break
                end
            end
        end)
    end
end)

RegisterControlKey("delblip", "Annuler un appel (LSPD)", "J", function()
    if blip then
        RemoveBlip(blip)
        Notif:ShowMessage("Vous avez annulé l'appel")
    end
end)

