
-- Common Factions

ESX.RegisterServerCallback('fl_factions:getStockInventory', function(xPlayer, source, cb, faction)
	TriggerEvent('fl_addoninventory:getSharedInventory', 'society_' .. faction, function(inventory)
		cb(inventory.items)
	end)
end)

RegisterNetEvent('fl_factions:getStockItems')
AddEventHandler('fl_factions:getStockItems', function(faction, itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('fl_addoninventory:getSharedInventory', 'society_' .. faction, function(inventory)
		local item = inventory.getItem(itemName)
		local sourceItem = xPlayer.getInventoryItem(itemName)

		-- is there enough in the society?
		if count > 0 and item.count >= count then

			-- can the player carry the said amount of x item?
			if not xPlayer.canCarryItem(sourceItem.name, sourceItem.count) then
				xPlayer.showNotification('Vous n\'avez pas assez de places')
			else
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				xPlayer.showNotification('Vous avez pris '.. count .. " " .. item.label)
			end
		else
			xPlayer.showNotification('Quantité invalide')
		end
	end)
end)

RegisterNetEvent('fl_factions:putStockItems')
AddEventHandler('fl_factions:putStockItems', function(faction, itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('fl_addoninventory:getSharedInventory', 'society_' .. faction, function(inventory)
		local item = inventory.getItem(itemName)
		local playerItemCount = xPlayer.getInventoryItem(itemName).count

		if item.count >= 0 and count <= playerItemCount then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
		else
			xPlayer.showNotification('Quantité invalide')
		end

		xPlayer.showNotification('Vous avez déposé ' .. count .. " " .. item.label)
	end)
end)

