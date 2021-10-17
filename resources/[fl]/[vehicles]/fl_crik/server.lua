-- raise the closest car --
RegisterCommand("crik+", function(source, args, raw)
	
	TriggerClientEvent('crik+', source)
end)

-- lower the previously raised car --
RegisterCommand("crik-", function(source, args, raw)
	
	TriggerClientEvent('crik-', source)
end)
