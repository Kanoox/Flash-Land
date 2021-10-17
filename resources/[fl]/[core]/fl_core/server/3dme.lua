BikeRental = {}

ESX.RegisterServerCallback('nwx:bikerental', function(xPlayer, source, cb, status)
    if status == "check" then
        cb(ESX.Table.Has(BikeRental, xPlayer.discord))
    elseif status then
        table.insert(BikeRental, xPlayer.discord)
        cb(true)
    elseif not status then
        for i = 1, #BikeRental, 1 do
            if BikeRental[i] == xPlayer.discord then
                table.remove(BikeRental, i)
                break
            end
        end
        cb(false)
    end
end)

ESX.RegisterServerCallback('nwx:payment', function(xPlayer, source, cb, zone, itemId, itemType)
    local price = Config.Zones[zone].Items[itemId].price
    if Config.Zones[zone].Free then
        if itemType == "weapon" then
             xPlayer.addInventoryItem(Config.Zones[zone].Items[itemId].item, 1)
        end
        cb(true)
    else
        if xPlayer.getMoney() >= price then
            xPlayer.removeMoney(price)
            if itemType == "weapon" then
                xPlayer.addInventoryItem(Config.Zones[zone].Items[itemId].item, 1)
            end
            cb(true)
        else
            cb(false)
        end
    end
end)

--- 3DME
RegisterNetEvent('3dme:shareDisplay')
AddEventHandler('3dme:shareDisplay', function(text)
	TriggerClientEvent('3dme:triggerDisplay', -1, text, source)
end)