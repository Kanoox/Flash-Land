
Citizen.CreateThread(function()
    Citizen.Wait(1000)
    for ChouffId, Chouff in pairs(Config.Chouff) do
        Chouff.canAttack = true
        Chouff.hasNotified = false
        Chouff.faction = nil
        Chouff.timeout = nil
        Chouff.ped = CreatePed(26, Chouff.model, Chouff.coords.x, Chouff.coords.y, Chouff.coords.z, Chouff.heading)
        SetPedRandomComponentVariation(Chouff.ped)
        SetPedRandomProps(Chouff.ped)
        FreezeEntityPosition(Chouff.ped, true)
        GiveWeaponToPed(Chouff.ped, `WEAPON_PISTOL`, 255, false, true)
        SetCurrentPedWeapon(Chouff.ped, `WEAPON_PISTOL`, true)
    end

    while true do
        for ChouffId, Chouff in pairs(Config.Chouff) do
            if DoesEntityExist(Chouff.ped) and Chouff.faction ~= nil then
                if GetEntityHealth(Chouff.ped) <= 0 then
                    DeleteEntity(Chouff.ped)
                    Chouff.ped = CreatePed(26, Chouff.model, Chouff.coords.x, Chouff.coords.y, Chouff.coords.z, Chouff.heading)
                    FreezeEntityPosition(Chouff.ped, true)
                    GiveWeaponToPed(Chouff.ped, `WEAPON_PISTOL`, 255, false, true)
                    SetCurrentPedWeapon(Chouff.ped, `WEAPON_PISTOL`, true)
                elseif not Chouff.hasNotified then
                    for _, source in pairs(GetPlayers()) do
                        local ped = GetPlayerPed(source)
                        if #(GetEntityCoords(ped) - Chouff.coords) <= 10 then
                            local xPlayer = ESX.GetPlayerFromId(source)
                            if not Chouff.hasNotified and Chouff.faction ~= nil and Chouff.faction ~= xPlayer.faction.name then
                                if Chouff.canAttack then
                                    GiveWeaponToPed(Chouff.ped, `WEAPON_PISTOL`, 255, false, true)
                                    SetCurrentPedWeapon(Chouff.ped, `WEAPON_PISTOL`, true)
                                    FreezeEntityPosition(Chouff.ped, false)
                                    TaskCombatPed(Chouff.ped, ped, 0, 16)
                                end
                                Chouff.hasNotified = true
                                SendMessageToFaction(Chouff.faction, '~r~Quelqu\'un est entré dans votre labo !')
                                if Chouff.timeout then
                                    ESX.ClearTimeout(Chouff.timeout)
                                end
                                Chouff.timeout = ESX.SetTimeout(60 * 1000, function()
                                    Chouff.hasNotified = false
                                    Chouff.timeout = nil
                                end)
                            end
                        end
                    end
                else
                    local stillPlayers = false
                    for _, source in pairs(GetPlayers()) do
                        local ped = GetPlayerPed(source)
                        if #(GetEntityCoords(ped) - Chouff.coords) <= 10 then
                            local xPlayer = ESX.GetPlayerFromId(source)
                            if Chouff.faction ~= nil and Chouff.faction ~= xPlayer.faction.name then
                                stillPlayers = true
                                if Chouff.canAttack then
                                    GiveWeaponToPed(Chouff.ped, `WEAPON_PISTOL`, 255, false, true)
                                    SetCurrentPedWeapon(Chouff.ped, `WEAPON_PISTOL`, true)
                                    TaskCombatPed(Chouff.ped, ped, 0, 16)
                                end
                            end
                        end
                    end

                    if not stillPlayers then
                        SendMessageToFaction(Chouff.faction, '~o~Ils sont sorti !')
                        ESX.ClearTimeout(Chouff.timeout)
                        Chouff.hasNotified = false
                        Chouff.timeout = nil
                        FreezeEntityPosition(Chouff.ped, true)
                        SetEntityCoords(Chouff.ped, Chouff.coords.x, Chouff.coords.y, Chouff.coords.z - 1)
                        SetEntityHeading(Chouff.ped, Chouff.heading)
                    end
                end
            end
            Citizen.Wait(100)
        end
        Citizen.Wait(10000)
    end
end)

RegisterNetEvent('fl_drugsPNJ:payChouff')
AddEventHandler('fl_drugsPNJ:payChouff', function(ChouffId)
    if ChouffId == nil or Config.Chouff[ChouffId] == nil then return end
    local xPlayer = ESX.GetPlayerFromId(source)
    local Chouff = Config.Chouff[ChouffId]

    if Chouff.faction ~= nil then
        xPlayer.showNotification('~r~Quelqu\'un m\'a déjà engager, casse toi !')
        return
    end

    if xPlayer.getMoney() < Chouff.price then
        xPlayer.showNotification('~r~T\'a pas assez de fric, reviens plus tard !')
        return
    end

    local price = Chouff.canAttack and Chouff.price or Chouff.price / 2
    xPlayer.removeMoney(price)
    Chouff.faction = xPlayer.faction.name
    xPlayer.showNotification('Vous avez engagé ' .. Chouff.name .. ' pour $' .. price .. ' pendant ' .. ESX.Math.Round(Config.ChouffTime / 60000) .. 'min')
    SendMessageToFaction(Chouff.faction, '~g~Un Chouf a été engagé par un membre de votre faction')

    SetTimeout(Config.ChouffTime, function()
        Chouff.faction = nil
        SendMessageToFaction(Chouff.faction, '~r~Le chouf ne vous préviendra plus...')
    end)
end)

RegisterNetEvent('fl_drugsPNJ:toggleAttack')
AddEventHandler('fl_drugsPNJ:toggleAttack', function(ChouffId)
    if ChouffId == nil or Config.Chouff[ChouffId] == nil then return end
    local xPlayer = ESX.GetPlayerFromId(source)
    local Chouff = Config.Chouff[ChouffId]

    Chouff.canAttack = not Chouff.canAttack
end)

function SendMessageToFaction(factionName, msg)
    for _,xPlayer in pairs(ESX.GetAllPlayers()) do
        if factionName == xPlayer.faction.name then
            xPlayer.showNotification(msg)
        end
    end
end

ESX.RegisterServerCallback('fl_drugsPNJ:getChouffData', function(xPlayer, source, cb, ChouffId)
    if ChouffId == nil or Config.Chouff[ChouffId] == nil then error('???') end
    local Chouff = Config.Chouff[ChouffId]
    cb({
        faction = Chouff.faction,
        canAttack = Chouff.canAttack,
        hasNotified = Chouff.canAttack,
    })
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end

    for ChouffId, Chouff in pairs(Config.Chouff) do
        if DoesEntityExist(Chouff.ped) then
            DeleteEntity(Chouff.ped)
        end
    end
end)