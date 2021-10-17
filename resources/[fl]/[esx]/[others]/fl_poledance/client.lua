ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

FishyDEV = false

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(0)
            if Config['PoleDance']['Enabled'] then
                for k, v in pairs(Config['PoleDance']['Locations']) do
                    if #(GetEntityCoords(PlayerPedId()) - v['Position']) <= 1.0 then
                        ESX.ShowFloatingHelpNotification(Strings['Pole_Dance'], v['Position'])
                        if IsControlJustReleased(0, 51) and not FishyDEV then
						    FishyDEV = true
                            LoadDict('mini@strip_club@pole_dance@pole_dance' .. v['Number'])
                            local scene = NetworkCreateSynchronisedScene(v['Position'], vector3(0.0, 0.0, 0.0), 2, false, false, 1065353216, 0, 1.3)
                            NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, 'mini@strip_club@pole_dance@pole_dance' .. v['Number'], 'pd_dance_0' .. v['Number'], 1.5, -4.0, 1, 1, 1148846080, 0)
                            NetworkStartSynchronisedScene(scene)
						elseif IsControlJustReleased(0, 51) and FishyDEV then
						FishyDEV = false
						ClearPedTasksImmediately(PlayerPedId())
                        end
                    end
                end
            end
    end
end)

LoadDict = function(Dict)
    while not HasAnimDictLoaded(Dict) do 
        Wait(0)
        RequestAnimDict(Dict)
    end
end