RegisterCommand('debug_routing_p', function(source, args, raw)
    if #args ~= 2 then
        print('debug_routing_p <playerId> <bucket>')
        return
    end

    SetPlayerRoutingBucket(tonumber(args[1]), tonumber(args[2]))
    exports['mumble-voip'].updateRoutingBucket(tonumber(args[1]))
    print('Defined bucket of ' .. tostring(GetPlayerName(args[1])) .. ' to ' .. tostring(args[2]))
end, true)

RegisterCommand('debug_routing_getp', function(source, args, raw)
    if #args ~= 1 then
        print('debug_routing_getp <playerId>')
        return
    end

    print('Bucket of ' .. tostring(GetPlayerName(args[1])) .. ' is ' .. tostring(GetPlayerRoutingBucket(args[1])))
end, true)

RegisterCommand('debug_routing_e', function(source, args, raw)
    if #args ~= 2 then
        print('debug_routing_e <entityId> <bucket>')
        return
    end

    SetEntityRoutingBucket(tonumber(args[1]), tonumber(args[2]))
    print('Defined bucket of entity ' .. tostring(args[1]) .. ' to ' .. tostring(args[2]))
end, true)

RegisterCommand('debug_routing_gete', function(source, args, raw)
    if #args ~= 1 then
        print('debug_routing_gete <entityId>')
        return
    end

    print('Bucket of entity ' .. tostring(args[1]) .. ' is ' .. tostring(GetEntityRoutingBucket(args[1])))
end, true)

RegisterCommand('debug_deleteentity', function(source, args, raw)
    if #args ~= 1 then
        print('debug_deleteentity <entityId>')
        return
    end

    DeleteEntity(args[1])
    print('Deleting entity ' .. tostring(args[1]))
end, true)