local Vehicles = nil

RegisterNetEvent('fl_lscustom:buyMod')
AddEventHandler('fl_lscustom:buyMod', function(price)
	local xPlayer = ESX.GetPlayerFromId(source)
	price = tonumber(price)

	TriggerEvent('fl_data:getSharedAccount', 'society_bennys', function(societyAccount)
		if price < societyAccount.money then
			TriggerClientEvent('fl_lscustom:installMod', xPlayer.source)
			xPlayer.showNotification('Achat effectué $' .. tostring(price))
			societyAccount.removeMoney(price)
		else
			TriggerClientEvent('fl_lscustom:cancelInstallMod', xPlayer.source)
			xPlayer.showNotification('Vous n\'avez pas assez d\'argent !')
		end
	end)
end)

RegisterNetEvent('fl_lscustom:buyModMechanic')
AddEventHandler('fl_lscustom:buyModMechanic', function(price)
	local xPlayer = ESX.GetPlayerFromId(source)
	price = tonumber(price)

	TriggerEvent('fl_data:getSharedAccount', 'society_mechanic', function(societyAccount)
		if price < societyAccount.money then
			TriggerClientEvent('fl_lscustom:installMod', xPlayer.source)
			xPlayer.showNotification('Achat effectué $' .. tostring(price))
			societyAccount.removeMoney(price)
		else
			TriggerClientEvent('fl_lscustom:cancelInstallMod', xPlayer.source)
			xPlayer.showNotification('Vous n\'avez pas assez d\'argent !')
		end
	end)
end)

RegisterNetEvent('fl_lscustom:refreshOwnedVehicle')
AddEventHandler('fl_lscustom:refreshOwnedVehicle', function(myCar)
	MySQL.Async.execute('UPDATE `owned_vehicles` SET `vehicle` = @vehicle WHERE `plate` = @plate',
	{
		['@plate'] = myCar.plate,
		['@vehicle'] = json.encode(myCar)
	})
end)

ESX.RegisterServerCallback('fl_lscustom:getVehiclesPrices', function(xPlayer, source, cb)
	if Vehicles == nil then
		MySQL.Async.fetchAll('SELECT * FROM vehicles', {}, function(result)
			local vehicles = {}

			for i=1, #result, 1 do
				table.insert(vehicles, {
					model = result[i].model,
					price = result[i].price
				})
			end

			Vehicles = vehicles
			cb(Vehicles)
		end)
	else
		cb(Vehicles)
	end
end)