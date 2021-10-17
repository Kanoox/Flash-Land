_CreateThread = CreateThread

CreateThread = function(run)
	_CreateThread(function()
		repeat Citizen.Wait(0) until ESX and ESX.PlayerLoaded
		_CreateThread(run)
	end)
end

Citizen.CreateThread = CreateThread

--[[
local _PlayerPedId = PlayerPedId
local CurrentPlayerPedId = PlayerPedId()

PlayerPedId = function()
    return CurrentPlayerPedId
end

local _GetEntityCoords = GetEntityCoords
local PlayerPedCoords = nil
GetEntityCoords = function(entity)
    if entity == PlayerPedId() then
        if PlayerPedCoords == nil then
            PlayerPedCoords = _GetEntityCoords(entity)
        end

        return PlayerPedCoords
    end

    return _GetEntityCoords(entity)
end

Citizen.CreateThread(function()
    while true do
        PlayerPedCoords = nil
        Citizen.Wait(0)
    end
end)
]]