function ExtractIdentifiers(source)
    local identifiers = {
        discord = "",
		steam = "",
    }

    for i = 0, GetNumPlayerIdentifiers(source) - 1 do
        local id = GetPlayerIdentifier(source, i)

        if string.find(id, "discord") then
            identifiers.discord = id
		elseif string.find(id, "steam") then
			identifiers.steam = id
        end
    end

    return identifiers
end

RegisterServerEvent("ruben:sendMessageWebhook")
AddEventHandler("ruben:sendMessageWebhook", function(webhook,message)
    webhook = "MODIFIEZ MOI"
	if webhook ~= "none" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end)


RegisterNetEvent('fl_billing:sendBill')
AddEventHandler('fl_billing:sendBill', function(playerId, sharedAccountName, label, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(playerId)
	webhook = "MODIFIEZ MOI"
	amount = ESX.Math.Round(amount)
	local player_id = source
	local ids = ExtractIdentifiers(player_id)
	local idDiscord = ExtractIdentifiers(playerId)

	TriggerEvent('fl_data:getSharedAccount', sharedAccountName, function(account)
		if amount < 0 then
			print(('fl_billing: %s attempted to send a negative bill!'):format(xPlayer.discord))
		elseif account == nil then
			if xTarget ~= nil then
				MySQL.Async.execute('INSERT INTO billing (discord, sender, target_type, target, label, amount) VALUES (@discord, @sender, @target_type, @target, @label, @amount)',
				{
					['@discord'] = xTarget.discord,
					['@sender'] = xPlayer.discord,
					['@target_type'] = 'player',
					['@target'] = xPlayer.discord,
					['@label'] = label,
					['@amount'] = amount
				}, function(rowsChanged)
					TriggerClientEvent('esx:showNotification', xTarget.source, 'Vous avez ~r~reçu~s~ une facture.')
					TriggerEvent("ruben:sendMessageWebhook", webhook, "```"..xPlayer.name.." vien d'envoyer une facture de "..amount.."$ à "..xTarget.name.."\nID du joueur : "..player_id.."\n```Discord de l'envoyeur: <@" ..ids.discord:gsub("discord:", "")..">\nDiscord du récépteur : <@"..idDiscord.discord:gsub("discord:", "")..">")
				end)
			end
		else
			if not xPlayer then
				xPlayer = {discord = '?'}
			end
			if xTarget ~= nil then
				MySQL.Async.execute('INSERT INTO billing (discord, sender, target_type, target, label, amount) VALUES (@discord, @sender, @target_type, @target, @label, @amount)',
				{
					['@discord'] = xTarget.discord,
					['@sender'] = xPlayer.discord,
					['@target_type'] = 'society',
					['@target'] = sharedAccountName,
					['@label'] = label,
					['@amount'] = amount
				}, function(rowsChanged)
					TriggerClientEvent('esx:showNotification', xTarget.source, 'Vous avez ~r~reçu~s~ une facture.')
					TriggerEvent("ruben:sendMessageWebhook", webhook, "```"..xPlayer.name.." vien d'envoyer une facture de "..amount.."$ à "..xTarget.name.."\nID du joueur : "..player_id.."\nID du récépteur : "..playerId.."\n```Discord de l'envoyeur: <@" ..ids.discord:gsub("discord:", "")..">\nDiscord du récépteur : <@"..idDiscord.discord:gsub("discord:", "")..">")
				end)
			end
		end
	end)

end)

ESX.RegisterServerCallback('fl_billing:hasTooManyBills', function(xPlayer, source, cb)
	local totalAmount = 0

	MySQL.Async.fetchAll('SELECT * FROM billing WHERE discord = @discord', {
		['@discord'] = xPlayer.discord
	}, function(result)
		for i = 1, #result, 1 do
			totalAmount = totalAmount + result[i].amount
		end

		cb(totalAmount > 5000)
	end)
end)

ESX.RegisterServerCallback('fl_billing:getBills', function(xPlayer, source, cb)
	MySQL.Async.fetchAll('SELECT * FROM billing WHERE discord = @discord', {
		['@discord'] = xPlayer.discord
	}, function(result)
		local bills = {}
		for i=1, #result, 1 do
			table.insert(bills, {
				id = result[i].id,
				discord = result[i].discord,
				sender = result[i].sender,
				targetType = result[i].target_type,
				target = result[i].target,
				label = result[i].label,
				amount = result[i].amount
			})
		end
		cb(bills)
	end)
end)

ESX.RegisterServerCallback('fl_billing:getTargetBills', function(xPlayer, source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)
	MySQL.Async.fetchAll('SELECT * FROM billing WHERE discord = @discord', {
		['@discord'] = xPlayer.discord
	}, function(result)
		local bills = {}
		for i=1, #result, 1 do
			table.insert(bills, {
				id = result[i].id,
				discord = result[i].discord,
				sender = result[i].sender,
				targetType = result[i].target_type,
				target = result[i].target,
				label = result[i].label,
				amount = result[i].amount
			})
		end
		cb(bills)
	end)
end)

ESX.RegisterServerCallback('fl_billing:payBill', function(xPlayer, source, cb, id)
	MySQL.Async.fetchAll('SELECT * FROM billing WHERE id = @id', {
		['@id'] = id
	}, function(result)
		if #result == 0 then
			xPlayer.showNotification('~r~Facture inconnue ou déjà payée !')
			return
		end
		local sender = result[1].sender
		local targetType = result[1].target_type
		local target = result[1].target
		local amount = result[1].amount
		local xTarget = ESX.GetPlayerFromDiscordIdentifier(sender)

		if targetType == 'player' then
			if xTarget ~= nil then
				if xPlayer.getMoney() >= amount then
					MySQL.Async.execute('DELETE from billing WHERE id = @id', {
						['@id'] = id
					}, function(rowsChanged)
						xPlayer.removeMoney(amount)
						xTarget.addMoney(amount)

						xPlayer.showNotification('Vous avez ~g~payé~s~ une facture de ~r~$' .. ESX.Math.GroupDigits(amount) .. '~s~.')
						TriggerClientEvent('esx:showNotification', xTarget.source, 'Vous avez ~g~reçu~s~ un paiement de ~g~$' .. ESX.Math.GroupDigits(amount) .. '~s~.')

						cb()
					end)
				elseif xPlayer.getBank() >= amount then
					MySQL.Async.execute('DELETE from billing WHERE id = @id', {
						['@id'] = id
					}, function(rowsChanged)
						xPlayer.removeAccountMoney('bank', amount)
						xTarget.addAccountMoney('bank', amount)

						xPlayer.showNotification('Vous avez ~g~payé~s~ une facture de ~r~$' .. ESX.Math.GroupDigits(amount) .. '~s~.')
						TriggerClientEvent('esx:showNotification', xTarget.source, 'Vous avez ~g~reçu~s~ un paiement de ~g~$' .. ESX.Math.GroupDigits(amount) .. '~s~.')

						cb()
					end)
				else
					TriggerClientEvent('esx:showNotification', xTarget.source, 'La personne ~r~ n\'a pas assez d\'argent~s~ pour payer la facture !')
					xPlayer.showNotification('Vous n\'avez pas assez d\'argent pour payer cette facture.')

					cb()
				end
			else
				xPlayer.showNotification('La personne n\'est pas présente.')
				cb()
			end
		else
			TriggerEvent('fl_data:getSharedAccount', target, function(account)
				if xPlayer.getMoney() >= amount then
					MySQL.Async.execute('DELETE from billing WHERE id = @id', {
						['@id'] = id
					}, function(rowsChanged)
						xPlayer.removeMoney(amount)
						account.addMoney(amount)

						xPlayer.showNotification('Vous avez ~g~payé~s~ une facture de ~r~$' .. ESX.Math.GroupDigits(amount) .. '~s~.')
						if xTarget ~= nil then
							TriggerClientEvent('esx:showNotification', xTarget.source, 'Vous avez ~g~reçu~s~ un paiement de ~g~$' .. ESX.Math.GroupDigits(amount) .. '~s~.')
						end

						cb()
					end)
				elseif xPlayer.getBank() >= amount then
					MySQL.Async.execute('DELETE from billing WHERE id = @id', {
						['@id'] = id
					}, function(rowsChanged)
						xPlayer.removeAccountMoney('bank', amount)
						account.addMoney(amount)

						xPlayer.showNotification('Vous avez ~g~payé~s~ une facture de ~r~$' .. ESX.Math.GroupDigits(amount) .. '~s~.')
						if xTarget ~= nil then
							TriggerClientEvent('esx:showNotification', xTarget.source, 'Vous avez ~g~reçu~s~ un paiement de ~g~$' .. ESX.Math.GroupDigits(amount) .. '~s~.')
						end

						cb()
					end)
				else
					xPlayer.showNotification('Vous n\'avez pas assez d\'argent pour payer cette facture.')

					if xTarget ~= nil then
						TriggerClientEvent('esx:showNotification', xTarget.source, 'La personne ~r~ n\'a pas assez d\'argent~s~ pour payer la facture !')
					end

					cb()
				end
			end)
		end
	end)
end)