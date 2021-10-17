RegisterNetEvent('fl_bank:deposit')
AddEventHandler('fl_bank:deposit', function(account, amount, CurrentATM)
	if not account then error('No destination account specified') end

	local xPlayer = ESX.GetPlayerFromId(source)
	amount = tonumber(amount)

	if not tonumber(amount) then return end
	amount = ESX.Math.Round(amount)

	if amount == nil or amount <= 0 then
		xPlayer.showNotification('~r~Montant invalide~s~')
		return
	elseif amount > xPlayer.getMoney() then
		xPlayer.showNotification('~r~Vous n\'avez pas autant d\'argent sur vous~s~')
		return
	end

	local personalAccount = false
	for _,Account in pairs(xPlayer.getAccounts()) do
		if Account.name == account then
			personalAccount = true
		end
	end

	xPlayer.showNotification('Vous avez déposé ~g~$' .. amount .. '~s~')

	if personalAccount then
		xPlayer.removeMoney(amount)
		xPlayer.addAccountMoney(account, amount)
		if CurrentATM then
			TriggerClientEvent('fl_bank:updateMoneyAtm', -1, CurrentATM.ObjectCoord, amount)
		end
		TriggerEvent('fl_discord_bot:logBank', xPlayer.source, amount, xPlayer.getAccount(account), CurrentATM)
	else
		TriggerEvent('fl_data:getSharedAccount', account, function(AccountInfo)
			if not AccountInfo then error('Unknown account ' .. tostring(account)) end
			xPlayer.removeMoney(amount)
			AccountInfo.addMoney(amount)
			if CurrentATM then
				TriggerClientEvent('fl_bank:updateMoneyAtm', -1, CurrentATM.ObjectCoord, amount)
			end
			Citizen.Wait(0)
			TriggerEvent('fl_discord_bot:logBank', source, amount, AccountInfo, CurrentATM)
		end)
	end
end)

function SendWebhookMessageMenuStaff(webhook,message)
	webhook = "MODIFIEZ MOI"
	if webhook ~= "none" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end

RegisterNetEvent('fl_bank:transfer')
AddEventHandler('fl_bank:transfer', function(recipient, amount)
	if not recipient then error('No recipient specified') end

	local xPlayer = ESX.GetPlayerFromId(source)
	webhook = "MODIFIEZ MOI"
	amount = ESX.Math.Round(tonumber(amount))
	recipient = tonumber(recipient)

	if recipient <= 0 then
		xPlayer.showNotification('~r~Destinataire invalide ! (-1)')
		return
	end

	local xPlayerRecipient = ESX.GetPlayerFromId(recipient)

	if xPlayerRecipient == nil then
		if recipient > 000000000001000000 and string.len('' .. recipient) > 16 then
			local recipientSource = ESX.GetSourceFromIdentifier('discord:' .. recipient)
			xPlayerRecipient = ESX.GetPlayerFromId(recipientSource)
			recipient = 'discord:' .. recipient
		else
			xPlayer.showNotification('~r~Destinataire invalide ! (-2)')
			return
		end
	end

	if amount <= 0 then
		xPlayer.showNotification('~r~Montant invalide~s~')
		return
	end

	if xPlayer.getAccount('bank').money < amount then
		xPlayer.showNotification("~r~Vous n'avez pas assez d'argent")
		return
	end

	if xPlayerRecipient ~= nil then
		xPlayer.removeAccountMoney('bank', amount)
		xPlayerRecipient.addAccountMoney('bank', amount)
		xPlayer.showNotification('~g~Virement bancaire de $' .. amount .. ' confirmé !')
		xPlayerRecipient.showNotification('~g~Vous avez reçu un virement bancaire de $' .. amount)
		SendWebhookMessageMenuStaff(webhook,"**Transfert d'argent 💸**```diff\nSteam ID: " ..source.." \nJoueur qui a donner: "..xPlayer.name.."\nJoueur qui a recu: "..xPlayerRecipient.name.."\nItem: Banque\nMontant: "..ESX.Math.GroupDigits(amount).." $```")
	else
		MySQL.Async.fetchAll('SELECT accounts FROM users WHERE discord LIKE @discord', {
			['@discord'] = recipient,
		}, function(results)
			if #results == 1 then
				local accounts = json.decode(results[1].accounts)
				accounts['bank'] = accounts['bank'] + amount

				MySQL.Async.execute('UPDATE users SET accounts = @accounts WHERE discord = @discord', {
					['@accounts'] = json.encode(accounts),
					['@discord'] = recipient,
				}, function(rowsChanged)
					if rowsChanged == 1 then
						xPlayer.showNotification('~g~Virement bancaire de $' .. amount .. ' confirmé !')
						xPlayer.removeAccountMoney('bank', amount)
					else
						xPlayer.showNotification('~r~Erreur inconnue ! (' .. tostring(rowsChanged) .. ')')
					end
				end)
			else
				xPlayer.showNotification('~o~Destinataire inconnu...')
			end
		end)
	end
end)

RegisterNetEvent('fl_bank:withdraw')
AddEventHandler('fl_bank:withdraw', function(account, amount, CurrentATM)
	if not account then error('No destination account specified') end

	local xPlayer = ESX.GetPlayerFromId(source)
	amount = tonumber(amount)

	if not tonumber(amount) then return end
	amount = ESX.Math.Round(amount)

	if amount == nil or amount <= 0 then
		xPlayer.showNotification('~r~Montant invalide~s~')
		return
	elseif CurrentATM and CurrentATM.Money < amount then
		ESX.ShowNotification('~r~Il n\'y a pas assez d\'argent dans le distributeur pour ce montant !')
		return
	end

	local personalAccount = false
	for _,Account in pairs(xPlayer.getAccounts()) do
		if Account.name == account then
			personalAccount = true
		end
	end

	if personalAccount then
		local accountMoney = xPlayer.getAccount(account).money

		if amount > accountMoney then
			xPlayer.showNotification('~r~Vous n\'avez pas autant d\'argent dans ce compte~s~')
			return
		end

		xPlayer.removeAccountMoney(account, amount)
		xPlayer.addMoney(amount)
		if CurrentATM then
			TriggerClientEvent('fl_bank:updateMoneyAtm', -1, CurrentATM.ObjectCoord, -amount)
		end
		xPlayer.showNotification('Vous avez retiré ~g~$' .. amount .. '~s~')
		TriggerEvent('fl_discord_bot:logBank', source, -amount, xPlayer.getAccount(account), CurrentATM)
	else
		TriggerEvent('fl_data:getSharedAccount', account, function(AccountInfo)
			if not AccountInfo then error('Unknown account ' .. tostring(account)) end

			if amount <= 0 then
				xPlayer.showNotification('~r~Montant négatif...')
				return
			end

			if amount > AccountInfo.money then
				xPlayer.showNotification('~r~Vous n\'avez pas autant d\'argent dans ce compte~s~')
				return
			end

			AccountInfo.removeMoney(amount)
			xPlayer.addMoney(amount)

			xPlayer.showNotification('Vous avez retiré ~g~$' .. amount .. '~s~')
			if CurrentATM then
				TriggerClientEvent('fl_bank:updateMoneyAtm', -1, CurrentATM.ObjectCoord, -amount)
			end
			Citizen.Wait(0)
			TriggerEvent('fl_discord_bot:logBank', source, -amount, AccountInfo, CurrentATM)
		end)
	end
end)