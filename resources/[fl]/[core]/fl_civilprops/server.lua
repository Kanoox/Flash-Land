ESX.RegisterCommand('debug_addpropdev', 'mod', function(xPlayer, args, showError)
    xPlayer.triggerEvent('fl_civilprops:addPropDev', args)
end, false, {})

ESX.RegisterServerCallback("fl_props:getUserGroup", function(xPlayer, source, cb)
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local playerGroup = xPlayer.getGroup()
    if playerGroup ~= nil and playerGroup == 'superadmin' or playerGroup == 'dev' then 
        cb(true)
    else
        cb(false) 
    end
end)  