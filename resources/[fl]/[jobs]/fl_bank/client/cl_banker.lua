function OpenBankActionsMenu()
	local elements = {
		{ label = 'Livret bleu', value = 'blue_booklet' },
		{ label = 'Liste des clients', value = 'list_customers' },
		{ label = 'Consultation des comptes', value = 'list_accounts' },
		{ label = 'Consultation des comptes entreprises', value = 'list_accounts_societies' },
		{ label = 'Historique des transactions', value = 'history' },
		{ label = 'Liste des banques', value = 'bank_list' },
		{ label = 'Facturation', value = 'billing' },
		{ label = 'Déposer du stock', value = 'put_stock' },
		{ label = 'Récupérer du stock', value = 'get_stock' },
		{ label = 'Facture impayées (en face de vous)', value = 'unpaid_bills' },
	}

	if ESX.PlayerData.job.grade_name == 'boss' then
		table.insert(elements, { label = 'Action Patron', value = 'boss_actions' })
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'bank_actions', {
		title    = 'Banque',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'blue_booklet' then
			OpenBlueBookletCustomersMenu()
		elseif data.current.value == 'billing' then
			OpenBilling()
		elseif data.current.value == 'boss_actions' then
			TriggerEvent('fl_society:openBossMenu', 'banker', function (data, menu)
			end, {})
		elseif data.current.value == 'list_customers' then
			ESX.ShowNotification('~r~Indisponible pour le moment')
		elseif data.current.value == 'list_accounts' then
			OpenAccountsMenu()
		elseif data.current.value == 'history' then
			ESX.ShowNotification('~r~Indisponible pour le moment')
		elseif data.current.value == 'bank_list' then
			ESX.ShowNotification('~r~Indisponible pour le moment')
		elseif data.current.value == 'put_stock' then
			TriggerEvent('fl_society:openPutStocksMenu', 'banker')
		elseif data.current.value == 'get_stock' then
			TriggerEvent('fl_society:openGetStocksMenu', 'banker')
		elseif data.current.value == 'list_accounts_societies' then
			OpenSocietiesAccount()
		elseif data.current.value == 'unpaid_bills' then
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
			if closestPlayer ~= -1 and closestDistance <= 3.0 then
				TriggerEvent('fl_bank:openUnpaidBills', closestPlayer)
			else
				ESX.ShowNotification('~r~Personne en face de vous ...')
			end
		end

	end, function(data, menu)
		menu.close()
		hasAlreadyEnteredMarker = false
	end)
end

function OpenBilling()
	RequestDialogAmount('Montant de la facture', function(amount)
		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

		if closestPlayer == -1 or closestDistance > 5.0 then
			ESX.ShowNotification('Aucun joueur à proximité')
		else
			TriggerServerEvent('fl_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_banker', 'Banque', amount)
		end
	end)
end

function OpenBankMenu()
	local elements = {}

	for _,Bank in pairs(Config.Banks) do
		table.insert(elements, {label = '', bank = Bank})
	end

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'banks_menu', {
		title = 'Liste des banques',
		elements = elements
	}, function(data, menu)
		ESX.ShowNotification('~r~Indisponible pour le moment')
		if data.current.action == 'account' then
		end
	end, function(data, menu)
		PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)
		menu.close()
		hasAlreadyEnteredMarker = false
	end, function(data, menu)
		PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', false)
	end)
end

function OpenSocietiesAccount()
	ESX.TriggerServerCallback('fl_bank:getAccountSocieties', function(AccountSocieties)
		local elements = {
			head = {'Société', 'Référence interne', 'Argent en compte'},
			rows = {}
		}

		for i=1, #AccountSocieties, 1 do
			table.insert(elements.rows, {
				data = AccountSocieties[i],
				cols = {
					AccountSocieties[i].label,
					AccountSocieties[i].account_name,
					ESX.Math.GroupDigits(AccountSocieties[i].money) .. ' $',
				}
			})
		end

		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'societies_list', elements, function(data, menu)

		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenAccountsMenu()
	ESX.TriggerServerCallback('fl_bank:getAllAccounts', function(AccountList)
		local elements = {
			head = {'Nom', 'Prénom', 'Argent en compte'},
			rows = {}
		}

		for i=1, #AccountList, 1 do
			table.insert(elements.rows, {
				data = AccountList[i],
				cols = {
					AccountList[i].lastname,
					AccountList[i].firstname,
					ESX.Math.GroupDigits(AccountList[i].bank) .. ' $',
				}
			})
		end

		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'account_list', elements, function(data, menu)

		end, function(data, menu)
			menu.close()
		end)
	end)
end

RegisterNetEvent('fl_bank:openUnpaidBills')
AddEventHandler('fl_bank:openUnpaidBills', function(player)
	local elements = {}

	ESX.TriggerServerCallback('fl_billing:getTargetBills', function(bills)
		for k,bill in ipairs(bills) do
			table.insert(elements, {
				label = bill.label,
				billId = bill.id,
				rightLabel = _U('armory_item', ESX.Math.GroupDigits(bill.amount)),
				rightLabelColor = 'red'
			})
		end

		ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'billing', {
			title = _U('unpaid_bills'),
			elements = elements
		}, nil, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player))
end)

function OpenBlueBookletCustomersMenu()
	ESX.TriggerServerCallback('fl_bank:getCustomersBlueBook', function(customers)
		local elements = {
			head = { 'Client', 'Solde', 'Actions' },
			rows = {}
		}

		for i=1, #customers, 1 do
			table.insert(elements.rows, {
				data = customers[i],
				cols = {
					customers[i].name,
					customers[i].bankSavings,
					'{{Virement|deposit}} {{Retrait|withdraw}}'
				}
			})
		end

		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'customers', elements, function(data, menu)
			local customer = data.data

			if data.value == 'deposit' then
				RequestDialogAmount('Montant', function(amount)
					TriggerServerEvent('fl_bank:customerBlueBookDeposit', customer.source, amount)
					OpenBlueBookletCustomersMenu()
				end)
			elseif data.value == 'withdraw' then
				RequestDialogAmount('Montant', function(amount)
					TriggerServerEvent('fl_bank:customerBlueBookWithdraw', customer.source, amount)
					OpenBlueBookletCustomersMenu()
				end)
			end

		end, function(data, menu)
			menu.close()
		end)
	end)
end