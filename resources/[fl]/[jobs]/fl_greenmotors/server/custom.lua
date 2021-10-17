local Vehicles = nil

RegisterNetEvent('fl_greenmotors:buyMod')
AddEventHandler('fl_greenmotors:buyMod', function(price)
	local xPlayer = ESX.GetPlayerFromId(source)
	price = tonumber(price)

	TriggerEvent('fl_data:getSharedAccount', 'society_greenmotors', function(societyAccount)
		if price < societyAccount.money then
			TriggerClientEvent('fl_greenmotors:installMod', xPlayer.source)
			xPlayer.showNotification('Achat effectué $' .. tostring(price))
			societyAccount.removeMoney(price)
		else
			TriggerClientEvent('fl_greenmotors:cancelInstallMod', xPlayer.source)
			xPlayer.showNotification('Vous n\'avez pas assez d\'argent !')
		end
	end)
end)

RegisterNetEvent('fl_greenmotors:refreshOwnedVehicle')
AddEventHandler('fl_greenmotors:refreshOwnedVehicle', function(myCar)
	MySQL.Async.execute('UPDATE `owned_vehicles` SET `vehicle` = @vehicle WHERE `plate` = @plate',
	{
		['@plate'] = myCar.plate,
		['@vehicle'] = json.encode(myCar)
	})
end)

ESX.RegisterServerCallback('fl_greenmotors:getVehiclesPrices', function(xPlayer, source, cb)
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