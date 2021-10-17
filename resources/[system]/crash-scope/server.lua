AddEventHandler('playerDropped', function(reason)
    if not reason:find('Game crashed') then
        return
    end

	local playerId = source
	local xPlayer = ESX.GetPlayerFromId(playerId)

    if xPlayer then
		MySQL.Async.execute('INSERT INTO crash_data (`discord`, `crash_hash`, `position`, `velocity`) VALUES (@discord, @crash_hash, @position, @velocity);', {
			['@discord'] = xPlayer.discord,
			['@crash_hash'] = reason,
			['@position'] = json.encode(xPlayer.getCoords()),
			['@velocity'] = '[]',
        })

--[[         TriggerClientEvent('crash-scope:newData', -1, {
			['discord'] = xPlayer.discord,
			['crash_hash'] = reason,
			['position'] = json.encode(xPlayer.getCoords()),
			['velocity'] = '[]',
        }) ]]
	end
end)

--[[
Citizen.CreateThread(function()
    print('crash-scope:data...')
    MySQL.Async.fetchAll('SELECT * FROM crash_data', {}, function(result)
        print('crash-scope:data!')
        TriggerClientEvent('crash-scope:data', -1, result)
    end)
end) 


RegisterCommand("test", function()
		print('crash-scope:data...')
		MySQL.Async.fetchAll('SELECT * FROM crash_data', {}, function(result)
			print('crash-scope:data!')
			TriggerClientEvent('crash-scope:data', -1, result)
		end)
end)]]