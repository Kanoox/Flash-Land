local color = {r = 107, g = 52, b = 254, alpha = 255}
local nbrDisplaying = 1
local currentlyDisplaying = {}

local function DrawText3D(x,y,z, text)
    local onScreen,_x,_y = World3dToScreen2d(x,y,z)
    local px,py,pz = table.unpack(GetGameplayCamCoord())
    local dist = #(vector3(px, py, pz) - vector3(x, y, z))

    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

    if onScreen then
        SetTextScale(0.0*scale, 0.55*scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(color.r, color.g, color.b, color.alpha)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(text)
        EndTextCommandDisplayText(_x, _y)
    end
end

local function Display(mePlayer, text, offset)
    if not currentlyDisplaying[mePlayer] then
        currentlyDisplaying[mePlayer] = {}
    end

    for _,anyText in pairs(currentlyDisplaying[mePlayer]) do
        if anyText == text then
            return
        end
    end

    table.insert(currentlyDisplaying[mePlayer], text)

    local displaying = true
    Citizen.CreateThread(function()
        Wait(10000)
        displaying = false
        for i,anyText in pairs(currentlyDisplaying[mePlayer]) do
            if anyText == text then
                table.remove(currentlyDisplaying[mePlayer], i)
            end
        end
    end)

    Citizen.CreateThread(function()
        nbrDisplaying = nbrDisplaying + 1
        while displaying do
            Wait(0)
            local coordsMe = GetEntityCoords(mePlayer, false)
            local coords = GetEntityCoords(PlayerPedId(), false)
            local dist = #(coordsMe - coords)
            if dist < 50 then
                DrawText3D(coordsMe['x'], coordsMe['y'], coordsMe['z']+offset, text)
            end
        end
        nbrDisplaying = nbrDisplaying - 1
    end)
end

RegisterCommand('me', function(source, args)
    local text = '* La personne'
    for i = 1,#args do
        text = text .. ' ' .. args[i]
    end
    text = text .. ' *'
    TriggerServerEvent('3dme:shareDisplay', text)
end)

RegisterNetEvent('3dme:triggerDisplay')
AddEventHandler('3dme:triggerDisplay', function(text, source)
    local player = GetPlayerFromServerId(source)
    if player ~= -1 then
        Display(GetPlayerPed(player), text, 1 + (nbrDisplaying*0.12))
    end
end)

RegisterCommand("debugFares", function()
    SetFocusEntity(PlayerPedId())
    ClearTimecycleModifier()
end)