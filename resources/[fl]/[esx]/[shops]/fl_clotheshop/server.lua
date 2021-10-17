RegisterNetEvent('fl_eden_clotheshop:pay')
AddEventHandler('fl_eden_clotheshop:pay', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeMoney(Config.Price)
	TriggerClientEvent('esx:showNotification', source, _U('you_paid') .. Config.Price)
end)

RegisterNetEvent('fl_eden_clotheshop:saveOutfit')
AddEventHandler('fl_eden_clotheshop:saveOutfit', function(label, skin)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('fl_datastore:insertToDataStore', 'property', xPlayer.discord, 'dressing', {
		label = label,
		skin = skin
	})
end)

RegisterNetEvent('fl_eden_clotheshop:renameOutfit')
AddEventHandler('fl_eden_clotheshop:renameOutfit', function(outfitIndex, newLabel)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('fl_datastore:getDataStore', 'property', xPlayer.discord, function(store)
		local outfit = store.get('dressing', outfitIndex)

		TriggerEvent('fl_datastore:removeFromDataStore', 'property', xPlayer.discord, 'dressing', outfitIndex)

		TriggerEvent('fl_datastore:insertToDataStore', 'property', xPlayer.discord, 'dressing', {
			label = newLabel,
			skin = outfit.skin
		})
	end)
end)

RegisterNetEvent('fl_eden_clotheshop:removeOutfit')
AddEventHandler('fl_eden_clotheshop:removeOutfit', function(label)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('fl_datastore:getDataStore', 'property', xPlayer.discord, function(store)
		local dressing = store.get('dressing') or {}

		table.remove(dressing, label)
		store.set('dressing', dressing)
	end)
end)

RegisterNetEvent('fl_eden_clotheshop:deleteOutfit')
AddEventHandler('fl_eden_clotheshop:deleteOutfit', function(outfitIndex)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerEvent('fl_datastore:removeFromDataStore', 'property', xPlayer.discord, 'dressing', outfitIndex)
end)

ESX.RegisterServerCallback('fl_eden_clotheshop:checkMoney', function(xPlayer, source, cb)
	cb(xPlayer.getMoney() >= Config.Price)
end)

ESX.RegisterServerCallback('fl_eden_clotheshop:checkPropertyDataStore', function(xPlayer, source, cb)
	local foundStore = false

	TriggerEvent('fl_datastore:getDataStore', 'property', xPlayer.discord, function(store)
		foundStore = true
	end)

	cb(foundStore)
end)

ESX.RegisterServerCallback('fl_eden_clotheshop:getPlayerDressing', function(xPlayer, source, cb)
	TriggerEvent('fl_datastore:getDataStore', 'property', xPlayer.discord, function(store)
		local count = store.count('dressing')
		local labels = {}

		for i=1, count, 1 do
			local entry = store.get('dressing', i)
			table.insert(labels, entry.label)
		end

		cb(labels)
	end)
end)

ESX.RegisterServerCallback('fl_eden_clotheshop:getPlayerOutfit', function(xPlayer, source, cb, num)
	TriggerEvent('fl_datastore:getDataStore', 'property', xPlayer.discord, function(store)
		local outfit = store.get('dressing', num)
		cb(outfit.skin)
	end)
end)