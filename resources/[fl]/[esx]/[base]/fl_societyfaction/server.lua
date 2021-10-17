local Factions = {}
local RegisteredSocietiesFaction = {}

function GetSocietyFaction(name)
	for i=1, #RegisteredSocietiesFaction, 1 do
		if RegisteredSocietiesFaction[i].name == name then
			return RegisteredSocietiesFaction[i]
		end
	end
end

MySQL.ready(function()
	local result = MySQL.Sync.fetchAll('SELECT * FROM factions', {})

	for i=1, #result, 1 do
		Factions[result[i].name] = result[i]
		Factions[result[i].name].grades = {}
	end

	local result2 = MySQL.Sync.fetchAll('SELECT * FROM faction_grades', {})

	for i=1, #result2, 1 do
		Factions[result2[i].faction_name].grades[tostring(result2[i].grade)] = result2[i]
	end
end)

AddEventHandler('fl_societyfaction:registerSocietyFaction', function(name, label, account, datastore, inventory, data)
	local found = false

	local society = {
		name = name,
		label = label,
		account = account,
		datastore = datastore,
		inventory = inventory,
		data = data,
	}

	for i=1, #RegisteredSocietiesFaction, 1 do
		if RegisteredSocietiesFaction[i].name == name then
			found = true
			RegisteredSocietiesFaction[i] = society
			break
		end
	end

	if not found then
		table.insert(RegisteredSocietiesFaction, society)
	end
end)

AddEventHandler('fl_societyfaction:getSocietiesFaction', function(cb)
	cb(RegisteredSocietiesFaction)
end)

AddEventHandler('fl_societyfaction:getSocietyFaction', function(name, cb)
	cb(GetSocietyFaction(name))
end)

RegisterNetEvent('fl_societyfaction:withdrawMoneyFaction')
AddEventHandler('fl_societyfaction:withdrawMoneyFaction', function(society, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local society = GetSocietyFaction(society)
	amount = ESX.Math.Round(tonumber(amount))

	if xPlayer.faction.name ~= society.name then
		print(('fl_societyfaction: %s attempted to call withdrawMoneyFaction!'):format(xPlayer.discord))
		return
	end

	TriggerEvent('fl_data:getSharedAccount', society.account, function(account)
		if amount > 0 and account.money >= amount then
			account.removeMoney(amount)
			xPlayer.addMoney(amount)

			xPlayer.showNotification(_U('have_withdrawn', ESX.Math.GroupDigits(amount)))
		else
			xPlayer.showNotification(_U('invalid_amount'))
		end
	end)
end)

RegisterNetEvent('fl_societyfaction:depositMoneyFaction')
AddEventHandler('fl_societyfaction:depositMoneyFaction', function(society, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local society = GetSocietyFaction(society)
	amount = ESX.Math.Round(tonumber(amount))

	if xPlayer.faction.name ~= society.name then
		print(('fl_societyfaction: %s attempted to call depositMoneyFaction!'):format(xPlayer.discord))
		return
	end

	if amount > 0 and xPlayer.getMoney() >= amount then
		TriggerEvent('fl_data:getSharedAccount', society.account, function(account)
			xPlayer.removeMoney(amount)
			account.addMoney(amount)
		end)

		xPlayer.showNotification(_U('have_deposited', ESX.Math.GroupDigits(amount)))
	else
		xPlayer.showNotification(_U('invalid_amount'))
	end
end)

ESX.RegisterServerCallback('fl_societyfaction:getVehiclesInGarage', function(xPlayer, source, cb, societyName)
	local society = GetSocietyFaction(societyName)

	TriggerEvent('fl_datastore:getSharedDataStore', society.datastore, function(store)
		local garage = store.get('garage') or {}
		cb(garage)
	end)
end)

RegisterNetEvent('fl_societyfaction:putVehicleInGarageFaction')
AddEventHandler('fl_societyfaction:putVehicleInGarageFaction', function(societyName, vehicle)
	local society = GetSocietyFaction(societyName)

	TriggerEvent('fl_datastore:getSharedDataStore', society.datastore, function(store)
		local garage = store.get('garage') or {}

		table.insert(garage, vehicle)
		store.set('garage', garage)
	end)
end)

RegisterNetEvent('fl_societyfaction:removeVehicleFromGarageFaction')
AddEventHandler('fl_societyfaction:removeVehicleFromGarageFaction', function(societyName, vehicle)
	local society = GetSocietyFaction(societyName)

	TriggerEvent('fl_datastore:getSharedDataStore', society.datastore, function(store)
		local garage = store.get('garage') or {}

		for i=1, #garage, 1 do
			if garage[i].plate == vehicle.plate then
				table.remove(garage, i)
				break
			end
		end

		store.set('garage', garage)
	end)
end)

ESX.RegisterServerCallback('fl_societyfaction:getSocietyMoneyFaction', function(xPlayer, source, cb, societyName)
	local society = GetSocietyFaction(societyName)

	if society then
		TriggerEvent('fl_data:getSharedAccount', society.account, function(account)
			cb(account.money)
		end)
	else
		cb(0)
	end
end)

ESX.RegisterServerCallback('fl_societyfaction:getEmployeesFaction', function(xPlayer, source, cb, society)
	MySQL.Async.fetchAll('SELECT firstname, lastname, discord, faction, faction_grade FROM users WHERE faction = @faction ORDER BY faction_grade DESC', {
		['@faction'] = society
	}, function (results)
		local employees = {}

		for i=1, #results, 1 do
			table.insert(employees, {
				name = results[i].firstname .. ' ' .. results[i].lastname,
				discord = results[i].discord,
				faction = {
					name = results[i].faction,
					label = Factions[results[i].faction].label,
					grade = results[i].faction_grade,
					grade_name  = Factions[results[i].faction].grades[tostring(results[i].faction_grade)].name,
					grade_label = Factions[results[i].faction].grades[tostring(results[i].faction_grade)].label
				}
			})
		end

		cb(employees)
	end)
end)

ESX.RegisterServerCallback('fl_societyfaction:getFaction', function(xPlayer, source, cb, society)
	local faction = json.decode(json.encode(Factions[society]))
	local grades = {}

	for k,v in pairs(faction.grades) do
		table.insert(grades, v)
	end

	table.sort(grades, function(a, b)
		return a.grade < b.grade
	end)

	faction.grades = grades

	cb(faction)
end)


ESX.RegisterServerCallback('fl_societyfaction:setFaction', function(xPlayer, source, cb, discord, faction, grade, type)
	local isBoss = xPlayer.faction.grade_name == 'boss'

	if isBoss then
		local xTarget = ESX.GetPlayerFromDiscordIdentifier(discord)

		if xTarget then
			xTarget.setFaction(faction, grade)

			if type == 'hire' then
				TriggerClientEvent('esx:showNotification', xTarget.source, _U('you_have_been_hired', faction))
			elseif type == 'promote' then
				TriggerClientEvent('esx:showNotification', xTarget.source, _U('you_have_been_promoted'))
			elseif type == 'fire' then
				TriggerClientEvent('esx:showNotification', xTarget.source, _U('you_have_been_fired', xTarget.getFaction().label))
			end

			cb()
		else
			MySQL.Async.execute('UPDATE users SET faction = @faction, faction_grade = @faction_grade WHERE discord = @discord', {
				['@faction'] = faction,
				['@faction_grade']  = grade,
				['@discord'] = discord
			}, function(rowsChanged)
				cb()
			end)
		end
	else
		print(('fl_societyfaction: %s attempted to setFaction'):format(xPlayer.discord))
		cb()
	end
end)

ESX.RegisterServerCallback('fl_societyfaction:setFactionSalary', function(xPlayer, source, cb, faction, grade, salary)
	local isBoss = isPlayerBossFaction(source, faction)

	if isBoss then
		if salary <= Config.MaxSalary then
			MySQL.Async.execute('UPDATE faction_grades SET salary = @salary WHERE faction_name = @faction_name AND grade = @grade', {
				['@salary'] = salary,
				['@faction_name'] = faction,
				['@grade'] = grade
			}, function(rowsChanged)
				Factions[faction].grades[tostring(grade)].salary = salary
				local xPlayers = ESX.GetPlayers()

				for i=1, #xPlayers, 1 do
					local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

					if xPlayer.faction.name == faction and xPlayer.faction.grade == grade then
						xPlayer.setFaction(faction, grade)
					end
				end

				cb()
			end)
		else
			print(('fl_societyfaction: %s attempted to setFactionSalary over config limit!'):format(xPlayer.discord))
			cb()
		end
	else
		print(('fl_societyfaction: %s attempted to setFactionSalary'):format(xPlayer.discord))
		cb()
	end
end)

ESX.RegisterServerCallback('fl_societyfaction:getOnlinePlayersFaction', function(xPlayer, source, cb)
	local xPlayers = ESX.GetPlayers()
	local players  = {}

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		table.insert(players, {
			source = xPlayer.source,
			discord = xPlayer.discord,
			name = xPlayer.name,
			faction = xPlayer.faction
		})
	end

	cb(players)
end)

ESX.RegisterServerCallback('fl_societyfaction:getVehiclesInGarageFaction', function(xPlayer, source, cb, societyName)
	local society = GetSocietyFaction(societyName)

	TriggerEvent('fl_datastore:getSharedDataStore', society.datastore, function(store)
		local garage = store.get('garage') or {}
		cb(garage)
	end)
end)

ESX.RegisterServerCallback('fl_societyfaction:isBossFaction', function(xPlayer, source, cb, faction)
	cb(isPlayerBossFaction(source, faction))
end)

function isPlayerBossFaction(playerId, faction)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer.faction.name == faction and xPlayer.faction.grade_name == 'boss' then
		return true
	else
		print(('fl_societyfaction: %s attempted open a society boss menu!'):format(xPlayer.discord))
		return false
	end
end
