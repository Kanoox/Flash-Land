AddEventHandler('playerConnecting', function(playerName, deferrals)
    local loadFile = LoadResourceFile(GetCurrentResourceName(), "plugins/server/NameChange/names.json")
	local loadedFile = json.decode(loadFile)
    local steam = ExtractIdentifiers(source).steam

    if loadedFile[steam] ~= nil then 
        if loadedFile[steam] ~= GetPlayerName(source) then 
            for _, i in ipairs(GetPlayers()) do
                if IsPlayerAceAllowed(i, NameChangeConfig.AcePermission) then 
                    TriggerClientEvent('chat:addMessage', i, {
                        template = '<div style="background-color: rgba(90, 90, 90, 0.9); text-align: center; border-radius: 0.5vh; padding: 0.7vh; font-size: 1.7vh;"><b>Player ^1{0} ^0used to be named ^1{1}</b></div>',
                        args = { GetPlayerName(source), loadedFile[steam] }
                    })
                end
            end
            PluginSinglePlayerLogs("Player **" .. GetPlayerName(source) .. "** used to be named **" ..loadedFile[steam].."**", Config.Plugins['NameChange'].color, source, 'NameChange')
        end
    end
    loadedFile[steam] = GetPlayerName(source)
    SaveResourceFile(GetCurrentResourceName(), "plugins/server/NameChange/names.json", json.encode(loadedFile), -1)
end)