Blips = {}
ClientRegisteredBracelet = {}

RegisterNetEvent('fl_sheriffjob:updateBracelet')
AddEventHandler('fl_sheriffjob:updateBracelet', function(RegisteredBracelet)
	ClientRegisteredBracelet = RegisteredBracelet
	local random = 30
	local playerPos = GetEntityCoords(PlayerPedId())

	if #(playerPos.xy - Config.sheriffStations.LSPD.Cloakrooms[1].xy) > 45 then
		for BraceletID,Bracelet in pairs(RegisteredBracelet) do
			if Blips[BraceletID] then
				RemoveBlip(Blips[BraceletID])
				Blips[BraceletID] = nil
			end

			if Blips[1000000000 + BraceletID] then
				RemoveBlip(Blips[1000000000 + BraceletID])
				Blips[1000000000 + BraceletID] = nil
			end
		end

		return
	end

	for BraceletID,Bracelet in pairs(ClientRegisteredBracelet) do
		if Bracelet.isActive and Bracelet.lastPosition then
			local coords = json.decode(Bracelet.lastPosition)
			if not coords or not coords.x or (coords.x == 0 and coords.y == 0 and coords.z == 0) or type(coords) == 'nil' or coords == nil then
				coords = {x = -5000.0, y = -5000.0, z = 0.0}
			end

			if Bracelet.currentPosition then
				coords.x = coords.x + math.random(-random, random)
				coords.y = coords.y + math.random(-random, random)
				coords.z = coords.z + math.random(-random, random)
			end

			local zoneBlip = nil
			if Blips[BraceletID] then
				zoneBlip = Blips[BraceletID]
				SetBlipCoords(zoneBlip, coords.x, coords.y, coords.z)
			else
				zoneBlip = AddBlipForRadius(coords.x, coords.y, coords.z, 70.0)
				Blips[BraceletID] = zoneBlip
			end

			SetBlipAlpha(zoneBlip, 120)
			SetBlipDisplay(zoneBlip, 3)

			if Bracelet.currentPosition then
				SetBlipColour(zoneBlip, 80)
			else
				SetBlipColour(zoneBlip, 85)
			end

			local humanBlip = nil
			if Blips[1000000000 + BraceletID] then
				humanBlip = Blips[1000000000 + BraceletID]
				SetBlipCoords(humanBlip, coords.x, coords.y, coords.z)
			else
				humanBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
				Blips[1000000000 + BraceletID] = humanBlip
			end

			SetBlipAlpha(humanBlip, 180)
			SetBlipSprite(humanBlip, 480)
			SetBlipScale(humanBlip, 0.8)
			SetBlipShrink(humanBlip, 1)
			SetBlipCategory(humanBlip, 7)
			SetBlipDisplay(humanBlip, 3)
			SetBlipAsShortRange(humanBlip, true)

			BeginTextCommandSetBlipName('STRING')
			AddTextComponentString(Bracelet.info)
			EndTextCommandSetBlipName(humanBlip)

			if Bracelet.currentPosition then
				SetBlipColour(humanBlip, 80)
			else
				SetBlipColour(humanBlip, 85)
			end
		else
			if Blips[BraceletID] then
				RemoveBlip(Blips[BraceletID])
				Blips[BraceletID] = nil
			end

			if Blips[1000000000 + BraceletID] then
				RemoveBlip(Blips[1000000000 + BraceletID])
				Blips[1000000000 + BraceletID] = nil
			end
		end
	end
end)

RegisterNetEvent('fl_sheriffjob:useBracelet')
AddEventHandler('fl_sheriffjob:useBracelet', function(Bracelet, UseItem)
	if not Bracelet then error('Use no bracelet') end
	local lastUser = Bracelet.info
	if not lastUser then lastUser = 'Aucun'	end

	local elements = {
		{label = 'Numéro bracelet : ' .. Bracelet.id, value = 'info'},
		{label = 'Dernier utilisateur : ' .. lastUser, value = 'info'},
	}


	local player = GetPlayerFromServerId(Bracelet.serverId)
	local distance = 100
	if player ~= -1 then
		distance = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(GetPlayerPed(player)))
	end

	if Bracelet.isActive and Bracelet.lastPosition and distance < 50 then
		table.insert(elements, {label = 'Enlever le bracelet', value = 'remove'})
	elseif UseItem then
		table.insert(elements, {label = 'Mettre le bracelet à un individu', value = 'put'})
	end

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'bracelet_info', {
		title = 'Information bracelet électronique',
		elements = elements,
	}, function(data, menu)

		if data.current.value == 'info' then
		elseif data.current.value == 'remove' then
			menu.close()
			if not Bracelet.lastPosition then
				ESX.ShowNotification('~r~Impossible d\'intéragir avec un bracelet hors du réseau...')
				return
			end

			TriggerServerEvent('fl_sheriffjob:removeBracelet', Bracelet.id)
			ESX.UI.Menu.CloseAll()
		elseif data.current.value == 'put' then
			PutBracelet(Bracelet)
		else
			print('Unknown button bracelet_info' .. tostring(data.current.value))
		end

	end, function(data, menu)
		menu.close()
	end)
end)

function PutBracelet(Bracelet)
	local elements = {}
	local closePlayers = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId(), false), 2.0);

	for _,anyPlayer in pairs(closePlayers) do
		if anyPlayer ~= PlayerId() then
			table.insert(elements, {label = GetPlayerName(anyPlayer), value = anyPlayer})
		end
	end

	if #closePlayers == 0 then
		table.insert(elements, {label = 'Aucun joueurs ...', value = 'nope'})
	end

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'bracelet_put', {
		title = 'Mettre le bracelet à',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'nope' then return end
		TriggerServerEvent('fl_sheriffjob:putBracelet', Bracelet.id, GetPlayerServerId(data.current.value))
		ESX.UI.Menu.CloseAll()
	end, function(data, menu)
		menu.close()
	end)
end

RegisterNetEvent('fl_sheriffjob:manageBracelet')
AddEventHandler('fl_sheriffjob:manageBracelet', function()
	local elements = {}
	for BraceletID,Bracelet in pairs(ClientRegisteredBracelet) do
		local braceletInfo = ''
		if Bracelet.info then
			if Bracelet.isActive then
				braceletInfo = 'Actif'
			else
				braceletInfo = 'Inactif'
			end
			braceletInfo = braceletInfo .. ' (' .. Bracelet.info .. ')'
		end
		table.insert(elements, {label = 'Bracelet n°' .. BraceletID .. ' ' .. braceletInfo, braceletId = BraceletID})
	end

	if #elements == 0 then
		table.insert(elements, {label = 'Aucun bracelet...'})
	end

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'bracelet_manage', {
		title = 'Information bracelet électronique',
		elements = elements
	}, function(data, menu)
		if not data.current.braceletId then return end
		TriggerEvent('fl_sheriffjob:useBracelet', ClientRegisteredBracelet[data.current.braceletId])
	end, function(data, menu)
		menu.close()
	end)
end)
