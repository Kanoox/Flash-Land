AddEventHandler('esx:playerLoaded', function(source)
	TriggerEvent('fl_license:getLicenses', source, function(licenses)
		TriggerClientEvent('fl_dmvschool:loadLicenses', source, licenses)
	end)
end)

RegisterNetEvent('fl_dmvschool:addLicense')
AddEventHandler('fl_dmvschool:addLicense', function(type)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('fl_license:addLicense', xPlayer.source, type, function()
		TriggerEvent('fl_license:getLicenses', xPlayer.source, function(licenses)
			TriggerClientEvent('fl_dmvschool:loadLicenses', xPlayer.source, licenses)
		end)
	end)
end)

RegisterNetEvent('fl_dmvschool:pay')
AddEventHandler('fl_dmvschool:pay', function(price)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeMoney(price)
	TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_paid', ESX.Math.GroupDigits(price)))
end)