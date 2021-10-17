RegisterNetEvent('fl_sheriffjob:requestarrest')
AddEventHandler('fl_sheriffjob:requestarrest', function(targetid, playerheading, playerCoords,  playerlocation)
	TriggerClientEvent('fl_sheriffjob:getarrested', targetid, playerheading, playerCoords, playerlocation)
	TriggerClientEvent('fl_sheriffjob:doarrested', source)
end)

RegisterNetEvent('fl_sheriffjob:requestrelease')
AddEventHandler('fl_sheriffjob:requestrelease', function(targetid, playerheading, playerCoords,  playerlocation)
	TriggerClientEvent('fl_sheriffjob:getuncuffed', targetid, playerheading, playerCoords, playerlocation)
	TriggerClientEvent('fl_sheriffjob:douncuffing', source)
end)


RegisterNetEvent('fl_sheriffjob:handcuff')
AddEventHandler('fl_sheriffjob:handcuff', function(target)
	TriggerClientEvent('fl_sheriffjob:handcuff', target)
end)

RegisterNetEvent('fl_sheriffjob:dragErrorResponse')
AddEventHandler('fl_sheriffjob:dragErrorResponse', function(target)
	TriggerClientEvent('fl_sheriffjob:dragErrorResponse', target)
end)

RegisterNetEvent('fl_sheriffjob:drag')
AddEventHandler('fl_sheriffjob:drag', function(target)
	TriggerClientEvent('fl_sheriffjob:drag', target, source)
end)

RegisterNetEvent('fl_sheriffjob:putInVehicle')
AddEventHandler('fl_sheriffjob:putInVehicle', function(target)
	TriggerClientEvent('fl_sheriffjob:putInVehicle', target)
end)

RegisterNetEvent('fl_sheriffjob:OutVehicle')
AddEventHandler('fl_sheriffjob:OutVehicle', function(target)
	TriggerClientEvent('fl_sheriffjob:OutVehicle', target, source)
end)

RegisterNetEvent('fl_sheriffjob:OutVehicleErrorResponse')
AddEventHandler('fl_sheriffjob:OutVehicleErrorResponse', function(target)
	TriggerClientEvent('fl_sheriffjob:OutVehicleErrorResponse', target, source)
end)