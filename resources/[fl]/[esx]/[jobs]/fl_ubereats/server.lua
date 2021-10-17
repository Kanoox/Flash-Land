RegisterNetEvent('fl_ubereats:buyItem')
AddEventHandler('fl_ubereats:buyItem', function(itemName, price, itemLabel)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(_source)
	local item = xPlayer.getInventoryItem(itemName)
	local societyAccount = nil

	TriggerEvent('fl_data:getSharedAccount', 'society_ubereats', function(account)
		societyAccount = account
	end)

	if societyAccount ~= nil and societyAccount.money >= price then
		if xPlayer.canCarryItem(item.name, 1) then
			societyAccount.removeMoney(price)
			xPlayer.addInventoryItem(itemName, 1)
			TriggerClientEvent('esx:showNotification', _source, _U('bought') .. itemLabel)
		else
			TriggerClientEvent('esx:showNotification', _source, _U('max_item'))
		end
	else
		TriggerClientEvent('esx:showNotification', _source, _U('not_enough'))
	end
end)
