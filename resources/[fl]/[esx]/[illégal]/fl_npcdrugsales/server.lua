local selling = {}

RegisterNetEvent('fl_npcdrugsales:trigger')
AddEventHandler('fl_npcdrugsales:trigger', function()
	selling[source] = true
	TriggerClientEvent('esx:showNotification', source, "Vous essayez de convaincre la personne d'acheter le produit...")
end)

RegisterNetEvent('fl_npcdrugsales:sell')
AddEventHandler('fl_npcdrugsales:sell', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	if not selling[xPlayer.source] then
		return
	end

	local meth = xPlayer.getInventoryItem('meth_pooch').count
	local coke = xPlayer.getInventoryItem('coke_pooch').count
	local weed = xPlayer.getInventoryItem('weed_pooch').count
	local shit = xPlayer.getInventoryItem('shit_pooch').count

	if meth <= 0 and coke <= 0 and weed <= 0 and shit <= 0 then
		TriggerClientEvent('esx:showNotification', source, "Vous n'avez pas de drogue")
		return
	end

	local percent = math.random(1, 100)
	local success = false
	local copscalled = false
	local notintrested = false

	if percent <= 40 then --40% non vendu
		success = false
		notintrested = true
	elseif percent >= 45 then -- 55% vendu
		success = true
		notintrested = false
	else -- 5% Police
		notintrested = false
		success = false
		copscalled = true
	end

	local cops = 0
	local xPlayers = ESX.GetPlayers()
	for i = 1, #xPlayers do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			cops = cops + 1
		end
	end

	if cops <= 1 then
		success = false
		notintrested = true
	end

	if coke >= 1 and success then
		local paymentc = math.random(Config.SellPrices['coke'].min, Config.SellPrices['coke'].max)
		TriggerClientEvent('esx:showNotification', source, "Vous avez vendu de la cocaïne pour ~g~$" .. paymentc)
		TriggerClientEvent("animation", source)
		xPlayer.removeInventoryItem('coke_pooch', 1)
		xPlayer.addAccountMoney('black_money', paymentc)
	elseif weed >= 1 and success then
		local paymentw = math.random(Config.SellPrices['weed'].min, Config.SellPrices['weed'].max)
		TriggerClientEvent('esx:showNotification', source, "Vous avez vendu de la weed pour ~g~$" .. paymentw)
		TriggerClientEvent("animation", source)
		xPlayer.removeInventoryItem('weed_pooch', 1)
		xPlayer.addAccountMoney('black_money', paymentw)
	elseif shit >= 1 and success then
		local payments = math.random(Config.SellPrices['shit'].min, Config.SellPrices['shit'].max)
		TriggerClientEvent('esx:showNotification', source, "Vous avez vendu du shit pour ~g~$" .. payments)
		TriggerClientEvent("animation", source)
		xPlayer.removeInventoryItem('shit_pooch', 1)
		xPlayer.addAccountMoney('black_money', payments)
	elseif meth >= 1 and success then
		local paymentm = math.random(Config.SellPrices['meth'].min, Config.SellPrices['meth'].max)
		TriggerClientEvent('esx:showNotification', source, "Vous avez vendu de la meth pour ~g~$" .. paymentm)
		TriggerClientEvent("animation", source)
		xPlayer.removeInventoryItem('meth_pooch', 1)
		xPlayer.addAccountMoney('black_money', paymentm)
	elseif not success and notintrested then
		TriggerClientEvent('esx:showNotification', source, "Je ne suis pas intéressé.")
	elseif copscalled and not success then
		TriggerClientEvent('esx:showNotification', source, "~r~Il appel les flics !")
		TriggerClientEvent("fl_npcdrugsales:notifyCops", source)
	end
	selling[xPlayer.source] = false
end)
