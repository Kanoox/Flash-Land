local PlayersSelling = {}

RegisterNetEvent('fl_unicornjob:buyItem')
AddEventHandler('fl_unicornjob:buyItem', function(itemName, price, itemLabel)
    local xPlayer  = ESX.GetPlayerFromId(source)
	local societyAccount = nil

    TriggerEvent('fl_data:getSharedAccount', 'society_unicorn', function(account)
		societyAccount = account
      end)

    if societyAccount ~= nil and societyAccount.money >= price then
		if xPlayer.canCarryItem(itemName, 1) then
            societyAccount.removeMoney(price)
            xPlayer.addInventoryItem(itemName, 1)
            xPlayer.showNotification(_U('bought') .. itemLabel)
        else
            xPlayer.showNotification(_U('max_item'))
        end
    else
        xPlayer.showNotification(_U('not_enough') .. ' d\'argent dans votre société')
    end

end)


RegisterNetEvent('fl_unicornjob:craftingCoktails')
AddEventHandler('fl_unicornjob:craftingCoktails', function(itemValue)
	local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.showNotification(_U('assembling_cocktail'))

    if itemValue == 'jagerbomb' then
        SetTimeout(1000, function()

            local alephQuantity = xPlayer.getInventoryItem('redbull').count
            local bethQuantity = xPlayer.getInventoryItem('jager').count

            if alephQuantity < 2 then
                xPlayer.showNotification(_U('not_enough') .. _U('redbull') .. '~w~')
            elseif bethQuantity < 2 then
                xPlayer.showNotification(_U('not_enough') .. _U('jager') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    xPlayer.showNotification(_U('craft_miss'))
                    xPlayer.removeInventoryItem('redbull', 1)
                    xPlayer.removeInventoryItem('jager', 1)
                else
                    xPlayer.showNotification(_U('craft') .. _U('jagerbomb') .. ' ~w~!')
                    xPlayer.removeInventoryItem('redbull', 1)
                    xPlayer.removeInventoryItem('jager', 1)
                    xPlayer.addInventoryItem('jagerbomb', 1)
                end
            end

        end)
    end

    if itemValue == 'golem' then
        SetTimeout(1000, function()
            local alephQuantity = xPlayer.getInventoryItem('limonade').count
            local bethQuantity = xPlayer.getInventoryItem('vodka').count
            local gimelQuantity = xPlayer.getInventoryItem('ice').count

            if alephQuantity < 2 then
                xPlayer.showNotification(_U('not_enough') .. _U('limonade') .. '~w~')
            elseif bethQuantity < 2 then
                xPlayer.showNotification(_U('not_enough') .. _U('vodka') .. '~w~')
            elseif gimelQuantity < 1 then
                xPlayer.showNotification(_U('not_enough') .. _U('ice') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    xPlayer.showNotification(_U('craft_miss'))
                    xPlayer.removeInventoryItem('limonade', 1)
                    xPlayer.removeInventoryItem('vodka', 1)
                    xPlayer.removeInventoryItem('ice', 1)
                else
                    xPlayer.showNotification(_U('craft') .. _U('golem') .. ' ~w~!')
                    xPlayer.removeInventoryItem('limonade', 1)
                    xPlayer.removeInventoryItem('vodka', 1)
                    xPlayer.removeInventoryItem('ice', 1)
                    xPlayer.addInventoryItem('golem', 1)
                end
            end

        end)
    end

    if itemValue == 'whiskycoca' then
        SetTimeout(1000, function()

            local alephQuantity = xPlayer.getInventoryItem('cocacola').count
            local bethQuantity = xPlayer.getInventoryItem('whisky').count

            if alephQuantity < 1 then
                xPlayer.showNotification(_U('not_enough') .. _U('cocacola') .. '~w~')
            elseif bethQuantity < 1 then
                xPlayer.showNotification(_U('not_enough') .. _U('whisky') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    xPlayer.showNotification(_U('craft_miss'))
                    xPlayer.removeInventoryItem('cocacola', 1)
                    xPlayer.removeInventoryItem('whisky', 1)
                else
                    xPlayer.showNotification(_U('craft') .. _U('whiskycoca') .. ' ~w~!')
                    xPlayer.removeInventoryItem('cocacola', 1)
                    xPlayer.removeInventoryItem('whisky', 1)
                    xPlayer.addInventoryItem('whiskycoca', 1)
                end
            end

        end)
    end

    if itemValue == 'rhumcoca' then
        SetTimeout(1000, function()

            local alephQuantity = xPlayer.getInventoryItem('cocacola').count
            local bethQuantity = xPlayer.getInventoryItem('rhum').count

            if alephQuantity < 1 then
                xPlayer.showNotification(_U('not_enough') .. _U('cocacola') .. '~w~')
            elseif bethQuantity < 1 then
                xPlayer.showNotification(_U('not_enough') .. _U('rhum') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    xPlayer.showNotification(_U('craft_miss'))
                    xPlayer.removeInventoryItem('cocacola', 1)
                    xPlayer.removeInventoryItem('rhum', 1)
                else
                    xPlayer.showNotification(_U('craft') .. _U('rhumcoca') .. ' ~w~!')
                    xPlayer.removeInventoryItem('cocacola', 1)
                    xPlayer.removeInventoryItem('rhum', 1)
                    xPlayer.addInventoryItem('rhumcoca', 1)
                end
            end

        end)
    end

    if itemValue == 'vodkaenergy' then
        SetTimeout(1000, function()

            local alephQuantity = xPlayer.getInventoryItem('redbull').count
            local bethQuantity = xPlayer.getInventoryItem('vodka').count
            local gimelQuantity = xPlayer.getInventoryItem('ice').count

            if alephQuantity < 1 then
                xPlayer.showNotification(_U('not_enough') .. _U('redbull') .. '~w~')
            elseif bethQuantity < 1 then
                xPlayer.showNotification(_U('not_enough') .. _U('vodka') .. '~w~')
            elseif gimelQuantity < 1 then
                xPlayer.showNotification(_U('not_enough') .. _U('ice') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    xPlayer.showNotification(_U('craft_miss'))
                    xPlayer.removeInventoryItem('redbull', 1)
                    xPlayer.removeInventoryItem('vodka', 1)
                    xPlayer.removeInventoryItem('ice', 1)
                else
                    xPlayer.showNotification(_U('craft') .. _U('vodkaenergy') .. ' ~w~!')
                    xPlayer.removeInventoryItem('redbull', 1)
                    xPlayer.removeInventoryItem('vodka', 1)
                    xPlayer.removeInventoryItem('ice', 1)
                    xPlayer.addInventoryItem('vodkaenergy', 1)
                end
            end

        end)
    end

    if itemValue == 'vodkafruit' then
        SetTimeout(1000, function()

            local alephQuantity = xPlayer.getInventoryItem('jusfruit').count
            local bethQuantity = xPlayer.getInventoryItem('vodka').count
            local gimelQuantity = xPlayer.getInventoryItem('ice').count

            if alephQuantity < 1 then
                xPlayer.showNotification(_U('not_enough') .. _U('jusfruit') .. '~w~')
            elseif bethQuantity < 1 then
                xPlayer.showNotification(_U('not_enough') .. _U('vodka') .. '~w~')
            elseif gimelQuantity < 1 then
                xPlayer.showNotification(_U('not_enough') .. _U('ice') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    xPlayer.showNotification(_U('craft_miss'))
                    xPlayer.removeInventoryItem('jusfruit', 1)
                    xPlayer.removeInventoryItem('vodka', 1)
                    xPlayer.removeInventoryItem('ice', 1)
                else
                    xPlayer.showNotification(_U('craft') .. _U('vodkafruit') .. ' ~w~!')
                    xPlayer.removeInventoryItem('jusfruit', 1)
                    xPlayer.removeInventoryItem('vodka', 1)
                    xPlayer.removeInventoryItem('ice', 1)
                    xPlayer.addInventoryItem('vodkafruit', 1)
                end
            end

        end)
    end

    if itemValue == 'rhumfruit' then
        SetTimeout(1000, function()

            local alephQuantity = xPlayer.getInventoryItem('jusfruit').count
            local bethQuantity = xPlayer.getInventoryItem('rhum').count
            local gimelQuantity = xPlayer.getInventoryItem('ice').count

            if alephQuantity < 1 then
                xPlayer.showNotification(_U('not_enough') .. _U('jusfruit') .. '~w~')
            elseif bethQuantity < 1 then
                xPlayer.showNotification(_U('not_enough') .. _U('rhum') .. '~w~')
            elseif gimelQuantity < 1 then
                xPlayer.showNotification(_U('not_enough') .. _U('ice') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    xPlayer.showNotification(_U('craft_miss'))
                    xPlayer.removeInventoryItem('jusfruit', 1)
                    xPlayer.removeInventoryItem('rhum', 1)
                    xPlayer.removeInventoryItem('ice', 1)
                else
                    xPlayer.showNotification(_U('craft') .. _U('rhumfruit') .. ' ~w~!')
                    xPlayer.removeInventoryItem('jusfruit', 1)
                    xPlayer.removeInventoryItem('rhum', 1)
                    xPlayer.removeInventoryItem('ice', 1)
                    xPlayer.addInventoryItem('rhumfruit', 1)
                end
            end

        end)
    end

    if itemValue == 'teqpaf' then
        SetTimeout(1000, function()

            local alephQuantity = xPlayer.getInventoryItem('limonade').count
            local bethQuantity = xPlayer.getInventoryItem('tequila').count

            if alephQuantity < 1 then
                xPlayer.showNotification(_U('not_enough') .. _U('limonade') .. '~w~')
            elseif bethQuantity < 1 then
                xPlayer.showNotification(_U('not_enough') .. _U('tequila') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    xPlayer.showNotification(_U('craft_miss'))
                    xPlayer.removeInventoryItem('limonade', 1)
                    xPlayer.removeInventoryItem('tequila', 1)
                else
                    xPlayer.showNotification(_U('craft') .. _U('teqpaf') .. ' ~w~!')
                    xPlayer.removeInventoryItem('limonade', 1)
                    xPlayer.removeInventoryItem('tequila', 1)
                    xPlayer.addInventoryItem('teqpaf', 1)
                end
            end

        end)
    end

    if itemValue == 'mojito' then
        SetTimeout(1000, function()

            local alephQuantity = xPlayer.getInventoryItem('rhum').count
            local bethQuantity = xPlayer.getInventoryItem('limonade').count
            local gimelQuantity = xPlayer.getInventoryItem('menthe').count
            local daletQuantity = xPlayer.getInventoryItem('ice').count

            if alephQuantity < 1 then
                xPlayer.showNotification(_U('not_enough') .. _U('rhum') .. '~w~')
            elseif bethQuantity < 1 then
                xPlayer.showNotification(_U('not_enough') .. _U('limonade') .. '~w~')
            elseif gimelQuantity < 1 then
                xPlayer.showNotification(_U('not_enough') .. _U('menthe') .. '~w~')
            elseif daletQuantity < 1 then
                xPlayer.showNotification(_U('not_enough') .. _U('ice') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    xPlayer.showNotification(_U('craft_miss'))
                    xPlayer.removeInventoryItem('rhum', 1)
                    xPlayer.removeInventoryItem('limonade', 1)
                    xPlayer.removeInventoryItem('menthe', 1)
                    xPlayer.removeInventoryItem('ice', 1)
                else
                    xPlayer.showNotification(_U('craft') .. _U('mojito') .. ' ~w~!')
                    xPlayer.removeInventoryItem('rhum', 1)
                    xPlayer.removeInventoryItem('limonade', 1)
                    xPlayer.removeInventoryItem('menthe', 1)
                    xPlayer.removeInventoryItem('ice', 1)
                    xPlayer.addInventoryItem('mojito', 1)
                end
            end

        end)
    end

    if itemValue == 'mixapero' then
        SetTimeout(1000, function()

            local alephQuantity = xPlayer.getInventoryItem('bolcacahuetes').count
            local bethQuantity = xPlayer.getInventoryItem('bolnoixcajou').count
            local gimelQuantity = xPlayer.getInventoryItem('bolpistache').count
            local daletQuantity = xPlayer.getInventoryItem('bolchips').count

            if alephQuantity < 1 then
                xPlayer.showNotification(_U('not_enough') .. _U('bolcacahuetes') .. '~w~')
            elseif bethQuantity < 1 then
                xPlayer.showNotification(_U('not_enough') .. _U('bolnoixcajou') .. '~w~')
            elseif gimelQuantity < 1 then
                xPlayer.showNotification(_U('not_enough') .. _U('bolpistache') .. '~w~')
            elseif daletQuantity < 1 then
                xPlayer.showNotification(_U('not_enough') .. _U('bolchips') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    xPlayer.showNotification(_U('craft_miss'))
                    xPlayer.removeInventoryItem('bolcacahuetes', 1)
                    xPlayer.removeInventoryItem('bolnoixcajou', 1)
                    xPlayer.removeInventoryItem('bolpistache', 1)
                    xPlayer.removeInventoryItem('bolchips', 1)
                else
                    xPlayer.showNotification(_U('craft') .. _U('mixapero') .. ' ~w~!')
                    xPlayer.removeInventoryItem('bolcacahuetes', 1)
                    xPlayer.removeInventoryItem('bolnoixcajou', 1)
                    xPlayer.removeInventoryItem('bolpistache', 1)
                    xPlayer.removeInventoryItem('bolchips', 1)
                    xPlayer.addInventoryItem('mixapero', 1)
                end
            end

        end)
    end

    if itemValue == 'metreshooter' then
        SetTimeout(1000, function()

            local alephQuantity = xPlayer.getInventoryItem('jager').count
            local bethQuantity = xPlayer.getInventoryItem('vodka').count
            local gimelQuantity = xPlayer.getInventoryItem('whisky').count
            local daletQuantity = xPlayer.getInventoryItem('tequila').count

            if alephQuantity < 1 then
                xPlayer.showNotification(_U('not_enough') .. _U('jager') .. '~w~')
            elseif bethQuantity < 1 then
                xPlayer.showNotification(_U('not_enough') .. _U('vodka') .. '~w~')
            elseif gimelQuantity < 1 then
                xPlayer.showNotification(_U('not_enough') .. _U('whisky') .. '~w~')
            elseif daletQuantity < 1 then
                xPlayer.showNotification(_U('not_enough') .. _U('tequila') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    xPlayer.showNotification(_U('craft_miss'))
                    xPlayer.removeInventoryItem('jager', 1)
                    xPlayer.removeInventoryItem('vodka', 1)
                    xPlayer.removeInventoryItem('whisky', 1)
                    xPlayer.removeInventoryItem('tequila', 1)
                else
                    xPlayer.showNotification(_U('craft') .. _U('metreshooter') .. ' ~w~!')
                    xPlayer.removeInventoryItem('jager', 1)
                    xPlayer.removeInventoryItem('vodka', 1)
                    xPlayer.removeInventoryItem('whisky', 1)
                    xPlayer.removeInventoryItem('tequila', 1)
                    xPlayer.addInventoryItem('metreshooter', 1)
                end
            end

        end)
    end

    if itemValue == 'jagercerbere' then
        SetTimeout(1000, function()

            local alephQuantity = xPlayer.getInventoryItem('jagerbomb').count
            local bethQuantity = xPlayer.getInventoryItem('vodka').count
            local gimelQuantity = xPlayer.getInventoryItem('tequila').count

            if alephQuantity < 1 then
                xPlayer.showNotification(_U('not_enough') .. _U('jagerbomb') .. '~w~')
            elseif bethQuantity < 1 then
                xPlayer.showNotification(_U('not_enough') .. _U('vodka') .. '~w~')
            elseif gimelQuantity < 1 then
                xPlayer.showNotification(_U('not_enough') .. _U('tequila') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    xPlayer.showNotification(_U('craft_miss'))
                    xPlayer.removeInventoryItem('jagerbomb', 1)
                    xPlayer.removeInventoryItem('vodka', 1)
                    xPlayer.removeInventoryItem('tequila', 1)
                else
                    xPlayer.showNotification(_U('craft') .. _U('jagercerbere') .. ' ~w~!')
                    xPlayer.removeInventoryItem('jagerbomb', 1)
                    xPlayer.removeInventoryItem('vodka', 1)
                    xPlayer.removeInventoryItem('tequila', 1)
                    xPlayer.addInventoryItem('jagercerbere', 1)
                end
            end

        end)
    end

end)

local function Sell(source, zone)

	if PlayersSelling[source] then
		local xPlayer = ESX.GetPlayerFromId(source)

		if zone == 'SellFarm' then
			SetTimeout(1100, function()
				local money = 0

				if xPlayer.getInventoryItem('jagerbomb').count > 0 and money == 0 then
					money = math.random(12,17)
					xPlayer.removeInventoryItem('jagerbomb', 1)
				end

				if xPlayer.getInventoryItem('golem').count > 0 and money == 0 then
					money = math.random(14,19)
					xPlayer.removeInventoryItem('golem', 1)
				end

				if xPlayer.getInventoryItem('whiskycoca').count > 0 and money == 0 then
					money = math.random(12,17)
					xPlayer.removeInventoryItem('whiskycoca', 1)
				end

				if xPlayer.getInventoryItem('rhumcoca').count > 0 and money == 0 then
					money = math.random(12,17)
					xPlayer.removeInventoryItem('rhumcoca', 1)
				end

				if xPlayer.getInventoryItem('vodkaenergy').count > 0 and money == 0 then
					money = math.random(14,19)
					xPlayer.removeInventoryItem('vodkaenergy', 1)
				end

				if xPlayer.getInventoryItem('vodkafruit').count > 0 and money == 0 then
					money = math.random(14,19)
					xPlayer.removeInventoryItem('vodkafruit', 1)
				end

				if xPlayer.getInventoryItem('rhumfruit').count > 0 and money == 0 then
					money = math.random(14,19)
					xPlayer.removeInventoryItem('rhumfruit', 1)
				end

				if xPlayer.getInventoryItem('teqpaf').count > 0 and money == 0 then
					money = math.random(12,17)
					xPlayer.removeInventoryItem('teqpaf', 1)
				end

				if xPlayer.getInventoryItem('mojito').count > 0 and money == 0 then
					money = math.random(17,22)
					xPlayer.removeInventoryItem('mojito', 1)
				end

				if xPlayer.getInventoryItem('metreshooter').count > 0 and money == 0 then
					money = math.random(30,40)
					xPlayer.removeInventoryItem('metreshooter', 1)
				end

				if xPlayer.getInventoryItem('mixapero').count > 0 and money == 0 then
					money = math.random(25,30)
					xPlayer.removeInventoryItem('mixapero', 1)
				end

				if xPlayer.getInventoryItem('jagercerbere').count > 0 and money == 0 then
					money = math.random(22,27)
					xPlayer.removeInventoryItem('jagercerbere', 1)
				end

				if money > 0 then
					TriggerEvent('fl_data:getSharedAccount', 'society_unicorn', function(account)
						societyAccount.addMoney(money)
						xPlayer.showNotification(_U('comp_earned') .. money)
					end)
				end

				Sell(source,zone)
			end)
		end
	end
end


RegisterNetEvent('fl_unicornjob:startSell')
AddEventHandler('fl_unicornjob:startSell', function(zone)
	if PlayersSelling[source] then return end

	PlayersSelling[source] = true
	TriggerClientEvent('esx:showNotification', source, _U('sale_in_prog'))
	Sell(source, zone)
end)

RegisterNetEvent('fl_unicornjob:stopSell')
AddEventHandler('fl_unicornjob:stopSell', function()
	PlayersSelling[source] = false
	TriggerClientEvent('esx:showNotification', source, 'Vous sortez de la ~r~zone')
end)
