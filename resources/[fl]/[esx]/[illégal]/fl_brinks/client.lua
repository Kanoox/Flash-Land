ESX =  nil
local robbing = false

Citizen.CreateThread(function()
    while ESX == nil do
	  TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	  Citizen.Wait(100)
    end
    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent("fizzfau-banktruck:onUse")
AddEventHandler("fizzfau-banktruck:onUse", function()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local closestVeh = ESX.Game.GetClosestVehicle(coords, false)
    local veh_coords = GetOffsetFromEntityInWorldCoords(closestVeh, 0.0, -4.25, 0.0)
    local distance = #(playerCoords - veh_coords)
    local model = GetEntityModel(closestVeh)
    if distance <= 5 then
        if model == `stockade` then
            local plate = GetVehicleNumberPlateText(closestVeh)
            TriggerServerEvent("fizzfau-moneytruck:checkRob", plate, closestVeh)
        end
    end
end)

RegisterNetEvent("fizzfau-moneytruck:startRob")
AddEventHandler("fizzfau-moneytruck:startRob", function(vehicle)
    robbing = true
    RequestAnimDict("mini@repair")
    while not HasAnimDictLoaded("mini@repair") do
        Citizen.Wait(100)
    end
    local dict = 'anim@amb@prop_human_atm@interior@male@enter'
    local anim = 'enter'
    local ped = PlayerPedId()
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(7)
    end
    local coords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, -4.25, 0.0)
    SetPlayerCoord(ped, coords, vehicle)
    TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 0, 0, 0, 0, 0)
    local cancelled = exports["hsn-bar"]:taskBar(3000, "Kart Okutuluyor")
    Dispatch(coords)
    ClearPedTasks(ped)
    CreateGuards(vehicle, ped)
end)

RegisterNetEvent("fizzfau-moneytruck:endRobbery")
AddEventHandler("fizzfau-moneytruck:endRobbery", function()
    robbing = false
    ClearPedTasksImmediately(PlayerPedId())
end)

RegisterNetEvent("fizzfau-moneytruck:anim")
AddEventHandler("fizzfau-moneytruck:anim", function()
    local ped = PlayerPedId()
    Citizen.CreateThread(function()
        while robbing == true do
            if not IsEntityPlayingAnim(ped, "mini@repair", "fixing_a_player", 3) then
                ClearPedSecondaryTask(ped)
                TaskPlayAnim(ped, "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
            end
            Citizen.Wait(25)
        end
    end)
    exports["hsn-bar"]:taskBar(30000, "Toplanıyor")
end)

function Dispatch(coords)
    local street1 = GetStreetNameAtCoord(coords.x, coords.y, coords.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
    local streetName = (GetStreetNameFromHashKey(street1))
    local playerGender = "Kadın"
    if ESX.PlayerData.charinfo.gender =="man" then
        playerGender = "Erkek"
    end
    print(playerGender, streetName)
    TriggerServerEvent('esx_outlawalert:banka-arac', {
        x = ESX.Math.Round(coords.x, 1),
        y = ESX.Math.Round(coords.y, 1),
        z = ESX.Math.Round(coords.z, 1)
      }, streetName, playerGender)
end

function CreateGuards(vehicle, ped)
    local peds = {}
    local hashKey = `ig_casey`
    RequestModel(hashKey)
    while not HasModelLoaded(hashKey) do
        RequestModel(hashKey)
        Citizen.Wait(250)
    end
    for i =1, 3 do
        peds[i] = CreatePedInsideVehicle(vehicle, 0xF50B51B7, hashKey, i - 1 , 1, 1)
        SetPedShootRate(peds[i],  750)
        GiveWeaponToPed(peds[i], `WEAPON_SMG`, 150, true, true)
        SetPedCombatAttributes(peds[i], 46, true)
        SetPedFleeAttributes(peds[i], 0, 0)
        SetPedAsEnemy(peds[i],true)
        SetPedMaxHealth(peds[i], 900)
        SetPedAlertness(peds[i], 3)
        SetPedCombatRange(peds[i], 0)
        SetPedCombatMovement(peds[i], 3)
        -- TaskCombatPed(peds[i], ped, 0, 16)
        TaskLeaveVehicle(peds[i], vehicle, 0)
        SetPedRelationshipGroupHash(peds[i], `HATES_PLAYER`)
    end
    Citizen.Wait(1000)
    SetVehicleDoorOpen(vehicle,2,0,0)
    SetVehicleDoorOpen(vehicle,3,0,0)
    DrawRob(vehicle)
end

function DrawRob(vehicle)
    local ped = PlayerPedId()
    Citizen.CreateThread(function()
        while true do
            local wait = 750
            if DoesEntityExist(vehicle) then
                local health = GetEntityHealth(vehicle)
                if health > 10 then
                    wait = 100
                    local coords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, -4.25, 0.0)
                    local pcoords = GetEntityCoords(ped)
                    local distance = #(pcoords - coords)
                    if distance <= 3.5 then
                        wait = 0
                        DrawText3Ds(coords.x, coords.y, coords.z, "E - Topla")
                        if IsControlJustPressed(0, 46) then
                            SetPlayerCoord(ped, coords, vehicle)
                            TriggerServerEvent("fizzfau-moneytruck:server:startRob")
                            TriggerEvent("fizzfau-moneytruck:anim")
                            return
                        end
                    end
                end
            end
            Citizen.Wait(wait)
        end
    end)
end

function DrawText3Ds(x,y,z,text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

function SetPlayerCoord(ped, coords, vehicle)
    SetEntityCoords(ped, coords.x, coords.y, coords.z)
    SetEntityHeading(ped, GetEntityHeading(vehicle))
end

RegisterNetEvent("esx:onPlayerDeath")
AddEventHandler('esx:onPlayerDeath', function()
    robbing = false
    exports["hsn-bar"]:closeGui()
    TriggerServerEvent("fizzfau-moneytruck:onPlayerDeath")
end)

RegisterNetEvent("esx:onPlayerSpawn")
AddEventHandler('esx:onPlayerSpawn', function()
    TriggerServerEvent("fizzfau-moneytruck:playerSpawned")
end)
