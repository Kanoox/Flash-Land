local Categories = {}
local Vehicles = {}

Citizen.CreateThread(function()
	local char = Config.PlateLetters
	char = char + Config.PlateNumbers
	if Config.PlateUseSpace then char = char + 1 end

	if char > 8 then
		print(('fl_sixt: ^1WARNING^7 plate character count reached, %s/8 characters.'):format(char))
	end
end)

function RemoveOwnedVehicle(plate)
	MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	})
end

MySQL.ready(function()
	Categories = MySQL.Sync.fetchAll('SELECT * FROM sixt_vehicle_categories')
	local vehicles = MySQL.Sync.fetchAll('SELECT * FROM sixt_vehicles')

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
	TriggerClientEvent('fl_sixt:sendCategories', -1, Categories)
	TriggerClientEvent('fl_sixt:sendVehicles', -1, Vehicles)
end)

RegisterNetEvent('fl_sixt:setVehicleOwned')
AddEventHandler('fl_sixt:setVehicleOwned', function (vehicleProps)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, job) VALUES (@owner, @plate, @vehicle, NULL)',
	{
		['@owner'] = xPlayer.discord,
		['@plate'] = vehicleProps.plate,
		['@vehicle'] = json.encode(vehicleProps),
	}, function (rowsChanged)
		TriggerClientEvent('esx:showNotification', _source, _U('vehicle_belongs', vehicleProps.plate))
	end)
end)

RegisterNetEvent('fl_sixt:setVehicleOwnedPlayerId')
AddEventHandler('fl_sixt:setVehicleOwnedPlayerId', function (playerId, vehicleProps)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, job) VALUES (@owner, @plate, @vehicle, NULL)',
	{
		['@owner'] = xPlayer.discord,
		['@plate'] = vehicleProps.plate,
		['@vehicle'] = json.encode(vehicleProps),
	}, function (rowsChanged)
		TriggerClientEvent('esx:showNotification', playerId, _U('vehicle_belongs', vehicleProps.plate))
	end)
end)

RegisterNetEvent('fl_sixt:setVehicleOwnedSociety')
AddEventHandler('fl_sixt:setVehicleOwnedSociety', function (society, vehicleProps)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)',
	{
		['@owner'] = 'society:' .. society,
		['@plate'] = vehicleProps.plate,
		['@vehicle'] = json.encode(vehicleProps),
	}, function (rowsChanged)

	end)
end)

RegisterNetEvent('fl_sixt:sellVehicle')
AddEventHandler('fl_sixt:sellVehicle', function (vehicle)
	MySQL.Async.fetchAll('SELECT * FROM sixt_current_vehicles WHERE vehicle = @vehicle LIMIT 1', {
		['@vehicle'] = vehicle
	}, function (result)
		local id = result[1].id

		MySQL.Async.execute('DELETE FROM sixt_current_vehicles WHERE id = @id', {
			['@id'] = id
		})
	end)
end)

RegisterNetEvent('fl_sixt:rentVehicle')
AddEventHandler('fl_sixt:rentVehicle', function (vehicle, plate, basePrice, rentPrice, target)
	local xPlayer = ESX.GetPlayerFromId(target)

	MySQL.Async.fetchAll('SELECT * FROM sixt_current_vehicles WHERE vehicle = @vehicle LIMIT 1', {
		['@vehicle'] = vehicle
	}, function (result)
		local id = result[1].id
		local price = result[1].price
		local owner = xPlayer.discord

		MySQL.Async.execute('DELETE FROM sixt_current_vehicles WHERE id = @id', {
			['@id'] = id
		})

		MySQL.Async.execute('INSERT INTO sixt_rented_vehicles (vehicle, plate, firstname, lastname, base_price, rent_price, owner) VALUES (@vehicle, @plate, @firstname, @lastname, @base_price, @rent_price, @owner)',
		{
			['@vehicle'] = vehicle,
			['@plate'] = plate,
			['@firstname'] = xPlayer.firstname,
			['@lastname'] = xPlayer.lastname,
			['@base_price'] = basePrice,
			['@rent_price'] = rentPrice,
			['@owner'] = owner
		})
	end)
end)

ESX.RegisterServerCallback('fl_sixt:getCategories', function(xPlayer, source, cb)
	cb(Categories)
end)

ESX.RegisterServerCallback('fl_sixt:getVehicles', function(xPlayer, source, cb)
	cb(Vehicles)
end)

ESX.RegisterServerCallback('fl_sixt:buyVehicle', function(xPlayer, source, cb, vehicleModel)
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

ESX.RegisterServerCallback('fl_sixt:buyVehicleSociety', function(xPlayer, source, cb, society, vehicleModel)
	local vehicleData = nil

	for i=1, #Vehicles, 1 do
		if Vehicles[i].model == vehicleModel then
			vehicleData = Vehicles[i]
			break
		end
	end

	TriggerEvent('fl_data:getSharedAccount', 'society_' .. society, function (account)
		if account.money >= vehicleData.price then
			account.removeMoney(vehicleData.price)

			MySQL.Async.execute('INSERT INTO sixt_current_vehicles (vehicle, price) VALUES (@vehicle, @price)', {
				['@vehicle'] = vehicleData.model,
				['@price'] = vehicleData.price
			}, function(rowsChanged)
				cb(true)
			end)

		else
			cb(false)
		end
	end)
end)

ESX.RegisterServerCallback('fl_sixt:getCommercialVehicles', function(xPlayer, source, cb)
	MySQL.Async.fetchAll('SELECT * FROM sixt_current_vehicles ORDER BY vehicle ASC', {}, function (result)
		local vehicles = {}

		for i=1, #result, 1 do
			table.insert(vehicles, {
				name = result[i].vehicle,
				price = result[i].price
			})
		end

		cb(vehicles)
	end)
end)


RegisterNetEvent('fl_sixt:returnProvider')
AddEventHandler('fl_sixt:returnProvider', function(vehicleModel)
	local _source = source

	MySQL.Async.fetchAll('SELECT * FROM sixt_current_vehicles WHERE vehicle = @vehicle LIMIT 1', {
		['@vehicle'] = vehicleModel
	}, function (result)

		if result[1] then
			local id = result[1].id
			local price = ESX.Math.Round(result[1].price * 0.75)

			TriggerEvent('fl_data:getSharedAccount', 'society_sixt', function(account)
				account.addMoney(price)
			end)

			MySQL.Async.execute('DELETE FROM sixt_current_vehicles WHERE id = @id', {
				['@id'] = id
			})

			TriggerClientEvent('esx:showNotification', _source, _U('sixt_vehicle_sold_for', vehicleModel, ESX.Math.GroupDigits(price)))
		else

			print(('fl_sixt: %s attempted selling an invalid vehicle!'):format(GetPlayerIdentifiers(_source)[1]))
		end

	end)
end)

ESX.RegisterServerCallback('fl_sixt:getRentedVehicles', function(xPlayer, source, cb)
	MySQL.Async.fetchAll('SELECT * FROM sixt_rented_vehicles ORDER BY firstname ASC', {}, function (result)
		local vehicles = {}

		for i=1, #result, 1 do
			table.insert(vehicles, {
				name = result[i].vehicle,
				plate = result[i].plate,
				firstname = result[i].firstname,
				lastname = result[i].lastname,
			})
		end

		cb(vehicles)
	end)
end)

ESX.RegisterServerCallback('fl_sixt:giveBackVehicle', function(xPlayer, source, cb, plate)
	MySQL.Async.fetchAll('SELECT * FROM sixt_rented_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function (result)
		if result[1] ~= nil then
			local vehicle = result[1].vehicle
			local basePrice = result[1].base_price

			MySQL.Async.execute('INSERT INTO sixt_current_vehicles (vehicle, price) VALUES (@vehicle, @price)', {
				['@vehicle'] = vehicle,
				['@price'] = basePrice
			})

			MySQL.Async.execute('DELETE FROM sixt_rented_vehicles WHERE plate = @plate', {
				['@plate'] = plate
			})

			RemoveOwnedVehicle(plate)
			cb(true)
		else
			cb(false)
		end
	end)
end)

ESX.RegisterServerCallback('fl_sixt:isPlateTaken', function(xPlayer, source, cb, plate)
	MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function (result)
		cb(result[1] ~= nil)
	end)
end)

ESX.RegisterServerCallback('fl_sixt:retrieveJobVehicles', function(xPlayer, source, cb, type)
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND type = @type AND job = @job', {
		['@owner'] = xPlayer.discord,
		['@type'] = type,
		['@job'] = xPlayer.job.name
	}, function (result)
		cb(result)
	end)
end)

RegisterNetEvent('fl_sixt:setJobVehicleState')
AddEventHandler('fl_sixt:setJobVehicleState', function(plate, state)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = @stored WHERE plate = @plate AND job = @job', {
		['@stored'] = state,
		['@plate'] = plate,
		['@job'] = xPlayer.job.name
	}, function(rowsChanged)
		if rowsChanged == 0 then
			print(('fl_sixt: %s exploited the garage!'):format(xPlayer.discord))
		end
	end)
end)

function PayRent(d, h, m)
	MySQL.Async.fetchAll('SELECT * FROM sixt_rented_vehicles', {}, function (result)
		for i=1, #result, 1 do
			local xPlayer = ESX.GetPlayerFromDiscordIdentifier(result[i].owner)

			-- message player if connected
			if xPlayer ~= nil then
				xPlayer.removeAccountMoney('bank', result[i].rent_price)
				xPlayer.showNotification(_U('paid_rental', ESX.Math.GroupDigits(result[i].rent_price)))
			else -- pay rent either way
				MySQL.Async.fetchAll('SELECT accounts FROM users WHERE discord LIKE @discord', {
					['@discord'] = result[i].owner,
				}, function(accountResult)
					if #accountResult ~= 1 then return end
					local accounts = json.decode(accountResult[1].accounts)
					accounts['bank'] = accounts['bank'] - result[i].rent_price
					MySQL.Async.execute('UPDATE users SET accounts = @accounts WHERE discord = @discord', {
						['@accounts'] = json.encode(accounts),
						['@discord'] = result[i].owner
					})
				end)
			end

			TriggerEvent('fl_data:getSharedAccount', 'society_sixt', function(account)
				account.addMoney(result[i].rent_price)
			end)
		end
	end)
end

TriggerEvent('cron:runAt', 22, 00, PayRent)