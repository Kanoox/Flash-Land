Citizen.CreateThread(function()
	SetMapName('San Andreas')
	SetGameType('Roleplay')
end)

Citizen.CreateThread(function()
	while true do
		for _,xPlayer in pairs(ESX.GetAllPlayers()) do
			local playerPed = GetPlayerPed(xPlayer.source)

			if DoesEntityExist(playerPed) then
				local playerCoords = GetEntityCoords(playerPed)
				xPlayer.updateCoords({x = playerCoords.x, y = playerCoords.y, z = playerCoords.z, heading = GetEntityHeading(playerPed)})
			end
			Citizen.Wait(0)
		end
		Citizen.Wait(1000)
	end
end)

RegisterNetEvent('esx:onPlayerJoined')
AddEventHandler('esx:onPlayerJoined', function()
	if not ESX.Players[source] then
		onPlayerJoined(source)
	end
end)

function onPlayerJoined(playerId)
	local discord

	for k,v in ipairs(GetPlayerIdentifiers(playerId)) do
		if string.match(v, 'discord:') then
			discord = v
			break
		end
	end

	if discord then
		if ESX.GetPlayerFromDiscordIdentifier(discord) then
			DropPlayer(playerId, ('ERROR CODE 110444 %s'):format(discord))
		else
			MySQL.Async.fetchScalar('SELECT 1 FROM users WHERE discord = @discord', {
				['@discord'] = discord
			}, function(result)
				if result then
					loadESXPlayer(discord, playerId)
				else
					print('New user ! ' .. tostring(discord))
					local accounts = {}

					for account,money in pairs(Config.StartingAccountMoney) do
						accounts[account] = money
					end

					MySQL.Async.execute('INSERT INTO users (name, accounts, discord) VALUES (@name, @accounts, @discord)', {
						['@name'] = GetPlayerName(playerId),
						['@accounts'] = json.encode(accounts),
						['@discord'] = discord,
					}, function(rowsChanged)
						loadESXPlayer(discord, playerId)
					end)
				end
			end)
		end
	else
		DropPlayer(playerId, 'ERROR CODE 11055')
	end
end

function loadESXPlayer(discord, playerId)
	local tasks = {}

	local userData = {
		firstname = '?',
		lastname = '?',
		accounts = {},
		inventory = {},
		job = {},
		faction = {},
		playerName = GetPlayerName(playerId),
		weight = 0,
	}

	MySQL.Async.execute('UPDATE users SET name = @name, last_update = current_timestamp() WHERE discord = @discord', {
		['@name'] = GetPlayerName(playerId),
		['@discord'] = discord,
	}, function(rowsChanged)
	end)

	table.insert(tasks, function(cb)
		MySQL.Async.fetchAll('SELECT * FROM users WHERE discord = @discord', {
			['@discord'] = discord
		}, function(result)
			userData.firstname = tostring(result[1].firstname)
			userData.lastname = tostring(result[1].lastname)
			local job, job_grade, jobObject, gradeJobObject = result[1].job, tostring(result[1].job_grade)
			local faction, faction_grade, factionObject, gradeFactionObject = result[1].faction, tostring(result[1].faction_grade)
			local foundAccounts, foundItems = {}, {}

			-- Accounts
			if result[1].accounts and result[1].accounts ~= '' then
				local accounts = json.decode(result[1].accounts)

				for account,money in pairs(accounts) do
					if account ~= 'banks' then -- TMP DELETING OF SHIT CODE TODO REMOVE
						foundAccounts[account] = money
					end
				end
			end

			for account,label in pairs(Config.Accounts) do
				table.insert(userData.accounts, {
					name = account,
					money = foundAccounts[account] or Config.StartingAccountMoney[account] or 0,
					label = label
				})
			end

			-- Job
			if ESX.DoesJobExist(job, job_grade) then
				jobObject, gradeJobObject = ESX.Jobs[job], ESX.Jobs[job].grades[job_grade]
			else
				print(('[^3WARNING^7] Ignoring invalid job for %s [job: %s, job_grade: %s]'):format(discord, job, job_grade))
				job, job_grade = 'unemployed', '0'
				jobObject, gradeJobObject = ESX.Jobs[job], ESX.Jobs[job].grades[job_grade]
			end

			userData.job.id = jobObject.id
			userData.job.name = jobObject.name
			userData.job.label = jobObject.label

			userData.job.grade = tonumber(job_grade)
			userData.job.grade_name = gradeJobObject.name
			userData.job.grade_label = gradeJobObject.label
			userData.job.grade_salary = gradeJobObject.salary

			userData.job.skin_male = {}
			userData.job.skin_female = {}

			if gradeJobObject.skin_male then userData.job.skin_male = json.decode(gradeJobObject.skin_male) end
			if gradeJobObject.skin_female then userData.job.skin_female = json.decode(gradeJobObject.skin_female) end

			-- Faction
			if ESX.DoesFactionExist(faction, faction_grade) then
				factionObject, gradeFactionObject = ESX.Factions[faction], ESX.Factions[faction].grades[faction_grade]
			else
				print(('[^3WARNING^7] Ignoring invalid faction for %s [faction: %s, faction_grade: %s]'):format(discord, faction, faction_grade))
				faction, faction_grade = 'resid', '0'
				factionObject, gradeFactionObject = ESX.Factions[faction], ESX.Factions[faction].grades[faction_grade]
			end

			userData.faction.id = factionObject.id
			userData.faction.name = factionObject.name
			userData.faction.label = factionObject.label

			userData.faction.grade = tonumber(faction_grade)
			userData.faction.grade_name = gradeFactionObject.name
			userData.faction.grade_label = gradeFactionObject.label
			userData.faction.grade_salary = gradeFactionObject.salary

			-- Inventory
			if result[1].inventory and result[1].inventory ~= '' then
				local inventory = json.decode(result[1].inventory)

				for name,count in pairs(inventory) do
					local item = ESX.Items[name]

					if item then
						foundItems[name] = count
					else
						print(('[^3WARNING^7] Ignoring invalid item "%s" for "%s"'):format(name, discord))
					end
				end
			end

			for name,item in pairs(ESX.Items) do
				local count = foundItems[name] or 0
				if count > 0 then
					userData.weight = userData.weight + (item.weight * count)

					table.insert(userData.inventory, {
						name = name,
						count = count,
						label = item.label,
						weight = item.weight,
						limit = item.limit,
						usable = ESX.UsableItemsCallbacks[name] ~= nil,
						usableCloseMenu = ESX.UsableItemsCloseMenu[name] ~= nil,
						canRemove = item.canRemove
					})
				end
			end

			table.sort(userData.inventory, function(a, b)
				return a.label < b.label
			end)

			-- Group
			if result[1].group then
				userData.group = result[1].group
			else
				userData.group = 'user'
			end

			-- Position
			if result[1].position and result[1].position ~= '' then
				userData.coords = json.decode(result[1].position)
				if #(vector3(0, 0, 0) - vector3(userData.coords.x, userData.coords.y, userData.coords.z)) < 5 then
					userData.coords = {x = -197.643, y = -784.515, z = 29.454, heading = 249.346}
				end
			else
				userData.coords = {x = -197.643, y = -784.515, z = 29.454, heading = 249.346}
			end
			
			cb()
		end)
	end)

	Async.parallel(tasks, function(results)
		local xPlayer = CreateExtendedPlayer(playerId, discord, userData.group, userData.accounts, userData.inventory, userData.weight, userData.job, userData.faction, userData.playerName, userData.coords, userData.firstname, userData.lastname)
		ESX.PlayersIdentifiers[xPlayer.discord] = xPlayer
		ESX.Players[playerId] = xPlayer
		TriggerEvent('esx:playerLoaded', playerId, xPlayer)

		xPlayer.triggerEvent('esx:playerLoaded', {
			group = xPlayer.getGroup(),
			accounts = xPlayer.getAccounts(),
			coords = xPlayer.getCoords(),
			discord = xPlayer.getDiscordIdentifier(),
			inventory = xPlayer.getInventory(),
			job = xPlayer.getJob(),
			faction = xPlayer.getFaction(),
			weight = xPlayer.getWeight(),
			maxWeight = xPlayer.getMaxWeight(),
			money = xPlayer.getMoney(),
		})

		xPlayer.triggerEvent('esx:createMissingPickups', ESX.Pickups)
		xPlayer.triggerEvent('esx:registerSuggestions', ESX.RegisteredCommands)
		print(('[^2INFO^7] "%s^7" connected (%s)'):format(xPlayer.getName(), playerId))
	end)
end

AddEventHandler('chatMessage', function(playerId, author, message)
	if message:sub(1, 1) == '/' and playerId > 0 then
		CancelEvent()
		local commandName = message:sub(1):gmatch("%w+")()
		TriggerClientEvent('chat:addMessage', playerId, {args = {'^1FreeLife', _U('commanderror_invalidcommand', commandName)}})
	end
end)

AddEventHandler('playerDropped', function(reason)
	local playerId = source
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer then
		TriggerEvent('esx:playerDropped', playerId, reason)

		xPlayer.save(function()
			ESX.PlayersIdentifiers[xPlayer.discord] = nil
			ESX.Players[playerId] = nil
		end)
	end
end)

RegisterNetEvent('esx:updateWeaponAmmo')
AddEventHandler('esx:updateWeaponAmmo', function(weaponName, ammoCount)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		xPlayer.updateWeaponAmmo(weaponName, ammoCount)
	end
end)

function SendWebhookMessageMenuStaff(webhook,message)
	webhook = "MODIFIEZ MOI"
	if webhook ~= "none" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end

RegisterNetEvent('esx:giveInventoryItem')
AddEventHandler('esx:giveInventoryItem', function(target, type, itemName, itemCount)
	local playerId = source
	local sourceXPlayer = ESX.GetPlayerFromId(playerId)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	webhook = "MODIFIEZ MOI"

	if type == 'item_standard' then
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)

		if itemCount > 0 and sourceItem.count >= itemCount then
			if targetXPlayer.canCarryItem(itemName, itemCount) then
				sourceXPlayer.removeInventoryItem(itemName, itemCount)
				targetXPlayer.addInventoryItem   (itemName, itemCount)

				sourceXPlayer.showNotification(_U('gave_item', itemCount, sourceItem.label, targetXPlayer.name))
				targetXPlayer.showNotification(_U('received_item', itemCount, sourceItem.label, sourceXPlayer.name))
				SendWebhookMessageMenuStaff(webhook,"**Echange d'items 💸**```diff\nSteam ID: "..playerId.." \nJoueur qui a donner: "..sourceXPlayer.name.."\nJoueur qui a recu: "..targetXPlayer.name.."\nItem: "..sourceItem.label.."\nMontant: "..itemCount.."```")
			else
				sourceXPlayer.showNotification(_U('ex_inv_lim', targetXPlayer.name))
				targetXPlayer.showNotification(_U('ex_inv_lim', targetXPlayer.name))
			end
		else
			sourceXPlayer.showNotification(_U('imp_invalid_quantity'))
		end
	elseif type == 'item_account' then
		if itemCount > 0 and sourceXPlayer.getAccount(itemName).money >= itemCount then
			sourceXPlayer.removeAccountMoney(itemName, itemCount)
			targetXPlayer.addAccountMoney   (itemName, itemCount)

			sourceXPlayer.showNotification(_U('gave_account_money', ESX.Math.GroupDigits(itemCount), Config.Accounts[itemName], targetXPlayer.name))
			targetXPlayer.showNotification(_U('received_account_money', ESX.Math.GroupDigits(itemCount), Config.Accounts[itemName], sourceXPlayer.name))
			--TriggerEvent("esx:givemoneyalert",sourceXPlayer.name,targetXPlayer.name,ESX.Math.GroupDigits(itemCount))
			SendWebhookMessageMenuStaff(webhook,"**Echange d'argent 💸**```diff\nSteam ID: " ..playerId.." \nJoueur qui a donner: "..sourceXPlayer.name.."\nJoueur qui a recu: "..targetXPlayer.name.."\nItem: "..Config.Accounts[itemName].."\nMontant: "..ESX.Math.GroupDigits(itemCount).."```")
			--TriggerEvent("ruben:sendMessageWebhook", webhook,"```Un joueur à utilisé le /pub "..adInfo.sender.."\nID du joueur: "..player_id.." \nJoueur: "..name.."\nMessage: "..msg.."```Discord: <@" ..ids.discord:gsub("discord:", "")..">\nLien profil steam: https://steamcommunity.com/profiles/" ..tonumber(ids.steam:gsub("steam:", ""),16).."\nSteam ID: **"..ids.steam.."** ")
		else
			sourceXPlayer.showNotification(_U('imp_invalid_amount'))
		end
	end
end)

RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(type, itemName, itemCount)
	local playerId = source
	local xPlayer = ESX.GetPlayerFromId(source)

	if type == 'item_standard' then
		if itemCount == nil or itemCount < 1 then
			xPlayer.showNotification(_U('imp_invalid_quantity'))
		else
			local xItem = xPlayer.getInventoryItem(itemName)

			if (itemCount > xItem.count or xItem.count < 1) then
				xPlayer.showNotification(_U('imp_invalid_quantity'))
			else
				xPlayer.removeInventoryItem(itemName, itemCount)
				local pickupLabel = ('~y~%s~s~ [~b~%s~s~]'):format(xItem.label, itemCount)
				ESX.CreatePickup('item_standard', itemName, itemCount, pickupLabel, playerId)
				xPlayer.showNotification(_U('threw_standard', itemCount, xItem.label))
			end
		end
	elseif type == 'item_account' then
		if itemCount == nil or itemCount < 1 then
			xPlayer.showNotification(_U('imp_invalid_amount'))
		else
			local account = xPlayer.getAccount(itemName)

			if (itemCount > account.money or account.money < 1) then
				xPlayer.showNotification(_U('imp_invalid_amount'))
			else
				xPlayer.removeAccountMoney(itemName, itemCount)
				local pickupLabel = ('~y~%s~s~ [~g~%s~s~]'):format(account.label, _U('locale_currency', ESX.Math.GroupDigits(itemCount)))
				ESX.CreatePickup('item_account', itemName, itemCount, pickupLabel, playerId)
				xPlayer.showNotification(_U('threw_account', ESX.Math.GroupDigits(itemCount), string.lower(account.label)))
			end
		end
	end
end)

RegisterNetEvent('esx:updateWeight')
AddEventHandler('esx:updateWeight', function(weightCapacitorType, value)
	if type(weightCapacitorType) ~= 'string' then error('weightCapacitorType must be a string') end
	if type(value) ~= 'boolean' then error('value must be a boolean') end

	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.updateWeightCapacitor(weightCapacitorType, value)
end)

RegisterNetEvent('esx:useItem')
AddEventHandler('esx:useItem', function(itemName)
	local xPlayer = ESX.GetPlayerFromId(source)
	local count = xPlayer.getInventoryItem(itemName).count

	if count > 0 then
		ESX.UseItem(source, itemName)
	else
		xPlayer.showNotification(_U('act_imp'))
	end
end)

RegisterNetEvent('esx:onPickup')
AddEventHandler('esx:onPickup', function(pickupId)
	local pickup, xPlayer, success = ESX.Pickups[pickupId], ESX.GetPlayerFromId(source)

	if pickup then
		if pickup.type == 'item_standard' then
			if xPlayer.canCarryItem(pickup.name, pickup.count) then
				xPlayer.addInventoryItem(pickup.name, pickup.count)
				success = true
			else
				xPlayer.showNotification(_U('threw_cannot_pickup'))
			end
		elseif pickup.type == 'item_account' then
			success = true
			xPlayer.addAccountMoney(pickup.name, pickup.count)
		end

		if success then
			ESX.Pickups[pickupId] = nil
			TriggerClientEvent('esx:removePickup', -1, pickupId)
		end
	end
end)

ESX.RegisterServerCallback('esx:getPlayerData', function(xPlayer, source, cb)
	cb({
		discord   = xPlayer.discord,
		accounts     = xPlayer.getAccounts(),
		inventory    = xPlayer.getInventory(),
		job          = xPlayer.getJob(),
		faction = xPlayer.getFaction(),
		money        = xPlayer.getMoney()
	})
end)

ESX.RegisterServerCallback('esx:getOtherPlayerData', function(xPlayer, source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)

	cb({
		discord   = xPlayer.discord,
		coords = xPlayer.getCoords(true),
		name = xPlayer.getName(),
		group = xPlayer.getGroup(),
		firstname = xPlayer.getFirstname(),
		lastname = xPlayer.getLastname(),
		weight = xPlayer.getWeight(),
		maxWeight = xPlayer.getMaxWeight(),
		accounts     = xPlayer.getAccounts(),
		inventory    = xPlayer.getInventory(),
		job          = xPlayer.getJob(),
		faction = xPlayer.getFaction(),
	})
end)

ESX.RegisterServerCallback('esx:getListItems', function(xPlayer, source, cb)
	local items = {}

	for itemName,AnyItem in pairs(ESX.Items) do
		if not AnyItem.temp then
			table.insert(items, {
				name = itemName,
				label = AnyItem.label,
				weight = AnyItem.weight,
				limit = AnyItem.limit,
				usable = ESX.UsableItemsCallbacks[itemName] ~= nil,
				usableCloseMenu = ESX.UsableItemsCloseMenu[itemName] ~= nil,
				canRemove = AnyItem.canRemove,
			})
		end
	end

	cb(items)
end)

ESX.RegisterServerCallback('esx:getJobs', function(xPlayer, source, cb)
	cb(ESX.Jobs)
end)

ESX.RegisterServerCallback('esx:getFactions', function(xPlayer, source, cb)
	cb(ESX.Factions)
end)

ESX.StartDBSync()
ESX.StartPayCheck()
