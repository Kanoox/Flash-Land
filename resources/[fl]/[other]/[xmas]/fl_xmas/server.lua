RegisterNetEvent('fl_xmas:giveSnowball')
AddEventHandler('fl_xmas:giveSnowball', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = xPlayer.getInventoryItem('snowball')
    if item.count > 10 then return end
    xPlayer.addInventoryItem('snowball', 1)
end)

ESX.RegisterUsableItem('snow_chain', function(source)
    TriggerClientEvent('fl_xmas:toggleSnowChain', source)
end)

AddEventHandler('esx:onRemoveInventoryItem', function(source, item, count)
    if item.name == 'snow_chain' and item.count <= 0 then
        TriggerClientEvent('fl_xmas:forceSnowChain', source, true)
    end
end)

AddEventHandler('weaponDamageEvent', function(source, data)
    if data.weaponType == `WEAPON_SNOWBALL` or data.weaponType == `AMMO_SNOWBALL` then CancelEvent() end
end)

ESX.RegisterTempItem('snow_chain', 'Chaîne à neige', 0.5, 10, true)
