local PlayerData, CurrentActionData, handcuffTimer, dragStatus, blipsCops, currentTask, spawnedVehicles = {}, {}, {}, {}, {}, {}, {}
local HasAlreadyEnteredMarker, isDead, IsHandcuffed, hasAlreadyJoined, playerInService, isInShopMenu = false, false, false, false, false, false
local LastStation, LastPart, LastPartNum, LastEntity, CurrentAction, CurrentActionMsg
dragStatus.isDragged = false
local CurrentActionData         = {}
ESX = nil
FarcCar = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end

	while ESX.GetPlayerData().faction == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()

	RMenu.Add('rurufarc', 'garage', RageUI.CreateMenu("Faction", "Actions disponibles", 0, 0, 'commonmenu', 'interaction_bgd', 110, 0, 50, 0))
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setFaction')
AddEventHandler('esx:setFaction', function(faction)
	PlayerData.faction = faction
end)

local ranger_farc = {
    vector3(-1795.6818847656, 457.76226806641, 127.3281817627)
}

local farc_garage = {
    vector3(-1786.6005859375, 454.20819091797, 127.3281817627)
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
		if (PlayerData.faction and PlayerData.faction.name == "farc") then
	for k in pairs(ranger_farc) do
		local ply = GetPlayerPed(-1)
		local plyCoords = GetEntityCoords(ply, false)
		local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, ranger_farc[k].x, ranger_farc[k].y, ranger_farc[k].z)
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
	
				TriggerServerEvent('fl_societyfaction:putVehicleInGarageFaction', 'farc', vehicleProps)
				ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
			end
		end
		if dist <= 25 then
			DrawMarker(27, ranger_farc[k].x, ranger_farc[k].y, ranger_farc[k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 0, 100, false, true, 2, false, false, false, false)
		end
	end
	for k in pairs(farc_garage) do
		local ply = GetPlayerPed(-1)
		local plyCoords = GetEntityCoords(ply, false)
		local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, farc_garage[k].x, farc_garage[k].y, farc_garage[k].z)
		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

		if dist <= 2.5 then
			ESX.ShowHelpNotification("Appuie sur ~INPUT_CONTEXT~ pour intéragir avec le ~BLIP_524~")
		    if IsControlJustReleased(1,51) then
				tenuelspd = false
				ESX.TriggerServerCallback('fl_societyfaction:getVehiclesInGarageFaction', function(garageVehicles)
					FarcCar = garageVehicles
				end, 'farc')
                RageUI.Visible(RMenu.Get('rurufarc', 'garage'), true)
			end
		end
		if dist <= 25 then
			DrawMarker(27, farc_garage[k].x, farc_garage[k].y, farc_garage[k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 100, false, true, 2, false, false, false, false)
		end
	end
        if RageUI.Visible(RMenu.Get('rurufarc', 'garage')) then
			FarcGarage()
		end
end
end
end)



function FarcGarage()
	RageUI.DrawContent({header = true, instructionalButton = true}, function()
		RageUI.Separator("~y~Véhicules dans le garage")
		for i=1, #FarcCar, 1 do
			local vehicleProps = FarcCar[i]
        RageUI.Button(""..GetDisplayNameFromVehicleModel(FarcCar[i].model), nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
			if (Selected) then
				RageUI.CloseAll()
				ESX.Game.SpawnVehicle(vehicleProps.model, vector3(-1790.7183837891, 456.67840576172, 127.3081817627), 84.949, function(vehicle)
					ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
					local playerPed = GetPlayerPed(-1)	
					TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)		
				end)
				TriggerServerEvent('fl_societyfaction:removeVehicleFromGarageFaction', 'farc', vehicleProps)
			end
		end)
	end
	end)
end