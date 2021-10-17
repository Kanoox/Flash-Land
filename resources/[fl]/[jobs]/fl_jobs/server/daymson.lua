local PlayersHarvestingDaymson = {}
local PlayersCraftingDaymson = {}
local PlayersSellingDaymson = {}

local function HarvestDaymson(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	SetTimeout(4000, function()
		if PlayersHarvestingDaymson[xPlayer.source] then
			if xPlayer.getInventoryItem('cdvierge').count >= 50 then
				xPlayer.showNotification('~r~Vous n\'avez plus de place~s~')
			else
				xPlayer.addInventoryItem('cdvierge', 5)
				HarvestDaymson(xPlayer.source)
			end
		end
	end)
end

RegisterNetEvent('fl_jobs:daymson:startHarvestDaymson')
AddEventHandler('fl_jobs:daymson:startHarvestDaymson', function()
	if PlayersHarvestingDaymson[source] then return end
	PlayersHarvestingDaymson[source] = true
	TriggerClientEvent('esx:showNotification', source, 'Récupération des ~b~cd vierge~s~...')
	HarvestDaymson(source)
end)

RegisterNetEvent('fl_jobs:daymson:stopHarvestDaymson')
AddEventHandler('fl_jobs:daymson:stopHarvestDaymson', function()
	PlayersHarvestingDaymson[source] = false
end)

-- Gravure CD
local function CraftDaymson(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	SetTimeout(4000, function()
		if PlayersCraftingDaymson[xPlayer.source] then
			if xPlayer.getInventoryItem('cdvierge').count <= 0 then
				xPlayer.showNotification('Vous n\'avez ~r~pas assez~s~ de cd vierge !')
			else
				xPlayer.removeInventoryItem('cdvierge', 5)
				xPlayer.addInventoryItem('cddaym', 5)

				CraftDaymson(xPlayer.source)
			end
		end
	end)
end

RegisterNetEvent('fl_jobs:daymson:startCraftDaymson')
AddEventHandler('fl_jobs:daymson:startCraftDaymson', function()
	if PlayersCraftingDaymson[source] then return end
	PlayersCraftingDaymson[source] = true
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.showNotification('Gravure en ~g~cours~s~...')
	CraftDaymson(xPlayer.source)
end)

RegisterNetEvent('fl_jobs:daymson:stopCraftDaymson')
AddEventHandler('fl_jobs:daymson:stopCraftDaymson', function()
	PlayersCraftingDaymson[source] = false
end)

local function SellDaymson(source, zone)
	if not PlayersSellingDaymson[source] then return end
	local xPlayer = ESX.GetPlayerFromId(source)

	if zone == 'DaymsonSellFarm' then
		if xPlayer.getInventoryItem('cddaym').count <= 5 then
			xPlayer.showNotification('Vous n\'avez pas assez de CD à vendre')
			return
		end

		SetTimeout(4000, function()
			local money = math.random(15, 23)
			xPlayer.removeInventoryItem('cddaym', 5)

			TriggerEvent('fl_data:getSharedAccount', 'society_daymson', function(societyAccount)
				societyAccount.addMoney(money)
				xPlayer.showNotification('Votre société a gagné ~g~$' .. money)
			end)

			SellDaymson(source, zone)
		end)
	end
end

RegisterNetEvent('fl_jobs:daymson:startSellDaymson')
AddEventHandler('fl_jobs:daymson:startSellDaymson', function(zone)
	if PlayersSellingDaymson[source] then return end
	PlayersSellingDaymson[source] = true
	TriggerClientEvent('esx:showNotification', source, 'Vente en cours..')
	SellDaymson(source, zone)
end)

RegisterNetEvent('fl_jobs:daymson:stopSellDaymson')
AddEventHandler('fl_jobs:daymson:stopSellDaymson', function()
	PlayersSellingDaymson[source] = false
	TriggerClientEvent('esx:showNotification', source, 'Vous sortez de la ~r~zone')
end)
