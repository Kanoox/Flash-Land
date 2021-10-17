RegisterNetEvent('fl_simcard:buySubscription')
AddEventHandler('fl_simcard:buySubscription', function(type)
	local xPlayer = ESX.GetPlayerFromId(source)

	local simcards = GetSimcards(source)

	if #simcards >= 2 then
		xPlayer.showNotification('~r~~h~VERSION DE TEST !')
		xPlayer.showNotification('~r~Durant cette période de test, vous êtes limités à 2 abonnements maximum...')
		return
	end

	if xPlayer.getMoney() >= 10000 then
		xPlayer.removeMoney(10000)

		local number = GetAvailablePhoneNumber()

		CreateNewSim(xPlayer.discord, 0, number)
		xPlayer.addInventoryItem(Config.ItemPrefix..number, 1)
		xPlayer.showNotification('Vous avez acheté une ~g~Carte Sim Illimité~w~ avec le numéro ~b~' .. number)
	else
		xPlayer.showNotification("Vous n'avez pas assez ~r~d'argent")
	end
end)

RegisterNetEvent('fl_simcard:buyPhone')
AddEventHandler('fl_simcard:buyPhone', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local PhoneItem = xPlayer.getInventoryItem('phone')

	if PhoneItem.count >= PhoneItem.limit then
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

	if GpsItem.count >= GpsItem.limit then
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