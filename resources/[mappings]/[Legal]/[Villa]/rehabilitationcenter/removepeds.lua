Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local myCoords = GetEntityCoords(PlayerPedId())
		if #(PlayerPedId() - vector3(-1510.13, 843.84, 182.51)) < 80 then
			ClearAreaOfPeds(-1510.13, 843.84, 182.51, 58.0, 0)
		else
			Citizen.Wait(5000)
		end
	end
end)