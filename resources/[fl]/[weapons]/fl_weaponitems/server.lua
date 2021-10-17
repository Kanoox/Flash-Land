RegisterNetEvent('esx:discardInventoryItem')
AddEventHandler('esx:discardInventoryItem', function(item, count)
	ESX.GetPlayerFromId(source).removeInventoryItem(item, count, true)
end)

RegisterNetEvent('esx:modelChanged')
AddEventHandler('esx:modelChanged', function(id)
	TriggerClientEvent('esx:modelChanged', id)
end)

ESX.RegisterUsableItem('pistol_ammo_box', function(source)
	local xPlayer  = ESX.GetPlayerFromId(source)
	local itemInfo = xPlayer.getInventoryItem('pistol_ammo')

	if not xPlayer.canCarryItem(itemInfo.name, 24) then
		xPlayer.showNotification('~r~Vous n\'avez pas assez de place')
		return
	end

	xPlayer.removeInventoryItem('pistol_ammo_box', 1)
	xPlayer.addInventoryItem('pistol_ammo', 24)
end)

ESX.RegisterUsableItem('smg_ammo_box', function(source)
	local xPlayer  = ESX.GetPlayerFromId(source)
	local itemInfo = xPlayer.getInventoryItem('smg_ammo')

	if not xPlayer.canCarryItem(itemInfo.name, 24) then
		xPlayer.showNotification('~r~Vous n\'avez pas assez de place')
		return
	end

	xPlayer.removeInventoryItem('smg_ammo_box', 1)
	xPlayer.addInventoryItem('smg_ammo', 30)
end)

ESX.RegisterUsableItem('rifle_ammo_box', function(source)
	local xPlayer  = ESX.GetPlayerFromId(source)
	local itemInfo = xPlayer.getInventoryItem('rifle_ammo')

	if not xPlayer.canCarryItem(itemInfo.name, 24) then
		xPlayer.showNotification('~r~Vous n\'avez pas assez de place')
		return
	end

	xPlayer.removeInventoryItem('rifle_ammo_box', 1)
	xPlayer.addInventoryItem('rifle_ammo', 30)
end)

ESX.RegisterUsableItem('shotgun_ammo_box', function(source)
	local xPlayer  = ESX.GetPlayerFromId(source)
	local itemInfo = xPlayer.getInventoryItem('shotgun_ammo')

	if not xPlayer.canCarryItem(itemInfo.name, 24) then
		xPlayer.showNotification('~r~Vous n\'avez pas assez de place')
		return
	end

	xPlayer.removeInventoryItem('shotgun_ammo_box', 1)
	xPlayer.addInventoryItem('shotgun_ammo', 16)
end)