RegisterNetEvent('heli:spotlight')
AddEventHandler('heli:spotlight', function(state)
	TriggerClientEvent('heli:spotlight', -1, source, state)
end)