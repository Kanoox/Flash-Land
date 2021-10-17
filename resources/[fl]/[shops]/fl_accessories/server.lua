Citizen.CreateThread(function()
	for item,itemName in pairs(Config.Items) do
		local separatedName, el1, el2 = extractIdFromItem(item)

		ESX.RegisterTempItem(item, itemName, 0.05, -1, 0)
		ESX.RegisterUsableItem(item, function(source)
			TriggerClientEvent('fl_accessories:useAcc', source, item)
		end)
	end
end)

RegisterNetEvent('fl_accessories:pay')
AddEventHandler('fl_accessories:pay', function(itemName)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeMoney(Config.Price)
	xPlayer.addInventoryItem(itemName, 1)
	TriggerClientEvent('esx:showNotification', source, "Vous avez payé ~g~$" .. ESX.Math.GroupDigits(Config.Price) .. "~s~.")
end)

ESX.RegisterServerCallback('fl_accessories:checkMoney', function(xPlayer, source, cb)
	cb(xPlayer.getMoney() >= Config.Price)
end)

RegisterNetEvent('fl_accessories:removeMaskOf')
AddEventHandler('fl_accessories:removeMaskOf', function(targetPlayer)
	print('fl_accessories:removeMaskOf', targetPlayer)
	TriggerClientEvent('fl_accessories:setAcc', targetPlayer, Config.Item['Mask'], 0, 0)
end)