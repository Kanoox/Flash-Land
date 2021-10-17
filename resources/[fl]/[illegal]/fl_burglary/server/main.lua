cachedData = {
	cbData = {}
}

RegisterNetEvent("fl_burglary:globalEvent")
AddEventHandler("fl_burglary:globalEvent", function(options)
	ESX.Trace((options.event or "none") .. " triggered to all clients.")

	if options.data.saveData then
		if options.event == "lockpick_house" then
			cachedData.cbData[options.data.houseId] = {
				Lootables = {}
			}
		elseif options.event == "lock_house" then
			cachedData.cbData[options.data.houseId] = {
				locked = true
			}
		else
			cachedData.cbData[options.data.houseId].Lootables[options.data.lootSpot] = true
		end
	end

    TriggerClientEvent("fl_burglary:eventHandler", -1, options.event or "none", options.data or nil)
end)

RegisterNetEvent("fl_burglary:cacheData")
AddEventHandler("fl_burglary:cacheData", function(data)
	cachedData.cbData = data
end)

ESX.RegisterServerCallback("fl_burglary:fetchData", function(xPlayer, source, cb)
	if xPlayer then
		cb(cachedData.cbData)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback("fl_burglary:lootItem", function(xPlayer, source, cb)
	if xPlayer then
		local randomTier = math.random(100)
		local tier = randomTier >= 95 and 5 or randomTier >= 85 and 4 or randomTier >= 70 and 3 or randomTier >= 50 and 2 or randomTier >= 0 and 1

		if #Config.LootTable[tier] > 0 then
			local randomItem = Config.LootTable[tier][math.random(#Config.LootTable[tier])]

			if randomItem ~= "nothing" then
				if not xPlayer.canCarryItem(randomItem, 1) then
					TriggerClientEvent('esx:showNotification', xPlayer.source, '~r~Vous n\'avez plus de place...')
					return
				end
				xPlayer.addInventoryItem(randomItem, 1)

				cb(randomItem)
			else
				TriggerClientEvent("esx:showNotification", source, "Tu n'as rien trouvé")
			end
		end
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback("fl_burglary:isHouseRobbable", function(xPlayer, source, cb)
	local players = ESX.GetPlayers()
	local copsOnduty = 0

	for playerIndex = 1, #players do
		local player = ESX.GetPlayerFromId(players[playerIndex])
		if player.job.name == "police" then
			copsOnduty = copsOnduty + 1
		end
	end

	cb(copsOnduty >= Config.CopsRequired)
end)