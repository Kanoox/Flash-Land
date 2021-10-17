local PhoneNumbers = {}
local CallsInProgress = {}
local lastIndexCall = 10

Citizen.CreateThread(function()
	if #GetPlayers() > 0 then
		print('WARNING ! This will not register job number (You have to restart policejob)')
	end

	Citizen.Wait(500)

	for _,AnyPlayer in pairs(GetPlayers()) do
		local xPlayer = ESX.GetPlayerFromId(AnyPlayer)
		UpdatePlayer(AnyPlayer)
		Citizen.Wait(0)
	end
end)

function GetPhoneNumberFromSource(source, callback)
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

function NotifyAlertSMS(number, alert, listSrc)
	if PhoneNumbers[number] == nil then
		error('NotifyAlertSMS ' .. tostring(number))
	end

	local mess = 'De #' .. alert.numero  .. ' : ' .. alert.message
	if alert.coords ~= nil then
		mess = mess .. ' ' .. alert.coords.x .. ', ' .. alert.coords.y
	end

	for k, _ in pairs(listSrc) do
		GetPhoneNumberFromSource(tonumber(k), function(n)
			if n ~= nil then
				InsertMessage(number, n, mess, 0, function(smsMess)
					TriggerClientEvent("fl_phone:receiveMessage", tonumber(k), smsMess)
				end)
			end
		end)
	end
end

function GetPhoneNumber(discord)
	local result = MySQL.Sync.fetchAll("SELECT users.phone_number FROM users WHERE users.discord = @discord", {
		['@discord'] = discord
	})
	if result[1] ~= nil then
		return result[1].phone_number
	end
	return nil
end

function GetIdentifierByPhoneNumber(phone_number)
	local result = MySQL.Sync.fetchAll("SELECT users.discord FROM users WHERE users.phone_number = @phone_number", {
		['@phone_number'] = phone_number
	})
	if result[1] ~= nil then
		return result[1].discord
	end
	return nil
end

function GetPlayerUniqueIdentifier(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		return xPlayer.discord
	end
	return 'discord:?'
end

function GetOrGeneratePhoneNumber(source, discord, cb)
	local myPhoneNumber = GetPhoneNumber(discord)
	if myPhoneNumber == '0' or myPhoneNumber == nil then
		cb(0)
	else
		cb(myPhoneNumber)
	end
end

function IsInCall(source)
	for _, AnyCall in pairs(CallsInProgress) do
		if AnyCall.is_accepts and (AnyCall.transmitter_src == source or AnyCall.receiver_src == source) then
			return true
		end
	end

	return false
end

function GetContacts(discord, source)
	MySQL.Async.fetchAll("SELECT * FROM phone_users_contacts WHERE phone_users_contacts.discord = @discord", {
		['@discord'] = discord
	}, function(result)
		TriggerClientEvent("fl_phone:contactList", source, result)
	end)
end

function UpdatePlayer(source)
	local discord = GetPlayerUniqueIdentifier(source)
	local num = GetPhoneNumber(discord)
	TriggerClientEvent("fl_phone:myPhoneNumber", source, num)
	GetContacts(discord, source)
	GetMessages(discord, source)
	SendHistoriqueCall(source, num)
end

function NotifyContactChange(source, discord)
	GetContacts(discord, source)
end

function GetMessages(discord, source)
	MySQL.Async.fetchAll("SELECT phone_messages.* FROM phone_messages LEFT JOIN users ON users.discord = @discord WHERE phone_messages.receiver = users.phone_number", {
		['@discord'] = discord
   }, function(result)
		TriggerClientEvent("fl_phone:allMessage", source, result)
	end)
end

function InsertMessage(transmitter, receiver, message, owner, cb)
	MySQL.Async.insert("INSERT INTO phone_messages (`transmitter`, `receiver`,`message`, `isRead`,`owner`) VALUES(@transmitter, @receiver, @message, @isRead, @owner);", {
		['@transmitter'] = transmitter,
		['@receiver'] = receiver,
		['@message'] = message,
		['@isRead'] = owner,
		['@owner'] = owner
	}, function(id)
		MySQL.Async.fetchAll('SELECT * from phone_messages WHERE `id` = @id;', {
			['@id'] = id
		}, function(result)
			cb(result[1])
		end)
	end)
end

function DeleteAllMessage(discord)
	MySQL.Async.execute("DELETE FROM phone_messages WHERE `receiver` = @mePhoneNumber", {
		['@mePhoneNumber'] = GetPhoneNumber(discord)
	})
end

function SendHistoriqueCall(source, num)
	MySQL.Async.fetchAll("SELECT * FROM phone_calls WHERE phone_calls.owner = @num ORDER BY time DESC LIMIT 120", {
		['@num'] = num
	}, function(result)
		TriggerClientEvent('fl_phone:historiqueCall', source, result)
	end)
end

function AppelsDeleteAllHistorique(discord, cb)
	MySQL.Async.execute("DELETE FROM phone_calls WHERE `owner` = @owner", {
		['@owner'] = GetPhoneNumber(discord)
	}, cb)
end

function SaveCalls(appelInfo)
	if appelInfo.extraData == nil or appelInfo.extraData.useNumber == nil then
		MySQL.Async.insert("INSERT INTO phone_calls (`owner`, `num`,`incoming`, `accepts`) VALUES(@owner, @num, @incoming, @accepts)", {
			['@owner'] = appelInfo.transmitter_num,
			['@num'] = appelInfo.receiver_num,
			['@incoming'] = 1,
			['@accepts'] = appelInfo.is_accepts
		}, function()
			SendHistoriqueCall(appelInfo.transmitter_src, appelInfo.transmitter_num)
		end)
	end

	if appelInfo.is_valid then
		local num = appelInfo.transmitter_num
		if appelInfo.hidden then
			num = "#######"
		end
		MySQL.Async.insert("INSERT INTO phone_calls (`owner`, `num`,`incoming`, `accepts`) VALUES(@owner, @num, @incoming, @accepts)", {
			['@owner'] = appelInfo.receiver_num,
			['@num'] = num,
			['@incoming'] = 0,
			['@accepts'] = appelInfo.is_accepts
		}, function()
			if appelInfo.receiver_src ~= nil then
				SendHistoriqueCall(appelInfo.receiver_src, appelInfo.receiver_num)
			end
		end)
	end
end

function AddSource(number, source)
	if number == nil or source == nil then error(ESX.Dump({number, source})) end
	PhoneNumbers[number].sources[tostring(source)] = true
end

function RemoveSource(number, source)
	if number == nil or source == nil then error(ESX.Dump({number, source})) end
	PhoneNumbers[number].sources[tostring(source)] = nil
end

function RegisterNumber(number, type, sharePos, hasDispatch, hideNumber, hidePosIfAnon)
	local hideNumber = hideNumber or false
	local hidePosIfAnon = hidePosIfAnon or false

	PhoneNumbers[number] = {
		type = type,
		sources = {},
		alerts = {}
	}

	for _,AnyPlayer in pairs(GetPlayers()) do
		local xPlayer = ESX.GetPlayerFromId(AnyPlayer)
		if xPlayer and xPlayer.job and xPlayer.job.name == number then
			AddSource(number, xPlayer.source)
		end
		Citizen.Wait(0)
	end
end

Citizen.CreateThread(function()
--	RegisterNumber('daymson', 'Client Daymson', true, true)
	RegisterNumber('bennys', 'Client Bennys', true, true)
	RegisterNumber('journaliste', 'Client Weazel News', true, true)
	RegisterNumber('burgershot', 'Client Burgershot', true, true)
	RegisterNumber('gouv', 'Alerte Gouvernement', true, true)
--	RegisterNumber('galaxy', 'Client Galaxy', true, true)
--	RegisterNumber('palace', 'Client Palace', true, true)
--	RegisterNumber('bahamas', 'Client Bahamas', true, true)
--	RegisterNumber('unicorn', 'Client Unicorn', true, true)
--	RegisterNumber('rebelstudio', 'Client Rebel Studio', true, true)
	RegisterNumber('ubereats', 'Client UberEats', true, true)
--	RegisterNumber('tabac', 'Client Malborose', true, true)
	RegisterNumber('mechanic', 'Client Mécano', true, true)
--	RegisterNumber('cardealer', 'Client Concession', false, false)
--	RegisterNumber('ammunation', 'Client Ammunation', true, true)
	RegisterNumber('sixt', 'Client Sixt', true, true)
	RegisterNumber('greenmotors', 'Client GreenMotors', true, true)
--	RegisterNumber('ltdb', 'Client LTDB', true, true)
	RegisterNumber('avocat', 'Client Avocat', true, true)
	RegisterNumber('police', 'Alerte Police', true, true)
--	RegisterNumber('realestateagent', 'Client Agence Immo', false, false)
	RegisterNumber('ambulance', 'Alerte Ambulance', true, true)
	RegisterNumber('taxi', 'Client Taxi', true, true)
--	RegisterNumber('banker', 'Client Banque', false, false)
--	RegisterNumber('vigneron', 'Client Vigneron', true, true)
--	RegisterNumber('bikedealer', 'Client Concession', false, false)
end)

AddEventHandler('esx:setJob', function(source, job, lastJob)
	if PhoneNumbers[lastJob.name] ~= nil then
		RemoveSource(lastJob.name, source)
	end

	if PhoneNumbers[job.name] ~= nil then
		AddSource(job.name, source)
	end
end)

AddEventHandler('esx:playerLoaded', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM users WHERE discord = @discord',{
		['@discord'] = xPlayer.discord
	}, function(result)
		local phoneNumber = result[1].phone_number
		xPlayer.set('phoneNumber', phoneNumber)

		if PhoneNumbers[xPlayer.job.name] ~= nil then
			AddSource(xPlayer.job.name, source)
		end
	end)
end)


AddEventHandler('esx:playerDropped', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	if PhoneNumbers[xPlayer.job.name] == nil then return end
	RemoveSource(xPlayer.job.name, source)
end)

RegisterNetEvent('fl_phone:sendMessageToJob')
AddEventHandler('fl_phone:sendMessageToJob', function(number, message, coords)
	if PhoneNumbers[number] == nil then
		return
	end

	GetPhoneNumberFromSource(source, function(phone)
		NotifyAlertSMS(number, {
			message = message,
			coords = coords,
			numero = phone,
		}, PhoneNumbers[number].sources)
	end)
end)

RegisterNetEvent('fl_phone:sendMessageCustomNumber')
AddEventHandler('fl_phone:sendMessageCustomNumber', function(phone, number, message, coords)
	if PhoneNumbers[number] == nil then
		return
	end

	NotifyAlertSMS(number, {
		message = message,
		coords = coords,
		numero = phone,
	}, PhoneNumbers[number].sources)
end)

RegisterNetEvent('fl_phone:addContact')
AddEventHandler('fl_phone:addContact', function(display, phoneNumber)
	local source = source
	local discord = GetPlayerUniqueIdentifier(source)

	MySQL.Async.insert("INSERT INTO phone_users_contacts (`discord`, `number`,`display`) VALUES(@discord, @number, @display)", {
		['@discord'] = discord,
		['@number'] = phoneNumber,
		['@display'] = display,
	}, function()
		NotifyContactChange(source, discord)
	end)
end)

RegisterNetEvent('fl_phone:updateContact')
AddEventHandler('fl_phone:updateContact', function(id, display, phoneNumber)
	local source = tonumber(source)
	local discord = GetPlayerUniqueIdentifier(source)

	MySQL.Async.insert("UPDATE phone_users_contacts SET number = @number, display = @display WHERE id = @id", {
		['@number'] = phoneNumber,
		['@display'] = display,
		['@id'] = id,
	}, function()
		NotifyContactChange(source, discord)
	end)
end)

RegisterNetEvent('fl_phone:deleteContact')
AddEventHandler('fl_phone:deleteContact', function(id)
	local source = source
	local discord = GetPlayerUniqueIdentifier(source)

	MySQL.Async.execute("DELETE FROM phone_users_contacts WHERE `discord` = @discord AND `id` = @id", {
		['@discord'] = discord,
		['@id'] = id,
	}, function()
		NotifyContactChange(source, discord)
	end)
end)

RegisterNetEvent('fl_phone:sendMessage')
AddEventHandler('fl_phone:sendMessage', function(phoneNumber, message)
	local xPlayer = ESX.GetPlayerFromId(source)
	local discord = GetPlayerUniqueIdentifier(xPlayer.source)
	local otherDiscord = GetIdentifierByPhoneNumber(phoneNumber)
	local myPhone = GetPhoneNumber(discord)

	if PhoneNumbers[phoneNumber] ~= nil then
		GetPhoneNumberFromSource(xPlayer.source, function(phone)
			NotifyAlertSMS(phoneNumber, {
				message = message,
				numero = phone,
			}, PhoneNumbers[phoneNumber].sources)
		end)
	end

	InsertMessage(myPhone, phoneNumber, message, 0, function(tomess)
		if otherDiscord ~= nil then
			local osou = ESX.GetSourceFromIdentifier(otherDiscord)
			if osou ~= nil then
				TriggerClientEvent("fl_phone:receiveMessage", osou, tomess)
			end
		end
	end)
	InsertMessage(phoneNumber, myPhone, message, 1, function(memess)
		TriggerClientEvent("fl_phone:receiveMessage", xPlayer.source, memess)
	end)
end)

RegisterNetEvent('fl_phone:deleteMessage')
AddEventHandler('fl_phone:deleteMessage', function(msgId)
	MySQL.Async.execute("DELETE FROM phone_messages WHERE `id` = @id", {
		['@id'] = msgId
	}, function() end)
end)

RegisterNetEvent('fl_phone:deleteMessageNumber')
AddEventHandler('fl_phone:deleteMessageNumber', function(number)
	MySQL.Async.execute("DELETE FROM phone_messages WHERE `receiver` = @mePhoneNumber and `transmitter` = @phone_number", {
		['@mePhoneNumber'] = GetPhoneNumber(GetPlayerUniqueIdentifier(source)),
		['@phone_number'] = number
	}, function() end)
end)

RegisterNetEvent('fl_phone:deleteAllMessage')
AddEventHandler('fl_phone:deleteAllMessage', function()
	DeleteAllMessage(GetPlayerUniqueIdentifier(source))
end)

RegisterNetEvent('fl_phone:setReadMessageNumber')
AddEventHandler('fl_phone:setReadMessageNumber', function(num)
	MySQL.Async.execute("UPDATE phone_messages SET phone_messages.isRead = 1 WHERE phone_messages.receiver = @receiver AND phone_messages.transmitter = @transmitter", {
		['@receiver'] = GetPhoneNumber(GetPlayerUniqueIdentifier(source)),
		['@transmitter'] = num
	}, function() end)
end)

RegisterNetEvent('fl_phone:deleteALL')
AddEventHandler('fl_phone:deleteALL', function()
	local source = source
	local discord = GetPlayerUniqueIdentifier(source)
	DeleteAllMessage(discord)

	MySQL.Async.execute("DELETE FROM phone_users_contacts WHERE `discord` = @discord", {
		['@discord'] = discord
	}, function()
		NotifyContactChange(source, discord)
	end)

	AppelsDeleteAllHistorique(discord, function()
		TriggerClientEvent("fl_phone:allMessage", source, {})
	end)
end)

RegisterNetEvent('fl_phone:getHistoriqueCall')
AddEventHandler('fl_phone:getHistoriqueCall', function()
	SendHistoriqueCall(source, GetPhoneNumber(GetPlayerUniqueIdentifier(source)))
end)

RegisterNetEvent('fl_phone:startCall')
AddEventHandler('fl_phone:startCall', function(phone_number, extraData)
	if phone_number == nil or phone_number == '' then
		error('BAD CALL NUMBER IS NIL')
	end
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer == nil then return end

	local hidden = string.sub(phone_number, 1, 1) == '#'
	if hidden then
		phone_number = string.sub(phone_number, 2)
	end

	local srcDiscord = GetPlayerUniqueIdentifier(xPlayer.source)

	local srcPhone = ''
	if extraData ~= nil and extraData.useNumber ~= nil then
		srcPhone = extraData.useNumber
	else
		srcPhone = GetPhoneNumber(srcDiscord)
	end
	local destPlayer = GetIdentifierByPhoneNumber(phone_number)
	local is_valid = destPlayer ~= nil and destPlayer ~= srcDiscord

	local indexCall = lastIndexCall
	lastIndexCall = lastIndexCall + 1

	CallsInProgress[indexCall] = {
		id = indexCall,
		transmitter_src = xPlayer.source,
		transmitter_num = srcPhone,
		receiver_src = nil,
		receiver_num = phone_number,
		is_valid = is_valid,
		is_accepts = false,
		hidden = hidden,
		extraData = extraData
	}

	if is_valid then
		local srcTo = ESX.GetSourceFromIdentifier(destPlayer)

		if srcTo ~= nil then
			CallsInProgress[indexCall].receiver_src = srcTo

			if IsInCall(srcTo) then
				xPlayer.showNotification('~o~Ce numéro est déjà occupé...')
				TriggerClientEvent('esx:showNotification', srcTo, '~o~Vous recevez un double appel...')
				CallsInProgress[indexCall] = nil
				return
			else
				TriggerClientEvent('fl_phone:waitingCall', srcTo, CallsInProgress[indexCall], false)
			end
		end

		TriggerClientEvent('fl_phone:waitingCall', xPlayer.source, CallsInProgress[indexCall], true)
	else
		xPlayer.showNotification('~o~Ce numéro n\'est pas attribué...')
	end
end)

RegisterNetEvent('fl_phone:acceptCall')
AddEventHandler('fl_phone:acceptCall', function(infoCall)
    local xPlayer = ESX.GetPlayerFromId(source)
    local id = infoCall.id

    
    if CallsInProgress[id] == nil then
        error('s(' .. tostring(xPlayer.source) .. ')   fl_phone:acceptCall from nil id : ' .. ESX.Dump(infoCall))
    end

    CallsInProgress[id].receiver_src = infoCall.receiver_src or CallsInProgress[id].receiver_src

    if CallsInProgress[id].receiver_src == nil then
        error(ESX.Dump(CallsInProgress[id]))
    end

    CallsInProgress[id].is_accepts = true
    TriggerClientEvent('fl_phone:acceptCall', CallsInProgress[id].transmitter_src, CallsInProgress[id], true, os.time())
    SetTimeout(1000, function()
        if CallsInProgress[id] == nil then print('CallsInProgress[' .. tostring(id) .. '] is nil when connecting call to receiver') return end
        TriggerClientEvent('fl_phone:acceptCall', CallsInProgress[id].receiver_src, CallsInProgress[id], false, os.time())
    end)
    SaveCalls(CallsInProgress[id])
end)

RegisterNetEvent('fl_phone:rejectCall')
AddEventHandler('fl_phone:rejectCall', function(infoCall)
    local xPlayer = ESX.GetPlayerFromId(source)
    local id = infoCall.id

    if CallsInProgress[id] == nil then
        return
    end
    TriggerClientEvent('fl_phone:rejectCall', CallsInProgress[id].transmitter_src, CallsInProgress[id], os.time())

    if CallsInProgress[id].receiver_src ~= nil then
        TriggerClientEvent('fl_phone:rejectCall', CallsInProgress[id].receiver_src, CallsInProgress[id], os.time())
    end

    if not CallsInProgress[id].is_accepts then
        SaveCalls(CallsInProgress[id])
    end

    CallsInProgress[id] = nil
end)

RegisterNetEvent('fl_phone:appelsDeleteHistorique')
AddEventHandler('fl_phone:appelsDeleteHistorique', function(numero)
	MySQL.Async.execute("DELETE FROM phone_calls WHERE `owner` = @owner AND `num` = @num", {
		['@owner'] = GetPhoneNumber(GetPlayerUniqueIdentifier(source)),
		['@num'] = numero
	}, function() end)
end)

RegisterNetEvent('fl_phone:appelsDeleteAllHistorique')
AddEventHandler('fl_phone:appelsDeleteAllHistorique', function()
	AppelsDeleteAllHistorique(GetPlayerUniqueIdentifier(source))
end)

AddEventHandler('esx:playerLoaded', function(source)
	GetOrGeneratePhoneNumber(source, GetPlayerUniqueIdentifier(source), function(myPhoneNumber)
		UpdatePlayer(source)
	end)
end)

RegisterNetEvent('fl_phone:allUpdate')
AddEventHandler('fl_phone:allUpdate', function()
	UpdatePlayer(source)
end)

AddEventHandler('playerDropped', function()
	for id, AnyCall in pairs(CallsInProgress) do
		if AnyCall.transmitter_src == source then
			if AnyCall.receiver_src ~= nil then
				TriggerClientEvent('fl_phone:rejectCall', AnyCall.receiver_src, AnyCall, os.time())
			end
			CallsInProgress[id] = nil
		end

		if AnyCall.receiver_src == source and AnyCall.is_accepts then
			TriggerClientEvent('fl_phone:rejectCall', AnyCall.transmitter_src, AnyCall, os.time())
			CallsInProgress[id] = nil
		end
	end
end)