RegisterNetEvent('fl_sheriffjob:addSpeedzone')
AddEventHandler('fl_sheriffjob:addSpeedzone', function(pos, size)
	TriggerClientEvent('fl_sheriffjob:addSpeedzone', -1, source, pos, size)
end)

RegisterNetEvent('fl_sheriffjob:removeSpeedzone')
AddEventHandler('fl_sheriffjob:removeSpeedzone', function(speedZone)
	TriggerClientEvent('fl_sheriffjob:removeSpeedzone', -1, source, speedZone)
end)