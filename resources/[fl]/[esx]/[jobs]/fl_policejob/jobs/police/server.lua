local Codes = {
    types = {
        [1] = "~g~Information de l'agent",
        [2] = "~o~Statut de l'intervention",
        [3] = "~r~Demande de renforts",
    },

    codes = {
        [11] = "~r~URGENCE~s~: ~g~Légère~n~",
        [12] = "~r~URGENCE~s~: ~o~Moyenne~n~",
        [13] = "~r~URGENCE~s~: ~r~Maximale~n~~s~> ~r~Toutes les unités doivent se rendre sur les lieux"
    },

}

local function getLicense(source)
	local steamid  = false
    local license  = false
    local discord  = false
    local xbl      = false
    local liveid   = false
    local ip       = false

	for k,v in pairs(GetPlayerIdentifiers(source))do
			
		if string.sub(v, 1, string.len("steam:")) == "steam:" then
			steamid = v
		elseif string.sub(v, 1, string.len("license:")) == "license:" then
			license = v
		elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
			xbl  = v
		elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
			ip = v
		elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
			discord = v
		elseif string.sub(v, 1, string.len("live:")) == "live:" then
			liveid = v
		end
	end

	return license:gsub("license:","")
end

-- handcuffs
RegisterNetEvent('fl_policejob:requestarrest')
AddEventHandler('fl_policejob:requestarrest', function(targetid, playerheading, playerCoords,  playerlocation)
	TriggerClientEvent('fl_policejob:getarrested', targetid, playerheading, playerCoords, playerlocation)
	TriggerClientEvent('fl_policejob:doarrested', source)
end)

RegisterNetEvent('fl_policejob:requestrelease')
AddEventHandler('fl_policejob:requestrelease', function(targetid, playerheading, playerCoords,  playerlocation)
	TriggerClientEvent('fl_policejob:getuncuffed', targetid, playerheading, playerCoords, playerlocation)
	TriggerClientEvent('fl_policejob:douncuffing', source)
end)


RegisterNetEvent('fl_policejob:handcuff')
AddEventHandler('fl_policejob:handcuff', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'police' or xPlayer.job.name == 'fbi' then
		TriggerClientEvent('fl_policejob:handcuff', target)
    end
end)

RegisterNetEvent('fl_policejob:dragErrorResponse')
AddEventHandler('fl_policejob:dragErrorResponse', function(target)
	TriggerClientEvent('fl_policejob:dragErrorResponse', target)
end)


RegisterNetEvent('fl_policejob:drag')
AddEventHandler('fl_policejob:drag', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'police' then
		TriggerClientEvent('fl_policejob:drag', target, source)
    end
end)

RegisterNetEvent('fl_policejob:putInVehicle')
AddEventHandler('fl_policejob:putInVehicle', function(target)
	TriggerClientEvent('fl_policejob:putInVehicle', target)
end)

RegisterNetEvent('fl_policejob:OutVehicle')
AddEventHandler('fl_policejob:OutVehicle', function(target)
	TriggerClientEvent('fl_policejob:OutVehicle', target, source)
end)

RegisterNetEvent('fl_policejob:OutVehicleErrorResponse')
AddEventHandler('fl_policejob:OutVehicleErrorResponse', function(target)
	TriggerClientEvent('fl_policejob:OutVehicleErrorResponse', target, source)
end)

RegisterNetEvent('baseevents:enteringVehicle')
AddEventHandler('baseevents:enteringVehicle', function(vehicle, seat, name, netID)
    TriggerClientEvent('fl_policejob:enteringVehicle', source, vehicle)
end)

RegisterNetEvent('baseevents:enteredVehicle')
AddEventHandler('baseevents:enteredVehicle', function(vehicle, seat, name, netID)
    TriggerClientEvent('fl_policejob:enteredVehicle', source, vehicle)
end)

-----

RegisterNetEvent('fl_policejob:message')
AddEventHandler('fl_policejob:message', function(target, msg)
	TriggerClientEvent('esx:showNotification', target, msg)
end)

ESX.RegisterServerCallback('esx_policejob:getVehicleInfos', function(xPlayer, source, cb, plate)

	MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)

		local retrivedInfo = {
			plate = plate
		}

		if result[1] then
			MySQL.Async.fetchAll('SELECT name, firstname, lastname FROM users WHERE discord = @discord',  {
				['@discord'] = result[1].owner
			}, function(result2)
				retrivedInfo.owner = result2[1].firstname .. ' ' .. result2[1].lastname
				cb(retrivedInfo)
			end)
		else
			cb(retrivedInfo)
		end
	end)
end)

ESX.RegisterServerCallback('fl_police:ownvehicle', function(xPlayer, source, cb, plate)

	MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		if result[1] then
			cb(true)
		else
			cb(false)
		end
	end)
end)

-- Chien

RegisterNetEvent('esx_policedog:hasClosestDrugs')
AddEventHandler('esx_policedog:hasClosestDrugs', function(playerId)
    local target = ESX.GetPlayerFromId(playerId)
    local src = source
    local inventory = target.inventory
	local drugs = {'weed', 'cocaine', 'meth'}
    for i = 1, #inventory do
        for k, v in pairs(drugs) do
            if inventory[i].name == v and inventory[i].count > 0 then
                TriggerClientEvent('esx_policedog:hasDrugs', src, true)
                return
            end
        end
    end
    TriggerClientEvent('esx_policedog:hasDrugs', src, false)
end)



RegisterNetEvent('fl_policejob:putInVehicle')
AddEventHandler('fl_policejob:putInVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'police' or xPlayer.job.name == 'fbi' then
		TriggerClientEvent('fl_policejob:putInVehicle', target)
    end
end)

RegisterNetEvent('fl_policejob:OutVehicle')
AddEventHandler('fl_policejob:OutVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'police' or xPlayer.job.name == 'fbi' then
		TriggerClientEvent('fl_policejob:OutVehicle', target)
    end
end)



RegisterNetEvent('fl_policejob:confiscatePlayerItem')
AddEventHandler('fl_policejob:confiscatePlayerItem', function(target, itemType, itemName, amount)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if sourceXPlayer.job.name ~= 'police' or xPlayer.job.name == 'fbi' then
		return
	end

	if itemType == 'item_standard' then
		local targetItem = targetXPlayer.getInventoryItem(itemName)
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)

		-- does the target player have enough in their inventory?
		if targetItem.count > 0 and targetItem.count <= amount then

			-- can the player carry the said amount of x item?
			if sourceXPlayer.canCarryItem(itemName, sourceItem.count) then
				targetXPlayer.removeInventoryItem(itemName, amount)
				sourceXPlayer.addInventoryItem   (itemName, amount)
            end
		end

	elseif itemType == 'item_weapon' then
		if amount == nil then amount = 0 end
		targetXPlayer.removeWeapon(itemName, amount)
		sourceXPlayer.addWeapon   (itemName, amount)
	end
end)

ESX.RegisterServerCallback('fl_policejob:getVehicleFromPlate', function(xPlayer, source, cb, plate)
	MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		if result[1] ~= nil then

			MySQL.Async.fetchAll('SELECT name, firstname, lastname FROM users WHERE discord = @discord',  {
				['@discord'] = result[1].owner
			}, function(result2)
				cb(result2[1].firstname .. ' ' .. result2[1].lastname, true)
			end)
		else
			cb('Inconnu', false)
		end
	end)
end)

ESX.RegisterServerCallback('fl_policejob:getOtherPlayerData', function(source, cb, target, notify)
	local xPlayer = ESX.GetPlayerFromId(target)

    TriggerClientEvent("esx:showNotification", target, "~r~Quelqu'un vous fouille ...")

	if xPlayer then
		local data = {
			name = xPlayer.getName(),
			job = xPlayer.job.label,
			grade = xPlayer.job.grade_label,
			inventory = xPlayer.getInventory(),
			accounts = xPlayer.getAccounts(),
			weapons = xPlayer.getLoadout()
		}

		cb(data)
    end
end)

RegisterNetEvent("fl_core:police:code")
AddEventHandler("fl_core:police:code", function(index,type,mugshot, mugshotStr, loc, id)
    local _src = source
    TriggerClientEvent("fl_core:police:code", -1, type, index, Codes.types[type], Codes.codes[index],mugshot, mugshotStr, GetPlayerName(_src),  loc, id)
end)




-- Appels

local reportTable = {}

ESX.RegisterServerCallback("fl_appels:getJob", function(xPlayer, source, cb)
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer ~= nil and xPlayer.job.name == 'police' then 
        cb(true)
    else
        cb(false) 
    end
end)  

function GetPhoneNumberFromSourcePolice(source, callback)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer == nil then
		callback(nil)
		return
	end

	MySQL.Async.fetchAll('SELECT * FROM users WHERE discord = @discord',{
		['@discord'] = xPlayer.discord
	}, function(result)
		callback(result[1].phone_number)
	end)
end

local compteur = 0
RegisterServerEvent('fl_appels:Zebi')
AddEventHandler('fl_appels:Zebi', function(msg, posi, numero)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local msge = msg
    local longueur = string.len(msge)
	local position = posi
	local idMec = source
	local num = numero
    if longueur <= 1 then
        TriggerClientEvent("esx:showNotification", source, "~r~Veuillez rentrer une raison valable")
    elseif longueur >= 80 then
        TriggerClientEvent("esx:showNotification", source, "~r~Veuillez rentrer une raison moins longue")
    else
		compteur = compteur + 1
		if num == nil then
			GetPhoneNumberFromSourcePolice(source, function(number)
				table.insert(reportTable, {
					nom = number,
					raison = msge,
					pos = position,
					cpt = compteur,
				})
			end)
		else
			table.insert(reportTable, {
				nom = num,
				raison = msge,
				pos = position,
				cpt = compteur,
			})
		end
		TriggerClientEvent("fl_notifs:AlerteNotifs", -1, lspd, msge)
		if #reportTable > 10 then
			table.remove(reportTable, 1)
		end	
    end
end)

RegisterServerEvent("fl_appels:ClearApp")
AddEventHandler("fl_appels:ClearApp", function(idA, nomMec, raisonMec)
	local is = idA
	local name = nomMec
	local ra = raisonMec
    table.remove(reportTable, is, name, ra)
end)

ESX.RegisterServerCallback('fl_appels:infoReport', function(xPlayer, source, cb)
    cb(reportTable)
end)


-- Speedzones

RegisterNetEvent('fl_policejob:addSpeedzone')
AddEventHandler('fl_policejob:addSpeedzone', function(pos, size)
	TriggerClientEvent('fl_policejob:addSpeedzone', -1, source, pos, size)
end)

RegisterNetEvent('fl_policejob:removeSpeedzone')
AddEventHandler('fl_policejob:removeSpeedzone', function(speedZone)
	TriggerClientEvent('fl_policejob:removeSpeedzone', -1, source, speedZone)
end)

-- Bracelets

local RegisteredBracelet = {}

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM police_bracelet', {}, function(results)
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
					MySQL.Async.execute("UPDATE police_bracelet SET lastPosition = @lastPosition WHERE id = @id;", {
						['@id'] = Bracelet.id,
						['@lastPosition'] = Bracelet.lastPosition,
					})
				end
			elseif Bracelet.lastPosition ~= '[]' and Bracelet.lastPosition ~= {} then
				if timedIndex == 24 then
					MySQL.Async.execute("UPDATE police_bracelet SET lastPosition = '[]' WHERE id = @id;", {
						['@id'] = Bracelet.id,
					})
				end
			end
			Citizen.Wait(100)
		end
		Citizen.Wait(5 * 1000)
		UpdateData()
		UpdateBraceletForPolice()

		Citizen.Wait(15 * 1000)
	end
end)

function UpdateBraceletForPolice()
	local xPlayers = ESX.GetPlayers()

	for i = 1, #xPlayers, 1 do
		local anyXPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if anyXPlayer ~= nil and anyXPlayer.job ~= nil and anyXPlayer.job.name == 'police' then
			TriggerClientEvent('fl_policejob:updateBracelet', xPlayers[i], RegisteredBracelet)
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
	MySQL.Async.execute('INSERT INTO `police_bracelet` (`id`) VALUES (NULL);', {}, function(lineInserted)
		if lineInserted ~= 1 then error('Insert error') end

		MySQL.Async.fetchAll('SELECT * FROM `police_bracelet` WHERE `id` = (SELECT MAX(id) FROM police_bracelet);', {}, function(results)
			results[1].isActive = results[1].isActive == 1
			RegisteredBracelet[results[1].id] = results[1]
			RegisterBracelet(results[1].id)
			xPlayerSource.addInventoryItem('bracelet_' .. results[1].id, 1)
		end)
	end)
end

function UpdateData()
	MySQL.Async.fetchAll('SELECT * FROM police_bracelet', {}, function(results)
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

	MySQL.Async.execute("UPDATE police_bracelet SET isActive = @isActive, target = @target, info = @info WHERE id = @id;", {
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
		xPlayerSource.removeInventoryItem('bracelet_' .. Bracelet.id, 1)
	else
		xPlayerSource.addInventoryItem('bracelet_' .. Bracelet.id, 1)
	end
	UpdateBraceletForPolice()
end

function RegisterBracelet(BraceletID)
	ESX.RegisterTempItem('bracelet_'..BraceletID, 'Bracelet électronique (' .. BraceletID .. ')', 0.01, -1, 0)

	ESX.RegisterCloseMenuUsableItem('bracelet_' .. BraceletID, true)
	ESX.RegisterUsableItem('bracelet_' .. BraceletID, function(source)
		local xPlayer = ESX.GetPlayerFromId(source)
		local Bracelet = RegisteredBracelet[BraceletID]

		if not xPlayer.job.name == 'police' then
			xPlayer.showNotification('~r~Vous ne savez pas comment activer ce bracelet...')
			return
		end

		if Bracelet.isActive then
			xPlayer.showNotification('~r~Bracelet déjà actif... BUG !')
		else
			TriggerClientEvent('fl_policejob:useBracelet', xPlayer.source, Bracelet, true)
		end
	end)
end

RegisterNetEvent('fl_policejob:putBracelet')
AddEventHandler('fl_policejob:putBracelet', function(BraceletID, target)
	local Bracelet = RegisteredBracelet[BraceletID]
	local xPlayerSource = ESX.GetPlayerFromId(source)
	local xPlayerTarget = ESX.GetPlayerFromId(target)

	if not Bracelet then error('Unknown bracelet') end
	if not xPlayerSource then error('Unknown player source') end
	if not xPlayerTarget then error('Unknown player target') end
	if not xPlayerSource.job.name == 'police' then error('Not police') end

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


RegisterNetEvent('fl_policejob:removeBracelet')
AddEventHandler('fl_policejob:removeBracelet', function(BraceletID)
	local Bracelet = RegisteredBracelet[BraceletID]
	local xPlayerSource = ESX.GetPlayerFromId(source)
	local xPlayerTarget = ESX.GetPlayerFromDiscordIdentifier(Bracelet.target)

	if not Bracelet then error('Unknown bracelet') end
	if not xPlayerSource then error('Unknown player') end
	if not xPlayerSource.job.name == 'police' then error('Not police') end

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
end, false, {help = 'Crée un bracelet de suivi police'})


-- carjack

