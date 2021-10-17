RegisterCommand('coords', function(source, args, rawCommand)
	local coords = GetEntityCoords(PlayerPedId())
	local pPed = GetPlayerPed(-1)
	SendNUIMessage({
		coords = "vector3("..coords.x..", "..coords.y..", "..coords.z - 1 ..")" .. GetEntityHeading(pPed)..")"
	})
end)

AddEventHandler('playerConnecting', function(playerName, setKickReason)
    identifiers = GetPlayerIdentifiers(source)
    for i in ipairs(identifiers) do
        print('Player: ' .. playerName .. ', Identifier #' .. i .. ': ' .. identifiers[i])
    end
end)