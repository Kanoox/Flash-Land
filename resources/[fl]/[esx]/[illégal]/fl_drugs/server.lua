local CopsConnected = 0
local PlayersHarvesting = {}
local PlayersTransforming = {}

for _, Drug in pairs(Config.Drugs) do
	PlayersHarvesting[Drug] = {}
	PlayersTransforming[Drug] = {}
end

Citizen.CreateThread(function()
	while true do
		CopsConnected = 0
		for _,xPlayer in pairs(ESX.GetAllPlayers()) do
			if xPlayer.job.name == 'police' then
				CopsConnected = CopsConnected + 1
			end
		end
		Citizen.Wait(60*1000)
	end
end)

local function Harvest(source, type)
	local xPlayer = ESX.GetPlayerFromId(source)
	if CopsConnected < Config.RequiredCops then
		xPlayer.showNotification(_U('act_imp_police') .. CopsConnected .. '/' .. Config.RequiredCops)
		return
	end
	xPlayer.showNotification(_U('pickup_in_prog'))

	SetTimeout(Config.HarvestTime, function()
		if xPlayer and PlayersHarvesting[type][source] then
			if xPlayer.canCarryItem(type, 1) then
				xPlayer.addInventoryItem(type, 1)
				Harvest(source, type)
			else
				xPlayer.showNotification('~r~Vous n\'avez plus de place...')
			end
		end
	end)
end

local function Transform(source, type)
	local xPlayer = ESX.GetPlayerFromId(source)
	if CopsConnected < Config.RequiredCops then
		xPlayer.showNotification(_U('act_imp_police') .. CopsConnected .. '/' .. Config.RequiredCops)
		return
	end
	xPlayer.showNotification(_U('packing_in_prog'))

	SetTimeout(Config.TransformTime, function()
		if xPlayer and PlayersTransforming[type][xPlayer.source] then
			local drugQuantity = xPlayer.getInventoryItem(type).count
			local poochQuantity = xPlayer.getInventoryItem(type .. '_pooch').count

			if drugQuantity < 5 then
				xPlayer.showNotification(_U('not_enough_' .. type))
			elseif xPlayer.canSwapItem(type, 5, type .. '_pooch', 1) then
				xPlayer.removeInventoryItem(type, 5)
				xPlayer.addInventoryItem(type .. '_pooch', 1)
				Transform(xPlayer.source, type)
			else
				xPlayer.showNotification("~r~Vous n'avez plus de place...")
			end
		end
	end)
end

RegisterNetEvent('fl_drugs:startHarvest')
AddEventHandler('fl_drugs:startHarvest', function(type)
	if PlayersHarvesting[type][source] then return end
	PlayersHarvesting[type][source] = true
	Harvest(source, type)
end)

RegisterNetEvent('fl_drugs:startTransform')
AddEventHandler('fl_drugs:startTransform', function(type)
	if PlayersTransforming[type][source] then return end
	PlayersTransforming[type][source] = true
	Transform(source, type)
end)

RegisterNetEvent('fl_drugs:stop')
AddEventHandler('fl_drugs:stop', function()
	for _, Drug in pairs(Config.Drugs) do
		PlayersHarvesting[Drug][source] = false
		PlayersTransforming[Drug][source] = false
	end
end)
