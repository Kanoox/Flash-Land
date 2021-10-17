local PlayerData, CurrentActionData, handcuffTimer, dragStatus, blipsCops, currentTask, spawnedVehicles = {}, {}, {}, {}, {}, {}, {}
local HasAlreadyEnteredMarker, isDead, IsHandcuffed, hasAlreadyJoined, playerInService, isInShopMenu = false, false, false, false, false, false
local LastStation, LastPart, LastPartNum, LastEntity, CurrentAction, CurrentActionMsg
dragStatus.isDragged = false
local CurrentActionData         = {}
ESX = nil
VagosCar = {}
RubenInventoryVagos = {}
RubenItemsVagos = {}
RubenPrendreArmesVagos = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end

	while ESX.GetPlayerData().faction == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
	RMenu.Add('ruruvagos', 'garage', RageUI.CreateMenu("Faction", "Actions disponibles", 0, 0, 'commonmenu', 'interaction_bgd', 110, 0, 50, 0))
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setFaction')
AddEventHandler('esx:setFaction', function(faction)
	PlayerData.faction = faction
end)

local ranger_vagos = {
    vector3(321.19744873047, -2033.77734375, 19.699999950562)
}

local vagos_garage = {
    vector3(317.22769165039, -2042.8879394531, 19.955413360596)
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
		if (PlayerData.faction and PlayerData.faction.name == "vagos") then
	for k in pairs(ranger_vagos) do
		local ply = GetPlayerPed(-1)
		local plyCoords = GetEntityCoords(ply, false)
		local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, ranger_vagos[k].x, ranger_vagos[k].y, ranger_vagos[k].z)
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
	
				TriggerServerEvent('fl_societyfaction:putVehicleInGarageFaction', 'vagos', vehicleProps)
				ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
			end
		end
		if dist <= 25 then
			DrawMarker(27, ranger_vagos[k].x, ranger_vagos[k].y, ranger_vagos[k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 0, 100, false, true, 2, false, false, false, false)
		end
	end
	for k in pairs(vagos_garage) do
		local ply = GetPlayerPed(-1)
		local plyCoords = GetEntityCoords(ply, false)
		local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, vagos_garage[k].x, vagos_garage[k].y, vagos_garage[k].z)
		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

		if dist <= 2.5 then
			ESX.ShowHelpNotification("Appuie sur ~INPUT_CONTEXT~ pour intéragir avec le ~BLIP_524~")
		    if IsControlJustReleased(1,51) then
				tenuelspd = false
				ESX.TriggerServerCallback('fl_societyfaction:getVehiclesInGarageFaction', function(garageVehicles)
					VagosCar = garageVehicles
				end, 'vagos')
                RageUI.Visible(RMenu.Get('ruruvagos', 'garage'), true)
			end
		end
		if dist <= 25 then
			DrawMarker(27, vagos_garage[k].x, vagos_garage[k].y, vagos_garage[k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 100, false, true, 2, false, false, false, false)
		end
	end
        if RageUI.Visible(RMenu.Get('ruruvagos', 'garage')) then
			VagosGarage()
		end
end
end
end)

function VagosGarage()
	RageUI.DrawContent({header = true, instructionalButton = true}, function()
		RageUI.Separator("~y~Véhicules dans le garage")
		for i=1, #VagosCar, 1 do
			local vehicleProps = VagosCar[i]
        RageUI.Button(""..GetDisplayNameFromVehicleModel(VagosCar[i].model), nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
			if (Selected) then
				RageUI.CloseAll()
				ESX.Game.SpawnVehicle(vehicleProps.model, vector3(323.729, -2032.145, 19.803), 51.005, function(vehicle)
					ESX.Game.SetVehicleProperties(vehicle, vehicleProps)	
					local playerPed = GetPlayerPed(-1)	
					TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)		
				end)
				TriggerServerEvent('fl_societyfaction:removeVehicleFromGarageFaction', 'vagos', vehicleProps)
			end
		end)
	end
	end)
end