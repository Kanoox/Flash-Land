RegisterNetEvent('fl_bank:customerBlueBookDeposit')
AddEventHandler('fl_bank:customerBlueBookDeposit', function (target, amount)
	local xPlayer = ESX.GetPlayerFromId(target)

	TriggerEvent('fl_data:getSharedAccount', 'society_banker', function (account)
		if amount > 0 and account.money >= amount then
			account.removeMoney(amount)

			TriggerEvent('fl_data:getAddonAccount', 'bank_savings', xPlayer.discord, function (account)
				account.addMoney(amount)
			end)
		else
			xPlayer.showNotification('Montant invalide')
		end
	end)
end)

RegisterNetEvent('fl_bank:customerBlueBookWithdraw')
AddEventHandler('fl_bank:customerBlueBookWithdraw', function (target, amount)
	local xPlayer = ESX.GetPlayerFromId(target)

	TriggerEvent('fl_data:getAddonAccount', 'bank_savings', xPlayer.discord, function (account)
		if amount > 0 and account.money >= amount then
			account.removeMoney(amount)

			TriggerEvent('fl_data:getSharedAccount', 'society_banker', function (account)
				account.addMoney(amount)
			end)
		else
			xPlayer.showNotification('Montant invalide')
		end
	end)
end)

ESX.RegisterServerCallback('fl_bank:getCustomersBlueBook', function(xPlayer, source, cb)
	local xPlayers  = ESX.GetPlayers()
	local customers = {}

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

		TriggerEvent('fl_data:getAddonAccount', 'bank_savings', xPlayer.discord, function(account)
			table.insert(customers, {
				source      = xPlayer.source,
				name        = xPlayer.name,
				bankSavings = account.money
			})
		end)
	end

	cb(customers)
end)

function CalculateBankSavings(d, h, m)
	local asyncTasks = {}

	MySQL.Async.fetchAll('SELECT * FROM addon_account_data WHERE account_name = @account_name', {
		['@account_name'] = 'bank_savings'
	}, function(result)
		local bankInterests = 0

		for i=1, #result, 1 do
			local xPlayer = ESX.GetPlayerFromDiscordIdentifier(result[i].owner)

			if xPlayer then
				TriggerEvent('fl_data:getAddonAccount', 'bank_savings', xPlayer.discord, function(account)
					local interests = math.floor(account.money / 100 * Config.BankSavingPercentage)
					bankInterests   = bankInterests + interests

					table.insert(asyncTasks, function(cb)
						account.addMoney(interests)
					end)
				end)
			else
				local interests = math.floor(result[i].money / 100 * Config.BankSavingPercentage)
				local newMoney  = result[i].money + interests
				bankInterests   = bankInterests + interests

				local scope = function(newMoney, owner)
					table.insert(asyncTasks, function(cb)
						MySQL.Async.execute('UPDATE addon_account_data SET money = @money WHERE owner = @owner AND account_name = @account_name',
						{
							['@money']        = newMoney,
							['@owner']        = owner,
							['@account_name'] = 'bank_savings',
						}, function(rowsChanged)
							cb()
						end)
					end)
				end

				scope(newMoney, result[i].owner)
			end
			Citizen.Wait(1000)
		end

		TriggerEvent('fl_data:getSharedAccount', 'society_banker', function(account)
			account.addMoney(bankInterests)
		end)

		Async.parallelLimit(asyncTasks, 5, function(results)
			print('[BANK] Calculated interests')
		end)

	end)
end

TriggerEvent('cron:runAt', 22, 0, CalculateBankSavings)

ESX.RegisterServerCallback('fl_bank:getAccountSocieties', function(xPlayer, source, cb)
	MySQL.Async.fetchAll('SELECT * FROM `addon_account_data` WHERE account_name LIKE \'society_%\' AND account_name NOT LIKE \'%_black\' AND money > 0', {}, function(result)
		local accountSocieties = {}

		for i=1, #result, 1 do
			local society = exports.fl_society:GetSociety(result[i].account_name:gsub("society_", ""))
			if society then
				table.insert(accountSocieties, {
					account_name = result[i].account_name,
					money = result[i].money,
					label = society.label,
				})
			end
		end

		cb(accountSocieties)
	end)
end)

ESX.RegisterServerCallback('fl_bank:getAllAccounts', function(xPlayer, source, cb)
	MySQL.Async.fetchAll('SELECT firstname, lastname, accounts FROM `users` ORDER BY `name` ASC', {}, function(result)
		local allAccounts = {}

		for i=1, #result, 1 do
			table.insert(allAccounts, {
				firstname = result[i].firstname,
				lastname = result[i].lastname,
				bank = json.decode(result[i].accounts).bank,
			})
		end

		cb(allAccounts)
	end)
end)