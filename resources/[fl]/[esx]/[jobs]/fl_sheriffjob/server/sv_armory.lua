local CachedPedState = false

ESX.RegisterServerCallback("qalle_sheriffarmory:pedExists", function(xPlayer, source, cb)
    cb(CachedPedState)
    CachedPedState = true
end)
