math.randomseed(os.time())

RegisteredSimCards = {}

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM simcards', {}, function(results)
		print('Registering ' .. #results .. ' sim cards')
		for _,SimInfo in pairs(results) do
			RegisteredSimCards[SimInfo.number] = SimInfo

			RegisterSim(SimInfo.number)
		end

		MySQL.Async.fetchAll('SELECT discord,phone_number FROM users', {}, function(results)
			local i = 0
			for _,UserInfo in pairs(results) do
				if UserInfo.phone_number > 0 and RegisteredSimCards[UserInfo.phone_number] == nil then
					CreateNewSim(UserInfo.discord, 0, UserInfo.phone_number)
					i = i + 1
				end
			end

			if i > 0 then
				print('Registered ' .. i .. ' original system simcards')
			end
		end)
	end)
end)

function UpdateData(Number)
	MySQL.Async.fetchAll('SELECT * FROM simcards WHERE number = @number', { ['@number'] = Number }, function(results)
		for _,SimInfo in pairs(results) do
			RegisteredSimCards[SimInfo.number] = SimInfo
		end
	end)
end

function CreateNewSim(owner, type, number)
	RegisterSim(number)

	if not RegisteredSimCards[number] then
		MySQL.Async.execute("INSERT INTO `simcards` (`id`, `owner`, `type`, `number`, `callPlan`, `smsPlan`) VALUES (NULL, @owner, @type, @number, @callPlan, @smsPlan);", {
			['@owner'] = owner,
			['@type'] = type,
			['@number'] = number,
			['@callPlan'] = Config.Sims[type].DefaultCallPlan,
			['@smsPlan'] = Config.Sims[type].DefaultSmsPlan,
		}, function(lines)
			if lines == 1 then
				UpdateData(number)
			else
				error('Create new sim error')
			end
		end)
	end
end

function ToggleSim(number, active)
	local SimCard = RegisteredSimCards[number]
	local SimInfo = Config.Sims[SimCard.type]

	if RegisteredSimCards[number] then
		MySQL.Async.fetchAll('SELECT * FROM users WHERE phone_number = @number', { ['@number'] = number }, function(results)
			if #results == 0 then
				return
			end

			for _,UserInfo in pairs(results) do
				local xPlayer = ESX.GetPlayerFromDiscordIdentifier(UserInfo.discord)
				if xPlayer then
					if not active then
						TriggerClientEvent('fl_simcard:ejectMySim', xPlayer.source)
						xPlayer.showNotification("~o~Désactivation de la carte sim ~b~" .. number)
					else
						xPlayer.showNotification("~o~Activation de la carte sim ~b~" .. number)
					end
				else
					MySQL.Async.execute('UPDATE `users` SET phone_number=0 WHERE phone_number = @number AND discord = @discord;', {
						['@number'] = number,
						['@discord'] = UserInfo.discord,
					}, function(lines)
						if #lines ~= 1 then
							error('Error on input a simcard for offline togglesim')
						end
					end)

					MySQL.Async.execute('INSERT INTO `user_inventory`(`id`, `discord`, `item`, `count`) VALUES (@discord, @item, 1);', {
						['@discord'] = UserInfo.discord,
						['@item'] = Config.ItemPrefix..number,
					}, function(lines)
						if #lines ~= 1 then
							error('Error on input a simcard for offline togglesim')
						end
					end)
				end
			end
		end)

		MySQL.Async.execute("UPDATE `simcards` SET `active` = @active WHERE number = @number;", {
			['@active'] = active,
			['@number'] = number,
		}, function(lines)
			if lines == 1 then
				UpdateData(number)
			else
				xPlayer.showNotification("~r~Erreur aucune carte sim avec ce numéro : " .. tostring(number))
				error('ToggleSim error #0')
			end
		end)
	else
		error('Unknown number to disable ' .. tostring(number))
	end
end

function RegisterSim(number)
	ESX.RegisterTempItem(Config.ItemPrefix..number, 'Carte Sim (' .. number .. ')', 0.001, -1, 0)

	ESX.RegisterUsableItem(Config.ItemPrefix..number, function(source)
		if RegisteredSimCards[number] and RegisteredSimCards[number].active == 1 then
			TriggerClientEvent('fl_simcard:startNumChange', source, number)
		else
			TriggerClientEvent('esx:showNotification', source, '~r~La carte sim est inactive... Contactez votre opérateur !')
		end
	end)
end

function GetAvailablePhoneNumber(prefix)
	local number = nil
	repeat
		number = GetRandomPhoneNumber(prefix)
	until number and not IsNumberUsed(number)
	return number
end

function GetRandomPhoneNumber(prefix)
	return prefix * 10000 + math.random(0000,9999)
end

function IsNumberUsed(number)
	local results = MySQL.Sync.fetchAll('SELECT * FROM simcards WHERE number = @number', {['@number'] = number})
	return #results > 0
end

function GetSimcards(source)
	local simcards = {}
	local xPlayer = ESX.GetPlayerFromId(source)

	for Number,SimCard in pairs(RegisteredSimCards) do
		if SimCard.owner == xPlayer.discord then
			table.insert(simcards, SimCard)
		end
	end

	for _,item in ipairs(xPlayer.getInventory()) do
		if item.name:find(Config.ItemPrefix) then
			for Number,SimCard in pairs(RegisteredSimCards) do
				if SimCard.owner == nil then
					if item.name == Config.ItemPrefix..Number then
						table.insert(simcards, SimCard)
					end
				end
			end
		end
	end

	return simcards
end

RegisterNetEvent('fl_simcard:toggleSim')
AddEventHandler('fl_simcard:toggleSim', function(number, toggle)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not RegisteredSimCards[number] or (RegisteredSimCards[number].owner ~= xPlayer.discord and RegisteredSimCards[number].owner) then
		xPlayer.showNotification("~r~Vous n'êtes pas le propriétaire de cette sim")
		return
	end

	local SimCard = RegisteredSimCards[number]
	local SimInfo = Config.Sims[SimCard.type]

	if toggle and SimInfo.DaySubscription then
		if xPlayer.getMoney() < SimInfo.DaySubscription then
			xPlayer.showNotification("Vous n'avez pas assez de ~r~cash")
			return
		end

		xPlayer.removeMoney(SimInfo.DaySubscription)
	end

	ToggleSim(number, toggle)
end)

RegisterNetEvent('fl_simcard:dupeSim')
AddEventHandler('fl_simcard:dupeSim', function(number)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not RegisteredSimCards[number] or (RegisteredSimCards[number].owner ~= xPlayer.discord and RegisteredSimCards[number].owner) then
		xPlayer.showNotification("~r~Vous n'êtes pas le propriétaire de cette sim")
		return
	end

	local SimCard = RegisteredSimCards[number]
	local SimInfo = Config.Sims[SimCard.type]

	if xPlayer.getMoney() < SimInfo.OneTimeBuy then
		xPlayer.showNotification("Vous n'avez pas assez de ~r~cash")
		return
	end

	xPlayer.addInventoryItem(Config.ItemPrefix..number, 1)
	xPlayer.removeMoney(SimInfo.OneTimeBuy)
	xPlayer.showNotification("~g~Vous avez obtenu une carte sim ~b~" .. number)
end)

RegisterNetEvent('fl_simcard:changeNumber')
AddEventHandler('fl_simcard:changeNumber', function(newNum)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT phone_number FROM users WHERE discord = @discord', {['@discord'] = xPlayer.discord},
		function(results)
			local oldNum = results[1].phone_number
			MySQL.Async.execute('UPDATE users SET phone_number = @phone_number WHERE discord = @discord', {
				['@discord'] = xPlayer.discord,
				['@phone_number'] = newNum
			})

			if newNum ~= 0 then
				xPlayer.removeInventoryItem(Config.ItemPrefix .. newNum, 1)
			end

			if oldNum ~= 0 then
				xPlayer.addInventoryItem(Config.ItemPrefix .. oldNum, 1)
			end

			TriggerClientEvent('fl_simcard:success', _source, newNum)
		end)
end)

-- Credit

RegisterNetEvent('fl_simcard:useSmsCredit')
AddEventHandler('fl_simcard:useSmsCredit', function(number)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not RegisteredSimCards[number] then
		xPlayer.showNotification("~r~Erreur !")
		return
	end

	local SimCard = RegisteredSimCards[number]
	local SimInfo = Config.Sims[SimCard.type]

	if SimCard.smsPlan == -1 then
		return
	end

	if SimCard.smsPlan == 0 then
		xPlayer.showNotification("~r~Crédit SMS vide.")
		return
	end

	if SimCard.smsPlan - 1 == 0 then
		xPlayer.showNotification("~r~Vous venez de vider le crédit SMS de cette carte SIM...")
	end

	MySQL.Async.execute("UPDATE `simcards` SET `smsPlan` = @smsPlan WHERE number=@number;", {
		['@smsPlan'] = SimCard.smsPlan - 1,
		['@number'] = number,
	}, function(lines)
		if lines == 1 then
			UpdateData(number)
		else
			error('error')
		end
	end)
end)

RegisterNetEvent('fl_simcard:useCallCredit')
AddEventHandler('fl_simcard:useCallCredit', function(number, time)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not RegisteredSimCards[number] then
		xPlayer.showNotification("~r~Erreur !")
		return
	end

	local SimCard = RegisteredSimCards[number]
	local SimInfo = Config.Sims[SimCard.type]

	if SimCard.callPlan == -1 then
		return
	end

	if SimCard.callPlan == 0 then
		xPlayer.showNotification("~r~Crédit appel vide.")
		return
	end

	local newCallPlan = SimCard.callPlan - math.floor(time + 0.5)

	if newCallPlan < 0 then
		xPlayer.showNotification("~r~Vous venez de vider le crédit appel de cette carte SIM...")
		newCallPlan = 0
	end

	MySQL.Async.execute("UPDATE `simcards` SET `callPlan` = @callPlan WHERE number=@number;", {
		['@callPlan'] = newCallPlan,
		['@number'] = number,
	}, function(lines)
		if lines == 1 then
			UpdateData(number)
		else
			error('error')
		end
	end)
end)

ESX.RegisterServerCallback('fl_simcard:hasSmsCredit', function(xPlayer, source, cb, number)
	local SimCard = RegisteredSimCards[number]
	local SimInfo = Config.Sims[SimCard.type]

	cb(SimCard.smsPlan == -1 or SimCard.smsPlan > 0)
end)

ESX.RegisterServerCallback('fl_simcard:hasCallCredit', function(xPlayer, source, cb, number)
	local SimCard = RegisteredSimCards[number]
	local SimInfo = Config.Sims[SimCard.type]

	cb(SimCard.callPlan == -1 or SimCard.callPlan > 0)
end)

--

ESX.RegisterServerCallback('fl_simcard:hasSimcard', function(xPlayer, source, cb, target)
	local xPlayerTarget = ESX.GetPlayerFromId(target)

	MySQL.Async.fetchAll('SELECT phone_number FROM users WHERE discord = @discord', {['@discord'] = xPlayerTarget.discord},
		function(results)
			cb(results[1] ~= nil and results[1].phone_number ~= nil and results[1].phone_number > 0)
		end)
end)

ESX.RegisterServerCallback('fl_simcard:getSimcards', function(xPlayer, source, cb)
	local simcards = {}

	for Number,SimCard in pairs(RegisteredSimCards) do
		if SimCard.owner == xPlayer.discord then
			table.insert(simcards, SimCard)
		end
	end

	for _,item in ipairs(xPlayer.getInventory()) do
		if item.name:find(Config.ItemPrefix) then
			for Number,SimCard in pairs(RegisteredSimCards) do
				if SimCard.owner == nil then
					if item.name == Config.ItemPrefix..Number then
						table.insert(simcards, SimCard)
					end
				end
			end
		end
	end

	cb(simcards)
end)

TriggerEvent('cron:runAt', 23, 05, function()
	print('Running Simcard Payment...')
	local nb = 0
	local total = 0
	for Number,SimCard in pairs(RegisteredSimCards) do
		local SimInfo = Config.Sims[SimCard.type]
		if SimCard.active == 1 and SimCard.owner and SimInfo.DaySubscription then
			nb = nb + 1
			total = total + SimInfo.DaySubscription

			if xPlayer then
				xPlayer.removeAccountMoney('bank', SimInfo.DaySubscription)
				xPlayer.showNotification('Vous payez votre abonnement téléphonique ~b~' .. Number .. ' : ~g~$' .. ESX.Math.GroupDigits(SimInfo.DaySubscription))

				if not (SimInfo.DefaultCallPlan == -1 and SimInfo.DefaultSmsPlan == -1) then
					MySQL.Async.execute('UPDATE `simcards` SET `callPlan`=@callPlan,`smsPlan`=@smsPlan WHERE `number`=@number;', {
						['@callPlan'] = SimInfo.DefaultCallPlan,
						['@smsPlan'] = SimInfo.DefaultSmsPlan,
						['@number'] = Number,
					}, function(lines)
						UpdateData(Number)
					end)
				end
			elseif SimInfo.DaySubscription > 0 then
				MySQL.Async.fetchAll('SELECT accounts FROM users WHERE discord LIKE @discord', {
					['@discord'] = SimCard.owner,
				}, function(results)
					if #results == 1 then
						local accounts = json.decode(results[1].accounts)
						local bank = accounts['bank']
						if bank > -5000 then
							accounts['bank'] = bank - SimInfo.DaySubscription
							MySQL.Async.execute('UPDATE users SET accounts = @accounts WHERE discord = @discord', {
								['@accounts'] = json.encode(accounts),
								['@discord'] = SimCard.owner,
							})

							if not (SimInfo.DefaultCallPlan == -1 and SimInfo.DefaultSmsPlan == -1) then
								MySQL.Async.execute('UPDATE `simcards` SET `callPlan`=@callPlan,`smsPlan`=@smsPlan WHERE `number`=@number;', {
									['@callPlan'] = SimInfo.DefaultCallPlan,
									['@smsPlan'] = SimInfo.DefaultSmsPlan,
									['@number'] = Number,
								}, function(lines)
									UpdateData(Number)
								end)
							end
						else
							print('Not enough money to pay phone ' .. tostring(SimCard.owner) .. ' : ' .. tostring(SimInfo.DaySubscription))
							MySQL.Async.execute('UPDATE `simcards` SET `active`=0,`callPlan`=0,`smsPlan`=0 WHERE `number`=@number;', {
								['@number'] = Number,
							})
						end
					else
						print('Multiple user from number' .. tostring(Number))
					end
				end)
			end
		end
		Citizen.Wait(1000)
	end

	print(tostring(nb) .. ' subscriptions paid for a total of $' .. total)
	TriggerEvent('fl_simcard:cron', nb, total)
end)