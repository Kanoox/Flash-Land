RegisterCommand('createped', function(source, args, rawCommand)
    local model = args[1]
    local number = tonumber(args[2])
    if number == nil or number <= 0 then number = 1 end
    local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local forward = GetEntityForwardVector(playerPed)
    local x, y, z = table.unpack(coords + forward)

    RequestModel(model)
    while not HasModelLoaded(model) do Citizen.Wait(0) end

    while number > 0 do
        local ped = CreatePed(5, model, x, y, z, 0.0, true, false)
        SetEntityHeading(ped, GetEntityHeading(playerPed) - 180.0)
        print(ped)
        number = number - 1
    end
end, true)

RegisterCommand('randomped', function(source, args, rawCommand)
    local ped = tonumber(args[1])
    print(DoesEntityExist(ped))
    SetPedRandomProps(ped)
    SetPedRandomComponentVariation(ped, 1)
    SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(ped), true)
end, true)

RegisterCommand('deleteped', function(source, args, rawCommand)
    local ped = tonumber(args[1])
    TriggerServerEvent('esx:deleteEntity', NetworkGetNetworkIdFromEntity(ped))
end, true)

RegisterCommand('wanderped', function(source, args, rawCommand)
    local ped = tonumber(args[1])
    NetworkRequestControlOfEntity(ped)
    print(tostring(NetworkHasControlOfEntity(ped)))
    Citizen.CreateThread(function()
        while true do
            TaskWanderInArea(ped, GetEntityCoords(ped), 20.0, 5.0, 1.0)
            Citizen.Wait(10000)
        end
    end)
end, true)

RegisterCommand('weaponped', function(source, args, rawCommand)
    local ped = tonumber(args[1])
    NetworkRequestControlOfEntity(ped)
    print(tostring(NetworkHasControlOfEntity(ped)))
    GiveWeaponToPed(ped, `WEAPON_CARBINERIFLE_MK2`, 100, 0, 1)
    SetCurrentPedWeapon(ped, `WEAPON_CARBINERIFLE_MK2`, 1)
    print('ped')
end, true)

RegisterCommand('attackped', function(source, args, rawCommand)
    local ped = tonumber(args[1])
    local ped2 = tonumber(args[2])
    NetworkRequestControlOfEntity(ped)
    TaskCombatPed(ped, ped2, 0, 16)
end, true)

RegisterCommand('entervehicle', function(source, args, rawCommand)
    local ped = tonumber(args[1])
    local vehicle = tonumber(args[2])
    NetworkRequestControlOfEntity(ped)
    NetworkRequestControlOfEntity(vehicle)
    TaskEnterVehicle(ped, vehicle, 20000, -1, 1.5, 1, 0)
    print('entervehicle')
end, true)

RegisterCommand('taskchase', function(source, args, rawCommand)
    local ped = tonumber(args[1])
    local entity = tonumber(args[2])
    NetworkRequestControlOfEntity(ped)
    TaskPlaneChase(ped, entity, 30.0, 30.0, 0.0)
    print('taskchase')
end, true)

RegisterCommand('followped', function(source, args, rawCommand)
    local ped = tonumber(args[1])
    local entity = tonumber(args[2])
    NetworkRequestControlOfEntity(ped)
    TaskFollowToOffsetOfEntity(ped, entity, math.random(-2, 2) + 0.0, math.random(-2, 2) + 0.0, 1.0, 1.0, 10.0, 10.0, true)
    print('follow')
end, true)

RegisterCommand('followped-1', function(source, args, rawCommand)
    local ped = tonumber(args[1])
    local entity = tonumber(args[2])
    NetworkRequestControlOfEntity(ped)
    TaskFollowToOffsetOfEntity(ped, entity, math.random(-2, 2) + 0.0, math.random(-2, 2) + 0.0, 1.0, 10.0, 10.0, 10.0, true)
    print('follow')
end, true)

RegisterCommand('stopped', function(source, args, rawCommand)
    local ped = tonumber(args[1])
    NetworkRequestControlOfEntity(ped)
    ClearPedTasks(ped)
    print('stop')
end, true)

RegisterCommand('removebodyarmorped', function(source, args, rawCommand)
    local ped = tonumber(args[1])
    NetworkRequestControlOfEntity(ped)
    SetPedComponentVariation(ped, 9, 1, 0, 0) --Gilet
    print('bodyarmorped')
end, true)

RegisterCommand('attackanyone', function(source, args, rawCommand)
    local ped = tonumber(args[1])
    NetworkRequestControlOfEntity(ped)
    SetPedRelationshipGroupHash(ped, `HATES_PLAYER`)
    RegisterHatedTargetsAroundPed(ped, 10.0)
    TaskCombatHatedTargetsAroundPed(ped, 10.0, 0)
    print('attackanyone')
end, true)