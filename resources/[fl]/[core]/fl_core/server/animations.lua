RegisterNetEvent('esx-qalle-needs:sync')
AddEventHandler('esx-qalle-needs:sync', function(need, sex)
    TriggerClientEvent('esx-qalle-needs:syncCL', -1, source, need, sex)
end)
