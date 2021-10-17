MySQL.ready(function()
	MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = true WHERE `stored` = @stored', {
		['@stored'] = false,
	}, function(rowsChanged)
		if rowsChanged > 0 then
			print(('fl_advancedgarage: %s vehicle(s) have been stored!'):format(rowsChanged))
		end
	end)
end)

local outVehicles = {}
local requestedVehicles = {}

Citizen.CreateThread(function()
	Citizen.Wait(5 * 1000)
	while true do
		local allVehicles = GetAllVehicles()
		local xPlayers = ESX.GetAllPlayers()
		requestedVehicles = {}

		for _, anyVehicle in pairs(allVehicles) do
			local isInterestingVehicle = false
			if DoesEntityExist(anyVehicle) then
				local anyPlate = GetVehicleNumberPlateText(anyVehicle)
				for _,vehiclePlate in pairs(outVehicles) do
					if anyPlate == vehiclePlate or anyPlate == vehiclePlate .. ' ' then -- broken GetVehicleNumberPlateText returning with space
						anyPlate = vehiclePlate
						isInterestingVehicle = true
					end
				end

				if isInterestingVehicle then
					local vehicleCoords = GetEntityCoords(anyVehicle)
					local anyVehicleNetId = NetworkGetNetworkIdFromEntity(anyVehicle)

					local closestXPlayer = nil
					local closestDist = math.huge

					for _,xPlayer in pairs(xPlayers) do
						local dist = #(xPlayer.getCoords(true) - vehicleCoords)

						if dist < closestDist then
							closestDist = dist
							closestXPlayer = xPlayer
						end
					end

					table.insert(requestedVehicles, {target = closestXPlayer.source, plate = anyPlate})
					closestXPlayer.triggerEvent('fl_advancedgarage:requestVehicleState', anyVehicleNetId)
				end
			end
			Citizen.Wait(10)
		end

		Citizen.Wait(5 * 60 * 1000)
	end
end)

RegisterNetEvent('fl_advancedgarage:responseVehicleState')
AddEventHandler('fl_advancedgarage:responseVehicleState', function(vehicleState)
	local wasWaitingForAnswer = false

	for _, anyRequested in pairs(requestedVehicles) do
		if anyRequested.plate == vehicleState.plate and anyRequested.target == source then
			wasWaitingForAnswer = true
		end
	end

	if not wasWaitingForAnswer then
		print('Wasn\'t waiting for answer of ' .. tostring(source))
		return
	end

	MySQL.Async.execute('UPDATE owned_vehicles SET vehicle = @vehicle WHERE plate = @plate', {
		['@vehicle'] = json.encode(vehicleState),
		['@plate'] = vehicleState.plate,
	}, function (rowsChanged)
		if rowsChanged ~= 1 then error('??? : ' .. tostring(rowsChanged)) end
	end)
end)

ESX.RegisterServerCallback('fl_advancedgarage:getOwned', function(xPlayer, source, cb, type)
	local owned = {}

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job IS NULL AND `stored` = @stored', {
		['@owner'] = xPlayer.discord,
		['@Type'] = type,
		['@stored'] = true,
	}, function(data)
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(owned, {vehicle = vehicle, stored = v.stored, plate = v.plate})
		end
		cb(owned)
	end)
end)

ESX.RegisterServerCallback('fl_advancedgarage:storeVehicle', function(xPlayer, source, cb, vehicleProps)
	local ownedCars = {}

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND @plate = plate', {
		['@owner'] = xPlayer.discord,
		['@plate'] = vehicleProps.plate,
	}, function (result)
		if result[1] == nil then
			xPlayer.showNotification("~r~Ce n'est pas votre véhicule...")
			print(('fl_advancedgarage: %s attempted to store an vehicle they don\'t own! (%s)'):format(xPlayer.discord, vehicleProps.plate))
			cb(false)
			return
		end

		local originalvehprops = json.decode(result[1].vehicle)
		if originalvehprops.model == vehicleProps.model then
			for i, vehiclePlate in pairs(outVehicles) do
				if vehiclePlate == vehicleProps.model then
					table.remove(outVehicles, i)
				end
			end

			MySQL.Async.execute('UPDATE owned_vehicles SET vehicle = @vehicle, stored = @stored WHERE owner = @owner AND plate = @plate', {
				['@owner'] = xPlayer.discord,
				['@vehicle'] = json.encode(vehicleProps),
				['@stored'] = true,
				['@plate'] = vehicleProps.plate,
			}, function (rowsChanged)
				if rowsChanged == 0 then
					xPlayer.showNotification("~r~Ce n'est pas votre véhicule... (#123)")
					print(('fl_advancedgarage: %s attempted to store an vehicle they don\'t own! (%s)'):format(xPlayer.discord, vehicleProps.plate))
				end
				cb(true)
			end)
		else
			print(('fl_advancedgarage: %s attempted to Cheat! Tried Storing: '..vehicleProps.model..'. Original Vehicle: '..originalvehprops.model):format(xPlayer.discord))
			DropPlayer(source, 'You have been Kicked from the Server for Possible Garage Cheating!!!')
			cb(false)
		end
	end)
end)

ESX.RegisterServerCallback('fl_advancedgarage:getOutOwned', function(xPlayer, source, cb, type)
	local owned = {}

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job IS NULL AND `stored` = @stored', {
		['@owner'] = xPlayer.discord,
		['@Type'] = type,
		['@stored'] = false,
	}, function(data)
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(owned, vehicle)
		end
		cb(owned)
	end)
end)

ESX.RegisterServerCallback('fl_advancedgarage:checkMoney', function(xPlayer, source, cb, type)
	cb(xPlayer.getMoney() >= Config.PoundPrice[type])
end)

RegisterNetEvent('fl_advancedgarage:pay')
AddEventHandler('fl_advancedgarage:pay', function(type)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeMoney(Config.PoundPrice[type])
	TriggerEvent('fl_data:getSharedAccount', 'society_mechanic', function(account)
		account.addMoney(Config.PoundPrice[type])
	end)
	TriggerClientEvent('esx:showNotification', source, 'Vous avez payé $' .. Config.PoundPrice[type])
end)

RegisterNetEvent('fl_advancedgarage:setVehicleState')
AddEventHandler('fl_advancedgarage:setVehicleState', function(plate)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = @stored WHERE plate = @plate', {
		['@stored'] = false,
		['@plate'] = plate,
	}, function(rowsChanged)
		if rowsChanged == 0 then
			print(('fl_advancedgarage: %s exploited the garage!'):format(xPlayer.discord))
		elseif rowsChanged == 1 then
			table.insert(outVehicles, plate)
		else
			error('????')
		end
	end)
end)