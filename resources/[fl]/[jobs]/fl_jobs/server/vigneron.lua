local PlayersHarvestingVigneron = {}
local PlayersCraftingVigneron = {}
local PlayersCraftingVigneron2 = {}
local PlayersSellingVigneron = {}
local PlayersSellingVigneron2 = {}

-- Récupération du raisin
local function HarvestVigneron(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	SetTimeout(4000, function()
		if PlayersHarvestingVigneron[xPlayer.source] then
			if xPlayer.getInventoryItem('raisin').count >= 100 then
				xPlayer.showNotification('~r~Vous n\'avez plus de place~s~')
			else
				xPlayer.addInventoryItem('raisin', 5)
				HarvestVigneron(xPlayer.source)
			end
		end
	end)
end

RegisterNetEvent('fl_jobs:vigneron:startHarvestVigneron')
AddEventHandler('fl_jobs:vigneron:startHarvestVigneron', function()
	PlayersHarvestingVigneron[source] = true
	TriggerClientEvent('esx:showNotification', source, 'Récupération du ~b~raisin~s~...')
	HarvestVigneron(source)
end)

RegisterNetEvent('fl_jobs:vigneron:stopHarvestVigneron')
AddEventHandler('fl_jobs:vigneron:stopHarvestVigneron', function()
	PlayersHarvestingVigneron[source] = false
end)

-- Raisin en Jus de raisin
local function CraftVigneron(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	SetTimeout(4000, function()
		if PlayersCraftingVigneron[source] then
			if xPlayer.getInventoryItem('raisin').count <= 1 then
				xPlayer.showNotification('Vous n\'avez ~r~pas assez~s~ de raisin !')
			else
				xPlayer.removeInventoryItem('raisin', 2)
				xPlayer.addInventoryItem('jusraisin', 1)

				CraftVigneron(source)
			end
		end
	end)
end

RegisterNetEvent('fl_jobs:vigneron:startCraftVigneron')
AddEventHandler('fl_jobs:vigneron:startCraftVigneron', function()
	PlayersCraftingVigneron[source] = true
	TriggerClientEvent('esx:showNotification', source, '~g~Distillation~s~ en cours..')
	CraftVigneron(source)
end)

RegisterNetEvent('fl_jobs:vigneron:stopCraftVigneron')
AddEventHandler('fl_jobs:vigneron:stopCraftVigneron', function()
	PlayersCraftingVigneron[source] = false
end)

-- Raisin en vin
local function CraftVigneron2(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	SetTimeout(4000, function()
		if PlayersCraftingVigneron2[xPlayer.source] then
			if xPlayer.getInventoryItem('raisin').count < 4 then
				xPlayer.showNotification('Vous n\'avez ~r~pas assez~s~ de raisin !')
			else
				xPlayer.removeInventoryItem('raisin', 4)
				xPlayer.addInventoryItem('vin', 1)

				CraftVigneron2(xPlayer.source)
			end
		end
	end)
end

RegisterNetEvent('fl_jobs:vigneron:startCraftVigneron2')
AddEventHandler('fl_jobs:vigneron:startCraftVigneron2', function()
	PlayersCraftingVigneron2[source] = true
	TriggerClientEvent('esx:showNotification', source, '~g~Distillation~s~ en cours..')
	CraftVigneron2(source)
end)

RegisterNetEvent('fl_jobs:vigneron:stopCraftVigneron2')
AddEventHandler('fl_jobs:vigneron:stopCraftVigneron2', function()
	PlayersCraftingVigneron2[source] = false
end)

-- Vente jus de raisin
local function SellVigneron(source, zone)
	if PlayersSellingVigneron[source] then
		local xPlayer = ESX.GetPlayerFromId(source)

		if zone == 'VigneronSellFarm' then
			if xPlayer.getInventoryItem('jusraisin').count <= 0 then
				TriggerClientEvent('esx:showNotification', source, 'Vous n\'avez pas assez de jus de raisin a vendre.')
				return
			end

			SetTimeout(5000, function()
				local money = math.random(8, 12)
				xPlayer.removeInventoryItem('jusraisin', 1)
				local societyAccount

				TriggerEvent('fl_data:getSharedAccount', 'society_vigneron', function(account)
					societyAccount = account
				end)
				if societyAccount ~= nil then
					societyAccount.addMoney(money)
					xPlayer.showNotification('Votre société a gagné ~g~$' .. money)
				end
				xPlayer.addMoney(2)
				xPlayer.showNotification('Vous avez gagné ~g~2$~s~')
				SellVigneron(source, zone)
			end)
		end
	end
end

RegisterNetEvent('fl_jobs:vigneron:startSellVigneron')
AddEventHandler('fl_jobs:vigneron:startSellVigneron', function(zone)
	if not PlayersSellingVigneron[source] then return end

	PlayersSellingVigneron[source] = true
	TriggerClientEvent('esx:showNotification', source, 'Vente en cours..')
	SellVigneron(source, zone)
end)

RegisterNetEvent('fl_jobs:vigneron:stopSellVigneron')
AddEventHandler('fl_jobs:vigneron:stopSellVigneron', function()
	PlayersSellingVigneron[source] = false
	TriggerClientEvent('esx:showNotification', source, 'Vous sortez de la ~r~zone')
end)

-- Vente de vin
local function SellVigneron2(source, zone)

	if PlayersSellingVigneron2[source] then
		local xPlayer = ESX.GetPlayerFromId(source)

		if zone == 'VigneronSellFarm2' then
			if xPlayer.getInventoryItem('vin').count <= 0 then
				TriggerClientEvent('esx:showNotification', source, 'Vous n\'avez pas assez de vin a vendre.')
				return
			end

			SetTimeout(5000, function()
				local money = math.random(12, 16)
				xPlayer.removeInventoryItem('vin', 1)
				local societyAccount

				TriggerEvent('fl_data:getSharedAccount', 'society_vigneron', function(account)
					societyAccount = account
				end)
				if societyAccount ~= nil then
					societyAccount.addMoney(money)
					xPlayer.showNotification('Votre société a gagné ~g~$' .. money)
				end
				xPlayer.addMoney(4)
				xPlayer.showNotification('Vous avez gagné ~g~4$~s~')
				SellVigneron2(source, zone)
			end)
		end
	end
end

RegisterNetEvent('fl_jobs:vigneron:startSellVigneron2')
AddEventHandler('fl_jobs:vigneron:startSellVigneron2', function(zone)
	if not PlayersSellingVigneron2[source] then return	end

	PlayersSellingVigneron2[source] = true
	TriggerClientEvent('esx:showNotification', source, 'Vente en cours..')
	SellVigneron2(source, zone)

end)

RegisterNetEvent('fl_jobs:vigneron:stopSellVigneron2')
AddEventHandler('fl_jobs:vigneron:stopSellVigneron2', function()
	PlayersSellingVigneron2[source] = false
	TriggerClientEvent('esx:showNotification', source, 'Vous sortez de la ~r~zone')
end)
