ESX.Players = {}
ESX.PlayersIdentifiers = {}
ESX.UsableItemsCallbacks = {}
ESX.UsableItemsCloseMenu = {}
ESX.Items = {}
ESX.ServerCallbacks = {}
ESX.TimeoutCount = -1
ESX.CancelledTimeouts = {}
ESX.LastPlayerData = {}
ESX.Pickups = {}
ESX.PickupId = 0
ESX.Jobs = {}
ESX.Factions = {}

AddEventHandler('esx:getSharedObject', function(cb)
	cb(ESX)
end)

function getSharedObject()
	return ESX
end

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM items', {}, function(result)
		for i=1, #result, 1 do
			ESX.Items[result[i].name] = {
				label = result[i].label,
				limit = result[i].limit,
				weight = result[i].weight,
				canRemove = (result[i].can_remove == 1 and true or false),
				weight = result[i].weight,
			}
		end
	end)

	local result = MySQL.Sync.fetchAll('SELECT * FROM jobs', {})

	for i=1, #result do
		ESX.Jobs[result[i].name] = result[i]
		ESX.Jobs[result[i].name].grades = {}
	end

	local result2 = MySQL.Sync.fetchAll('SELECT * FROM job_grades', {})

	for i=1, #result2 do
		if ESX.Jobs[result2[i].job_name] then
			ESX.Jobs[result2[i].job_name].grades[tostring(result2[i].grade)] = result2[i]
		else
			print(('es_extended: invalid job "%s" from table job_grades ignored!'):format(result2[i].job_name))
		end
	end

	for k,v in pairs(ESX.Jobs) do
		if next(v.grades) == nil then
			ESX.Jobs[v.name] = nil
			print(('es_extended: ignoring job "%s" due to missing job grades!'):format(v.name))
		end
	end

	local result3 = MySQL.Sync.fetchAll('SELECT * FROM factions', {})

	for i=1, #result3 do
		ESX.Factions[result3[i].name] = result3[i]
		ESX.Factions[result3[i].name].grades = {}
	end

	local result4 = MySQL.Sync.fetchAll('SELECT * FROM faction_grades', {})

	for i=1, #result4 do
		if ESX.Factions[result4[i].faction_name] then
			ESX.Factions[result4[i].faction_name].grades[tostring(result4[i].grade)] = result4[i]
		else
			print(('es_extended: invalid faction "%s" from table faction_grades ignored!'):format(result4[i].faction_name))
		end
	end

	for k,v in pairs(ESX.Factions) do
		if next(v.grades) == nil then
			ESX.Factions[v.name] = nil
			print(('es_extended: ignoring faction "%s" due to missing faction grades!'):format(v.name))
		end
	end
end)

AddEventHandler('esx:playerLoaded', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local accounts = {}
	local items = {}
	local xPlayerAccounts = xPlayer.getAccounts()
	local xPlayerItems = xPlayer.getInventory()

	for i=1, #xPlayerAccounts, 1 do
		accounts[xPlayerAccounts[i].name] = xPlayerAccounts[i].money
	end

	for i=1, #xPlayerItems, 1 do
		items[xPlayerItems[i].name] = xPlayerItems[i].count
	end

	ESX.LastPlayerData[source] = {
		accounts = accounts,
		items = items
	}
end)

RegisterNetEvent('esx:clientLog')
AddEventHandler('esx:clientLog', function(msg)
	RconPrint(msg .. "\n")
end)

RegisterNetEvent('esx:triggerServerCallback')
AddEventHandler('esx:triggerServerCallback', function(name, requestId, ...)
	local _source = source

	ESX.TriggerServerCallback(name, requestID, _source, function(...)
		TriggerClientEvent('esx:serverCallback', _source, requestId, ...)
	end, ...)
end)
