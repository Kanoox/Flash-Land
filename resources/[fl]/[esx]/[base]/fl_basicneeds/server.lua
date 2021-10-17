for itemName, itemData in pairs(Config.Usables) do
	ESX.RegisterUsableItem(itemName, function(source)
		local xPlayer = ESX.GetPlayerFromId(source)

		xPlayer.removeInventoryItem(itemName, 1)

		if itemData.thirst then
			if itemData.thirst > 0 then
				TriggerClientEvent('fl_status:add', source, 'thirst', itemData.thirst)
			else
				TriggerClientEvent('fl_status:remove', source, 'thirst', -itemData.thirst)
			end
		end

		if itemData.drunk then
			if itemData.drunk > 0 then
				TriggerClientEvent('fl_status:add', source, 'drunk', itemData.drunk)
			else
				TriggerClientEvent('fl_status:remove', source, 'drunk', -itemData.drunk)
			end
		end

		if itemData.hunger then
			if itemData.hunger > 0 then
				TriggerClientEvent('fl_status:add', source, 'hunger', itemData.hunger)
			else
				TriggerClientEvent('fl_status:remove', source, 'hunger', -itemData.hunger)
			end
		end

		if itemData.anim then
			TriggerClientEvent('fl_basicneeds:' .. itemData.anim.action, source, itemData.anim.prop)

			if itemData.anim.action == 'onDrink' then
				xPlayer.showNotification('Vous avez bu un ~g~' .. itemData.name .. '~s~')
			elseif itemData.anim.action == 'onEat' then
				xPlayer.showNotification('Vous avez mangé un ~g~' .. itemData.name .. '~s~')
			else
				xPlayer.showNotification('Vous avez ?? ~g~' .. itemData.name .. '~s~')
			end
		end

	end)
end

ESX.RegisterUsableItem('malbora', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local briquet = xPlayer.getInventoryItem('briquet', 1)

	if briquet.count > 0 then
		xPlayer.removeInventoryItem('malbora', 1)
		TriggerClientEvent('fl_basicneeds:onSmoke', source, 'ng_proc_cigarette01a')
		TriggerClientEvent('esx:showNotification', source, 'Vous fumez une ~r~Malboro~s~')
	else
		TriggerClientEvent('esx:showNotification', source, 'Vous n\'avez de briquet')
	end
end)

-- Cigar
ESX.RegisterUsableItem('cigar', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local briquet = xPlayer.getInventoryItem('briquet', 1)

	if briquet.count > 0 then
		xPlayer.removeInventoryItem('cigar', 1)
		TriggerClientEvent('fl_basicneeds:onSmoke', source, 'prop_cigar_03')
		TriggerClientEvent('esx:showNotification', source, 'Vous fumez un ~r~Cigare~s~')
	else
		TriggerClientEvent('esx:showNotification', source, 'Vous n\'avez pas de briquet')
	end
end)

ESX.RegisterUsableItem('traceur', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('traceur', 1)
	TriggerClientEvent('fl_basicneeds:traceur', source, '')
	TriggerClientEvent('esx:showNotification', source, _U('used_traceur'))
end)

ESX.RegisterUsableItem('steroids', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('steroids', 1)
	TriggerClientEvent('fl_basicneeds:onEatSteroids', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_steroid'))
end)

ESX.RegisterUsableItem('coke', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('coke', 1)

	TriggerClientEvent('fl_basicneeds:onEatCoke', source)
	TriggerClientEvent('fl_status:remove', source, 'hunger', 100000)
	TriggerClientEvent('fl_status:remove', source, 'thirst', 100000)
	TriggerClientEvent('fl_status:add', source, 'drunk', 20000)
    TriggerClientEvent('esx:showNotification', source, 'Vous avez ~g~sniffé~s~ de la ~r~Coke~s~')
end)

ESX.RegisterUsableItem('meth', function(source)
	local xPlayer  = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('meth', 1)

	TriggerClientEvent('fl_basicneeds:meth', source)
    TriggerClientEvent('esx:showNotification', source, 'Vous avez pris de la ~g~Meth~s~')
end)

ESX.RegisterUsableItem('opium', function(source)
	local xPlayer  = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('opium', 1)

	TriggerClientEvent('fl_basicneeds:opium', source)
    TriggerClientEvent('esx:showNotification', source, 'Vous avez pris de l\'~g~opium~s~')
end)

ESX.RegisterUsableItem('weed', function(source)
	local xPlayer  = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('weed', 1)

	TriggerClientEvent('fl_basicneeds:weed', source)
    TriggerClientEvent('esx:showNotification', source, 'Vous avez pris de la ~g~Weed~s~')
end)

ESX.RegisterUsableItem('shit', function(source)
	local xPlayer  = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('shit', 1)

	TriggerClientEvent('fl_basicneeds:shit', source)
    TriggerClientEvent('esx:showNotification', source, 'Vous avez pris du ~g~Shit~s~')
end)

ESX.RegisterUsableItem('poison', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('poison', 1)

	TriggerClientEvent('fl_status:remove', source, 'prevHealth', -100000)
	TriggerClientEvent('esx:showNotification', source, 'Vous avez ~r~ingérez du poison~s~ !')
end)
