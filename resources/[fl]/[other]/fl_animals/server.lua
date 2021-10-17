ESX.RegisterServerCallback('fl_animals:getPet', function(xPlayer, source, cb)
	MySQL.Async.fetchAll('SELECT pet FROM users WHERE discord = @discord', {
		['@discord'] = xPlayer.discord
	}, function(result)
		if result[1].pet ~= nil then
			cb(result[1].pet)
		else
			cb('')
		end
	end)
end)

RegisterServerEvent('fl_animals:petDied')
AddEventHandler('fl_animals:petDied', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE users SET pet = "(NULL)" WHERE discord = @discord', {
		['@discord'] = xPlayer.discord
	})
end)

RegisterServerEvent('fl_animals:consumePetFood')
AddEventHandler('fl_animals:consumePetFood', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('croquettes', 1)
end)

ESX.RegisterServerCallback('fl_animals:buyPet', function(xPlayer, source, cb, pet)
	local price = GetPriceFromPet(pet)

	if price == 0 then
		print(('fl_animals: %s attempted to buy an invalid pet!'):format(xPlayer.discord))
		cb(false)
	end

	if xPlayer.getMoney() >= price then
		xPlayer.removeMoney(price)

		MySQL.Async.execute('UPDATE users SET pet = @pet WHERE discord = @discord', {
			['@discord'] = xPlayer.discord,
			['@pet'] = pet
		}, function(rowsChanged)
			xPlayer.showNotification(_U('you_bought', pet, ESX.Math.GroupDigits(price)))
			cb(true)
		end)
	else
		TriggerClientEvent('esx:showNotification', source, _U('your_poor'))
		cb(false)
	end
end)

function GetPriceFromPet(pet)
	for i=1, #Config.PetShop, 1 do
		if Config.PetShop[i].pet == pet then
			return Config.PetShop[i].price
		end
	end

	return 0
end