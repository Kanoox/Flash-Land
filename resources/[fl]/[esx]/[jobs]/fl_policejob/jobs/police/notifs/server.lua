RegisterServerEvent("iCore:sendCall")
AddEventHandler("iCore:sendCall", function(data, msg, coords)
    local xPlayers = ESX.GetPlayers()
    local xSource = ESX.GetPlayerFromId(source)
    for k, v in pairs(xPlayers) do 
        local xPlayer = ESX.GetPlayerFromId(v)

        if xPlayer.job.name == "police" then
            xPlayer.triggerEvent("iCore:getCall", data, msg, coords, xSource)
        end
    end
end)

RegisterServerEvent("iCore:tookCall")
AddEventHandler("iCore:tookCall", function()
    local xSource = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()

    for k, v in pairs(xPlayers) do
        local xPlayer = ESX.GetPlayerFromId(v)

        if xPlayer.job.name == "police" then
            xPlayer.showNotification("~b~" .. xSource.name .. " ~s~a pris l'appel")
        end
    end
end)

RegisterServerEvent("iCore:sendCallMsg")
AddEventHandler("iCore:sendCallMsg", function(msg, coords)
    local xPlayers = ESX.GetPlayers()
    local xSource = ESX.GetPlayerFromId(source)
    for k, v in pairs(xPlayers) do 
        local xPlayer = ESX.GetPlayerFromId(v)

        if xPlayer.job.name == "police" then
            xPlayer.triggerEvent("iCore:getCallMsg", msg, coords, xSource)
        end
    end
end)
