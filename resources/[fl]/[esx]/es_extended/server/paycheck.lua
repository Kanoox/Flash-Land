ESX.StartPayCheck = function()

	function payCheck()
		for i, xPlayer in pairs(ESX.GetAllPlayers()) do
			local job = xPlayer.job.grade_name
			local salary = xPlayer.job.grade_salary
			local prime = 20
			local boss = xPlayer.job.grade_name == 'boss'

			if job == 'unemployed' then -- unemployed
				if salary > 0 then
					xPlayer.addAccountMoney('bank', salary)
					TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck'), _U('received_help', salary), 'CHAR_BANK_MAZE', 9)
				end
			else
				TriggerEvent('fl_society:getSociety', xPlayer.job.name, function (society)
					if society ~= nil then -- verified society
						TriggerEvent('fl_data:getSharedAccount', society.account, function (account)
							if account.money >= salary then -- does the society money to pay its employees?
								xPlayer.addAccountMoney('bank', salary)
								account.removeMoney(salary)
								if salary > 0 then
									TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck'), _U('received_salary', salary), 'CHAR_BANK_MAZE', 9)
								end

								if not boss then
									xPlayer.addAccountMoney('bank', prime)
									xPlayer.showNotification('Vous avez reçu votre prime d\'activité: ~g~' .. prime .. '$~s~')
								end
							else
								TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), '', _U('company_nomoney'), 'CHAR_BANK_MAZE', 1)
								if not boss then
									xPlayer.addAccountMoney('bank', prime)
									xPlayer.showNotification('Vous avez reçu votre prime d\'activité: ~g~' .. prime .. '$~s~')
								end
							end
						end)
					else -- not a society
						xPlayer.addAccountMoney('bank', salary)
						TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck'), _U('received_salary', salary), 'CHAR_BANK_MAZE', 9)
						if not boss then
							xPlayer.addAccountMoney('bank', prime)
							xPlayer.showNotification('Vous avez reçu votre prime d\'activité: ~g~' .. prime .. '$~s~')
						end
					end
				end)
			end

			Citizen.Wait(1000)
		end

		SetTimeout(Config.PaycheckInterval, payCheck)

	end

	SetTimeout(Config.PaycheckInterval, payCheck)

end
