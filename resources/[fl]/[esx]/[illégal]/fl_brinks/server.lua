ESX = nil
Vehicles = {}
isDead = {}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem("securitygreen", function(source)
    TriggerClientEvent("fizzfau-banktruck:onUse", source)
end)

RegisterServerEvent("fizzfau-moneytruck:checkRob")
AddEventHandler("fizzfau-moneytruck:checkRob", function(plate, vehicle)
    if CountCops() >= Config.PoliceAmount then
        if Vehicles[plate] == nil then 
            Vehicles[plate] = true
            TriggerClientEvent("fizzfau-moneytruck:startRob", source, vehicle)
        else
            TriggerClientEvent("notification", source, "Bu araç zaten soyulmuş!")
        end
    else
        TriggerClientEvent("notification", source, "Yeterli polis yok!")
    end
end)

RegisterServerEvent("fizzfau-moneytruck:server:startRob")
AddEventHandler("fizzfau-moneytruck:server:startRob", function()
    StartRobbing(source)
end)
    
function CountCops()
    local players = ESX.GetPlayers()
    local count = 0
    for i =1, #players do
        local player = ESX.GetPlayerFromId(players[i])
        if player.job.name == "police" then
            count = count + 1
        end
    end
    return count
end

function StartRobbing(source)
    local player = ESX.GetPlayerFromId(source)
    local temp_item
    if player ~= nil then
        local time = Config.RobbingTime
        while time > 0 do
            if not isDead[source] then
                Citizen.Wait(Config.WaitMultiplier * 1000)
                time = time - Config.WaitMultiplier
                local check = math.random(100)
                if check <= Config.ItemOrCash then
                    local money = math.random(Config.Money.Min, Config.Money.Max)
                    player.addMoney(money)
                else
                    local item = Config.Items[math.random(#Config.Items)]
                    if item ~= temp_item then
                        local count = math.random(item[1], item[2])
                        player.addInventoryItem(item[3], count)
                    end
                end
            else
                return
            end
        end
        TriggerClientEvent("fizzfau-moneytruck:endRobbery", source)
    end
end

RegisterServerEvent("fizzfau-moneytruck:onPlayerDeath")
AddEventHandler("fizzfau-moneytruck:onPlayerDeath", function()
    isDead[source] = true
end)

RegisterServerEvent("fizzfau-moneytruck:playerSpawned")
AddEventHandler("fizzfau-moneytruck:playerSpawned", function()
    isDead[source] = false
end)