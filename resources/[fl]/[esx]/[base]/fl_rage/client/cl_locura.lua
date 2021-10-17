local PlayerData, CurrentActionData, handcuffTimer, dragStatus, blipsCops, currentTask, spawnedVehicles = {}, {}, {}, {}, {}, {}, {}
local HasAlreadyEnteredMarker, isDead, IsHandcuffed, hasAlreadyJoined, playerInService, isInShopMenu = false, false, false, false, false, false
local LastStation, LastPart, LastPartNum, LastEntity, CurrentAction, CurrentActionMsg
dragStatus.isDragged = false
local CurrentActionData         = {}
ESX = nil
LocuraCar = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end

	while ESX.GetPlayerData().faction == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()

	RMenu.Add('rurulocura', 'garage', RageUI.CreateMenu("Faction", "Actions disponibles", 0, 0, 'commonmenu', 'interaction_bgd', 110, 0, 50, 0))
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setFaction')
AddEventHandler('esx:setFaction', function(faction)
	PlayerData.faction = faction
end)

local ranger_locura = {
    vector3(472.4616394043, -1574.6990966797, 28.142995376587)
}

local locura_garage = {
    vector3(463.54965209961, -1576.3489990234, 28.290935287476)
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
		if (PlayerData.faction and PlayerData.faction.name == "locura") then
	for k in pairs(ranger_locura) do
		local ply = GetPlayerPed(-1)
		local plyCoords = GetEntityCoords(ply, false)
		local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, ranger_locura[k].x, ranger_locura[k].y, ranger_locura[k].z)
		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

		if dist <= 1.5 then
			ESX.ShowHelpNotification("Appuie sur ~INPUT_CONTEXT~ pour ranger le véhicule")
		    if IsControlJustReleased(1,51) then
				local playerPed = GetPlayerPed(-1)
				local coords    = GetEntityCoords(playerPed)
				if IsPedInAnyVehicle(playerPed,  true) then	
				  local vehicle = GetVehiclePedIsIn(playerPed, false)
				  if DoesEntityExist(vehicle) then
			
					CurrentActionData = {vehicle = vehicle}
			
				  end
				end
				local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
	
				TriggerServerEvent('fl_societyfaction:putVehicleInGarageFaction', 'locura', vehicleProps)
				ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
			end
		end
		if dist <= 25 then
			DrawMarker(27, ranger_locura[k].x, ranger_locura[k].y, ranger_locura[k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 0, 100, false, true, 2, false, false, false, false)
		end
	end
	for k in pairs(locura_garage) do
		local ply = GetPlayerPed(-1)
		local plyCoords = GetEntityCoords(ply, false)
		local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, locura_garage[k].x, locura_garage[k].y, locura_garage[k].z)
		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

		if dist <= 2.5 then
			ESX.ShowHelpNotification("Appuie sur ~INPUT_CONTEXT~ pour intéragir avec le ~BLIP_524~")
		    if IsControlJustReleased(1,51) then
				tenuelspd = false
				ESX.TriggerServerCallback('fl_societyfaction:getVehiclesInGarageFaction', function(garageVehicles)
					LocuraCar = garageVehicles
				end, 'locura')
                RageUI.Visible(RMenu.Get('rurulocura', 'garage'), true)
			end
		end
		if dist <= 25 then
			DrawMarker(27, locura_garage[k].x, locura_garage[k].y, locura_garage[k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 100, false, true, 2, false, false, false, false)
		end
	end
        if RageUI.Visible(RMenu.Get('rurulocura', 'garage')) then
			LocuraGarage()
		end
end
end
end)



function LocuraGarage()
	RageUI.DrawContent({header = true, instructionalButton = true}, function()
		RageUI.Separator("~y~Véhicules dans le garage")
		for i=1, #LocuraCar, 1 do
			local vehicleProps = LocuraCar[i]
        RageUI.Button(""..GetDisplayNameFromVehicleModel(LocuraCar[i].model), nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
			if (Selected) then
				RageUI.CloseAll()
				ESX.Game.SpawnVehicle(vehicleProps.model, vector3(468.00302124023, -1580.0089111328, 28.122877120972), 226.793, function(vehicle)
					ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
					local playerPed = GetPlayerPed(-1)	
					TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)		
				end)
				TriggerServerEvent('fl_societyfaction:removeVehicleFromGarageFaction', 'locura', vehicleProps)
			end
		end)
		
	end
	end)
end