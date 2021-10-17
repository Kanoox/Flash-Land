local RegisteredStatus = {}

function LoadPlayer(playerId, xPlayer)
	MySQL.Async.fetchAll('SELECT status FROM users WHERE discord = @discord', {
		['@discord'] = xPlayer.discord
	}, function(result)
		local data = {}

		if result[1].status and result[1].status ~= nil then
			data = json.decode(result[1].status)
		end

		RegisteredStatus[playerId] = data
		TriggerClientEvent('fl_status:load', playerId, data)
	end)
end

Citizen.CreateThread(function()
	Citizen.Wait(1000)

	for _,playerId in ipairs(ESX.GetPlayers()) do
		local xPlayer = ESX.GetPlayerFromId(playerId)
		LoadPlayer(playerId, xPlayer)
	end
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	LoadPlayer(playerId, xPlayer)
end)

AddEventHandler('esx:playerDropped', function(playerId, reason)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	MySQL.Async.execute('UPDATE users SET status = @status WHERE discord = @discord', {
		['@status'] = json.encode(RegisteredStatus[playerId]),
		['@discord'] = xPlayer.discord
	})
	RegisteredStatus[playerId] = nil
end)

AddEventHandler('fl_status:getStatus', function(playerId, statusName, cb)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local status  = RegisteredStatus[playerId]

	cb(status[statusName])
end)

RegisterServerEvent('fl_status:update')
AddEventHandler('fl_status:update', function(status)
	RegisteredStatus[source] = status
end)

Citizen.CreateThread(function()
	Citizen.Wait(20 * 1000)
	while true do
		local xPlayers = ESX.GetPlayers()

		local updateStatement = 'UPDATE users SET status = (case %s end) where discord in (%s)'
		local whenList = ''
		local whereList = ''
		local firstItem = true
		local playerCount = 0

		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			local status = RegisteredStatus[xPlayer.source]

			if status then
				whenList = whenList .. string.format('when discord = \'%s\' then \'%s\' ', xPlayer.discord, json.encode(status))

				if not firstItem then
					whereList = whereList .. ', '
				end
				whereList = whereList .. string.format('\'%s\'', xPlayer.discord)

				firstItem = false
				playerCount = playerCount + 1
			end
		end

		if playerCount > 0 then
			local sql = string.format(updateStatement, whenList, whereList)

			MySQL.Async.execute(sql)
		end
		Citizen.Wait(5 * 60 * 1000)
	end

end)

ESX.RegisterCommand('feed', 'mod', function(xPlayer, args, showError)
	xPlayer.triggerEvent('fl_status:set', 'hunger', 1000000)
	xPlayer.triggerEvent('fl_status:set', 'thirst', 1000000)
	xPlayer.triggerEvent('fl_status:set', 'drunk', 0)
end, true, {help = 'Nourriture au max'})

ESX.RegisterCommand('getstatus', 'mod', function(xPlayer, args, showError)
	print(ESX.Dump(RegisteredStatus[xPlayer.source]))
end, true, {help = ''})