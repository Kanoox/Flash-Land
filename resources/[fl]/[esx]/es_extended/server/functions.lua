ESX.RegisteredCommands = {}

ESX.Trace = function(msg)
	if Config.EnableDebug then
		print(('[^2TRACE^7] %s^7'):format(msg))
	end
end

ESX.SetTimeout = function(msec, cb)
	local id = ESX.TimeoutCount + 1

	SetTimeout(msec, function()
		if ESX.CancelledTimeouts[id] then
			ESX.CancelledTimeouts[id] = nil
		else
			cb()
		end
	end)

	ESX.TimeoutCount = id

	return id
end

ESX.RegisterCommand = function(name, group, cb, allowConsole, suggestion)
	if type(name) == 'table' then
		for k,v in ipairs(name) do
			ESX.RegisterCommand(v, group, cb, allowConsole, suggestion)
		end

		return
	end

	if ESX.RegisteredCommands[name] then
		print(('[^3WARNING^7] An command "%s" is already registered, overriding command'):format(name))

		if ESX.RegisteredCommands[name].suggestion then
			TriggerClientEvent('chat:removeSuggestion', -1, ('/%s'):format(name))
		end
	end

	if suggestion then
		if not suggestion.arguments then suggestion.arguments = {} end
		if not suggestion.help then suggestion.help = '' end

		TriggerClientEvent('chat:addSuggestion', -1, ('/%s'):format(name), suggestion.help, suggestion.arguments)
	end

	ESX.RegisteredCommands[name] = {group = group, cb = cb, allowConsole = allowConsole, suggestion = suggestion}

	RegisterCommand(name, function(playerId, args, rawCommand)
		local command = ESX.RegisteredCommands[name]

		if not command.allowConsole and playerId == 0 then
			print(('[^3WARNING^7] %s'):format(_U('commanderror_console')))
		else
			local xPlayer, error = ESX.GetPlayerFromId(playerId), nil

			if command.suggestion then
				if command.suggestion.validate then
					if #args ~= #command.suggestion.arguments then
						error = _U('commanderror_argumentmismatch', #args, #command.suggestion.arguments)

						if #command.suggestion.arguments == 1 and (command.suggestion.arguments[1].type == 'player' or command.suggestion.arguments[1].type == 'playerId') then
							error = nil
						end
					end
				end

				if not error and #command.suggestion.arguments > 0 then
					local newArgs = {}

					for k,v in ipairs(command.suggestion.arguments) do
						if v.type then
							if v.type == 'number' then
								local newArg = tonumber(args[k])

								if newArg then
									newArgs[v.name] = newArg
								else
									error = _U('commanderror_argumentmismatch_number', k)
								end
							elseif v.type == 'player' or v.type == 'playerId' then
								local targetPlayer = tonumber(args[k])

								if args[k] == 'me' then targetPlayer = playerId end

								if #command.suggestion.arguments == 1 and #args == 0 then
									targetPlayer = playerId
								end

								if targetPlayer then
									local xTargetPlayer = ESX.GetPlayerFromId(targetPlayer)

									if xTargetPlayer then
										if v.type == 'player' then
											newArgs[v.name] = xTargetPlayer
										else
											newArgs[v.name] = targetPlayer
										end
									else
										error = _U('commanderror_invalidplayerid')
									end
								else
									error = _U('commanderror_argumentmismatch_number', k)
								end
							elseif v.type == 'string' then
								newArgs[v.name] = args[k]
							elseif v.type == 'boolean' or v.type == 'bool' then
								newArgs[v.name] = args[k] == 1 or args[k] == 'true' or args[k] == '1'
							elseif v.type == 'item' then
								if ESX.Items[args[k]] then
									newArgs[v.name] = args[k]
								else
									error = _U('commanderror_invaliditem')
								end
							elseif v.type == 'any' then
								newArgs[v.name] = args[k]
							else
								error('Unknown type :' .. tostring(v.type))
							end
						end

						if error then break end
					end

					args = newArgs
				end
			end

			TriggerEvent('esx:onCommandExecuted', xPlayer, rawCommand, name, args)

			if error then
				if playerId == 0 then
					print(('[^3WARNING^7] %s^7'):format(error))
				else
					xPlayer.triggerEvent('chat:addMessage', {args = {'^FreeLife', error}})
				end
			else
				cb(xPlayer or false, args, function(msg)
					if playerId == 0 then
						print(('[^3WARNING^7] %s^7'):format(msg))
					else
						xPlayer.triggerEvent('chat:addMessage', {args = {'^FreeLife', msg}})
					end
				end)
			end
		end
	end, true)

	if type(group) == 'table' then
		for k,v in ipairs(group) do
			ExecuteCommand(('add_ace group.%s command.%s allow'):format(v, name))
		end
	else
		ExecuteCommand(('add_ace group.%s command.%s allow'):format(group, name))
	end
end

ESX.GetSourceFromIdentifier = function(identifier)
	for _,anyPlayer in pairs(GetPlayers()) do
		for _, anyIdentifier in pairs(GetPlayerIdentifiers(anyPlayer)) do
			if identifier == anyIdentifier then
				return anyPlayer
			end
		end
	end
	return nil
end

ESX.ClearTimeout = function(id)
	ESX.CancelledTimeouts[id] = true
end

local useCb = {}
local resetCb = 0

ESX.RegisterServerCallback = function(name, cb)
	ESX.ServerCallbacks[name] = cb
end

RegisterCommand("getResetCb", function(source)
	print(resetCb)
end, false)

Citizen.CreateThread(function()
	while true do
		resetCb = resetCb + 1
		useCb = {}
		Wait(350)
	end
end)

ESX.TriggerServerCallback = function(name, requestId, source, cb, ...)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer == nil then
		return
	end
	if ESX.ServerCallbacks[name] then
		if not useCb[source] then useCb[source] = 0 end
		useCb[source] = (useCb[source] + 1)
		if useCb[source] > 25 then
			print("[!!!!!!!] Un sombre cafard "..source.." ("..GetPlayerName(source)..") essaie de spam "..name)
			return
		end
		ESX.ServerCallbacks[name](xPlayer, source, cb, ...)
	else
		print(('[^3WARNING^7] Server callback "%s" does not exist. Make sure that the server sided file really is loading, an error in that file might cause it to not load.'):format(name))
	end
end

ESX.SavePlayers = function(cb)
	local xPlayers, asyncTasks = ESX.GetPlayers(), {}

	for i=1, #xPlayers, 1 do
		table.insert(asyncTasks, function(endedTask)
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer then
				xPlayer.save(endedTask)
			end
		end)
	end

	Async.parallelLimit(asyncTasks, 8, function(results)
		if cb then
			cb()
		end
	end)
end

ESX.StartDBSync = function()
	function saveData()
		ESX.SavePlayers()
		SetTimeout(10 * 60 * 1000, saveData)
	end

	SetTimeout(10 * 60 * 1000, saveData)
end

ESX.GetPlayers = function()
	local sources = {}

	for k,v in pairs(ESX.Players) do
		table.insert(sources, k)
	end

	return sources
end

ESX.GetAllPlayers = function()
	return ESX.Players
end

ESX.GetPlayerFromId = function(source)
	if source == nil then return nil end
	return ESX.Players[tonumber(source)]
end

ESX.GetPlayerFromDiscordIdentifier = function(discord)
	return ESX.PlayersIdentifiers[discord]
end

ESX.GetItem = function(name)
	return ESX.Items[name]
end

ESX.ExistItem = function(name)
	return ESX.Items[name] ~= nil
end

ESX.RegisterTempItem = function(name, label, weight, limit, canRemove)
	ESX.Items[name] = {
		label = label,
		weight = weight,
		limit = limit,
		canRemove = canRemove,
		temp = true,
		weight = weight,
	}
end

ESX.RegisterCloseMenuUsableItem = function(item, close)
	ESX.UsableItemsCloseMenu[item] = close
end

ESX.RegisterUsableItem = function(item, cb)
	ESX.UsableItemsCallbacks[item] = cb

	Citizen.CreateThread(function()
		Citizen.Wait(3 * 1000)
		if ESX.Items[item] == nil then
			print('Registered unknown usable item : ' .. tostring(item))
		end
	end)
end

ESX.UseItem = function(source, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	ESX.UsableItemsCallbacks[item](source, xPlayer)
end

ESX.GetItemLabel = function(item)
	if ESX.Items[item] then
		return ESX.Items[item].label
	end

	return 'Item inconnu (' .. item .. ')'
end

ESX.GetAccountName = function(item)
	return Config.Accounts[item]
end

ESX.CreatePickup = function(type, name, count, label, playerId, components, tintIndex)
	local pickupId = (ESX.PickupId == 65635 and 0 or ESX.PickupId + 1)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local coords = xPlayer.getCoords()

	ESX.Pickups[pickupId] = {
		type = type, name = name,
		count = count, label = label,
		coords = coords
	}

	TriggerClientEvent('esx:createPickup', -1, pickupId, label, coords, type, name, components, tintIndex)
	ESX.PickupId = pickupId
end

ESX.GetJob = function(job)
	return ESX.Jobs[job]
end

ESX.DoesJobExist = function(job, grade)
	grade = tostring(grade)

	if job and grade then
		if ESX.Jobs[job] and ESX.Jobs[job].grades[grade] then
			return true
		end
	end

	return false
end

ESX.DoesFactionExist = function(faction, grade)
	grade = tostring(grade)

	if faction and grade then
		if ESX.Factions[faction] and ESX.Factions[faction].grades[grade] then
			return true
		end
	end

	return false
end

ESX.GetPlayersWithJob = function(job)
	if job == nil then error('nil job') end

    local xPlayers = {}
    for _, playerId in pairs(ESX.GetPlayers()) do
        local anyXPlayer = ESX.GetPlayerFromId(playerId)
		if anyXPlayer and anyXPlayer.job and anyXPlayer.job.name == job then
			table.insert(xPlayers, anyXPlayer)
        end
	end

	return xPlayers
end

ESX.GetPlayersWithFaction = function(faction)
	if faction == nil then error('nil faction') end

    local xPlayers = {}
    for _, playerId in pairs(ESX.GetPlayers()) do
        local anyXPlayer = ESX.GetPlayerFromId(playerId)
		if anyXPlayer and anyXPlayer.faction and anyXPlayer.faction.name == faction then
			table.insert(xPlayers, anyXPlayer)
        end
	end

	return xPlayers
end

RegisterNetEvent("esx:deleteEntity")
AddEventHandler("esx:deleteEntity", function(netId)
	DeleteEntity(NetworkGetEntityFromNetworkId(netId))
end)

RegisterNetEvent("esx:deleteEntityTable")
AddEventHandler("esx:deleteEntityTable", function(list)
    for _,netId in pairs(list) do
		DeleteEntity(NetworkGetEntityFromNetworkId(netId))
    end
end)

ESX.RegisterServerCallback('esx:createAutomobile', function(xPlayer, source, cb, model, coords)
	local vector = type(coords) == "vector4" and coords or type(coords) == "vector3" and vector4(coords, 0.0)
	local vehicle = Citizen.InvokeNative(`CREATE_AUTOMOBILE`, model, vector)

	while not DoesEntityExist(vehicle) do
		Citizen.Wait(10)
	end

	SetEntityHeading(vehicle, vector.w)
	cb(NetworkGetNetworkIdFromEntity(vehicle))
end)