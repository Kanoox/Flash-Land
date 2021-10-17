local seatsTaken = {}

RegisterNetEvent('fl_sit:takePlace')
AddEventHandler('fl_sit:takePlace', function(objectCoords)
	seatsTaken[objectCoords] = true
end)

RegisterNetEvent('fl_sit:leavePlace')
AddEventHandler('fl_sit:leavePlace', function(objectCoords)
	if seatsTaken[objectCoords] then
		seatsTaken[objectCoords] = nil
	end
end)

ESX.RegisterServerCallback('fl_sit:getPlace', function(xPlayer, source, cb, objectCoords)
	cb(seatsTaken[objectCoords])
end)
