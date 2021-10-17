local PlayerData, CurrentActionData, handcuffTimer, dragStatus, blipsCops, currentTask, spawnedVehicles = {}, {}, {}, {}, {}, {}, {}
local HasAlreadyEnteredMarker, isDead, IsHandcuffed, hasAlreadyJoined, playerInService, isInShopMenu = false, false, false, false, false, false
local LastStation, LastPart, LastPartNum, LastEntity, CurrentAction, CurrentActionMsg
dragStatus.isDragged = false
local CurrentActionData         = {}
ESX = nil
VercettiCar = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end

	while ESX.GetPlayerData().faction == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()

	RMenu.Add('ruruvercetti', 'garage', RageUI.CreateMenu("Faction", "Actions disponibles", 0, 0, 'commonmenu', 'interaction_bgd', 110, 0, 50, 0))
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setFaction')
AddEventHandler('esx:setFaction', function(faction)
	PlayerData.faction = faction
end)

local ranger_vercetti = {
    vector3(-2955.5910644531, 56.916439056396, 10.626000994932)
}

local vercetti_garage = {
    vector3(-2948.45703125, 57.9453125, 10.698493804932)
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
		if (PlayerData.faction and PlayerData.faction.name == "vercetti") then
	for k in pairs(ranger_vercetti) do
		local ply = GetPlayerPed(-1)
		local plyCoords = GetEntityCoords(ply, false)
		local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, ranger_vercetti[k].x, ranger_vercetti[k].y, ranger_vercetti[k].z)
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
	
				TriggerServerEvent('fl_societyfaction:putVehicleInGarageFaction', 'vercetti', vehicleProps)
				ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
			end
		end
		if dist <= 25 then
			DrawMarker(27, ranger_vercetti[k].x, ranger_vercetti[k].y, ranger_vercetti[k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 0, 100, false, true, 2, false, false, false, false)
		end
	end
	for k in pairs(vercetti_garage) do
		local ply = GetPlayerPed(-1)
		local plyCoords = GetEntityCoords(ply, false)
		local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, vercetti_garage[k].x, vercetti_garage[k].y, vercetti_garage[k].z)
		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

		if dist <= 2.5 then
			ESX.ShowHelpNotification("Appuie sur ~INPUT_CONTEXT~ pour intéragir avec le ~BLIP_524~")
		    if IsControlJustReleased(1,51) then
				tenuelspd = false
				ESX.TriggerServerCallback('fl_societyfaction:getVehiclesInGarageFaction', function(garageVehicles)
					VercettiCar = garageVehicles
				end, 'vercetti')
                RageUI.Visible(RMenu.Get('ruruvercetti', 'garage'), true)
			end
		end
		if dist <= 25 then
			DrawMarker(27, vercetti_garage[k].x, vercetti_garage[k].y, vercetti_garage[k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 100, false, true, 2, false, false, false, false)
		end
	end
        if RageUI.Visible(RMenu.Get('ruruvercetti', 'garage')) then
			VercettiGarage()
		end
end
end
end)



function VercettiGarage()
	RageUI.DrawContent({header = true, instructionalButton = true}, function()
		RageUI.Separator("~y~Véhicules dans le garage")
		for i=1, #VercettiCar, 1 do
			local vehicleProps = VercettiCar[i]
        RageUI.Button(""..GetDisplayNameFromVehicleModel(VercettiCar[i].model), nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
			if (Selected) then
				RageUI.CloseAll()
				ESX.Game.SpawnVehicle(vehicleProps.model, vector3(-2955.5910644531, 56.916439056396, 10.608493804932), 62.425, function(vehicle)
					ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
					local playerPed = GetPlayerPed(-1)	
					TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)		
				end)
				TriggerServerEvent('fl_societyfaction:removeVehicleFromGarageFaction', 'vercetti', vehicleProps)
			end
		end)
	end
	end)
end