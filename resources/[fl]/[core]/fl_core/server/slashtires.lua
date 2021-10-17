RegisterNetEvent('fl_core:slashTargetClient')
AddEventHandler('fl_core:slashTargetClient', function(client, tireIndex)
	TriggerClientEvent("fl_core:slashClientTire", client, tireIndex)
end)