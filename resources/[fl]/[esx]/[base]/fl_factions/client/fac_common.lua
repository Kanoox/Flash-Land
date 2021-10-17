local CurrentFaction = nil
local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}
local HasAlreadyEnteredMarker = false
local LastStation = nil
local LastPart = nil
local LastPartNum = nil


function SetVehicleMaxMods(vehicle)
	local props = {
		modEngine = 2,
		modBrakes = 2,
		modTransmission = 2,
		modSuspension = 3,
		modTurbo = true,
	}

	ESX.Game.SetVehicleProperties(vehicle, props)
end

function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

function OpenActionsMenu()
	local elements = {
		{label = 'Déposer Stock', value = 'put_stock'},
		{label = 'Prendre Stock', value = 'get_stock'}
	}
	if ESX.PlayerData.faction ~= nil and ESX.PlayerData.faction.grade_name == 'boss' then
		table.insert(elements, {type = 'separator'})
		table.insert(elements, {label = 'Actions Boss', value = 'faction_actions'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'faction_actions', {
			title = 'Faction',
			description = 'Actions',
			elements = elements
		}, function(data, menu)
			if data.current.value == 'put_stock' then
				OpenPutStocksMenu()
			elseif data.current.value == 'get_stock' then
				OpenGetStocksMenu()
			elseif data.current.value == 'faction_actions' then
				TriggerEvent('fl_societyfaction:openBossMenuFaction', ESX.PlayerData.faction.name, function(data, menu)
					menu.close()
				end)
			else
				error('Unknown value')
			end

		end,
		function(data, menu)
			menu.close()
			CurrentAction = 'faction_actions_menu'
			CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu.'
			CurrentActionData = {}
		end
	)
end

-- Stock Items
function OpenGetStocksMenu()
	ESX.TriggerServerCallback('fl_factions:getStockInventory', function(items)
		local elements = {}

		for i=1, #items, 1 do
			if items[i].count > 0 then
				table.insert(elements, {
					label = 'x' .. items[i].count .. ' ' .. items[i].label,
					value = items[i].name
				})
			end
		end

		ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'stocks_menu', {
			title = 'Faction',
			description = 'Récupération stock',
			elements = elements
		}, function(data, menu)
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
				title = 'Quantité'
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification('Quantité invalide')
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('fl_factions:getStockItems', ESX.PlayerData.faction.name, data.current.value, count)

					Citizen.Wait(1000)
					OpenGetStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end, ESX.PlayerData.faction.name)
end

function OpenPutStocksMenu()
	ESX.TriggerServerCallback('fl_faction:getPlayerInventory', function(inventory)
		local elements = {}

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					value = item.name
				})
			end
		end

		ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'stocks_menu', {
			title = 'Faction',
			description = 'Inventaire joueur',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = 'Quantité'
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification('Quantité invalide')
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('fl_factions:putStockItems', ESX.PlayerData.faction.name, itemName, count)

					Citizen.Wait(1000)
					OpenPutStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

AddEventHandler('fl_factions:hasEnteredMarker', function(zone, station, part, partNum)
	if zone == 'Actions' then
		CurrentAction = 'faction_actions_menu'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu.'
		CurrentActionData = {}
	elseif zone == 'Cloakroom' then
		CurrentAction = 'faction_cloakroom_menu'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au vestiaire.'
		CurrentActionData = {}
	elseif zone == 'Garage' then
		CurrentAction = 'faction_garage_menu'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au garage.'
		CurrentActionData = {}
	elseif zone == 'VehicleDeleter' then
		local playerPed = PlayerPedId()
		if IsPedInAnyVehicle(playerPed,  true) then
			CurrentAction = 'faction_delete_vehicle'
			CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour ranger le véhicule.'
			CurrentActionData = {}
		end
	elseif zone == 'VehicleSpawnPoint' then
	else
		print("Unknown zone : " .. tostring(zone))
	end
end)

AddEventHandler('fl_factions:hasExitedMarker', function(zone, station, part, partNum)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

-- Update current faction
Citizen.CreateThread(function()
	while not ESX do
		Citizen.Wait(0)
	end

	while true do
		if ESX.PlayerData.faction then
			for _,Faction in pairs(Config.Factions) do
				if ESX.PlayerData.faction.name == Faction.Society then
					CurrentFaction = Faction
				end
			end
		end
		Citizen.Wait(3000)
	end
end)

-- Update distance
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)

		if CurrentFaction then
			local coords = GetEntityCoords(PlayerPedId())

			for _,Marker in pairs(CurrentFaction) do
				if type(Marker) == 'table' and Marker.Pos then
					Marker.inDistance = (Config.MarkerType ~= -1 and #(coords - vector3(Marker.Pos.x, Marker.Pos.y, Marker.Pos.z + 1.0)) < Config.DrawDistance)
				end
			end
		end

	end
end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentFaction then
			for _,Marker in pairs(CurrentFaction) do
				if type(Marker) == 'table' and Marker.inDistance then
					DrawMarker(
						 Config.MarkerType,
						 Marker.Pos.x, Marker.Pos.y, Marker.Pos.z - 0.3, 0.0, 0.0, 0.0, 0, 0.0, 0.0,
						 Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Marker.Color.r, Marker.Color.g, Marker.Color.b,
						 100, false, true, 2, false, false, false, false)
				end
			end
		end

	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while not ESX do
		Citizen.Wait(0)
	end

	while true do
		Citizen.Wait(300)

		if CurrentFaction then
			local coords = GetEntityCoords(PlayerPedId())
			local isInMarker = false
			local currentZone = nil
			local currentStation = nil
			local currentPart = nil
			local currentPartNum = nil

			for n,v in pairs(CurrentFaction) do
				if(type(v) == 'table' and v.Pos and #(coords - vector3(v.Pos.x, v.Pos.y, v.Pos.z)) < Config.MarkerSize.x) then
					isInMarker = true
					currentZone = v.ZoneType
				end
			end

			local hasExited = false

			if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastZone ~= currentZone or LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum) ) then
				if
					(LastZone ~= nil and LastStation ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
					(LastZone ~= currentZone or LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
				then
					TriggerEvent('fl_factions:hasExitedMarker', LastZone, LastStation, LastPart, LastPartNum)
					hasExited = true
				end

				HasAlreadyEnteredMarker = true
				LastZone = currentZone
				LastStation = currentStation
				LastPart = currentPart
				LastPartNum = currentPartNum

				TriggerEvent('fl_factions:hasEnteredMarker', currentZone, currentStation, currentPart, currentPartNum)
			end

			if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('fl_factions:hasExitedMarker', LastZone, LastStation, LastPart, LastPartNum)
			end

		end

	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while not ESX do
		Citizen.Wait(0)
	end

	while true do
		Citizen.Wait(0)
		if CurrentAction and ESX.PlayerData.faction ~= nil then

			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)

			if IsControlJustPressed(0, 38) and not ESX.IsPlayerDead() then
				if CurrentAction == 'faction_actions_menu' then
					OpenActionsMenu()
				end

				if CurrentAction == 'faction_cloakroom_menu' then
					ESX.UI.Menu.CloseAll()
					TriggerEvent('fl_clotheshop:openNonEditableDessing')
				end

				if CurrentAction == 'faction_garage_menu' then
					TriggerEvent('fl_advancedgarage:openMenuGarage', 'car_garage_point')
				end

				if CurrentAction == 'faction_delete_vehicle' then
					TriggerEvent('fl_advancedgarage:openMenuGarage', 'car_store_point')
				end

				CurrentAction = nil

			end
		else
			Citizen.Wait(300)
		end
	end
end)
