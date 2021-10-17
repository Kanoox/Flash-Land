local Categories = {}
local Vehicles = {}

Citizen.CreateThread(function()
	local char = Config.PlateLetters
	char = char + Config.PlateNumbers
	if Config.PlateUseSpace then char = char + 1 end

	if char > 8 then
		print(('fl_bikeshop: ^1WARNING^7 plate character count reached, %s/8 characters.'):format(char))
	end
end)

function RemoveOwnedVehicle(plate)
	MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	})
end

MySQL.ready(function()
	Categories = MySQL.Sync.fetchAll('SELECT * FROM bike_categories')
	local vehicles = MySQL.Sync.fetchAll('SELECT * FROM bikes')

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
	TriggerClientEvent('fl_bikeshop:sendCategories', -1, Categories)
	TriggerClientEvent('fl_bikeshop:sendVehicles', -1, Vehicles)
end)

RegisterNetEvent('fl_bikeshop:setVehicleOwned')
AddEventHandler('fl_bikeshop:setVehicleOwned', function (vehicleProps)
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

RegisterNetEvent('fl_bikeshop:setVehicleOwnedPlayerId')
AddEventHandler('fl_bikeshop:setVehicleOwnedPlayerId', function (playerId, vehicleProps)
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

RegisterNetEvent('fl_bikeshop:setVehicleOwnedSociety')
AddEventHandler('fl_bikeshop:setVehicleOwnedSociety', function (society, vehicleProps)
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

RegisterNetEvent('fl_bikeshop:sellVehicle')
AddEventHandler('fl_bikeshop:sellVehicle', function (vehicle)
	MySQL.Async.fetchAll('SELECT * FROM bikedealer_vehicles WHERE vehicle = @vehicle LIMIT 1', {
		['@vehicle'] = vehicle
	}, function (results)
		for _,result in pairs(results) do
			MySQL.Async.execute('DELETE FROM bikedealer_vehicles WHERE id = @id', {
				['@id'] = result.id
			})
		end
	end)
end)

RegisterNetEvent('fl_bikeshop:addToList')
AddEventHandler('fl_bikeshop:addToList', function(target, model, plate)
	local xPlayer, xTarget = ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(target)
	local dateNow = os.date('%Y-%m-%d %H:%M')

	if xPlayer.job.name ~= 'bikedealer' then
		print(('fl_bikeshop: %s attempted to add a sold bike to list!'):format(xPlayer.discord))
		return
	end

	MySQL.Async.execute('INSERT INTO bike_sold (client, model, plate, soldby, date) VALUES (@client, @model, @plate, @soldby, @date)', {
		['@client'] = xTarget.getName(),
		['@model'] = model,
		['@plate'] = plate,
		['@soldby'] = xPlayer.getName(),
		['@date'] = dateNow
	})
end)

ESX.RegisterServerCallback('fl_bikeshop:getSoldVehicles', function(xPlayer, source, cb)
	MySQL.Async.fetchAll('SELECT * FROM bike_sold ORDER BY date DESC', {}, function(result)
		cb(result)
	end)
end)

RegisterNetEvent('fl_bikeshop:rentVehicle')
AddEventHandler('fl_bikeshop:rentVehicle', function (vehicle, plate, playerName, basePrice, rentPrice, target)
	local xPlayer = ESX.GetPlayerFromId(target)

	MySQL.Async.fetchAll('SELECT * FROM bikedealer_vehicles WHERE vehicle = @vehicle LIMIT 1', {
		['@vehicle'] = vehicle
	}, function (result)
		local id = result[1].id
		local price = result[1].price
		local owner = xPlayer.discord

		MySQL.Async.execute('DELETE FROM bikedealer_vehicles WHERE id = @id', {
			['@id'] = id
		})

		MySQL.Async.execute('INSERT INTO rented_bikes (vehicle, plate, player_name, base_price, rent_price, owner) VALUES (@vehicle, @plate, @player_name, @base_price, @rent_price, @owner)',
		{
			['@vehicle'] = vehicle,
			['@plate'] = plate,
			['@player_name'] = playerName,
			['@base_price'] = basePrice,
			['@rent_price'] = rentPrice,
			['@owner'] = owner
		})
	end)
end)

ESX.RegisterServerCallback('fl_bikeshop:getCategories', function(xPlayer, source, cb)
	cb(Categories)
end)

ESX.RegisterServerCallback('fl_bikeshop:getVehicles', function(xPlayer, source, cb)
	cb(Vehicles)
end)

ESX.RegisterServerCallback('fl_bikeshop:buyVehicle', function(xPlayer, source, cb, vehicleModel)
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

ESX.RegisterServerCallback('fl_bikeshop:buyVehicleSociety', function(xPlayer, source, cb, society, vehicleModel)
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

			MySQL.Async.execute('INSERT INTO bikedealer_vehicles (vehicle, price) VALUES (@vehicle, @price)', {
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

RegisterNetEvent('fl_bikeshop:addVehicleToStock')
AddEventHandler('fl_bikeshop:addVehicleToStock', function(model)
	MySQL.Async.execute('INSERT INTO bikedealer_vehicles (vehicle, price) VALUES (@vehicle, @price)', {
		['@vehicle'] = model,
		['@price'] = 0,
	}, function(rowsChanged)
	end)
end)

ESX.RegisterServerCallback('fl_bikeshop:getCommercialVehicles', function(xPlayer, source, cb)
	MySQL.Async.fetchAll('SELECT * FROM bikedealer_vehicles ORDER BY vehicle ASC', {}, function (result)
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


RegisterNetEvent('fl_bikeshop:returnProvider')
AddEventHandler('fl_bikeshop:returnProvider', function(vehicleModel)
	local _source = source

	MySQL.Async.fetchAll('SELECT * FROM bikedealer_vehicles WHERE vehicle = @vehicle LIMIT 1', {
		['@vehicle'] = vehicleModel
	}, function (result)

		if result[1] then
			local id = result[1].id
			local price = ESX.Math.Round(result[1].price * 0.75)

			TriggerEvent('fl_data:getSharedAccount', 'society_bikedealer', function(account)
				account.addMoney(price)
			end)

			MySQL.Async.execute('DELETE FROM bikedealer_vehicles WHERE id = @id', {
				['@id'] = id
			})

			TriggerClientEvent('esx:showNotification', _source, _U('vehicle_sold_for', vehicleModel, ESX.Math.GroupDigits(price)))
		else
			print(('fl_bikeshop: %s attempted selling an invalid vehicle!'):format(GetPlayerIdentifiers(_source)[1]))
		end
	end)
end)

ESX.RegisterServerCallback('fl_bikeshop:getRentedVehicles', function(xPlayer, source, cb)
	MySQL.Async.fetchAll('SELECT * FROM rented_bikes ORDER BY player_name ASC', {}, function (result)
		local vehicles = {}

		for i=1, #result, 1 do
			table.insert(vehicles, {
				name = result[i].vehicle,
				plate = result[i].plate,
				playerName = result[i].player_name
			})
		end

		cb(vehicles)
	end)
end)

ESX.RegisterServerCallback('fl_bikeshop:giveBackVehicle', function(xPlayer, source, cb, plate)
	MySQL.Async.fetchAll('SELECT * FROM rented_bikes WHERE plate = @plate', {
		['@plate'] = plate
	}, function (result)
		if result[1] ~= nil then
			local vehicle = result[1].vehicle
			local basePrice = result[1].base_price

			MySQL.Async.execute('INSERT INTO bikedealer_vehicles (vehicle, price) VALUES (@vehicle, @price)', {
				['@vehicle'] = vehicle,
				['@price'] = basePrice
			})

			MySQL.Async.execute('DELETE FROM rented_bikes WHERE plate = @plate', {
				['@plate'] = plate
			})

			RemoveOwnedVehicle(plate)
			cb(true)
		else
			cb(false)
		end
	end)
end)

ESX.RegisterServerCallback('fl_bikeshop:resellVehicle', function(xPlayer, source, cb, plate, model)
	local resellPrice = 0

	-- calculate the resell price
	for i=1, #Vehicles, 1 do
		if GetHashKey(Vehicles[i].model) == model then
			resellPrice = ESX.Math.Round(Vehicles[i].price / 100 * Config.ResellPercentage)
			break
		end
	end

	if resellPrice == 0 then
		print(('fl_bikeshop: %s attempted to sell an unknown bike!'):format(GetPlayerIdentifiers(source)[1]))
		cb(false)
	else
		MySQL.Async.fetchAll('SELECT * FROM rented_bikes WHERE plate = @plate', {
			['@plate'] = plate
		}, function (result)
			if result[1] then -- is it a rented vehicle?
				cb(false) -- it is, don't let the player sell it since he doesn't own it
			else
				local xPlayer = ESX.GetPlayerFromId(source)

				MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND @plate = plate', {
					['@owner'] = xPlayer.discord,
					['@plate'] = plate
				}, function (result)
					if result[1] then -- does the owner match?
						local vehicle = json.decode(result[1].vehicle)

						if vehicle.model == model then
							if vehicle.plate == plate then
								xPlayer.addMoney(resellPrice)
								RemoveOwnedVehicle(plate)
								cb(true)
							else
								print(('fl_bikeshop: %s attempted to sell an bike with plate mismatch!'):format(xPlayer.discord))
								cb(false)
							end
						else
							print(('fl_bikeshop: %s attempted to sell an bike with model mismatch!'):format(xPlayer.discord))
							cb(false)
						end
					else
						if xPlayer.job.grade_name == 'boss' then
							MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND @plate = plate', {
								['@owner'] = 'society:' .. xPlayer.job.name,
								['@plate'] = plate
							}, function (result)
								if result[1] then
									local vehicle = json.decode(result[1].vehicle)

									if vehicle.model == model then
										if vehicle.plate == plate then
											xPlayer.addMoney(resellPrice)
											RemoveOwnedVehicle(plate)
											cb(true)
										else
											print(('fl_bikeshop: %s attempted to sell an bike with plate mismatch!'):format(xPlayer.discord))
											cb(false)
										end
									else
										print(('fl_bikeshop: %s attempted to sell an bike with model mismatch!'):format(xPlayer.discord))
										cb(false)
									end
								else
									cb(false)
								end
							end)
						else
							cb(false)
						end
					end
				end)
			end
		end)
	end
end)

ESX.RegisterServerCallback('fl_bikeshop:isPlateTaken', function(xPlayer, source, cb, plate)
	MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function (result)
		cb(result[1] ~= nil)
	end)
end)

ESX.RegisterServerCallback('fl_bikeshop:retrieveJobVehicles', function(xPlayer, source, cb, type)
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND type = @type AND job = @job', {
		['@owner'] = xPlayer.discord,
		['@type'] = type,
		['@job'] = xPlayer.job.name
	}, function (result)
		cb(result)
	end)
end)

RegisterNetEvent('fl_bikeshop:setJobVehicleState')
AddEventHandler('fl_bikeshop:setJobVehicleState', function(plate, state)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = @stored WHERE plate = @plate AND job = @job', {
		['@stored'] = state,
		['@plate'] = plate,
		['@job'] = xPlayer.job.name
	}, function(rowsChanged)
		if rowsChanged == 0 then
			print(('fl_bikeshop: %s exploited the garage!'):format(xPlayer.discord))
		end
	end)
end)

TriggerEvent('cron:runAt', 22, 35, function (d, h, m)
	MySQL.Async.fetchAll('SELECT * FROM rented_bikes', {}, function (result)
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

			TriggerEvent('fl_data:getSharedAccount', 'society_bikedealer', function(account)
				account.addMoney(result[i].rent_price)
			end)
		end
	end)
end)