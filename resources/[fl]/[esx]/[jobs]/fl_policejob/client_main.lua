flCore = {}
flCore.prefix = "[FL CORE] >> "
ESX = nil


Citizen.CreateThread(function()
    flCore.loadESX()
    flCore.loadAll()
    flCore.markers.init()
    flCore.jobsMarkers.subscribe()
    --flCore.menus.init()
    flCore.jobsFunc.init()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
    flCore.jobsFunc.changed()
    flCore.jobsMarkers.unsubscribeAll()
    flCore.jobsMarkers.subscribe()
end)