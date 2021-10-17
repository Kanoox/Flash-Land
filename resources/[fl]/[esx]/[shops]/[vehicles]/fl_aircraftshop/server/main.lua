local Categories = {}
local Vehicles = {}

Citizen.CreateThread(function()
	local char = Config.PlateLetters
	char = char + Config.PlateNumbers
	if Config.PlateUseSpace then char = char + 1 end

	if char > 8 then
		print(('fl_aircraftshop: ^1WARNING^7 plate character count reached, %s/8 characters.'):format(char))
	end
end)

function RemoveOwnedVehicle(plate)
	MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	})
end

MySQL.ready(function()
	Categories = MySQL.Sync.fetchAll('SELECT * FROM aircraft_categories')
	local vehicles = MySQL.Sync.fetchAll('SELECT * FROM aircrafts')

	for i=1, #vehicles, 1 do
		local vehicle = vehicles[i]

		for j=1, #Categories, 1 do
			if Categories[j].name == vehicle.category then
				vehicle.categoryLabel = Categories[j].label
				break
			end
		end

		table.insert(Vehicles, vehicle)
	end

	-- send information after db has loaded, making sure everyone gets vehicle information
	TriggerClientEvent('fl_aircraftshop:sendCategories', -1, Categories)
	TriggerClientEvent('fl_aircraftshop:sendVehicles', -1, Vehicles)
end)

ESX.RegisterServerCallback('fl_aircraftshop:buyLicense', function(xPlayer, source, cb)
	if xPlayer.getMoney() >= Config.LicensePrice then
		xPlayer.removeMoney(Config.LicensePrice)

		TriggerEvent('fl_license:addLicense', source, 'aircraft', function()
			cb(true)
		end)
	else
		TriggerClientEvent('esx:showNotification', source, _U('not_enough_money'))
		cb(false)
	end
end)

RegisterNetEvent('fl_aircraftshop:setVehicleOwned')
AddEventHandler('fl_aircraftshop:setVehicleOwned', function(vehicleProps)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, type) VALUES (@owner, @plate, @vehicle, @type)',
	{
		['@owner'] = xPlayer.discord,
		['@plate'] = vehicleProps.plate,
		['@vehicle'] = json.encode(vehicleProps),
		['@type'] = 'aircraft',
	}, function(rowsChanged)
		if rowsChanged == 1 then
			xPlayer.showNotification(_U('aircraft_belongs', vehicleProps.plate))
		else
			xPlayer.showNotification('~r~Une erreur est survenue ...(' .. tostring(rowsChanged) .. ')')
		end
	end)
end)

ESX.RegisterServerCallback('fl_aircraftshop:getCategories', function(xPlayer, source, cb)
	cb(Categories)
end)

ESX.RegisterServerCallback('fl_aircraftshop:getVehicles', function(xPlayer, source, cb)
	cb(Vehicles)
end)

ESX.RegisterServerCallback('fl_aircraftshop:buyVehicle', function(xPlayer, source, cb, vehicleModel)
	local vehicleData = nil

	for i=1, #Vehicles, 1 do
		if Vehicles[i].model == vehicleModel then
			vehicleData = Vehicles[i]
			break
		end
	end

	if xPlayer.getMoney() >= vehicleData.price then
		xPlayer.removeMoney(vehicleData.price)
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('fl_aircraftshop:resellVehicle', function(xPlayer, source, cb, plate, model)
	local resellPrice = 0

	-- calculate the resell price
	for i=1, #Vehicles, 1 do
		if GetHashKey(Vehicles[i].model) == model then
			resellPrice = ESX.Math.Round(Vehicles[i].price / 100 * Config.ResellPercentage)
			break
		end
	end

	if resellPrice == 0 then
		print(('fl_aircraftshop: %s attempted to sell an unknown vehicle!'):format(xPlayer.discord))
		cb(false)
	end

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND @plate = plate', {
		['@owner'] = xPlayer.discord,
		['@plate'] = plate
	}, function(result)
		if result[1] then -- does the owner match?
			local vehicle = json.decode(result[1].vehicle)
			if vehicle.model == model then
				if vehicle.plate == plate then
					xPlayer.addMoney(resellPrice)
					RemoveOwnedVehicle(plate)
					cb(true)
				else
					print(('fl_aircraftshop: %s attempted to sell an vehicle with plate mismatch!'):format(xPlayer.discord))
					cb(false)
				end
			else
				print(('fl_aircraftshop: %s attempted to sell an vehicle with model mismatch!'):format(xPlayer.discord))
				cb(false)
			end
		else
			cb(false)
		end
	end)
end)

ESX.RegisterServerCallback('fl_aircraftshop:isPlateTaken', function(xPlayer, source, cb, plate)
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		cb(result[1] ~= nil)
	end)
end)

ESX.RegisterServerCallback('fl_aircraftshop:retrieveJobVehicles', function(xPlayer, source, cb, type)
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND type = @type AND job = @job', {
		['@owner'] = xPlayer.discord,
		['@type'] = type,
		['@job'] = xPlayer.job.name
	}, function(result)
		cb(result)
	end)
end)

RegisterNetEvent('fl_aircraftshop:setJobVehicleState')
AddEventHandler('fl_aircraftshop:setJobVehicleState', function(plate, state)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = @stored WHERE plate = @plate AND job = @job', {
		['@stored'] = state,
		['@plate'] = plate,
		['@job'] = xPlayer.job.name
	}, function(rowsChanged)
		if rowsChanged == 0 then
			print(('fl_aircraftshop: %s exploited the garage!'):format(xPlayer.discord))
		end
	end)
end)