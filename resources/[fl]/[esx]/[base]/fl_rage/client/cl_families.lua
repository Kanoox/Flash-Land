local PlayerData, CurrentActionData, handcuffTimer, dragStatus, blipsCops, currentTask, spawnedVehicles = {}, {}, {}, {}, {}, {}, {}
local HasAlreadyEnteredMarker, isDead, IsHandcuffed, hasAlreadyJoined, playerInService, isInShopMenu = false, false, false, false, false, false
local LastStation, LastPart, LastPartNum, LastEntity, CurrentAction, CurrentActionMsg
dragStatus.isDragged = false
local CurrentActionData         = {}
ESX = nil
FamiliesCar = {}
RubenInventoryFamilies = {}
RubenItemsFamilies = {}
RubenPrendreArmesFamilies = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end

	while ESX.GetPlayerData().faction == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()

	RMenu.Add('rurufamilies', 'garage', RageUI.CreateMenu("Faction", "Actions disponibles", 0, 0, 'commonmenu', 'interaction_bgd', 110, 0, 50, 0))
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setFaction')
AddEventHandler('esx:setFaction', function(faction)
	PlayerData.faction = faction
end)

local ranger_families = {
    vector3(-127.18942260742, -1624.9816894531, 31.189960479736)
}

local families_garage = {
    vector3(-131.73838806152, -1618.9415283203, 31.63308883667)
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
		if (PlayerData.faction and PlayerData.faction.name == "families") then
	for k in pairs(ranger_families) do
		local ply = GetPlayerPed(-1)
		local plyCoords = GetEntityCoords(ply, false)
		local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, ranger_families[k].x, ranger_families[k].y, ranger_families[k].z)
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
	
				TriggerServerEvent('fl_societyfaction:putVehicleInGarageFaction', 'families', vehicleProps)
				ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
			end
		end
		if dist <= 25 then
			DrawMarker(27, ranger_families[k].x, ranger_families[k].y, ranger_families[k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 0, 100, false, true, 2, false, false, false, false)
		end
	end
	for k in pairs(families_garage) do
		local ply = GetPlayerPed(-1)
		local plyCoords = GetEntityCoords(ply, false)
		local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, families_garage[k].x, families_garage[k].y, families_garage[k].z)
		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

		if dist <= 2.5 then
			ESX.ShowHelpNotification("Appuie sur ~INPUT_CONTEXT~ pour intéragir avec le ~BLIP_524~")
		    if IsControlJustReleased(1,51) then
				tenuelspd = false
				ESX.TriggerServerCallback('fl_societyfaction:getVehiclesInGarageFaction', function(garageVehicles)
					FamiliesCar = garageVehicles
				end, 'families')
                RageUI.Visible(RMenu.Get('rurufamilies', 'garage'), true)
			end
		end
		if dist <= 25 then
			DrawMarker(27, families_garage[k].x, families_garage[k].y, families_garage[k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 100, false, true, 2, false, false, false, false)
		end
	end
        if RageUI.Visible(RMenu.Get('rurufamilies', 'garage')) then
			FamiliesGarage()
		end
end
end
end)



function FamiliesGarage()
	RageUI.DrawContent({header = true, instructionalButton = true}, function()
		RageUI.Separator("~y~Véhicules dans le garage")
		for i=1, #FamiliesCar, 1 do
			local vehicleProps = FamiliesCar[i]
        RageUI.Button(""..GetDisplayNameFromVehicleModel(FamiliesCar[i].model), nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
			if (Selected) then
				RageUI.CloseAll()
				ESX.Game.SpawnVehicle(vehicleProps.model, vector3(-128.146, -1621.359, 31.046), 138.667, function(vehicle)
					ESX.Game.SetVehicleProperties(vehicle, vehicleProps)	
					local playerPed = GetPlayerPed(-1)	
					TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)		
				end)
				TriggerServerEvent('fl_societyfaction:removeVehicleFromGarageFaction', 'families', vehicleProps)
			end
		end)
	end
	end)
end