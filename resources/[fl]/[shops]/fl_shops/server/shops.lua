local ShopItems = {}

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM shops LEFT JOIN items ON items.name = shops.item', {}, function(shopResult)
		for i=1, #shopResult, 1 do
			if shopResult[i].name then
				if ShopItems[shopResult[i].store] == nil then
					ShopItems[shopResult[i].store] = {}
				end

				if shopResult[i].limit == -1 then
					shopResult[i].limit = 30
				end

				table.insert(ShopItems[shopResult[i].store], {
					label = shopResult[i].label,
					item = shopResult[i].item,
					price = shopResult[i].price,
					limit = shopResult[i].limit,
					weight = shopResult[i].weight,
				})
			else
				print(('fl_shops: invalid item "%s" found!'):format(shopResult[i].item))
			end
		end
	end)
end)

ESX.RegisterServerCallback('fl_shops:requestDBItems', function(xPlayer, source, cb)
	cb(ShopItems)
end)

ESX.RegisterServerCallback('fl_shops:IsFoodSellerOnline', function(xPlayer, source, cb)
	cb(IsFoodSellerOnline())
end)

function IsFoodSellerOnline()
	return #ESX.GetPlayersWithJob('ubereats') > 0 or #ESX.GetPlayersWithJob('burgershot') > 0
end

RegisterNetEvent('fl_shops:buyItem')
AddEventHandler('fl_shops:buyItem', function(account, itemName, amount, zone)
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	amount = ESX.Math.Round(amount)

	-- is the player trying to exploit?
	if amount < 0 then
		print('fl_shops: ' .. xPlayer.discord .. ' attempted to exploit the shop!')
		return
	end

	-- get price
	local price = 0
	local itemLabel = ''

	for i=1, #ShopItems[zone], 1 do
		if ShopItems[zone][i].item == itemName then
			price = ShopItems[zone][i].price
			itemLabel = ShopItems[zone][i].label
			break
		end
	end

	price = price * amount

	if IsFoodSellerOnline() then
		price = price * Config.MultiplierFoodSeller
	end

	-- can the player afford this item?
	if xPlayer.getAccount(account).money >= price then
		-- can the player carry the said amount of x item?
		if not xPlayer.canCarryItem(sourceItem.name, amount) then
			xPlayer.showNotification('Vous n\'avez ~r~pas~s~ assez ~y~de place~s~ dans votre inventaire !')
		else
			xPlayer.removeAccountMoney(account, price)
			xPlayer.addInventoryItem(itemName, amount)
			xPlayer.showNotification(('Vous venez d\'acheter ~y~%sx~s~ ~b~%s~s~ pour ~r~$%s~s~'):format(amount, itemLabel, ESX.Math.GroupDigits(price)))
		end
	else
		local missingMoney = price - xPlayer.getAccount(account).money
		xPlayer.showNotification('Vous n\'avez ~r~pas assez~s~ d\'argent: ' .. ESX.Math.GroupDigits(missingMoney))
	end
end)
