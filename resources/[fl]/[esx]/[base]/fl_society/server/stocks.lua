
RegisterNetEvent('fl_society:getStockItem')
AddEventHandler('fl_society:getStockItem', function(society, itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('fl_addoninventory:getSharedInventory', 'society_' .. society, function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		if count <= 0 then
			TriggerClientEvent('esx:showNotification', xPlayer.source, '~r~Quantité invalide... (<0)')
			return
		end

		-- is there enough in the society?
		if inventoryItem.count >= count then

			-- can the player carry the said amount of x item?
			if not xPlayer.canCarryItem(inventoryItem.name, count) then
				TriggerClientEvent('esx:showNotification', xPlayer.source, '~r~Vous n\'avez pas la place sur vous !')
			else
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', xPlayer.source, '~o~Vous avez retiré x' .. count .. ' ' .. inventoryItem.label)
			end
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, '~r~Pas assez de cet item dans le coffre...')
		end
	end)
end)

RegisterNetEvent('fl_society:putStockItem')
AddEventHandler('fl_society:putStockItem', function(society, itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('fl_addoninventory:getSharedInventory', 'society_'  .. society, function(inventory)
		local sourceItem = xPlayer.getInventoryItem(itemName)

		if count <= 0 then
			TriggerClientEvent('esx:showNotification', xPlayer.source, '~r~Quantité invalide... (<0)')
			return
		end

		-- does the player have enough of the item?
		if sourceItem.count >= count then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			xPlayer.showNotification('~g~Vous avez ajouté x' .. count .. ' ' .. sourceItem.label)
		else
			xPlayer.showNotification('~r~Vous n\'avez pas autant de cet item !')
		end
	end)
end)

ESX.RegisterServerCallback('fl_society:getStockInventory', function(xPlayer, source, cb, society)
	TriggerEvent('fl_addoninventory:getSharedInventory', 'society_' .. society, function(inventory)
		cb(inventory.items)
	end)
end)
