local playersHealing = {}

RegisterNetEvent('fl_ambulancejob:revive')
AddEventHandler('fl_ambulancejob:revive', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name ~= 'ambulance' then return end

	TriggerEvent('fl_data:getSharedAccount', 'society_ambulance', function(societyAccount)
		societyAccount.addMoney(Config.ReviveReward)
		xPlayer.showNotification('Votre société a gagné ' .. Config.ReviveReward ..' ~g~$~s~', Config.ReviveReward)
		TriggerClientEvent('fl_ambulancejob:revive', target)
	end)

end)

RegisterNetEvent('fl_ambulancejob:heal')
AddEventHandler('fl_ambulancejob:heal', function(target, type)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name ~= 'ambulance' then return end

	TriggerClientEvent('fl_ambulancejob:heal', target, type)
end)

RegisterNetEvent('fl_ambulancejob:putInVehicle')
AddEventHandler('fl_ambulancejob:putInVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name ~= 'ambulance' then return end

	TriggerClientEvent('fl_ambulancejob:putInVehicle', target)
end)

ESX.RegisterServerCallback('fl_ambulancejob:removeItemsAfterRPDeath', function(xPlayer, source, cb)
	if xPlayer.getMoney() > 0 then
		xPlayer.removeMoney(xPlayer.getMoney())
	end

	if xPlayer.getAccount('black_money').money > 0 then
		xPlayer.setAccountMoney('black_money', 0)
	end

	for _,item in pairs(xPlayer.inventory) do
		if item.count > 0 and (string.match(string.upper(item.name), 'WEAPON') or string.match(string.upper(item.name), 'AMMO')) then
			xPlayer.setInventoryItem(item.name, 0)
		end
	end

	cb()
end)

RegisterNetEvent('fl_ambulancejob:removeItem')
AddEventHandler('fl_ambulancejob:removeItem', function(item)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem(item, 1)

	if item == 'bandage' then
		TriggerClientEvent('esx:showNotification', _source, _U('used_bandage'))
	elseif item == 'medikit' then
		TriggerClientEvent('esx:showNotification', _source, _U('used_medikit'))
	end
end)

RegisterNetEvent('fl_ambulancejob:giveItem')
AddEventHandler('fl_ambulancejob:giveItem', function(itemName)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name ~= 'ambulance' then
		print(('fl_ambulancejob: %s attempted to spawn in an item!'):format(xPlayer.discord))
		return
	elseif (itemName ~= 'medikit' and itemName ~= 'bandage') then
		print(('fl_ambulancejob: %s attempted to spawn in an item!'):format(xPlayer.discord))
		return
	end

	local xItem = xPlayer.getInventoryItem(itemName)
	local count = 1

	if xItem.limit ~= -1 then
		count = xItem.limit - xItem.count
	end

	if xPlayer.canCarryItem(xItem.name, count) then
		xPlayer.addInventoryItem(itemName, count)
	else
		TriggerClientEvent('esx:showNotification', source, _U('max_item'))
	end
end)

ESX.RegisterUsableItem('medikit', function(source)
	if playersHealing[source] then return end
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('medikit', 1)

	playersHealing[source] = true
	TriggerClientEvent('fl_ambulancejob:useItem', source, 'medikit')

	Citizen.Wait(10000)
	playersHealing[source] = nil
end)

ESX.RegisterUsableItem('bandage', function(source)
	if playersHealing[source] then return end
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('bandage', 1)

	playersHealing[source] = true
	TriggerClientEvent('fl_ambulancejob:useItem', source, 'bandage')

	Citizen.Wait(10000)
	playersHealing[source] = nil
end)

ESX.RegisterServerCallback('fl_ambulancejob:getDeathStatus', function(xPlayer, source, cb)
	MySQL.Async.fetchScalar('SELECT is_dead FROM users WHERE discord = @discord', {
		['@discord'] = xPlayer.discord
	}, function(isDead)
		if isDead then
			print(('fl_ambulancejob: %s attempted combat logging!'):format(xPlayer.discord))
		end

		cb(isDead)
	end)
end)

RegisterNetEvent('fl_ambulancejob:setDeathStatus')
AddEventHandler('fl_ambulancejob:setDeathStatus', function(isDead)
	if type(isDead) ~= 'boolean' then
		error(('fl_ambulancejob: %s attempted to parse something else than a boolean to setDeathStatus!'):format(xPlayer.discord))
	end
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE users SET is_dead = @isDead WHERE discord = @discord', {
		['@discord'] = xPlayer.discord,
		['@isDead'] = isDead
	}, function() end)
end)

RegisterNetEvent('fl_ambulancejob:svsearch')
AddEventHandler('fl_ambulancejob:svsearch', function()
	TriggerClientEvent('fl_ambulancejob:clsearch', -1, source)
end)