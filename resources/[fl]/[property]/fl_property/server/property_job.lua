
RegisterNetEvent('fl_realestateagentjob:revoke')
AddEventHandler('fl_realestateagentjob:revoke', function(propertyId)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name ~= 'realestateagent' and xPlayer.job.name ~= 'casino' and xPlayer.job.name ~= 'gouv' and xPlayer.job.name ~= '_dev' then
		print(('fl_realestateagentjob: %s attempted to revoke a property!'):format(xPlayer.discord))
	else
		TriggerEvent('fl_property:removeOwnedPropertyId', propertyId)
	end
end)

RegisterNetEvent('fl_realestateagentjob:buySelf')
AddEventHandler('fl_realestateagentjob:buySelf', function(property)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name ~= 'realestateagent' and xPlayer.job.name ~= 'casino' and xPlayer.job.name ~= 'gouv' and xPlayer.job.name ~= '_dev' then
		print(('fl_realestateagentjob: %s attempted to buySelf a property!'):format(xPlayer.discord))
		return
	end

	if xPlayer.job.grade_name ~= 'boss' and xPlayer.job.grade_name ~= 'gestion' then
		xPlayer.showNotification('~r~Indisponible en dehors des grades gestion et patron')
		return
	end

	xPlayer.removeAccountMoney('bank', property.price)
	TriggerEvent('fl_data:getSharedAccount', 'society_realestateagent', function(account)
		account.addMoney(property.price)
	end)
	TriggerEvent('fl_property:setPropertyOwned', property.name, property.price, false, xPlayer.discord, xPlayer.job.name)
end)

RegisterNetEvent('fl_realestateagentjob:sellBank')
AddEventHandler('fl_realestateagentjob:sellBank', function(target, property, price)
	local xPlayer, xTarget = ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(target)

	if xPlayer.job.name ~= 'realestateagent' then
		print(('fl_realestateagentjob: %s attempted to sellBank a property!'):format(xPlayer.discord))
		return
	end

	if xTarget.getAccount('bank').money >= price then
		xTarget.removeAccountMoney('bank', price)

		TriggerEvent('fl_data:getSharedAccount', 'society_realestateagent', function(account)
			account.addMoney(price)
		end)

		TriggerEvent('fl_property:setPropertyOwned', property, price, false, xTarget.discord, xPlayer.job.name)
	else
		xPlayer.showNotification(_U('client_poor'))
	end
end)

RegisterNetEvent('fl_realestateagentjob:sell')
AddEventHandler('fl_realestateagentjob:sell', function(target, property, price)
	local xPlayer, xTarget = ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(target)

	if xPlayer.job.name ~= 'realestateagent' then
		print(('fl_realestateagentjob: %s attempted to sell a property!'):format(xPlayer.discord))
		return
	end

	if xTarget.getMoney() >= price then
		xTarget.removeMoney(price)

		TriggerEvent('fl_data:getSharedAccount', 'society_realestateagent', function(account)
			account.addMoney(price)
		end)

		TriggerEvent('fl_property:setPropertyOwned', property, price, false, xTarget.discord, xPlayer.job.name)
	else
		xPlayer.showNotification(_U('client_poor'))
	end
end)

RegisterNetEvent('fl_realestateagentjob:rent')
AddEventHandler('fl_realestateagentjob:rent', function(target, property, price)
	local xPlayer, xTarget = ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(target)

	if xPlayer.job.name ~= 'realestateagent' then
		print(('fl_realestateagentjob: %s attempted to rent a property!'):format(xPlayer.discord))
		return
	end

	TriggerEvent('fl_property:setPropertyOwned', property, price, true, xTarget.discord, xPlayer.job.name)
end)

ESX.RegisterServerCallback('fl_realestateagentjob:getCustomers', function(xPlayer, source, cb)
	TriggerEvent('fl_ownedproperty:getOwnedProperties', function(properties)
		local customers = {}

		for i=1, #properties, 1 do
				table.insert(customers, {
					name = properties[i].ownerFirstname .. ' ' .. properties[i].ownerLastname,
					propertyOwner = properties[i].owner,
					propertyRented = properties[i].rented,
					propertyId = properties[i].id,
					propertyPrice = properties[i].price,
					propertyName = properties[i].name,
					propertyLabel = properties[i].label,
					propertySoldby = properties[i].soldby,
				})
		end

		cb(customers)
	end)
end)



RegisterServerEvent('fl_property:patronmess')
AddEventHandler('fl_property:patronmess', function(PriseOuFin, message)
    local _source = source
    local _raison = PriseOuFin
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers = ESX.GetPlayers()


    for i = 1, #xPlayers, 1 do
        local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
        if thePlayer.job.name == 'realestateagent' then
            TriggerClientEvent('fl_property:messagepatron', xPlayers[i], _raison, message)
        end
    end
end)