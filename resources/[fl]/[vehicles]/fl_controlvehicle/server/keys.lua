MySQL.ready(function()
	MySQL.Async.execute('DELETE FROM vehicle_keys WHERE NB = @NB AND TIME < DATE_SUB(NOW(), INTERVAL 14 DAY)', {
		['@NB'] = 2
	})
end)

ESX.RegisterCommand('lock', 'user', function(xPlayer, args, showError)
	xPlayer.triggerEvent('lock')
end, true, {})

ESX.RegisterServerCallback('fl_controlvehicle:myKey', function(xPlayer, source, cb, plate)
	MySQL.Async.fetchAll('SELECT * FROM vehicle_keys WHERE value = @plate AND discord = @discord',{
		['@plate'] = plate,
		['@discord'] = xPlayer.discord
	}, function(result)
		cb(result[1] ~= nil and xPlayer.discord == result[1].discord)
	end)
end)

ESX.RegisterServerCallback('fl_controlvehicle:getAllKeys', function(xPlayer, source, cb)
	MySQL.Async.fetchAll('SELECT * FROM vehicle_keys WHERE discord = @discord', {
		['@discord'] = xPlayer.discord
	}, function(result)
		local key = {}
		for i=1, #result, 1 do
			table.insert(key, {
				plate = result[i].value,
				NB = result[i].NB,
			})
		end
		cb(key)
	end)
end)

RegisterNetEvent('fl_controlvehicle:deleteKeyJobs')
AddEventHandler('fl_controlvehicle:deleteKeyJobs', function(plate, netId)
	if plate == nil then return end
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('DELETE FROM vehicle_keys WHERE NB = 2 AND value = @plate', {
		['@plate']   = plate,
	}, function(changedLines)
		if changedLines == 1 then
			if netId ~= nil then
				local vehicle = NetworkGetEntityFromNetworkId(netId)
				if DoesEntityExist(vehicle) then
					DeleteEntity(vehicle)
				end
			end
			xPlayer.showNotification('~g~Vous avez rendu les clés du véhicule')
		else
			xPlayer.showNotification('~r~Ce véhicule n\'a rien à faire dans ce garage !')
		end
	end)

end)

RegisterNetEvent('fl_controlvehicle:giveKey')
AddEventHandler('fl_controlvehicle:giveKey', function(plate)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('INSERT INTO vehicle_keys (label, value, NB, discord) VALUES (@label, @value, @NB, @discord)', {
		['@label'] = 'Cles',
		['@value'] = plate,
		['@NB'] = 2,
		['@discord'] = xPlayer.discord
	}, function(result)
		xPlayer.showNotification('Vous avez recu un double de clés')
	end)
end)

RegisterNetEvent('fl_controlvehicle:registerKey')
AddEventHandler('fl_controlvehicle:registerKey', function(plate, target)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayerTarget = ESX.GetPlayerFromId(target)

	MySQL.Async.execute('INSERT INTO vehicle_keys (label, value, NB, discord) VALUES (@label, @value, @NB, @discord)', {
		['@label'] = 'Cles',
		['@value'] = plate,
		['@NB'] = 1,
		['@discord'] = xPlayerTarget.discord
	}, function(result)
		xPlayerTarget.showNotification('Vous avez un nouvelle paire de clés !')
		xPlayer.showNotification('Clés bien enregistrée !')
	end)
end)

RegisterNetEvent('fl_controlvehicle:changeOwner')
AddEventHandler('fl_controlvehicle:changeOwner', function(target, plate)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayerTarget = ESX.GetPlayerFromId(target)

	if plate == nil or xPlayerTarget == nil then
		xPlayer.showNotification('~r~??? #6415641')
		return
	end

	MySQL.Async.execute('DELETE FROM vehicle_keys WHERE value = @plate AND discord = @discord', {
		['@plate'] = plate,
		['@discord'] = xPlayer.discord
	})

	MySQL.Async.execute('INSERT INTO vehicle_keys (label, value, NB, discord) VALUES (@label, @value, @NB, @discord)', {
		['@label'] = 'Cles',
		['@value'] = plate,
		['@NB'] = 1,
		['@discord'] = xPlayerTarget.discord,
	})

	MySQL.Async.execute("UPDATE owned_vehicles SET owner=@owner WHERE plate=@plate", {['@owner'] = xPlayerTarget.discord, ['@plate'] = plate})
	MySQL.Async.execute("UPDATE vehicle_keys SET discord=@discord WHERE value=@plate", {['@discord'] = xPlayerTarget.discord, ['@plate'] = plate})

	xPlayerTarget.showNotification('Vous avez reçu de nouvelle clé')
	xPlayer.showNotification('Vous avez donné votre clé')
end)

RegisterNetEvent('fl_controlvehicle:deleteVehicle')
AddEventHandler('fl_controlvehicle:deleteVehicle', function(plate)
	if plate == nil then return end
	MySQL.Async.execute("DELETE FROM owned_vehicles WHERE plate=@plate", {['@plate'] = plate})
	MySQL.Async.execute("DELETE FROM vehicle_keys WHERE value=@plate", {['@plate'] = plate})
end)

RegisterNetEvent('fl_controlvehicle:lendKey')
AddEventHandler('fl_controlvehicle:lendKey', function(target, plate)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayerTarget = ESX.GetPlayerFromId(target)

	MySQL.Async.execute('INSERT INTO vehicle_keys (label, value, NB, discord) VALUES (@label, @value, @NB, @discord)', {
		['@label'] = 'Cles',
		['@value'] = plate,
		['@NB'] = 2,
		['@discord'] = xPlayerTarget.discord
	}, function(result)
		xPlayerTarget.showNotification('Vous avez reçu un double de clé ')
		xPlayer.showNotification('Vous avez prêté votre clé')
	end)
end)