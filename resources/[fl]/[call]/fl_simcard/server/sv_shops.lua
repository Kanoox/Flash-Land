RegisterNetEvent('fl_simcard:buySimcard')
AddEventHandler('fl_simcard:buySimcard', function(type, payingCash)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not Config.Sims[type].Prefix then
		error('Cannot buy a recharge on buySimcard')
		return
	end

	local simcards = GetSimcards(source)

	if Config.Sims[type].DaySubscription and #simcards >= Config.MaxSubscription then
		local nbSubscription = 0
		for _,AnySimCard in pairs(simcards) do
			if Config.Sims[AnySimCard.type].DaySubscription then
				nbSubscription = nbSubscription +1
			end
		end
		if nbSubscription >= Config.MaxSubscription then
			xPlayer.showNotification('~r~Impossible d\'avoir plus de '..Config.MaxSubscription..' abonnements à son nom...')
			return
		end
	end

	if payingCash and xPlayer.getMoney() < Config.Sims[type].OneTimeBuy then
		xPlayer.showNotification("Vous n'avez pas assez ~r~de cash")
		return
	end

	if not payingCash and xPlayer.getBank() < Config.Sims[type].OneTimeBuy then
		xPlayer.showNotification("Carte bancaire ~r~refusée")
		return
	end


	local number = GetAvailablePhoneNumber(Config.Sims[type].Prefix)
	local usingIdentifier = xPlayer.discord
	if payingCash then
		if not Config.Sims[type].DaySubscription then
			usingIdentifier = nil
		end
		xPlayer.removeMoney(Config.Sims[type].OneTimeBuy)
	else
		xPlayer.removeBank(Config.Sims[type].OneTimeBuy)
	end

	CreateNewSim(usingIdentifier, type, number)
	xPlayer.addInventoryItem(Config.ItemPrefix..number, 1)
	xPlayer.showNotification('Vous avez acheté ~g~' .. Config.Sims[type].Name .. '~w~ avec le numéro ~b~' .. number)
end)

RegisterNetEvent('fl_simcard:buyPhone')
AddEventHandler('fl_simcard:buyPhone', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local PhoneItem = xPlayer.getInventoryItem('phone')

	if not xPlayer.canCarryItem(PhoneItem.name, 1) then
		xPlayer.showNotification("Vous n'avez pas assez de ~r~place !")
		return
	end

	if xPlayer.getMoney() >= Config.PhonePrice then
		xPlayer.removeMoney(Config.PhonePrice)
		xPlayer.addInventoryItem('phone', 1)

		xPlayer.showNotification("Vous avez acheté un ~g~Portable")
	else
		xPlayer.showNotification("Vous n'avez pas assez ~r~d'argent")
	end
end)

RegisterNetEvent('fl_simcard:buyGps')
AddEventHandler('fl_simcard:buyGps', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local GpsItem = xPlayer.getInventoryItem('gps')

	if not xPlayer.canCarryItem(GpsItem.name, 1) then
		xPlayer.showNotification("Vous n'avez pas assez de ~r~place !")
		return
	end

	if xPlayer.getMoney() >= Config.GpsPrice then
		xPlayer.removeMoney(Config.GpsPrice)
		xPlayer.addInventoryItem('gps', 1)

		xPlayer.showNotification("Vous avez acheté un ~g~GPS")
	else
		xPlayer.showNotification("Vous n'avez pas assez ~r~d'argent")
	end
end)