-- Blips
Citizen.CreateThread(function()
	for _,Shop in pairs(Config.Shops) do
		if not Shop.hide then
			local blip = AddBlipForCoord(Shop.shop)
			SetBlipSprite(blip, 606)
			SetBlipScale(blip, 0.8)
			SetBlipColour(blip, 2)
			SetBlipDisplay(blip, 4)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName('STRING')
			AddTextComponentString(Shop.name)
			EndTextCommandSetBlipName(blip)
		end
	end
end)

-- Menu

function AddLine(elements, action, name, rightLabelColor, rightLabel, data)
	if not rightLabel or not rightLabelColor then
		table.insert(elements, {label = name, action = action, data = data})
		return
	end
	table.insert(elements, {
		label = name,
		rightLabelColor = rightLabelColor,
		rightLabel = rightLabel,
		action = action,
		data = data,
	})
end

function OpenShopMenu(Shop)
	if not Shop then error('no shop') end

	ESX.TriggerServerCallback('fl_simcard:getSimcards', function(simcards)
		local elements = {}

		for _,SimCard in pairs(simcards) do
			if (Shop.illegal and not SimCard.owner) or not Shop.illegal then
				if Config.Sims[SimCard.type].DaySubscription then
					AddLine(elements, SimCard.number, 'Abonnement N°' .. SimCard.id, {26, 188, 156}, SimCard.number, SimCard)
				else
					AddLine(elements, SimCard.number, 'Sim N°' .. SimCard.id, {220, 220, 220}, SimCard.number, SimCard)
				end
			end
		end

		if #simcards == 0 then
			AddLine(elements, 'nosim', 'Aucune sim à votre nom...')
		end

		table.insert(elements, {label = '____________________'})
		if not Shop.illegal then
			AddLine(elements, 'phone', 'Téléphone', 'green', '$200')
		end

		for type,SimInfo in pairs(Config.Sims) do
			if (not SimInfo.Illegal and not Shop.illegal) or (SimInfo.Illegal and Shop.illegal) then
				AddLine(elements, 'sim', SimInfo.Name, 'white', '>>', type)
			end
		end

		ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'simcard_shop_menu', {
			title = Shop.name,
			elements = elements
		}, function(data, menu)
			if data.current.action == 'phone' then
				TriggerServerEvent('fl_simcard:buyPhone')
			elseif tonumber(data.current.action) then
				OpenMenuInfoSim(data.current.data)
			elseif data.current.action == 'sim' then
				OpenMenuBuySim(Shop, data.current.data)
			elseif data.current.action == 'nosim' then
				ESX.ShowNotification('~r~Aucune sim à votre nom...')
			end

		end, function(data, menu)
			PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)
			menu.close()
			hasAlreadyEnteredMarker = false
		end, function(data, menu)
			PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', false)
		end)
	end)
end

function OpenMenuInfoSim(SimCard)
	local SimInfo = Config.Sims[SimCard.type]
	local elements = {}

	AddLine(elements, 'info', 'ID Abonnement', 'blue', SimCard.id)
	AddLine(elements, 'info', 'N°', 'blue', SimCard.number)
	if SimCard.owner then
		AddLine(elements, 'info', 'Propriétaire', 'grey', 'Vous')
	else
		AddLine(elements, 'info', 'Propriétaire', 'grey', 'Inconnu')
	end

	if SimCard.active == 1 then
		AddLine(elements, 'info', 'Etat', 'green', 'Actif')
	else
		AddLine(elements, 'info', 'Etat', 'red', 'Inactif')
	end

	if SimInfo.DaySubscription then
		AddLine(elements, 'info', 'Prix de l\'abonnement', 'green', '$' .. SimInfo.DaySubscription .. '/jour')
	end

	if SimInfo.DefaultCallPlan then
		local right = 'ERROR!'
		if SimInfo.DefaultCallPlan > 0 then
			right = (SimInfo.DefaultCallPlan/60) .. ' min'
			if SimInfo.DefaultCallPlan ~= SimCard.callPlan then
				AddLine(elements, 'info', 'Appels restants', 'lightblue', (SimCard.callPlan/60) .. ' min')
			end
		elseif SimInfo.DefaultCallPlan == -1 then
			right = 'Illimité'
		end
		AddLine(elements, 'info', 'Appels inclus', 'lightblue', right)
	end

	if SimInfo.DefaultSmsPlan then
		local right = 'ERROR!'
		if SimInfo.DefaultCallPlan > 0 then
			right = SimInfo.DefaultSmsPlan .. ' sms'
			if SimInfo.DefaultSmsPlan ~= SimCard.smsPlan then
				AddLine(elements, 'info', 'SMS restants', 'lightblue', SimCard.smsPlan .. ' sms')
			end
		elseif SimInfo.DefaultCallPlan == -1 then
			right = 'Illimité'
		end
		AddLine(elements, 'info', 'SMS inclus', 'lightblue', right)
	end

	table.insert(elements, {label = '____________________'})

	if SimInfo.OneTimeBuy and SimInfo.DaySubscription then
		AddLine(elements, 'dupe', 'Obtenir une autre sim (Cash)', 'green', '$' .. SimInfo.OneTimeBuy)
	end

	if SimCard.active == 1 then
		if SimInfo.DaySubscription then
			AddLine(elements, 'delete', 'Désactiver (Réactivation payante)')
		else
			AddLine(elements, 'delete', 'Désactiver')
		end
	else
		if SimInfo.DaySubscription then
			AddLine(elements, 'activate', 'Réactiver', 'green', '$' .. SimInfo.DaySubscription)
		else
			AddLine(elements, 'activate', 'Réactiver')
		end
	end

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'simcard_info_menu', {
		title =  SimInfo.Name,
		elements = elements
	}, function(data, menu)
		if data.current.action == 'dupe' then
			TriggerServerEvent('fl_simcard:dupeSim', SimCard.number)
			return
		elseif data.current.action == 'delete' then
			TriggerServerEvent('fl_simcard:toggleSim', SimCard.number, false)
		elseif data.current.action == 'activate' then
			TriggerServerEvent('fl_simcard:toggleSim', SimCard.number, true)
		else
			return
		end
		menu.close()

		local loading = ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'loading', {
			title =  'Chargement...',
			elements = {{label = 'Nous contactons votre opérateur...'}}
		}, function(data, menu)
		end, function(data, menu)
		end, function(data, menu)
		end)

		Citizen.Wait(2000)

		ESX.TriggerServerCallback('fl_simcard:getSimcards', function(simcards)
			for _,AnySimCard in pairs(simcards) do
				if AnySimCard.number == SimCard.number then
					loading.close()
					ESX.UI.Menu.CloseAll()
					OpenMenuInfoSim(AnySimCard)
					break
				end
			end
		end)
	end, function(data, menu)
		PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)
		menu.close()
	end, function(data, menu)
		PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', false)
	end)
end

function OpenMenuBuySim(Shop, type)
	ESX.TriggerServerCallback('fl_billing:hasTooManyBills', function(hasTooManyBills)
		local SimInfo = Config.Sims[type]
		local elements = {}

		if SimInfo.OneTimeBuy then
			AddLine(elements, 'info', 'Prix d\'achat', 'green', '$' .. SimInfo.OneTimeBuy)
		end
		if SimInfo.DaySubscription then
			AddLine(elements, 'info', 'Prix de l\'abonnement', 'green', '$' .. SimInfo.DaySubscription .. '/jour')
		end

		if SimInfo.DefaultCallPlan then
			local right = 'ERROR!'
			if SimInfo.DefaultCallPlan > 0 then
				right = (SimInfo.DefaultCallPlan/60) .. ' min'
			elseif SimInfo.DefaultCallPlan == -1 then
				right = 'Illimité'
			end
			AddLine(elements, 'info', 'Appels inclus', 'lightblue', right)
		end

		if SimInfo.DefaultSmsPlan then
			local right = 'ERROR!'
			if SimInfo.DefaultCallPlan > 0 then
				right = SimInfo.DefaultSmsPlan .. ' sms'
			elseif SimInfo.DefaultCallPlan == -1 then
				right = 'Illimité'
			end
			AddLine(elements, 'info', 'SMS inclus', 'lightblue', right)
		end

		if SimInfo.Prefix then
			AddLine(elements, 'info', 'Numéro', 'lightblue', SimInfo.Prefix .. 'XXXX')
		end

		table.insert(elements, {label = '____________________'})

		local cashTxt = 'Payer en liquide'
		if SimInfo.DaySubscription then
			cashTxt = cashTxt .. ' (puis CB pour abo\')'
		end
		AddLine(elements, 'cash', cashTxt .. '')
		if not Shop.illegal then
			AddLine(elements, 'bank', 'Payer par Carte Bleu')
		end

		ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'simcard_buy_menu', {
			title = 'Acheter ' .. SimInfo.Name,
			elements = elements
		}, function(data, menu)
			if data.current.action == 'info' then

			elseif data.current.action == 'cash' then
				TriggerServerEvent('fl_simcard:buySimcard', type, true)
			elseif data.current.action == 'bank' then
				if hasTooManyBills then
					xPlayer.showNotification("Carte bancaire ~r~refusée")
				else
					TriggerServerEvent('fl_simcard:buySimcard', type, false)
				end
			end

			Citizen.Wait(400)
			OpenShopMenu(Shop)
		end, function(data, menu)
			PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)
			menu.close()
		end, function(data, menu)
			PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', false)
		end)
	end)
end
