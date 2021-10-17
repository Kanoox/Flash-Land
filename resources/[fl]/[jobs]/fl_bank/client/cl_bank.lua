-- Blips
Citizen.CreateThread(function()
	for _,Bank in pairs(Config.Banks) do
		local blip = AddBlipForCoord(Bank.guichetPositions[1])
		SetBlipSprite(blip, 108)
		SetBlipScale(blip, 0.8)
		SetBlipColour(blip, 2)
		SetBlipDisplay(blip, 3)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentString('Banque')
		EndTextCommandSetBlipName(blip)

		for _,GuichetPosition in pairs(Bank.guichetPositions) do
			local blip = AddBlipForCoord(GuichetPosition)
			SetBlipSprite(blip, 431)
			SetBlipScale(blip, 0.7)
			SetBlipColour(blip, 3)
			SetBlipDisplay(blip, 5)
			SetBlipAsShortRange(blip, true)
			SetBlipPriority(blip, 10)
		end
	end
end)

function OpenGuichet()
	print('OpenGuichet()')

	if CurrentATM and CurrentATM.Destroyed then
		PlaySoundFrontend(-1, 'HACKING_CLICK_BAD', 0, false)
		ESX.ShowNotification('~r~Cet appareil a été détruit...')
		return
	end

	local societyName = ESX.PlayerData.job.name

	if ESX.PlayerData.job.grade_name ~= 'boss' then
		societyName = 'unemployed'
	end

	ESX.TriggerServerCallback('fl_society:getSocietyMoney', function(societyMoney)
		ESX.TriggerServerCallback('esx:getPlayerData', function(data)
			ESX.TriggerServerCallback('fl_billing:getBills', function(bills)
				local bank = -1
				local black = -1

				for _,Account in pairs(data.accounts) do
					if Account.name == 'bank' then
						bank = Account.money
					elseif Account.name == 'black_money' then
						black = Account.money
					end
				end

				IsMenuOpen = true
				local elements = {}
				local title = 'ATM'

				AddLine(elements, 'nope', nil, 'IBAN : ' .. tostring(string.gsub(ESX.PlayerData.discord, 'discord:', '')))

				AddAccountLine(elements, 'in_hand', 'Argent en poche', 'green', data.money)
				AddAccountLine(elements, 'black_in_hand', 'Argent sale en poche', 'orange', black)
				AddAccountLine(elements, 'bank', 'Compte courant', {0, 111, 238}, bank)

				if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name ~= 'unemployed' and ESX.PlayerData.job.grade_name == 'boss' then
					AddAccountLine(elements, 'society_bank', 'Compte entreprise', {0, 111, 238}, societyMoney)
				end

				AddLine(elements, 'bills', nil, 'Factures', {26, 188, 156}, #bills)
				AddLine(elements, 'transfer', nil, 'Virement bancaire')

				if CurrentATM then
					table.insert(elements, {type = 'separator'})
					if ESX.PlayerData.job ~= 'banker' then
						--table.insert(elements, {label = 'Pirater le distributeur', action = 'hack'})
						--table.insert(elements, {label = 'Détruire le distributeur', action = 'destroy'})
					end
					table.insert(elements, {label = 'Accès de maintenance', action = 'maintenance'})
				else
					title = 'Guichet'
				end

				ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'atm_menu', {
					title = title,
					elements = elements
				}, function(data, menu)
					if data.current.action == 'account' then
						if data.current.account == 'in_hand' then
							RequestAccountSelection(function(account)
								RequestDialogAmount('Combien souhaitez-vous déposer sur votre ' .. account.label .. ' ?', function(amount)
									TriggerServerEvent('fl_bank:deposit', account.account, amount, CurrentATM)
									Citizen.Wait(500)
									OpenGuichet()
								end)
							end)
						elseif data.current.account == 'black_in_hand' then
							ESX.ShowNotification('~r~Les billets sont rejetés par le distributeur !')
						elseif data.current.account == 'bank' then
							ESX.TriggerServerCallback('fl_billing:hasTooManyBills', function(hasTooManyBills)
								if hasTooManyBills then
									ESX.ShowNotification('~r~La banque vous interdit les retraits avec autant d\'impayé !')
									return
								end

								RequestDialogAmount('Combien souhaitez-vous retirer de votre compte courant ?', function(amount)
									if not CurrentATM or CurrentATM.Money >= amount then
										TriggerServerEvent('fl_bank:withdraw', 'bank', amount, CurrentATM)
										Citizen.Wait(500)
										OpenGuichet()
									else
										PlaySoundFrontend(-1, 'HACKING_CLICK_BAD', 0, false)
										ESX.ShowNotification('~r~Il n\'y a pas assez d\'argent dans le distributeur pour ce montant !')
										ESX.ShowNotification('~b~Il reste uniquement ' .. CurrentATM.Money .. ' $ dans ce distributeur')
									end
								end)
							end)
						elseif data.current.account == 'society_bank' then
							RequestDialogAmount('Combien souhaitez-vous retirer de votre compte de société ?', function(amount)
								if not CurrentATM or CurrentATM.Money >= amount then
									TriggerServerEvent('fl_bank:withdraw', 'society_' .. ESX.PlayerData.job.name, amount, CurrentATM)
									Citizen.Wait(500)
									OpenGuichet()
								else
									PlaySoundFrontend(-1, 'HACKING_CLICK_BAD', 0, false)
									ESX.ShowNotification('~r~Il n\'y a pas assez d\'argent dans le distributeur pour ce montant !')
									ESX.ShowNotification('~b~Il reste uniquement ' .. CurrentATM.Money .. ' $ dans ce distributeur')
								end
							end)
						end
					elseif data.current.action == 'bills' then
						if #bills > 0 then
							OpenBillMenu()
						else
							ESX.ShowNotification('~r~Aucune facture à payer')
						end
					elseif data.current.action == 'transfer' then
						RequestDialogAmount('Transfère vers quel compte ?', function(recipient)
							RequestDialogAmount('Montant à transferer ?', function(amount)
								TriggerServerEvent('fl_bank:transfer', recipient, amount)
								Citizen.Wait(500)
								OpenGuichet()
							end)
						end)
					elseif data.current.action == 'destroy' then
						menu.close()
						RequestAnimDict('amb@prop_human_bum_bin@idle_b')
						repeat
							Citizen.Wait(0)
						until HasAnimDictLoaded('amb@prop_human_bum_bin@idle_b')

						TriggerServerEvent('3dme:shareDisplay', '*La personne détruit le distributeur*')
						TaskPlayAnim(PlayerPedId(), 'amb@prop_human_bum_bin@idle_b', 'idle_d', 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
						Citizen.Wait(3000)
						StopAnimTask(PlayerPedId(), 'amb@prop_human_bum_bin@idle_b', 'idle_d', 1.0)
						TriggerServerEvent('3dme:shareDisplay', '*La personne détruit le distributeur*')
						TriggerServerEvent('fl_bank:destroyAtm', CurrentATM)
					elseif data.current.action == 'maintenance' then
						if ESX.PlayerData.job.name == 'banker' then
							ESX.ShowNotification('~g~Argent dans l\'atm : ' .. CurrentATM.Money .. ' $')
						else
							PlaySoundFrontend(-1, 'HACKING_CLICK_BAD', 0, false)
							ESX.ShowNotification('~r~Vous n\'avez pas accès à la maintenance de cet appareil')
						end
					elseif data.current.action == 'hack' then
						menu.close()
						RequestAnimDict('amb@prop_human_bum_bin@idle_b')
						repeat
							Citizen.Wait(0)
						until HasAnimDictLoaded('amb@prop_human_bum_bin@idle_b')

						TaskPlayAnim(PlayerPedId(), 'amb@prop_human_bum_bin@idle_b', 'idle_d', 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
		   				TriggerServerEvent('3dme:shareDisplay', '*La personne hack le distributeur*')
						TriggerEvent('fl_bank:seqStartHack', 3, 20, function(seqSwitch, seqRemaingingTime, success)
							StopAnimTask(PlayerPedId(), 'amb@prop_human_bum_bin@idle_b', 'idle_d', 1.0)
							if seqRemaingingTime > 0 then
								TriggerServerEvent('fl_bank:hackAtm', CurrentATM)
							else
								ESX.ShowNotification('~r~Vous avez échoué le hack...')
							end
							hasAlreadyEnteredMarker = false
						end)
					end
				end, function(data, menu)
					PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)
					menu.close()
					hasAlreadyEnteredMarker = false
				end, function(data, menu)
					PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', false)
				end)
			end)
		end)
	end, societyName)
end

function AddAccountLine(elements, account, name, color, money)
	AddLine(elements, 'account', account, name, color, ESX.Math.GroupDigits(tonumber(money)) .. ' $')
end

function AddLine(elements, action, account, name, rightLabelColor, rightLabel)
	if not rightLabel or not rightLabelColor then
		table.insert(elements, {label = name, action = action, account = account})
		return
	end

	table.insert(elements, {
		label = name,
		rightLabelColor = rightLabelColor,
		rightLabel = rightLabel,
		action = action,
		account = account,
	})
end

function RequestDialogAmount(title, result)
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'dialog_amount', { title = title },
		function(data, menu)
			local amount = tonumber(data.value)
			if amount == nil then
				ESX.ShowNotification('~r~Montant invalide')
			else
				menu.close()
				result(amount)
			end
		end,
		function(data, menu)
			menu.close()
		end
	)
end

function RequestAccountSelection(result)
	local elements = {}

	AddLine(elements, 'account', 'bank', 'Compte courant')

	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name ~= 'unemployed' and ESX.PlayerData.job.grade_name == 'boss' then
		AddLine(elements, 'account', 'society_' .. ESX.PlayerData.job.name, 'Compte entreprise')
	end

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'atm_account_selection', {
		title = 'Déposer sur quel compte ?',
		elements = elements
	}, function(data, menu)
		menu.close()
		result(data.current)
	end, function(data, menu)
		PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)
		menu.close()
	end, function(data, menu)
		PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', false)
	end)
end

function OpenBillMenu()
	ESX.TriggerServerCallback('fl_billing:getBills', function(bills)
		local elements = {}

		for _,bill in pairs(bills) do
			AddAccountLine(elements, bill.id, bill.label, 'orange', bill.amount)
		end

		ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'bill_list', {
			title = 'Liste des factures',
			elements = elements
		}, function(data, menu)
			ESX.TriggerServerCallback('fl_billing:payBill', function()
				OpenBillMenu()
			end, data.current.account)
			menu.close()
		end, function(data, menu)
			PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)
			menu.close()
		end, function(data, menu)
			PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', false)
		end)
	end)
end
