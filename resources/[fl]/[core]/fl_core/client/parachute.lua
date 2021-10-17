local HasAlreadyEnteredMarker = false
local LastZone = nil
local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}
local ZoneId = ''
local MenuActions = {}

local RentedBike = false
local Parachute = false

Citizen.CreateThread(function()
    Citizen.Wait(5000)
    ESX.TriggerServerCallback('nwx:bikerental', function(status)
        RentedBike = status
        TriggerEvent('esx:removeWeapon', 'GADGET_PARACHUTE')
    end, "check")
end)

AddEventHandler('nwx:hasEnteredMarker', function(zone)
    CurrentAction = MenuActions.MenuTrigger
    CurrentActionMsg = MenuActions.MenuMessage
    CurrentActionData = {zone = zone}
end)

AddEventHandler('nwx:hasExitedMarker', function(zone)
    CurrentAction = nil
    ESX.UI.Menu.CloseAll()
end)

Citizen.CreateThread(function()
    for k, v in pairs(Config.Zones) do
        if v.EnableBlips then
            for i = 1, #v.Pos, 1 do
                local blip = AddBlipForCoord(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
                SetBlipSprite(blip, v.BlipSprite)
                SetBlipDisplay(blip, 4)
                SetBlipScale(blip, v.BlipScale)
                SetBlipColour(blip, v.BlipColor)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(v.Name)
                EndTextCommandSetBlipName(blip)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local canSleep = true

        for k, v in pairs(Config.Zones) do
            for i = 1, #v.Pos, 1 do
                if (v.Enable and #(coords - vector3(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)) < v.DrawDistance) then
                    if k == "BikeRental" and RentedBike then
                        DrawMarker(v.MarkerType, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.ZoneSize.x, v.ZoneSize.y, v.ZoneSize.z, v.RentetMarkerColor.r, v.RentetMarkerColor.g, v.RentetMarkerColor.b, 100, false, true, 2, false, false, false, false)
                    else
                        DrawMarker(v.MarkerType, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.ZoneSize.x, v.ZoneSize.y, v.ZoneSize.z, v.MarkerColor.r, v.MarkerColor.g, v.MarkerColor.b, 100, false, true, 2, false, false, false, false)
                    end
                    canSleep = false
                end
            end
        end

        if canSleep then
            Citizen.Wait(500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local isInMarker = false
        local currentZone = nil

        for k, v in pairs(Config.Zones) do
            for i = 1, #v.Pos, 1 do
                if (v.Enable and #(coords - vector3(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)) < 1.5) then
                    isInMarker = true
                    ShopItems = v.Items
                    MenuActions = v.MenuActions
                    currentZone = k
                    LastZone = k
                    ZoneId = i
                end
            end
        end
        if isInMarker and not HasAlreadyEnteredMarker then
            HasAlreadyEnteredMarker = true
            TriggerEvent('nwx:hasEnteredMarker', currentZone)
        end
        if not isInMarker and HasAlreadyEnteredMarker then
            HasAlreadyEnteredMarker = false
            TriggerEvent('nwx:hasExitedMarker', LastZone)
        end

        if not HasAlreadyEnteredMarker then
            Citizen.Wait(500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if CurrentAction ~= nil then
            local ped = PlayerPedId()

            if CurrentActionData.zone == "BikeRental" and IsPedOnAnyBike(ped) and RentedBike then
                ESX.ShowHelpNotification(_U('return_bike'))
            else
                ESX.ShowHelpNotification(CurrentActionMsg)
            end

            if IsControlJustReleased(0, 38) then
                if CurrentActionData.zone == "Basejumping" then
                    OpenMenu(CurrentActionData.zone)
                elseif CurrentActionData.zone == "BikeRental" then
                    if IsPedOnAnyBike(ped) and RentedBike then
                        ESX.TriggerServerCallback('nwx:bikerental', function(status)
                            transition(0)
                            ESX.Game.DeleteVehicle(GetVehiclePedIsIn(ped, false))
                            RentedBike = status
                        end, false)
                    else
                        OpenMenu(CurrentActionData.zone)
                    end
                end
                CurrentAction = nil
            end

        else
            Citizen.Wait(500)
        end
    end
end)

function OpenMenu(zone)
    if zone == "Basejumping" then
        ESX.ShowNotification(_U('caution'))
    end
    local elements = {}

    for i = 1, #Config.Zones[zone].Items, 1 do
        local item = Config.Zones[zone].Items[i]
        if Config.Zones[zone].Free then
            table.insert(elements, {
                label = item.label,
                item = item.item,
                action = Config.Zones[zone].MenuActions.MenuTrigger,
                itemId = i,
                itemType = Config.Zones[zone].ItemType,
            })
        else
            if zone == "BikeRental" and RentedBike then
                table.insert(elements, {
                    label = item.label,
                    rightLabel = _U('item_price', Config.CurrencyPrefix, ESX.Math.GroupDigits(item.price * Config.Zones[zone].Multiplier), Config.CurrencySuffix),
                    item = item.item,
                    action = Config.Zones[zone].MenuActions.MenuTrigger,
                    itemId = i,
                    itemType = Config.Zones[zone].ItemType,
                })
            else
                table.insert(elements, {
                    label = item.label,
                    item = item.item,
                    rightLabel = _U('item_price', Config.CurrencyPrefix, ESX.Math.GroupDigits(item.price), Config.CurrencySuffix),
                    action = Config.Zones[zone].MenuActions.MenuTrigger,
                    itemId = i,
                    itemType = Config.Zones[zone].ItemType,
                })
            end
        end
    end

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'multimenu', {
        title = Config.Zones[zone].MenuTitle,
        elements = elements
    }, function(data, menu)
    if data.current.action == 'bikerental_menu' then

        ESX.TriggerServerCallback('nwx:payment', function(payed)
            if payed then

                menu.close()

                local ped = PlayerPedId()
                local coords = GetEntityCoords(ped)
                local heading = GetEntityHeading(ped)

                transition(0)

                ESX.Game.SpawnVehicle(data.current.item, coords, heading, function(vehicle)
                    TaskWarpPedIntoVehicle(ped, vehicle, -1)
                end)

                ESX.ShowNotification(_U('enjoy'))

                ESX.TriggerServerCallback('nwx:bikerental', function(status)
                    RentedBike = status
                end, true)

            else

                ESX.ShowNotification(_U('not_enough_money'))
                menu.close()

            end
        end, zone, data.current.itemId, data.current.itemType)

    elseif data.current.action == 'basejumping_menu' then

        ESX.TriggerServerCallback('nwx:payment', function(payed)
            if payed then

                menu.close()

                local ped = PlayerPedId()

                ESX.Game.Teleport(ped, vector3(Config.Zones[zone].TelePos[ZoneId].x, Config.Zones[zone].TelePos[ZoneId].y, Config.Zones[zone].TelePos[ZoneId].z), function()
                    Parachute = true
                    SetEntityHeading(ped, Config.Zones[zone].TelePos[ZoneId].h)
                    ForcePedToOpenParachute(ped)
                    ParachuteRelease()
                end)

                ESX.ShowNotification(_U('enjoy'))

            else

                ESX.ShowNotification(_U('not_enough_money'))
                menu.close()

            end
        end, zone, data.current.itemId, data.current.itemType)

    else
        menu.close()
    end
end, function(data, menu)

menu.close()

CurrentAction = MenuActions.MenuTrigger
CurrentActionMsg = MenuActions.MenuMessage
CurrentActionData = {zone = zone}

end, function(data, menu)
end)
end

function ParachuteRelease()
    Citizen.CreateThread(function()
        while Parachute do
         Citizen.Wait(0)
         local ped = PlayerPedId()
         if IsPedInParachuteFreeFall(ped) then
            ForcePedToOpenParachute(ped)
            Parachute = false
            Citizen.Wait(900)
        end
    end
end)
end

function transition(timer)
    DoScreenFadeOut(1000)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    Citizen.Wait(timer)
    DoScreenFadeIn(3000)
end