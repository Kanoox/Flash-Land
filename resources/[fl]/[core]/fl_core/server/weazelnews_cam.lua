RegisterCommand("cam", function(source, args, raw)
    TriggerClientEvent("Cam:ToggleCam", source)
end)

RegisterCommand("bmic", function(source, args, raw)
    TriggerClientEvent("Mic:ToggleBMic", source)
end)

RegisterCommand("mic", function(source, args, raw)
    TriggerClientEvent("Mic:ToggleMic", source)
end)
