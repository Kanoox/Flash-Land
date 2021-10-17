OwnedProperties = {}

function ReloadProperties()
	MySQL.Async.fetchAll('SELECT * FROM properties', {}, function(properties)

		for i=1, #properties, 1 do
			local id = nil
			local entering = nil
			local garage = nil
			local exit = nil
			local inside = nil
			local outside = nil
			local isSingle = nil
			local isRoom = nil
			local isGateway = nil
			local isOpen = nil
			local roomMenu = nil
			local clothingMenu = nil

			if properties[i].id ~= nil then
				id = json.decode(properties[i].id)
			end

			if properties[i].entering ~= nil then
				entering = json.decode(properties[i].entering)
			end

			if properties[i].garage ~= nil then
				garage = json.decode(properties[i].garage)
			end

			if properties[i].exit ~= nil then
				exit = json.decode(properties[i].exit)
			end

			if properties[i].inside ~= nil then
				inside = json.decode(properties[i].inside)
			end

			if properties[i].outside ~= nil then
				outside = json.decode(properties[i].outside)
			end

			if properties[i].room_menu ~= nil then
				roomMenu = json.decode(properties[i].room_menu)
			end

			if properties[i].clothing_menu ~= nil then
				clothingMenu = json.decode(properties[i].clothing_menu)
			end

			if properties[i].is_single == 0 then
				isSingle = false
			else
				isSingle = true
			end

			if properties[i].is_room == 0 then
				isRoom = false
			else
				isRoom = true
			end

			if properties[i].is_gateway == 0 then
				isGateway = false
			else
				isGateway = true
			end

			--print(GarageType)
			table.insert(Config.Properties, {
				id = properties[i].id,
				name = properties[i].name,
				label = properties[i].label,
				entering = entering,
				exit = exit,
				inside = inside,
				outside = outside,
				gateway = properties[i].gateway,
				isSingle = isSingle,
				isRoom = isRoom,
				isGateway = isGateway,
				roomMenu = roomMenu,
				clothingMenu = clothingMenu,
				price = properties[i].price,
				interiorId = properties[i].interiorId,
				openHouseRadius = properties[i].open_house_radius,
				type = properties[i].type,
				soldby = properties[i].soldby,
				poids = properties[i].poids,
				garage = garage,
				GarageType =  properties[i].GarageType
			})
		end

		Citizen.Wait(1000)
		TriggerClientEvent('fl_property:sendProperties', -1, Config.Properties)
		PoidsDesItems()
	end)
end

MySQL.ready(ReloadProperties)
AddEventHandler('fl_property:reloadProperties', ReloadProperties)

function GetProperty(name)
	for i=1, #Config.Properties, 1 do
		if Config.Properties[i].name == name then
			return Config.Properties[i]
		end
	end
end

function GetOwnedProperty(ownedPropertyId)
	for _,OwnedProperty in pairs(OwnedProperties) do
		if OwnedProperty.id == ownedPropertyId then
			return OwnedProperty
		end
	end
end

function SetPropertyOwned(name, price, rented, owner, soldby)
	MySQL.Async.execute('INSERT INTO owned_properties (name, price, rented, owner, soldby) VALUES (@name, @price, @rented, @owner, @soldby)', {
		['@name'] = name,
		['@price'] = price,
		['@rented'] = (rented and 1 or 0),
		['@owner'] = owner,
		['@soldby'] = soldby,
	}, function(rowsChanged)
		local xPlayer = ESX.GetPlayerFromDiscordIdentifier(owner)

		if xPlayer then
			if rented then
				xPlayer.showNotification(_U('rented_for', ESX.Math.GroupDigits(price)))
			else
				xPlayer.showNotification(_U('purchased_for', ESX.Math.GroupDigits(price)))
			end
		end
		UpdateOwnedForClients(-1)
	end)
end

function RemoveOwnedProperty(ownedPropertyId)
	MySQL.Async.execute('DELETE FROM owned_properties WHERE id = @id', {
		['@id'] = ownedPropertyId,
	}, function(rowsChanged)
		print('[fl_property] RemoveOwnedProperty(' .. ownedPropertyId .. '|' .. rowsChanged .. ')')
		UpdateOwnedForClients(-1)
	end)
end

function UpdateOwnedForClients(target)
	TriggerEvent('fl_ownedproperty:getOwnedProperties', function(owned_properties)
		TriggerClientEvent('fl_property:ownedPropertyChanged', target, owned_properties)
	end)
end

RegisterNetEvent('fl_ownedproperty:getOwnedProperties')
AddEventHandler('fl_ownedproperty:getOwnedProperties', function(cb)
	MySQL.Async.fetchAll('SELECT owned_properties.*, users.firstname, users.lastname FROM users, owned_properties WHERE owned_properties.owner = users.discord ORDER BY id ASC', {}, function(result)
		local tmpOwnedProperties = {}

		for i=1, #result, 1 do
			local property = GetProperty(result[i].name)
			local otherKeys = {}
			if result[i].other_keys then
				for _,AnyIdentifier in pairs(json.decode(result[i].other_keys)) do
					local xPlayer = ESX.GetPlayerFromDiscordIdentifier(AnyIdentifier)
					if xPlayer then
						table.insert(otherKeys, {
							discord = AnyIdentifier,
							name = xPlayer.firstname .. ' ' .. xPlayer.lastname,
						})
					else
						local resultName = MySQL.Sync.fetchAll('SELECT users.firstname, users.lastname FROM users WHERE discord = @discord', {
							['@discord'] = AnyIdentifier,
						})
						table.insert(otherKeys, {
							discord = AnyIdentifier,
							name = resultName[1].firstname .. ' ' .. resultName[1].lastname,
						})
					end
				end
			end
			table.insert(tmpOwnedProperties, {
				id = result[i].id,
				name = result[i].name,
				label = property.label,
				property = property,
				price = result[i].price,
				rented = (result[i].rented == 1 and true or false),
				owner = result[i].owner,
				ownerFirstname = result[i].firstname,
				ownerLastname = result[i].lastname,
				society = result[i].society,
				otherKeys = otherKeys,
				soldby = result[i].soldby,
				garage = result[i].garage,
				GarageType = result[i].GarageType
			})
		end

		OwnedProperties = tmpOwnedProperties
		cb(OwnedProperties)
	end)
end)

RegisterNetEvent('fl_property:doorSync')
AddEventHandler('fl_property:doorSync', function(PropertyName, ObjectHash, Toggle)
	TriggerClientEvent('fl_property:doorSync', -1, PropertyName, ObjectHash, Toggle)
end)

AddEventHandler('fl_property:setPropertyOwned', function(name, price, rented, owner, soldby)
	SetPropertyOwned(name, price, rented, owner, soldby)
end)

RegisterNetEvent('fl_property:removeOwnedPropertyId')
AddEventHandler('fl_property:removeOwnedPropertyId', function(ownedPropertyId)
	RemoveOwnedProperty(ownedPropertyId)
end)

RegisterNetEvent('fl_property:saveLastProperty')
AddEventHandler('fl_property:saveLastProperty', function(propertyId)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE users SET last_property = @last_property WHERE discord = @discord', {
		['@last_property'] = propertyId,
		['@discord'] = xPlayer.discord
	})
end)

RegisterNetEvent('fl_property:deleteLastProperty')
AddEventHandler('fl_property:deleteLastProperty', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE users SET last_property = NULL WHERE discord = @discord', {
		['@discord'] = xPlayer.discord
	})
end)

RegisterNetEvent('fl_property:updateOtherKeys')
AddEventHandler('fl_property:updateOtherKeys', function(propertyId, otherKeysRaw)
	local xPlayer = ESX.GetPlayerFromId(source)
	local otherKeysJson = nil

	if otherKeysRaw then
		local otherKeys = {}

		for _,AnyKeyRaw in pairs(otherKeysRaw) do
			table.insert(otherKeys, AnyKeyRaw.discord)
		end

		if otherKeys ~= {} then
			otherKeysJson = json.encode(otherKeys)
		else
			otherKeysJson = nil
		end
	end

	MySQL.Async.execute('UPDATE `owned_properties` SET other_keys = @otherKeys WHERE id = @propertyId AND `owner` = @discord', {
		['@otherKeys'] = otherKeysJson,
		['@propertyId'] = propertyId,
		['@discord'] = xPlayer.discord,
	})
	Citizen.Wait(500)
	UpdateOwnedForClients(-1)
end)

RegisterNetEvent('fl_property:definedPropertyAsSociety')
AddEventHandler('fl_property:definedPropertyAsSociety', function(propertyId, society)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE `owned_properties` SET `society` = @society WHERE `id` = @propertyId', {
		['@society'] = society,
		['@propertyId'] = propertyId,
	})
	Citizen.Wait(500)
	UpdateOwnedForClients(-1)
end)

RegisterNetEvent('fl_property:resetPropertyAsSociety')
AddEventHandler('fl_property:resetPropertyAsSociety', function(propertyId, discord)
	MySQL.Async.execute('UPDATE `owned_properties` SET `society` = NULL WHERE `id` = @propertyId AND `owner` = @discord', {
		['@propertyId'] = propertyId,
		['@discord'] = discord,
	})
	Citizen.Wait(500)
	UpdateOwnedForClients(-1)
end)

RegisterNetEvent('fl_property:getItem')
AddEventHandler('fl_property:getItem', function(ownedPropertyId, type, item, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	if type == 'item_standard' then
		local sourceItem = xPlayer.getInventoryItem(item)
		TriggerEvent('fl_addoninventory:getInventory', 'property', 'property_' .. ownedPropertyId, function(inventory)
			local inventoryItem = inventory.getItem(item)

			-- is there enough in the property?
			if count > 0 and inventoryItem.count >= count then

				-- can the player carry the said amount of x item?
				if not xPlayer.canCarryItem(sourceItem.name, sourceItem.count) then
					xPlayer.showNotification(_U('player_cannot_hold'))
				else
					inventory.removeItem(item, count)
					xPlayer.addInventoryItem(item, count)
					xPlayer.showNotification(_U('have_withdrawn', count, inventoryItem.label))
				end
			else
				xPlayer.showNotification(_U('not_enough_in_property'))
			end
		end)

	elseif type == 'money' then
		TriggerEvent('fl_data:getAddonAccount', 'property_money', 'property_' .. ownedPropertyId, function(account)
			local roomAccountMoney = account.money

			if roomAccountMoney >= count then
				account.removeMoney(count)
				xPlayer.addMoney(count)
				xPlayer.showNotification('Vous avez pris ~y~$' .. ESX.Math.GroupDigits(count) .. '~s~.')
			else
				xPlayer.showNotification(_U('amount_invalid'))
			end
		end)
	elseif type == 'item_account' then
		TriggerEvent('fl_data:getAddonAccount', 'property_' .. item, 'property_' .. ownedPropertyId, function(account)
			local roomAccountMoney = account.money

			if roomAccountMoney >= count then
				account.removeMoney(count)
				xPlayer.addAccountMoney(item, count)
			else
				xPlayer.showNotification(_U('amount_invalid'))
			end
		end)
	end
end)



RegisterNetEvent('fl_property:swag')
AddEventHandler('fl_property:swag', function(OwnedId, Swag, Toggle)
	TriggerClientEvent('fl_property:swag', -1, OwnedId, Swag, Toggle)
end)

ESX.RegisterServerCallback('fl_property:getProperties', function(xPlayer, source, cb)
	cb(Config.Properties)
end)

ESX.RegisterServerCallback('fl_property:IsInBucket', function(xPlayer, source, cb)
	local _src = source

	cb(GetPlayerRoutingBucket(_src))
end)

ESX.RegisterServerCallback('fl_property:getOwnedProperties', function(xPlayer, source, cb)
	MySQL.Async.fetchAll('SELECT owned_properties.*, users.firstname, users.lastname FROM users, owned_properties WHERE owned_properties.owner = users.discord ORDER BY id ASC', {}, function(result)
		local tmpOwnedProperties = {}

		for i=1, #result, 1 do
			local property = GetProperty(result[i].name)
			local otherKeys = {}
			if result[i].other_keys then
				for _,AnyIdentifier in pairs(json.decode(result[i].other_keys)) do
					local xPlayer = ESX.GetPlayerFromDiscordIdentifier(AnyIdentifier)
					if xPlayer then
						table.insert(otherKeys, {
							discord = AnyIdentifier,
							name = xPlayer.getName(),
						})
					else
						table.insert(otherKeys, {
							discord = AnyIdentifier,
							name = '?' .. AnyIdentifier .. '?',
						})
					end
				end
			end

			if property then
				table.insert(tmpOwnedProperties, {
					id = result[i].id,
					name = result[i].name,
					label = property.label,
					property = property,
					price = result[i].price,
					rented = (result[i].rented == 1 and true or false),
					owner = result[i].owner,
					ownerFirstname = result[i].firstname,
					ownerLastname = result[i].lastname,
					society = result[i].society,
					otherKeys = otherKeys,
					soldby = result[i].soldby,
				})
			else
				print('Unknown property : ' .. tostring(result[i].name))
			end

		end

		OwnedProperties = tmpOwnedProperties
		cb(OwnedProperties)
	end)
end)

local itemsPounds = {}
function PoidsDesItems()
	MySQL.Async.fetchAll('SELECT * FROM items', {
	}, function(results)
		for i =1, #results, 1 do
			table.insert(itemsPounds, {
				name = results[i].name,
				poids = results[i].weight
			})
		end
	end)
end


ESX.RegisterServerCallback('fl_property:getLastProperty', function(xPlayer, source, cb)
	local PropActu = nil
	MySQL.Async.fetchAll('SELECT last_property FROM users WHERE discord = @discord', {
		['@discord'] = xPlayer.discord
	}, function(users)
	
			
		MySQL.Async.fetchAll('SELECT * FROM owned_properties WHERE id = @idProp', {
			['@idProp'] = users[1].last_property
		}, function(owned_properties)

		
			if owned_properties[1] ~= nil then
				for i=1, #Config.Properties, 1 do
					if Config.Properties[i].name == owned_properties[1].name then
						PropActu = Config.Properties[i]
					end
				end
			end

			if PropActu ~= nil and owned_properties[1] ~= nil then
				cb({
					CurrentProp = PropActu,
					OwnedProp = owned_properties[1]
				})
			end
			
		end)
	end)
end)

ESX.RegisterServerCallback('fl_property:getPropertyInventory', function(xPlayer, source, cb, ownedPropertyId)
	local money = 0
	local blackMoney = 0
	local items = {}
	local poids = 0
	

	TriggerEvent('fl_data:getOrCreateAddonAccount', 'property_money', 'property_' .. ownedPropertyId, function(account)
		money = account.money
	end)

	TriggerEvent('fl_data:getOrCreateAddonAccount', 'property_black_money', 'property_' .. ownedPropertyId, function(account)
		blackMoney = account.money
	end)

	TriggerEvent('fl_addoninventory:getInventory', 'property', 'property_' .. ownedPropertyId, function(inventory)
		if inventory then
			items = inventory.items
		else
			print('Nothing to find in property inventory of ' .. tostring(ownedPropertyId))
		end
	end)


	for k,v in pairs(items) do
		if v.count > 0 then
			for y, z in pairs(itemsPounds) do
				if v.name == z.name then
					poids = poids + z.poids * v.count
				end
			end
		end
	end

	cb({
		money = money,
		blackMoney = blackMoney,
		items = items,
		poids = poids
	})
end)

function GetPoidsActuel(property)
	local items = {}
	local poidsInChest = 0

	TriggerEvent('fl_addoninventory:getInventory', 'property', 'property_' .. property, function(inventory)
		if inventory then
			items = inventory.items
		else
			print('Nothing to find in property inventory of ' .. tostring(property))
		end
	end)

	for k,v in pairs(items) do
		if v.count > 0 then
			for y, z in pairs(itemsPounds) do
				if v.name == z.name then
					poidsInChest = poidsInChest + z.poids * v.count
				end
			end
		end
	end
	return poidsInChest
end


RegisterNetEvent('fl_property:putItem')
AddEventHandler('fl_property:putItem', function(ownedPropertyId, type, item, count, poidsMax)
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	
	local maxDuPoids = poidsMax
	local poidsActuel = GetPoidsActuel(ownedPropertyId)
	Wait(100)
	local futurPoids = 0
	for k,v in pairs(itemsPounds) do
		if item == v.name then
			futurPoids = v.poids * count + poidsActuel
		end
	end


	if type == 'item_standard' then
		local playerItemCount = xPlayer.getInventoryItem(item).count
		if futurPoids > maxDuPoids then
			xPlayer.showNotification('Dépôt ~r~impossible ~s~! Limite de poids ~r~dépassée~s~.')
		elseif playerItemCount >= count and count > 0 then
			TriggerEvent('fl_addoninventory:getInventory', 'property', 'property_' .. ownedPropertyId, function(inventory)
				xPlayer.removeInventoryItem(item, count)
				inventory.addItem(item, count)
				xPlayer.showNotification(_U('have_deposited', count, inventory.getItem(item).label))
			end)
		else
			xPlayer.showNotification(_U('invalid_quantity'))
		end
	elseif type == 'money' then
		local playerMoney = xPlayer.getMoney()

		if playerMoney >= count and count > 0 then
			TriggerEvent('fl_data:getOrCreateAddonAccount', 'property_money', 'property_' .. ownedPropertyId, function(account)
				local OwnedProperty = GetOwnedProperty(ownedPropertyId)
				if not OwnedProperty then
					print('Unknown property from ownedPropertyId in putItem')
				end

				if account.getMoney() > Config.MaximumMoney and OwnedProperty.property.interiorId ~= -60 then
					xPlayer.showNotification('~r~Vous ne pouvez pas déposer plus de $' .. ESX.Math.GroupDigits(Config.MaximumMoney))
					return
				end

				if account.getMoney() > Config.MaximumMoneyWareHouse and OwnedProperty.property.interiorId == -60 then
					xPlayer.showNotification('~r~Vous ne pouvez pas déposer plus de $' .. ESX.Math.GroupDigits(Config.MaximumMoneyWareHouse) .. ' dans un entrepôt')
					return
				end

				if account.getMoney() + count > Config.MaximumMoney and OwnedProperty.property.interiorId ~= -60 then
					xPlayer.showNotification('~r~Impossible de poser plus de $' .. ESX.Math.GroupDigits(Config.MaximumMoney) .. ' dans cette propriété')
					return
				end

				if account.getMoney() + count > Config.MaximumMoneyWareHouse and OwnedProperty.property.interiorId == -60 then
					xPlayer.showNotification('~r~Impossible de poser plus de $' .. ESX.Math.GroupDigits(Config.MaximumMoneyWareHouse) .. ' dans un entrepôt')
					return
				end

				xPlayer.removeMoney(count)
				account.addMoney(count)
				xPlayer.showNotification('Vous avez déposé ~y~$' ..  ESX.Math.GroupDigits(count) .. '~s~.')
			end)
		else
			xPlayer.showNotification(_U('amount_invalid'))
		end
	elseif type == 'item_account' then
		local playerAccountMoney = xPlayer.getAccount(item).money

		if playerAccountMoney >= count and count > 0 then
			TriggerEvent('fl_data:getOrCreateAddonAccount', 'property_' .. item, 'property_' .. ownedPropertyId, function(account)
				local OwnedProperty = GetOwnedProperty(ownedPropertyId)

				if account.getMoney() + count > Config.MaximumBlackMoney and OwnedProperty.property.interiorId ~= -60 then
					xPlayer.showNotification('~r~Impossible de poser plus de $' .. ESX.Math.GroupDigits(Config.MaximumBlackMoney) .. ' sale dans cette propriété')
					return
				end

				xPlayer.removeAccountMoney(item, count)
				account.addMoney(count)
			end)
		else
			xPlayer.showNotification(_U('amount_invalid'))
		end
	end
end)



ESX.RegisterServerCallback('fl_property:getOldPropertyInventory', function(xPlayer, source, cb, ownerIdentifier)
	local blackMoney = 0
	local items = {}

	TriggerEvent('fl_data:getAddonAccount', 'property_black_money', ownerIdentifier, function(account)
		blackMoney = account.money
	end)

	TriggerEvent('fl_addoninventory:getInventory', 'property', ownerIdentifier, function(inventory)
		if inventory then
			items = inventory.items
		else
			print('Nothing to find in property inventory of ' .. tostring(ownerIdentifier))
		end
	end)

	cb({
		blackMoney = blackMoney,
		items = items
	})
end)

ESX.RegisterServerCallback('fl_property:getPlayerInventory', function(xPlayer, source, cb)
	cb({
		money = xPlayer.getAccount('money').money,
		blackMoney = xPlayer.getAccount('black_money').money,
		items = xPlayer.inventory,
	})
end)

TriggerEvent('cron:runAt', 18, 16, function(d, h, m)
	print('Paying all rents')
	local totalOfTheDay = {}
	MySQL.Async.fetchAll('SELECT * FROM owned_properties WHERE rented = 1', {}, function (result)
		for i=1, #result, 1 do
			local xPlayer = ESX.GetPlayerFromDiscordIdentifier(result[i].owner)

			-- message player if connected
			if xPlayer then
				xPlayer.removeAccountMoney('bank', result[i].price)
				xPlayer.showNotification(_U('paid_rent', ESX.Math.GroupDigits(result[i].price)))
			elseif result[i].price > 0 then -- pay rent either way
				MySQL.Async.fetchAll('SELECT accounts FROM users WHERE discord LIKE @discord', {
					['@discord'] = result[i].owner,
				}, function(results)
					if #results == 1 then
						local accounts = json.decode(results[1].accounts)
						local bank = accounts['bank']
						if bank > -5000 then
							accounts['bank'] = bank - result[i].price
							MySQL.Async.execute('UPDATE users SET accounts = @accounts WHERE discord = @discord', {
								['@accounts'] = json.encode(accounts),
								['@discord'] = result[i].owner
							})
						else
							print('Not enough money to pay rent ' .. tostring(result[i].owner) .. ' : ' .. tostring(result[i].price))
							MySQL.Async.execute('DELETE FROM owned_properties WHERE owner = @discord', {
								['@discord'] = result[i].owner,
							}, function(rowsChanged)
								if rowsChanged > 0 then
									print(' - Deleted owned property.')
								end
							end)
						end
					else
						MySQL.Async.execute('DELETE FROM owned_properties WHERE owner = @discord', {
							['@discord'] = result[i].owner,
						}, function(rowsChanged)
							if rowsChanged > 0 then
								print(' - Deleted owned property of unknown user')
							end
						end)
					end
				end)
			end

			totalOfTheDay[result[i].soldby] = totalOfTheDay[result[i].soldby] + result[i].price
			TriggerEvent('fl_data:getSharedAccount', 'society_' .. result[i].soldby, function(account)
				account.addMoney(result[i].price)
			end)
			Citizen.Wait(1000)
		end

		for soldby, total in pairs(totalOfTheDay) do
			for _, xPlayer in pairs(ESX.GetPlayersWithJob(soldby)) do
				if xPlayer.job.grade_name == 'boss' then
					xPlayer.showNotification('~g~Les propriétaires ont payé leur loyer : $' .. total, true, true, 130)
				end
			end
		end
	end)
end)


RegisterNetEvent('fl_property:EnterInInstance')
AddEventHandler('fl_property:EnterInInstance', function(Property)
	local src = source
	local ped = GetPlayerPed(src)

	SetPlayerRoutingBucket(src, Property.id)
	--print('Bucket entrée :' , GetPlayerRoutingBucket(src))

	exports["pma-voice"]:updateRoutingBucket(src, Property.id)


end)

RegisterNetEvent('fl_property:BeUnstuck')
AddEventHandler('fl_property:BeUnstuck', function()
	local src = source
	SetPlayerRoutingBucket(src, 0)
	exports["pma-voice"]:updateRoutingBucket(src, 0)
end)

RegisterNetEvent('fl_property:ExitInInstance')
AddEventHandler('fl_property:ExitInInstance', function(Property)
	local src = source
	local ped = GetPlayerPed(src)
	SetEntityCoords(ped, Property.outside.x, Property.outside.y, Property.outside.z, true)
	SetPlayerRoutingBucket(src, 0)

	exports["pma-voice"]:updateRoutingBucket(src, 0)

end)

RegisterNetEvent('fl_property:InviteToVisit')
AddEventHandler('fl_property:InviteToVisit', function(player, Property)
	local target = player

	TriggerClientEvent('fl_property:onInvite', player, Property)
	--print('Bucket entrée :' , GetPlayerRoutingBucket(src))
end)

RegisterNetEvent('fl_property:wantToEnter')
AddEventHandler('fl_property:wantToEnter', function(property, owner, serverid)
	local _src = source
	local id = owner.id

	local xPlayer = ESX.GetPlayerFromDiscordIdentifier(owner.owner)

	MySQL.Async.fetchAll('SELECT * FROM owned_properties WHERE id = @id', {
		['@id'] = owner.id,
	}, function(results)
		local prop = results[1]
		local target = serverid
		if prop ~= nil then
			TriggerClientEvent('fl_property:AcceptWantToEnter', xPlayer.source, property, prop, _src)
		else
			print('Propriété inexistante')
		end
	end)
end)

RegisterNetEvent('fl_property:EnterInPropAfterWanted')
AddEventHandler('fl_property:EnterInPropAfterWanted', function(propCara, property, plyWant)
	local propriete = propCara
	local ownedpropriete = property
	TriggerClientEvent('fl_property:GoInHouseWhichWant', plyWant, propriete, ownedpropriete)
end)


RegisterNetEvent('fl_property:VisitProperty')
AddEventHandler('fl_property:VisitProperty', function(Property)
	local src = source
	local ped = GetPlayerPed(src)

	SetPlayerRoutingBucket(src, 25000)
	--print('Bucket entrée :' , GetPlayerRoutingBucket(src))

end)

RegisterNetEvent('fl_property:InviteInYourInstance')
AddEventHandler('fl_property:InviteInYourInstance', function(player, Property)
	local target = player

	TriggerClientEvent('fl_property:onInvite', player, Property)
	--print('Bucket entrée :' , GetPlayerRoutingBucket(src))
end)



-- Garage 

RegisterServerEvent('fl_property:setParking')
AddEventHandler('fl_property:setParking', function(plate, name, zone, vehicleProps)
  local x_source = source
  local xPlayer  = ESX.GetPlayerFromId(x_source)
  
  if vehicleProps ~= false then
    Insert(x_source, plate, name, zone, vehicleProps)
  end   
end)

function Insert(source, plate, name, zone, vehicleProps)
  
  local xPlayer  = ESX.GetPlayerFromId(source)

  MySQL.Async.execute('INSERT INTO `user_parkings` (identifier, plate, name, zone, vehicle) VALUES (@identifier, @plate, @name, @zone, @vehicle)',
  {
    ['@identifier'] = xPlayer.discord,
    ['@plate']     = plate,
    ['@name']      = name,
    ['@zone']      = json.encode(zone),
    ['@vehicle']   = json.encode(vehicleProps)
  }, function(rowsChanged)
    xPlayer.showNotification("Véhicule ranger")
    UpdateState(plate)
  end)
end

function UpdateState(plate)

  MySQL.Sync.execute("UPDATE owned_vehicles SET garageperso=true WHERE plate= @plate",
    {
     ['@plate'] = plate
    }
  )
end



RegisterServerEvent('fl_property:DelParking')
AddEventHandler('fl_property:DelParking', function(plate)
  local x_source = source
  local xPlayer  = ESX.GetPlayerFromId(x_source)

  MySQL.Async.execute('DELETE FROM `user_parkings` WHERE `identifier` = @identifier AND `plate` = @plate',
  {
    ['@identifier'] = xPlayer.discord,
    ['@plate']     = plate,
  }, function(rowsChanged)
     UpdateStateOtherGarage(plate)
  end)
end)

function UpdateStateOtherGarage(plate)

  MySQL.Sync.execute("UPDATE owned_vehicles SET garageperso=false WHERE plate= @plate",
    {
     ['@plate'] = plate
    }
  )

  MySQL.Sync.execute("UPDATE owned_vehicles SET state=false WHERE plate= @plate",
    {
     ['@plate'] = plate
    }
  )

end

ESX.RegisterServerCallback('fl_property:getVehiclesInGarage', function(xPlayer, source, cb, name)
	local xPlayer  = ESX.GetPlayerFromId(source)
  
	MySQL.Async.fetchAll('SELECT * FROM `user_parkings` WHERE `identifier` = @identifier AND name = @name',
	{
	  ['@identifier'] = xPlayer.discord,
	  ['@name']     = name
	}, function(result)
  
	  local vehicles = {}
  
	  for i=1, #result, 1 do
		table.insert(vehicles, {
		  zone    = json.decode(result[i].zone),
		  plate = result[i].plate,
		  vehicle = json.decode(result[i].vehicle)
		})
	  end
  
	  cb(vehicles)
	end)
end)