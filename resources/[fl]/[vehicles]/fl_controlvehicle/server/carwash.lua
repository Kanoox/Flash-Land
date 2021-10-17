ESX.RegisterServerCallback('fl_controlvehicle:carWashCanAfford', function(xPlayer, source, cb)
	if xPlayer.getMoney() >= Config.WasherPrice then
		xPlayer.removeMoney(Config.WasherPrice)
		xPlayer.showNotification('Votre véhicule s\'est fait lavé pour ~g~$' .. ESX.Math.GroupDigits(Config.WasherPrice) .. '~s~')
		cb(true)
	else
		xPlayer.showNotification('Vous ne pouvez pas laver votre véhicule')
		cb(false)
	end
end)