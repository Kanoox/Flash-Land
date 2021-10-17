PlayersHarvesting = {}
PlayersHarvesting2 = {}
PlayersHarvesting3 = {}

PlayersVenteMunition = {}
PlayersHarvestingMunition = {}
PlayersHarvestingMunition2 = {}

PlayersCrafting = {}

RegisterNetEvent('fl_ammunation:givelicence')
AddEventHandler(
	'fl_ammunation:givelicence',
	function(playerId, tier)
		local xPlayer = ESX.GetPlayerFromId(source)
		local xPlayers = ESX.GetPlayers()

		for i = 1, #xPlayers, 1 do
			local xPlayer2 = ESX.GetPlayerFromId(xPlayers[i])

			if xPlayer2.source == playerId then
				TriggerEvent('fl_license:addLicense',
					xPlayer2.source,
					'weapon',
					function()
						LoadLicenses(xPlayer2.source)
					end
				)
				TriggerClientEvent('esx:showNotification', source, "Vous avez donné un permis de port d'arme")

				break
			end
		end
	end
)

RegisterServerEvent("ruben:achat")
AddEventHandler("ruben:achat", function(item, quantity, price)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xItem = xPlayer.getInventoryItem(item)

    if xPlayer.getMoney() >= price then
        xPlayer.removeMoney(price)
        xPlayer.addInventoryItem(item, quantity)
        TriggerClientEvent("esx:showNotification", source, "Vous avez acheté ~g~"..quantity.." ~b~" ..xItem.label.. " ~w~à ~b~" ..price.. "$")
    else
        TriggerClientEvent("esx:showNotification", source, "~r~Vous n'avez pas assez d'argent")
    end
end)

function LoadLicenses(source)
	TriggerEvent('fl_license:getLicenses',
		source,
		function(licenses)
			TriggerClientEvent('fl_weashop:loadLicenses', source, licenses)
		end
	)
end

-------------- Récupération carbonne -------------
local function Harvest(source)
	SetTimeout(
		4000,
		function()
			if PlayersHarvesting[source] then
				local xPlayer = ESX.GetPlayerFromId(source)
				local CarbonQuantity = xPlayer.getInventoryItem('carbon').count

				if not xPlayer.canCarryItem('carbon', CarbonQuantity) then
					TriggerClientEvent('esx:showNotification', source, _U('you_do_not_room'))
				else
					xPlayer.addInventoryItem('carbon', 1)
					Harvest(source)
				end
			end
		end
	)
end

RegisterNetEvent('fl_ammunation:startHarvest')
AddEventHandler(
	'fl_ammunation:startHarvest',
	function()
		PlayersHarvesting[source] = true
		TriggerClientEvent('esx:showNotification', source, 'Récupération de ~b~carbone~s~...')
		Harvest(source)
	end
)

RegisterNetEvent('fl_ammunation:stopHarvest')
AddEventHandler(
	'fl_ammunation:stopHarvest',
	function()
		PlayersHarvesting[source] = false
	end
)
------------ Récupération acier --------------
local function Harvest2(source)
	SetTimeout(
		8000,
		function()
			if PlayersHarvesting2[source] then
				local xPlayer = ESX.GetPlayerFromId(source)
				local AcierQuantity = xPlayer.getInventoryItem('acier').count
				if not xPlayer.canCarryItem('acier', AcierQuantity) then
					TriggerClientEvent('esx:showNotification', source, _U('you_do_not_room'))
				else
					xPlayer.addInventoryItem('acier', 1)

					Harvest2(source)
				end
			end
		end
	)
end

RegisterNetEvent('fl_ammunation:startHarvest2')
AddEventHandler(
	'fl_ammunation:startHarvest2',
	function()
		PlayersHarvesting2[source] = true
		TriggerClientEvent('esx:showNotification', source, "Récupération d'~b~acier~s~...")
		Harvest2(source)
	end
)

RegisterNetEvent('fl_ammunation:stopHarvest2')
AddEventHandler(
	'fl_ammunation:stopHarvest2',
	function()
		PlayersHarvesting2[source] = false
	end
)

--- farm munition
-- poudre
local function HarvestMunition(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	if PlayersHarvestingMunition[xPlayer.source] then
		SetTimeout(1800, function()
			local itemQuantity = xPlayer.getInventoryItem('poudre').count
			if not xPlayer.canCarryItem('poudre', itemQuantity) then
				TriggerClientEvent('esx:showNotification', xPlayer.source, _U('not_enough_place'))
				return
			else
				xPlayer.addInventoryItem('poudre', 1)
				HarvestMunition(source)
			end
		end)
	end
end

RegisterNetEvent('fl_ammunation:startHarvestMunition')
AddEventHandler(
	'fl_ammunation:startHarvestMunition',
	function()
		if not PlayersHarvestingMunition[source] then
			TriggerClientEvent('esx:showNotification', source, "~r~Pas sur le point~w~")
			PlayersHarvestingMunition[source] = false
		else
			PlayersHarvestingMunition[source] = true
			TriggerClientEvent('esx:showNotification', source, _U('poudre_taken'))
			HarvestMunition(source)
		end
	end
)

RegisterNetEvent('fl_ammunation:stopHarvestMunition')
AddEventHandler(
	'fl_ammunation:stopHarvestMunition',
	function()
		if PlayersHarvestingMunition[source] then
			PlayersHarvestingMunition[source] = false
			TriggerClientEvent('esx:showNotification', source, 'Vous sortez de la ~r~zone')
		else
			TriggerClientEvent('esx:showNotification', source, 'Vous pouvez ~g~réceptionner')
			PlayersHarvestingMunition[source] = true
		end
	end
)

--douille
local function HarvestMunition2(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	if PlayersHarvestingMunition2[xPlayer.source] then
		SetTimeout(1800, function()
			local itemQuantity = xPlayer.getInventoryItem('douille').count
			if not xPlayer.canCarryItem('douille', itemQuantity) then
				TriggerClientEvent('esx:showNotification', xPlayer.source, _U('not_enough_place'))
				return
			else
				xPlayer.addInventoryItem('douille', 1)
				HarvestMunition2(xPlayer.source)
			end
		end)
	end
end

RegisterNetEvent('fl_ammunation:startHarvestMunition2')
AddEventHandler(
	'fl_ammunation:startHarvestMunition2',
	function()
		if not PlayersHarvestingMunition2[source] then
			TriggerClientEvent('esx:showNotification', source, "~r~Pas sur le point~w~")
			PlayersHarvestingMunition2[source] = false
		else
			PlayersHarvestingMunition2[source] = true
			TriggerClientEvent('esx:showNotification', source, _U('douille_taken'))
			HarvestMunition2(source)
		end
	end
)

RegisterNetEvent('fl_ammunation:stopHarvestMunition2')
AddEventHandler(
	'fl_ammunation:stopHarvestMunition2',
	function()
		if PlayersHarvestingMunition2[source] then
			PlayersHarvestingMunition2[source] = false
			TriggerClientEvent('esx:showNotification', source, 'Vous sortez de la ~r~zone')
		else
			TriggerClientEvent('esx:showNotification', source, 'Vous pouvez ~g~réceptionner')
			PlayersHarvestingMunition2[source] = true
		end
	end
)

-- Vente munition

local function VenteMunition(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	SetTimeout(
		1800,
		function()
			if PlayersVenteMunition[source] then
				local Quantity = xPlayer.getInventoryItem('pistol_ammo').count
				local Prix = 200

				if Quantity < 5 then
					TriggerClientEvent('esx:showNotification', _source, "~r~Vous n'avez plus de chargeur à vendre.")
					PlayersVenteMunition[_source] = false
				else
					xPlayer.removeInventoryItem('pistol_ammo', 5)
					TriggerEvent(
						'fl_data:getSharedAccount',
						'society_ammunation',
						function(societyAccount)
							societyAccount.addMoney(Prix)
							xPlayer.showNotification(_U('your_comp_earned') .. Prix)
						end
					)
					VenteMunition(_source)
				end
			end
		end
	)
end

RegisterNetEvent('fl_ammunation:startVenteMunition')
AddEventHandler(
	'fl_ammunation:startVenteMunition',
	function()
		if not PlayersVenteMunition[source] then
			TriggerClientEvent('esx:showNotification', source, '~r~Sortez et revenez dans la zone !')
			PlayersVenteMunition[source] = false
		else
			PlayersVenteMunition[source] = true
			TriggerClientEvent('esx:showNotification', source, '~g~Action ~w~en cours...')
			VenteMunition(source)
		end
	end
)

RegisterNetEvent('fl_ammunation:stopVenteMunition')
AddEventHandler(
	'fl_ammunation:stopVenteMunition',
	function()
		if PlayersVenteMunition[source] then
			PlayersVenteMunition[source] = false
		else
			PlayersVenteMunition[source] = true
		end
	end
)

-- Craft
local function Craft(source, weapon)
	local xPlayer = ESX.GetPlayerFromId(source)
	if string.match(weapon, 'ammo') then
		if xPlayer.getInventoryItem('poudre').count < 5 then
			xPlayer.showNotification("Vous n'avez ~r~pas~s~ de poudre")
			TriggerClientEvent('fl_ammunation:stopAnim', xPlayer.source)
			return
		end
		if xPlayer.getInventoryItem('douille').count < 5 then
			xPlayer.showNotification("Vous n'avez ~r~pas~s~ de douille")
			TriggerClientEvent('fl_ammunation:stopAnim', xPlayer.source)
			return
		end

		SetTimeout(15000, function()
			if not PlayersCrafting[source] then
				return
			end

			if xPlayer.getInventoryItem('poudre').count < 5 then
				xPlayer.showNotification("Vous n'avez ~r~pas~s~ de poudre")
				TriggerClientEvent('fl_ammunation:stopAnim', xPlayer.source)
				return
			end

			if xPlayer.getInventoryItem('douille').count < 5 then
				xPlayer.showNotification("Vous n'avez ~r~pas~s~ de douille")
				TriggerClientEvent('fl_ammunation:stopAnim', xPlayer.source)
				return
			end

			xPlayer.removeInventoryItem('poudre', 5)
			xPlayer.removeInventoryItem('douille', 5)
			xPlayer.addInventoryItem('pistol_ammo', 5)
		end)
	end

	if xPlayer.getInventoryItem('clip').count < 1 then
		xPlayer.showNotification("Vous n'avez ~r~pas~s~ de chargeur")
		TriggerClientEvent('fl_ammunation:stopAnim', xPlayer.source)
		return
	end

	if Config.CarbonePrice[weapon] == nil then
		xPlayer.showNotification("~r~Arme inconnue ? " .. tostring(weapon) .. ' ! Rapporter ce bug')
		return
	end

	if xPlayer.getInventoryItem('carbon').count < Config.CarbonePrice[weapon] then
		xPlayer.showNotification("Vous n'avez ~r~pas assez~s~ de carbone")
		TriggerClientEvent('fl_ammunation:stopAnim', xPlayer.source)
		return
	end

	if xPlayer.getInventoryItem('acier').count < Config.AcierPrice[weapon] then
		xPlayer.showNotification("Vous n'avez ~r~pas assez~s~ d'acier")
		TriggerClientEvent('fl_ammunation:stopAnim', xPlayer.source)
		return
	end

	SetTimeout(
		15000,
		function()
			if not PlayersCrafting[source] then
				return
			end
			local carbone = false
			local acier = false
			local prix = Config.Price[weapon]
			local clip = false
			local societymoney = false

			TriggerEvent(
				'fl_data:getSharedAccount',
				'society_ammunation',
				function(account)
					if account.money >= prix then
						societymoney = true
					else
						xPlayer.showNotification("~r~Votre société n'a pas les fonds nécéssaire pour fabriquer cette arme")
					end
				end
			)

			TriggerClientEvent('fl_ammunation:stopAnim', xPlayer.source)

			if xPlayer.getInventoryItem('clip').count < 1 then
				xPlayer.showNotification("Vous n'avez ~r~pas~s~ de chargeur")
				return
			end

			if xPlayer.getInventoryItem('carbon').count < Config.CarbonePrice[weapon] then
				xPlayer.showNotification("Vous n'avez ~r~pas assez~s~ de carbone")
				return
			end

			if xPlayer.getInventoryItem('acier').count < Config.AcierPrice[weapon] then
				xPlayer.showNotification("Vous n'avez ~r~pas assez~s~ d'acier")
				return
			end

			xPlayer.removeInventoryItem('carbon', Config.CarbonePrice[weapon])
			xPlayer.removeInventoryItem('acier', Config.AcierPrice[weapon])
			xPlayer.removeInventoryItem('clip', 1)
			xPlayer.addInventoryItem(weapon, 1)

			TriggerEvent(
				'fl_data:getSharedAccount',
				'society_ammunation',
				function(societyAccount)
					societyAccount.removeMoney(prix)
					xPlayer.showNotification(_U('achat_society') .. prix .. _U('achat_society2'))
				end
			)
		end
	)
end

RegisterNetEvent('fl_ammunation:startCraft')
AddEventHandler(
	'fl_ammunation:startCraft',
	function(weapon)
		PlayersCrafting[source] = true
		TriggerClientEvent('esx:showNotification', source, "Assemblage ...")
		Craft(source, weapon)
	end
)

RegisterNetEvent('fl_ammunation:stopCraft')
AddEventHandler(
	'fl_ammunation:stopCraft',
	function()
		PlayersCrafting[source] = false
	end
)
