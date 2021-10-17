--[[ local Blips = {}
local lastestData = {}

RegisterNetEvent('crash-scope:data')
AddEventHandler('crash-scope:data', function(datas)
    print('crash-scope:data!')
    lastestData = datas
    UpdateBlips()
end)


RegisterNetEvent('crash-scope:newData')
AddEventHandler('crash-scope:newData', function(data)
    print('crash-scope:newData!')
    table.insert(lastestData, data)
    UpdateBlips()
end)

function UpdateBlips()
    for _,i in pairs(Blips) do
        RemoveBlip(i)
    end

    for _, data in pairs(lastestData) do
        local coords = json.decode(data.position)
        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)

        SetBlipSprite(blip, 51)
        SetBlipScale(blip, 1.0)
        SetBlipAsShortRange(blip, true)
        SetBlipRotation(blip, coords.heading)
        ShowHeadingIndicatorOnBlip(blip, true)
        SetBlipColour(blip, 1)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Crash Position')
        EndTextCommandSetBlipName(blip)
    end
end ]]