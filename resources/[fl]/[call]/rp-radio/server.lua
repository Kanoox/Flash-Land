ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('radio', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    TriggerClientEvent('Radio.Set', source, true)
    TriggerClientEvent('esx:showNotification', source, 'Vous pouvez désormais utiliser la radio.')

end)

ESX.RegisterServerCallback('rp-radio:getItemAmount', function(xPlayer, source, cb)
    local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	local quantity = xPlayer.getInventoryItem('radio').count

	cb(quantity)
end)

