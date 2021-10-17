local Factions = {}

RegisterNetEvent('fl_faction:confiscatePlayerItem')
AddEventHandler('fl_faction:confiscatePlayerItem', function(target, itemType, itemName, amount)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if itemType == 'item_standard' then
		local targetItem = targetXPlayer.getInventoryItem(itemName)

		local label = targetItem.label

		if targetItem.count < amount then
			TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Il~r~n\'a pas autant de ~b~' .. label)
			return
		end

		if not sourceXPlayer.canCarryItem(itemName, amount) then
			TriggerClientEvent('esx:showNotification', sourceXPlayer.source, '~r~Vous n\'avez plus de place...')
			return
		end

		targetXPlayer.removeInventoryItem(itemName, amount)
		sourceXPlayer.addInventoryItem(itemName, amount)

		TriggerClientEvent('esx:showMugshotNotification', sourceXPlayer.source, ' ', ' ', 'Vous avez confisqué ~y~x' .. amount .. ' ' .. label, targetXPlayer.source)
		TriggerClientEvent('esx:showMugshotNotification', targetXPlayer.source, ' ', ' ', '~b~Quelqu\'un~s~ vous a confisqué ~y~x' .. amount .. ' ' .. label, sourceXPlayer.source)
	elseif itemType == 'item_account' then
		if targetXPlayer.getAccount(itemName).money < amount then
			TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Il~r~n\'a pas autant d\'~b~argent...')
			return
		end

		targetXPlayer.removeAccountMoney(itemName, amount)
		sourceXPlayer.addAccountMoney(itemName, amount)

		TriggerClientEvent('esx:showMugshotNotification', sourceXPlayer.source, ' ', ' ', 'Vous avez confisqué ~y~$' .. amount .. '~s~', targetXPlayer.source)
		TriggerClientEvent('esx:showMugshotNotification', targetXPlayer.source, ' ', ' ', '~b~Quelqu\'un~s~ vous a confisqué ~y~$' .. amount, sourceXPlayer.source)
	else
		print('consfiscate an unknown type')
	end
end)

RegisterNetEvent('fl_factions:mowHead')
AddEventHandler('fl_factions:mowHead', function(target)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if sourceXPlayer == nil or targetXPlayer == nil then
		return
	end

	local mowerItem = sourceXPlayer.getInventoryItem('mower')
	if mowerItem == nil or mowerItem.count <= 0 then
		return
	end

	TriggerClientEvent('3dme:triggerDisplay', -1, '*La personne rase le crane*', source)
	TriggerClientEvent('fl_factions:mowMyHead', target)
end)

ESX.RegisterServerCallback('fl_faction:getPlayerInventory', function(xPlayer, source, cb)
	cb({
		items = xPlayer.inventory
	})
end)


for _,Faction in pairs(Config.Factions) do
	TriggerEvent('fl_societyfaction:registerSocietyFaction',
		Faction.Society,
		Faction.Name,
		'society_'..Faction.Society,
		'society_'..Faction.Society,
		'society_'..Faction.Society,
		{})
end
