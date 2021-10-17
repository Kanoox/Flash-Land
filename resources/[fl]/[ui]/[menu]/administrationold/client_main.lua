pzCore = {}
pzCore.prefix = "[P.ZCore] >>"
ESX = nil

Citizen.CreateThread(function()
    pzCore.loadESX()
    pzCore.loadAll()
    pzCore.staff.init()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)