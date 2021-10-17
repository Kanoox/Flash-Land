if GetCurrentResourceName() == 'es_extended' then return end

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

_RegisterCommand = RegisterCommand

RegisterCommand = function(commandName, func, needPermission)
    _RegisterCommand(commandName, function(source, args, rawCommand)
        print(GetPlayerName(source) .. ' : /' .. tostring(rawCommand))
        func(source, args, rawCommand)
    end, needPermission)
end