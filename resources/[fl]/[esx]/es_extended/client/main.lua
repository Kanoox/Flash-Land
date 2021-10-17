local pickups = {}
ESX.IsDead = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if NetworkIsPlayerActive(PlayerId()) then
			TriggerServerEvent('esx:onPlayerJoined')
			break
		end
	end
end)

Citizen.CreateThread(function()
	repeat Citizen.Wait(0) until ESX.PlayerData
	repeat Citizen.Wait(0) until ESX.PlayerData.weight
	while true do
		Citizen.Wait(0)

		if ESX.PlayerData.weight > ESX.PlayerData.maxWeight then
			SetPedMoveRateOverride(PlayerPedId(), 0.5)
			DisableControlAction(0, 22, true)

			if IsControlPressed(0, 21) then
				DisableControlAction(0, 21, true)
				ForcePedMotionState(PlayerPedId(), `motionstate_walk`, 0, 0, 0)
			end
		else
			Citizen.Wait(5000)
		end
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerLoaded = true
	ESX.PlayerData = xPlayer

	if GetEntityModel(PlayerPedId()) == `PLAYER_ZERO` then
		local defaultModel = `a_m_y_stbla_02`
		RequestModel(defaultModel)

		while not HasModelLoaded(defaultModel) do
			Citizen.Wait(10)
		end

		SetPlayerModel(PlayerId(), defaultModel)
		SetPedDefaultComponentVariation(PlayerPedId())
		SetPedRandomComponentVariation(PlayerPedId(), true)
		SetModelAsNoLongerNeeded(defaultModel)
	end

	-- freeze the player
	FreezeEntityPosition(PlayerPedId(), true)

	-- enable PVP
	SetCanAttackFriendly(PlayerPedId(), true, false)
	NetworkSetFriendlyFireOption(true)

	-- disable wanted level
	ClearPlayerWantedLevel(PlayerId())
	SetMaxWantedLevel(0)

	ESX.Game.Teleport(PlayerPedId(), {
		x = xPlayer.coords.x,
		y = xPlayer.coords.y,
		z = xPlayer.coords.z + 0.2,
		heading = xPlayer.coords.heading
	}, function()
		TriggerServerEvent('esx:onPlayerSpawn')
		TriggerEvent('esx:onPlayerSpawn')
		TriggerEvent('esx:restoreLoadout')

		Citizen.Wait(4000)
		ShutdownLoadingScreen()
		ShutdownLoadingScreenNui()
		Citizen.Wait(500)
		FreezeEntityPosition(PlayerPedId(), false)
		DoScreenFadeIn(10000)
		TriggerServerEvent("vMenu:RequestPermissions")

		TriggerEvent('esx:loadingScreenOff')
	end)

end)

RegisterNetEvent('fl_ambulancejob:justRespawned')
AddEventHandler('fl_ambulancejob:justRespawned', function()
	ESX.IsDead = false
end)

RegisterNetEvent('fl_ambulancejob:revive')
AddEventHandler('fl_ambulancejob:revive', function()
	ESX.IsDead = false
end)

RegisterNetEvent('esx:setMaxWeight')
AddEventHandler('esx:setMaxWeight', function(newMaxWeight)
	ESX.PlayerData.maxWeight = newMaxWeight
	TriggerEvent('esx:changedPlayerData', ESX.GetPlayerData())
end)

AddEventHandler('esx:onPlayerSpawn', function() ESX.IsDead = false end)
AddEventHandler('esx:onPlayerDeath', function() ESX.IsDead = true end)

AddEventHandler('skinchanger:modelLoaded', function()
	while not ESX.PlayerLoaded do
		Citizen.Wait(100)
	end

	TriggerEvent('esx:restoreLoadout')
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
	for k,v in ipairs(ESX.PlayerData.accounts) do
		if v.name == account.name then
			ESX.PlayerData.accounts[k] = account
			break
		end
	end
	TriggerEvent('esx:changedPlayerData', ESX.GetPlayerData())
end)

RegisterNetEvent('esx:addInventoryItem')
AddEventHandler('esx:addInventoryItem', function(item, count, silent)
	local found = false
	for k,v in ipairs(ESX.PlayerData.inventory) do
		if v.name == item.name then
			ESX.PlayerData.inventory[k] = item
			found = true
			break
		end
	end

	if not found then
		table.insert(ESX.PlayerData.inventory, item)
	end

	ESX.PlayerData.weight = ESX.PlayerData.weight + (item.weight * count)

	if not silent then
		ESX.UI.ShowInventoryItemNotification(true, item, count)
	end
	TriggerEvent('esx:changedPlayerData', ESX.GetPlayerData())
end)

RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(item, count, silent)
	for k,v in ipairs(ESX.PlayerData.inventory) do
		if v.name == item.name then
			ESX.PlayerData.inventory[k] = item
			if item.count < 0 then
				table.remove(ESX.PlayerData.inventory, k)
			end
			break
		end
	end

	ESX.PlayerData.weight = ESX.PlayerData.weight - (item.weight * count)

	if not silent then
		ESX.UI.ShowInventoryItemNotification(false, item, count)
	end
	TriggerEvent('esx:changedPlayerData', ESX.GetPlayerData())
end)

RegisterNetEvent('esx:onUpdateMaxWeight')
AddEventHandler('esx:onUpdateMaxWeight', function(maxWeight)
	ESX.PlayerData.maxWeight = maxWeight
	TriggerEvent('esx:changedPlayerData', ESX.GetPlayerData())
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
	TriggerEvent('esx:changedPlayerData', ESX.GetPlayerData())
end)

RegisterNetEvent('esx:setFaction')
AddEventHandler('esx:setFaction', function(faction)
	ESX.PlayerData.faction = faction
	TriggerEvent('esx:changedPlayerData', ESX.GetPlayerData())
end)

RegisterNetEvent('esx:teleport')
AddEventHandler('esx:teleport', function(coords)
	local playerPed = PlayerPedId()

	coords.x = coords.x + 0.0
	coords.y = coords.y + 0.0
	coords.z = coords.z + 0.0

	ESX.Game.Teleport(playerPed, coords)
end)

RegisterNetEvent('esx:createPickup')
AddEventHandler('esx:createPickup', function(pickupId, label, coords, type, name, components, tintIndex)
	local function setObjectProperties(object)
		SetEntityAsMissionEntity(object, true, false)
		PlaceObjectOnGroundProperly(object)
		FreezeEntityPosition(object, true)
		SetEntityCollision(object, false, true)

		pickups[pickupId] = {
			obj = object,
			label = label,
			inRange = false,
			coords = vector3(coords.x, coords.y, coords.z)
		}
	end

	ESX.Game.SpawnLocalObject('prop_cs_box_clothes', coords, setObjectProperties)
end)

RegisterNetEvent('esx:createMissingPickups')
AddEventHandler('esx:createMissingPickups', function(missingPickups)
	for pickupId,pickup in pairs(missingPickups) do
		TriggerEvent('esx:createPickup', pickupId, pickup.label, pickup.coords, pickup.type, pickup.name, pickup.components, pickup.tintIndex)
	end
end)

RegisterNetEvent('esx:spawnCar')
AddEventHandler('esx:spawnCar', function(model)
	ESX.Game.SpawnVehicle(model, GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()), function(vehicle)
		TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
	end)
end)

RegisterNetEvent('esx:registerSuggestions')
AddEventHandler('esx:registerSuggestions', function(registeredCommands)
	for name,command in pairs(registeredCommands) do
		if command.suggestion then
			TriggerEvent('chat:addSuggestion', ('/%s'):format(name), command.suggestion.help, command.suggestion.arguments)
		end
	end
end)

RegisterNetEvent('esx:removePickup')
AddEventHandler('esx:removePickup', function(pickupId)
	if pickups[pickupId] and pickups[pickupId].obj then
		ESX.Game.DeleteObject(pickups[pickupId].obj)
		pickups[pickupId] = nil
	end
end)

RegisterNetEvent('esx:deleteVehicle')
AddEventHandler('esx:deleteVehicle', function(radius)
	local playerPed = PlayerPedId()

	if radius and tonumber(radius) then
		radius = tonumber(radius) + 0.01
		local vehicles = ESX.Game.GetVehiclesInArea(GetEntityCoords(playerPed), radius)
		local list = {}
		for k,v in pairs(vehicles) do
			table.insert(list, NetworkGetNetworkIdFromEntity(v))
		end
		TriggerServerEvent("esx:deleteEntityTable", list)
	else
		local radius = 2.0
		local vehicle = ESX.Game.GetVehiclesInArea(GetEntityCoords(playerPed), radius)
		local list = {}
		for k,v in pairs(vehicle) do
			table.insert(list, NetworkGetNetworkIdFromEntity(v))
		end
		TriggerServerEvent("esx:deleteEntityTable", list)
	end
end)

RegisterNetEvent('esx:stuck')
AddEventHandler('esx:stuck', function()
    local pos = GetEntityCoords(PlayerPedId())
    local interiorid = GetInteriorAtCoords(pos.x, pos.y, pos.z)

    if #(GetEntityCoords(PlayerPedId()).xy) < 30 or GetEntityCoords(PlayerPedId()).z < -30 or interiorid ~= 0 then
        ClearPedTasksImmediately(PlayerPedId())
        SetEntityVisible(PlayerPedId(), true, 1)
        FreezeEntityPosition(PlayerPedId(), false)
        SetEntityCoords(PlayerPedId(), 241.23, -807.15, 30.27, false, false, false, true)
        if IsInProperty then
            TriggerServerEvent('fl_property:BeUnstuck')
        end
        TriggerEvent('chatMessage', "", {0,0,0}, "^1^*Vous vous êtes débloqué !")
    else
        TriggerEvent('chatMessage', "", {0,0,0}, "^1^*Vous n'êtes pas bloqué")
    end
end)

RegisterCommand('debugui', function()
	ESX.UI.Menu.CloseAll()
	print('Fermeture de tous les menus')
end, false)

-- Pickups
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local playerCoords, letSleep = GetEntityCoords(playerPed), true
		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer(playerCoords)

		for pickupId,pickup in pairs(pickups) do
			local distance = #(playerCoords - pickup.coords)

			if distance < 5 then
				local label = pickup.label
				letSleep = false

				if distance < 1 then
					if IsControlJustReleased(0, 38) then
						if IsPedOnFoot(playerPed) and (closestDistance == -1 or closestDistance > 3) and not pickup.inRange then
							pickup.inRange = true

							local dict, anim = 'weapons@first_person@aim_rng@generic@projectile@sticky_bomb@', 'plant_floor'
							ESX.Streaming.RequestAnimDict(dict)
							TaskPlayAnim(playerPed, dict, anim, 8.0, 1.0, 1000, 16, 0.0, false, false, false)
							Citizen.Wait(1000)

							TriggerServerEvent('esx:onPickup', pickupId)
							PlaySoundFrontend(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)
						end
					end

					label = ('%s~n~%s'):format(label, _U('threw_pickup_prompt'))
				end

				ESX.Game.Utils.DrawText3D({
					x = pickup.coords.x,
					y = pickup.coords.y,
					z = pickup.coords.z + 0.25
				}, label, 1.2, 4)
			elseif pickup.inRange then
				pickup.inRange = false
			end
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('esx:setHealth')
AddEventHandler('esx:setHealth', function(health)
	SetEntityHealth(PlayerPedId(), health)
end)

RegisterNetEvent('esx:setHealthEntity')
AddEventHandler('esx:setHealthEntity', function(netId, health)
	SetEntityHealth(NetworkGetEntityFromNetworkId(netId), health)
end)

RegisterNetEvent('esx:setVehicleProps')
AddEventHandler('esx:setVehicleProps', function(netId, vehicleProps)
	if NetworkDoesEntityExistWithNetworkId(netId) then
		ESX.Game.SetVehicleProperties(NetworkGetEntityFromNetworkId(netId), vehicleProps)
	end
end)

local freeze = false
RegisterNetEvent('esx:freeze')
AddEventHandler('esx:freeze', function()
	freeze = not freeze
	FreezeEntityPosition(PlayerPedId(), freeze)
end)

RegisterNetEvent('esx:setArmor')
AddEventHandler('esx:setArmor', function(armor)
	SetPedArmour(PlayerPedId(), armor)
end)

RegisterNetEvent('esx:setPlayerModel')
AddEventHandler('esx:setPlayerModel', function(model)
	if type(model) == 'string' then model = GetHashKey(model) end
	ESX.Streaming.RequestModel(model)
	SetPlayerModel(PlayerId(), model)
	--SetModelAsNoLongerNeeded(model)
end)

local lastNotifOverweight = 0
AddEventHandler('esx:changedPlayerData', function(PlayerData)
	if PlayerData.weight > PlayerData.maxWeight then
		if GetGameTimer() - lastNotifOverweight > 15 * 60 * 1000 then
			ESX.ShowNotification('~r~Trop de poids sur vous ... Vous vous déplacerez plus lentement !')
			lastNotifOverweight = GetGameTimer()
		end
	end
end)