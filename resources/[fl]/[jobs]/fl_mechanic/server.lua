PlayersHarvesting = {}
PlayersHarvesting2 = {}
PlayersHarvesting3 = {}
PlayersCrafting = {}
PlayersCrafting2 = {}
PlayersCrafting3 = {}

local function Harvest(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	SetTimeout(4000, function()

		if PlayersHarvesting[source] then
			local GazBottleQuantity = xPlayer.getInventoryItem('gazbottle').count

			if GazBottleQuantity >= 5 then
				xPlayer.showNotification(_U('you_do_not_room'))
			else
				xPlayer.addInventoryItem('gazbottle', 1)
				Harvest(xPlayer.source)
			end
		end

	end)
end

RegisterNetEvent('fl_mechanic:startHarvest')
AddEventHandler('fl_mechanic:startHarvest', function()
	PlayersHarvesting[source] = true
	TriggerClientEvent('esx:showNotification', source, _U('recovery_gas_can'))
	Harvest(source)
end)

RegisterNetEvent('fl_mechanic:stopHarvest')
AddEventHandler('fl_mechanic:stopHarvest', function()
	PlayersHarvesting[source] = false
end)

local function Harvest2(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	SetTimeout(4000, function()
		if PlayersHarvesting2[xPlayer.source] then
			local FixToolQuantity = xPlayer.getInventoryItem('fixtool').count

			if FixToolQuantity >= 5 then
				xPlayer.showNotification(_U('you_do_not_room'))
			else
				xPlayer.addInventoryItem('fixtool', 1)
				Harvest2(xPlayer.source)
			end
		end
	end)
end

RegisterNetEvent('fl_mechanic:startHarvest2')
AddEventHandler('fl_mechanic:startHarvest2', function()
	PlayersHarvesting2[source] = true
	TriggerClientEvent('esx:showNotification', source, _U('recovery_repair_tools'))
	Harvest2(source)
end)

RegisterNetEvent('fl_mechanic:stopHarvest2')
AddEventHandler('fl_mechanic:stopHarvest2', function()
	PlayersHarvesting2[source] = false
end)

local function Harvest3(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	SetTimeout(4000, function()
		if PlayersHarvesting3[xPlayer.source] then
			local CaroToolQuantity = xPlayer.getInventoryItem('carotool').count
			if CaroToolQuantity >= 5 then
				xPlayer.showNotification(_U('you_do_not_room'))
			else
				xPlayer.addInventoryItem('carotool', 1)
				Harvest3(xPlayer.source)
			end
		end

	end)
end

RegisterNetEvent('fl_mechanic:startHarvest3')
AddEventHandler('fl_mechanic:startHarvest3', function()
	PlayersHarvesting3[source] = true
	TriggerClientEvent('esx:showNotification', source, _U('recovery_body_tools'))
	Harvest3(source)
end)

RegisterNetEvent('fl_mechanic:stopHarvest3')
AddEventHandler('fl_mechanic:stopHarvest3', function()
	PlayersHarvesting3[source] = false
end)

local function Craft(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	SetTimeout(4000, function()

		if PlayersCrafting[xPlayer.source] then
			local GazBottleQuantity = xPlayer.getInventoryItem('gazbottle').count

			if GazBottleQuantity <= 0 then
				xPlayer.showNotification(_U('not_enough_gas_can'))
			else
				xPlayer.removeInventoryItem('gazbottle', 1)
				xPlayer.addInventoryItem('blowpipe', 1)
				Craft(xPlayer.source)
			end
		end

	end)
end

RegisterNetEvent('fl_mechanic:startCraft')
AddEventHandler('fl_mechanic:startCraft', function()
	PlayersCrafting[source] = true
	TriggerClientEvent('esx:showNotification', source, _U('assembling_blowtorch'))
	Craft(source)
end)

RegisterNetEvent('fl_mechanic:stopCraft')
AddEventHandler('fl_mechanic:stopCraft', function()
	PlayersCrafting[source] = false
end)

local function Craft2(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	SetTimeout(4000, function()
		if PlayersCrafting2[xPlayer.source] then
			local FixToolQuantity = xPlayer.getInventoryItem('fixtool').count

			if FixToolQuantity <= 0 then
				xPlayer.showNotification(_U('not_enough_repair_tools'))
			else
				xPlayer.removeInventoryItem('fixtool', 1)
				xPlayer.addInventoryItem('fixkit', 1)
				Craft2(xPlayer.source)
			end
		end

	end)
end

RegisterNetEvent('fl_mechanic:startCraft2')
AddEventHandler('fl_mechanic:startCraft2', function()
	PlayersCrafting2[source] = true
	TriggerClientEvent('esx:showNotification', source, _U('assembling_body_kit'))
	Craft2(source)
end)

RegisterNetEvent('fl_mechanic:stopCraft2')
AddEventHandler('fl_mechanic:stopCraft2', function()
	PlayersCrafting2[source] = false
end)

local function Craft3(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	SetTimeout(4000, function()
		if PlayersCrafting3[xPlayer.source] then
			local CaroToolQuantity = xPlayer.getInventoryItem('carotool').count

			if CaroToolQuantity <= 0 then
				xPlayer.showNotification(_U('not_enough_body_tools'))
			else
				xPlayer.removeInventoryItem('carotool', 1)
				xPlayer.addInventoryItem('carokit', 1)
				Craft3(xPlayer.source)
			end
		end

	end)
end

RegisterNetEvent('fl_mechanic:startCraft3')
AddEventHandler('fl_mechanic:startCraft3', function()
	PlayersCrafting3[source] = true
	TriggerClientEvent('esx:showNotification', source, _U('assembling_body_kit'))
	Craft3(source)
end)

RegisterNetEvent('fl_mechanic:stopCraft3')
AddEventHandler('fl_mechanic:stopCraft3', function()
	PlayersCrafting3[source] = false
end)

RegisterNetEvent('fl_mechanic:onNPCJobMissionCompleted')
AddEventHandler('fl_mechanic:onNPCJobMissionCompleted', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local total = math.random(Config.NPCJobEarnings.min, Config.NPCJobEarnings.max);

	TriggerEvent('fl_data:getSharedAccount', 'society_mechanic', function(account)
		account.addMoney(total)
	end)

	TriggerClientEvent("esx:showNotification", xPlayer.source, _U('your_comp_earned').. total)
end)

ESX.RegisterUsableItem('blowpipe', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('blowpipe', 1)

	TriggerClientEvent('fl_mechanic:onHijack', xPlayer.source)
	xPlayer.showNotification(_U('you_used_blowtorch'))
end)

ESX.RegisterUsableItem('fixkit', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('fixkit', 1)

	TriggerClientEvent('fl_mechanic:onFixkit', xPlayer.source)
	xPlayer.showNotification(_U('you_used_repair_kit'))
end)

ESX.RegisterUsableItem('carokit', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('carokit', 1)

	TriggerClientEvent('fl_mechanic:onCarokit', xPlayer.source)
	xPlayer.showNotification(_U('you_used_body_kit'))
end)
