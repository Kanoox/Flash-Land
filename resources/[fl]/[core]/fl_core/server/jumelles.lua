ESX.RegisterCloseMenuUsableItem('jumelles', true)
ESX.RegisterUsableItem('jumelles', function(source)
	TriggerClientEvent('fl_jumelles:toggle', source)
end)