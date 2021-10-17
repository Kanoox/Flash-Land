AddEventHandler('fl_society:openGetStocksMenu', function(society)
	ESX.TriggerServerCallback('fl_society:getStockInventory', function(items)
		local elements = {}

		for i=1, #items, 1 do
			if items[i].count > 0 then
				table.insert(elements, {
					label = 'x' .. items[i].count .. ' ' .. items[i].label,
					value = items[i].name
				})
			end
		end

		ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'stocks_menu', {
			title = 'Stocks',
			elements = elements
		}, function(data, menu)
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
				title = 'Quantité'
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification('Quantité invalide')
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('fl_society:getStockItem', society, data.current.value, count)

					Citizen.Wait(1000)
					TriggerEvent('fl_society:openGetStocksMenu', society)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end, society)
end)

AddEventHandler('fl_society:openPutStocksMenu', function(society)
	ESX.TriggerServerCallback('fl_faction:getPlayerInventory', function(inventory)
		local elements = {}

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					value = item.name
				})
			end
		end

		ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'stocks_menu', {
			title = 'Inventaire',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = 'Quantité'
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification('Quantité invalide')
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('fl_society:putStockItem', society, itemName, count)

					Citizen.Wait(1000)
					TriggerEvent('fl_society:openPutStocksMenu', society)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end)