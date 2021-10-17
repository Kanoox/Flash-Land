RegisterNetEvent('fl_particles:sync')
AddEventHandler('fl_particles:sync', function(id, coords, dict, name, loop, time)
	local routingBucket = 0

	if source ~= nil then
		routingBucket = GetPlayerRoutingBucket(source)
	end

	for _, playerId in pairs(GetPlayers()) do
		if GetPlayerRoutingBucket(playerId) then
			TriggerClientEvent('fl_particles:sync', playerId, id, coords, dict, name, loop, time)
		end
	end
end)

RegisterNetEvent('fl_particles:disable')
AddEventHandler('fl_particles:disable', function(id)
	--print('fl_particles:disable ' .. tostring(GetPlayerName(source)))
	TriggerClientEvent('fl_particles:disable', -1, id)
end)

RegisterNetEvent('fl_particles:disableall')
AddEventHandler('fl_particles:disableall', function()
	--print('fl_particles:disableall ' .. tostring(GetPlayerName(source)))
	TriggerClientEvent('fl_particles:disableall', -1)
end)