Citizen.CreateThread(function()
	while true do
		TriggerClientEvent('fl_core:updatePlayerCount', -1, GetNumPlayerIndices())
		Citizen.Wait(25000)
	end
end)