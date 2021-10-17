CreateThread(function()
    SetAllVehicleGeneratorsActiveInArea(-29.99, -1083.32, 26.4, -59.99, -1098.32, 26.4, false, false)
end)

RegisterCommand("volume", function(_, args)
	if tonumber(args[1]) and tonumber(args[1]) >= 0.0 and tonumber(args[1]) <= 1.0 then
		exports['saltychat']:SetRadioVolume(args[1])
	end
end)

RegisterCommand("vitesse", function()
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	SetEntityMaxSpeed(vehicle, 9999.0)
end)