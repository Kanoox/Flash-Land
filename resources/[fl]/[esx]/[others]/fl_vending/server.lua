ESX.RegisterServerCallback('fl_vending:checkMoneyandInvent', function(xPlayer, source, cb, item, multiplier)
	local thisItem = item
	local thisCost = nil
	local thisName = nil
	local cashMoney = xPlayer.getMoney()
	local targetItem = xPlayer.getInventoryItem(thisItem)

	for _, machine in ipairs(Config.Machines) do
		if machine.item == thisItem then
			thisCost = machine.price
			thisName = machine.name
		end
	end

	if thisCost > cashMoney then
		cb("cash")
	else
		if not xPlayer.canCarryItem(thisItem, 1) then
			cb("inventory")
		else
			xPlayer.removeMoney(thisCost * multiplier)
			xPlayer.addInventoryItem(thisItem, 1)
			cb(true)
		end
	end
end)