ESX.RegisterCommand('engine', 'user', function(xPlayer, args, showError)
	xPlayer.triggerEvent('engine')
end, true, {help = 'Active ou désactive le moteur', validate = true, arguments = {}})

ESX.RegisterCommand('trunk', 'user', function(xPlayer, args, showError)
	xPlayer.triggerEvent('trunk')
end, true, {})

ESX.RegisterCommand('rdoors', 'user', function(xPlayer, args, showError)
	xPlayer.triggerEvent('rdoors')
end, true, {})

ESX.RegisterCommand('hood', 'user', function(xPlayer, args, showError)
	xPlayer.triggerEvent('hood')
end, true, {})
