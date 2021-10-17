

ESX.RegisterServerCallback('fl_tattooshop:requestPlayerTattoos', function(xPlayer, source, cb)
	if xPlayer then
		MySQL.Async.fetchAll('SELECT tattoos FROM users WHERE discord = @discord', {
			['@discord'] = xPlayer.discord
		}, function(result)
			if result[1].tattoos then
				cb(json.decode(result[1].tattoos))
			else
				cb()
			end
		end)
	else
		cb()
	end
end)

RegisterNetEvent("fl_tattooshop:purchaseTattoo")
AddEventHandler('fl_tattooshop:purchaseTattoo', function(tattooList, target, tattoo)
	local xPlayer = ESX.GetPlayerFromId(target)

	table.insert(tattooList, tattoo)

	MySQL.Async.execute('UPDATE users SET tattoos = @tattoos WHERE discord = @discord', {
		['@tattoos'] = json.encode(tattooList),
		['@discord'] = xPlayer.discord
	})

	TriggerClientEvent('esx:showNotification', target, "Vous venez d'obtenir un nouveau tatouage.")
	TriggerClientEvent('esx:showNotification', source, "Vous venez d'appliquer tatouage.")
end)

RegisterNetEvent("fl_tattooshop:getSkin")
AddEventHandler("fl_tattooshop:getSkin", function(target)
	TriggerClientEvent("fl_tattooshop:getSkin", target, source)
end)

RegisterNetEvent("fl_tattooshop:addTattoo")
AddEventHandler("fl_tattooshop:addTattoo", function(target)
	TriggerClientEvent("fl_tattooshop:addTattoo", target)
end)

RegisterNetEvent("fl_tattooshop:change")
AddEventHandler("fl_tattooshop:change", function(target, name, value)
	TriggerClientEvent("fl_tattooshop:change", target, name, value)
end)

RegisterNetEvent("fl_tattooshop:resetSkin")
AddEventHandler("fl_tattooshop:resetSkin", function(target)
	TriggerClientEvent("fl_tattooshop:resetSkin", target)
end)

RegisterNetEvent("fl_tattooshop:setPedSkin")
AddEventHandler("fl_tattooshop:setPedSkin", function(target)
	TriggerClientEvent("fl_tattooshop:setPedSkin", target)
end)

RegisterNetEvent("fl_tattooshop:setSkin")
AddEventHandler("fl_tattooshop:setSkin", function(skin, target, tattoos)
	TriggerClientEvent("fl_tattooshop:setSkin", target, skin, source, tattoos)
end)
