local RegisteredBracelet = {}

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM sheriff_bracelet', {}, function(results)
		for _,Bracelet in pairs(results) do
			Bracelet.isActive = Bracelet.isActive == 1
			RegisteredBracelet[Bracelet.id] = Bracelet
			RegisterBracelet(Bracelet.id)
		end
	end)
end)

Citizen.CreateThread(function()
	local timedIndex = 0
	Citizen.Wait(5000)
	while true do
		timedIndex = timedIndex + 1
		if timedIndex > 24 then timedIndex = 0 end

		for BraceletID,Bracelet in pairs(RegisteredBracelet) do
			if Bracelet.isActive then
				local xPlayerTarget = ESX.GetPlayerFromDiscordIdentifier(Bracelet.target)
				if xPlayerTarget then
					Bracelet.serverId = xPlayerTarget.source
					Bracelet.currentPosition = GetEntityCoords(GetPlayerPed(xPlayerTarget.source), false)
					Bracelet.lastPosition = json.encode(Bracelet.currentPosition)
				else
					Bracelet.currentPosition = nil
				end

				if timedIndex == 24 then
					MySQL.Async.execute("UPDATE sheriff_bracelet SET lastPosition = @lastPosition WHERE id = @id;", {
						['@id'] = Bracelet.id,
						['@lastPosition'] = Bracelet.lastPosition,
					})
				end
			elseif Bracelet.lastPosition ~= '[]' and Bracelet.lastPosition ~= {} then
				if timedIndex == 24 then
					MySQL.Async.execute("UPDATE sheriff_bracelet SET lastPosition = '[]' WHERE id = @id;", {
						['@id'] = Bracelet.id,
					})
				end
			end
			Citizen.Wait(100)
		end
		Citizen.Wait(5 * 1000)
		UpdateData()
		UpdateBraceletForsheriff()

		Citizen.Wait(15 * 1000)
	end
end)

function UpdateBraceletForsheriff()
	local xPlayers = ESX.GetPlayers()

	for i = 1, #xPlayers, 1 do
		local anyXPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if anyXPlayer ~= nil and anyXPlayer.job ~= nil and anyXPlayer.job.name == 'sheriff' then
			TriggerClientEvent('fl_sheriffjob:updateBracelet', xPlayers[i], RegisteredBracelet)
		end
		Citizen.Wait(0)
	end
end

Citizen.CreateThread(function()
	Citizen.Wait(1000)
	while true do
		for BraceletID,Bracelet in pairs(RegisteredBracelet) do
			if Bracelet.isActive then
				local xPlayerTarget = ESX.GetPlayerFromDiscordIdentifier(Bracelet.target)
				if xPlayerTarget then
					xPlayerTarget.showNotification('~r~Vous avez un bracelet électronique sur vous... (Localisation en cours)')
				end
			end
		end
		Citizen.Wait(1000 * 60 * 30)
	end
end)

function CreateBracelet(source)
	local xPlayerSource = ESX.GetPlayerFromId(source)
	MySQL.Async.execute('INSERT INTO `sheriff_bracelet` (`id`) VALUES (NULL);', {}, function(lineInserted)
		if lineInserted ~= 1 then error('Insert error') end

		MySQL.Async.fetchAll('SELECT * FROM `sheriff_bracelet` WHERE `id` = (SELECT MAX(id) FROM sheriff_bracelet);', {}, function(results)
			results[1].isActive = results[1].isActive == 1
			RegisteredBracelet[results[1].id] = results[1]
			RegisterBracelet(results[1].id)
			xPlayerSource.addInventoryItem(Config.PrefixBracelet .. results[1].id, 1)
		end)
	end)
end

function UpdateData()
	MySQL.Async.fetchAll('SELECT * FROM sheriff_bracelet', {}, function(results)
		for _,Bracelet in pairs(results) do
			Bracelet.isActive = Bracelet.isActive == 1
			RegisteredBracelet[Bracelet.id] = Bracelet
		end
	end)
end

function SetBracelet(Bracelet, source, target, active)
	local xPlayerSource = ESX.GetPlayerFromId(source)
	local xPlayerTarget = ESX.GetPlayerFromId(target)
	local targetDiscord = nil
	local targetName = nil

	if xPlayerTarget then
		targetName = xPlayerTarget.firstname .. ' ' .. xPlayerTarget.lastname
		targetDiscord = xPlayerTarget.discord
	end

	MySQL.Async.execute("UPDATE sheriff_bracelet SET isActive = @isActive, target = @target, info = @info WHERE id = @id;", {
		['@isActive'] = active,
		['@id'] = Bracelet.id,
		['@target'] = targetDiscord,
		['@info'] = targetName,
	}, function(lines)
		if lines == 1 then
			UpdateData()
		else
			error('error')
		end
	end)

	if active then
		xPlayerSource.removeInventoryItem(Config.PrefixBracelet .. Bracelet.id, 1)
	else
		xPlayerSource.addInventoryItem(Config.PrefixBracelet .. Bracelet.id, 1)
	end
	UpdateBraceletForsheriff()
end

function RegisterBracelet(BraceletID)
	ESX.RegisterTempItem(Config.PrefixBracelet..BraceletID, 'Bracelet électronique (' .. BraceletID .. ')', 0.01, -1, 0)

	ESX.RegisterCloseMenuUsableItem(Config.PrefixBracelet .. BraceletID, true)
	ESX.RegisterUsableItem(Config.PrefixBracelet .. BraceletID, function(source)
		local xPlayer = ESX.GetPlayerFromId(source)
		local Bracelet = RegisteredBracelet[BraceletID]

		if not xPlayer.job.name == 'sheriff' then
			xPlayer.showNotification('~r~Vous ne savez pas comment activer ce bracelet...')
			return
		end

		if Bracelet.isActive then
			xPlayer.showNotification('~r~Bracelet déjà actif... BUG !')
		else
			TriggerClientEvent('fl_sheriffjob:useBracelet', xPlayer.source, Bracelet, true)
		end
	end)
end

RegisterNetEvent('fl_sheriffjob:putBracelet')
AddEventHandler('fl_sheriffjob:putBracelet', function(BraceletID, target)
	local Bracelet = RegisteredBracelet[BraceletID]
	local xPlayerSource = ESX.GetPlayerFromId(source)
	local xPlayerTarget = ESX.GetPlayerFromId(target)

	if not Bracelet then error('Unknown bracelet') end
	if not xPlayerSource then error('Unknown player source') end
	if not xPlayerTarget then error('Unknown player target') end
	if not xPlayerSource.job.name == 'sheriff' then error('Not sheriff') end

	for BraceletID,Bracelet in pairs(RegisteredBracelet) do
		if Bracelet.target == xPlayerTarget.discord then
			xPlayerSource.showNotification('~r~L\'individu porte déjà un bracelet sur lui')
			return
		end
	end

	xPlayerSource.showNotification('~g~Vous mettez un bracelet électronique sur ~b~' .. xPlayerTarget.firstname .. ' ' .. xPlayerTarget.lastname .. ' (N°' .. Bracelet.id .. ')')
	xPlayerTarget.showNotification('~b~' .. xPlayerSource.firstname .. ' ' .. xPlayerSource.lastname .. '~y~ vous met un bracelet électronique')

	SetBracelet(Bracelet, xPlayerSource.source, xPlayerTarget.source, true)
end)

RegisterNetEvent('fl_sheriffjob:removeBracelet')
AddEventHandler('fl_sheriffjob:removeBracelet', function(BraceletID)
	local Bracelet = RegisteredBracelet[BraceletID]
	local xPlayerSource = ESX.GetPlayerFromId(source)
	local xPlayerTarget = ESX.GetPlayerFromDiscordIdentifier(Bracelet.target)

	if not Bracelet then error('Unknown bracelet') end
	if not xPlayerSource then error('Unknown player') end
	if not xPlayerSource.job.name == 'sheriff' then error('Not sheriff') end

	if not xPlayerTarget then
		xPlayerSource.showNotification('~r~Le bracelet est hors du réseau... (#E5)')
		return
	end

	if #(GetEntityCoords(GetPlayerPed(xPlayerSource.source)) - GetEntityCoords(GetPlayerPed(xPlayerTarget.source))) > 2.0 then
		xPlayerSource.showNotification('~r~Aucun bracelet près de vous...')
		return
	end

	xPlayerSource.showNotification('~g~Vous enlevez un bracelet électronique de ~b~' .. xPlayerTarget.firstname .. ' ' .. xPlayerTarget.lastname .. ' (N°' .. Bracelet.id .. ')')
	xPlayerTarget.showNotification('~b~' .. xPlayerSource.lastname .. '~y~ vous a retiré votre bracelet électronique')

	SetBracelet(Bracelet, xPlayerSource.source, -2, false)
end)

ESX.RegisterCommand('givebracelet', 'mod', function(xPlayer, args, showError)
	CreateBracelet(xPlayer.source)
	TriggerClientEvent('chatMessage', xPlayer.source, "FreeLife", {0, 255, 0}, "Bracelet créé !")
end, false, {help = 'Crée un bracelet de suivi sheriff'})