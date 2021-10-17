BikerCounterfeit = exports['bob74_ipl']:GetBikerCounterfeitObject()

local InOpenMachine = 0
local CurrentData = nil
local restingDays = 0

AddEventHandler('onResourceStop', function(resourceName)
	if GetCurrentResourceName() ~= resourceName then return	end
	if CurrentData == nil then return end
	TriggerEvent('instance:leave')
end)

RegisterCommand('debug_washmoney', function() print(ESX.Dump(CurrentData)) end, true)

function RefreshWarehouse()
	for i=1, 4, 1 do
		BikerCounterfeit['Dryer' .. i].Set(BikerCounterfeit['Dryer' .. i].none)
	end

	if CurrentData then
		local TmpWashing = CurrentData.CurrentlyWashing
		for i=1, CurrentData.NumberMachines, 1 do
			local state = 'off'
			if TmpWashing > 0 then
				TmpWashing = TmpWashing - Config.WashingMachine
				state = 'on'
			elseif InOpenMachine == i then
				state = 'open'
			end
			BikerCounterfeit['Dryer' .. i].Set(BikerCounterfeit['Dryer' .. i][state])
		end
	end
	RefreshInterior(BikerCounterfeit.interiorId)
end

Citizen.CreateThread(function()
	ESX.TriggerServerCallback('fl_washmoney:getRestingDays', function(_restingDays)
		restingDays = _restingDays
	end)

	RefreshWarehouse()

	while true do
		Citizen.Wait(2)
		local sleep = true
		local helpNotification = nil

		local playerCoord = GetEntityCoords(PlayerPedId())

		for Job, WasherSociety in pairs(Config.Washers) do
			local WasherDistance = #(playerCoord - WasherSociety.entrance)
			if WasherDistance < 20.0 then
				sleep = false
				if WasherDistance < 1.0 then
					helpNotification = '~INPUT_CONTEXT~ pour entrer'
					if IsControlJustPressed(1, 38) then
						local _Job = Job
						ESX.TriggerServerCallback('fl_washmoney:getWasherData', function(WasherData)
							CurrentData = WasherData
							TriggerEvent('instance:createSpecialInstance', 'washmoney', {special = 'washmoney_'.._Job, WashSocietyData = WasherData})
						end, Job)
						Citizen.Wait(1000)
					end
				end
			end
		end

		local inMapping = #(Config.Manage - playerCoord) < 20.0

		if inMapping and CurrentData ~= nil then
			sleep = false
			DrawMarker(29, Config.Manage, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 30, 30, 150, 125, 0, 0, 2, 1)

			if #(Config.Manage - playerCoord) < 1.0 then
				helpNotification = '~INPUT_CONTEXT~ pour gérer le blanchiment'
				if IsControlJustPressed(1, 38) then
					OpenManageMenu()
				end
			end

			DrawMarker(23, Config.Exit - vector3(0, 0, 0.95), 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 255, 255, 200, 0, 0, 2, 1)

			if #(Config.Exit - playerCoord) < 1.0 then
				helpNotification = '~INPUT_CONTEXT~ pour sortir du bâtiment'
				if IsControlJustPressed(1, 38) then
					if CurrentData then
						TriggerEvent('instance:leave')
					end
				end
			end

			for machineIndex, MachineCoord in pairs(Config.Machines) do
				if CurrentData and machineIndex <= CurrentData.NumberMachines then
					DrawMarker(29, MachineCoord, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 30, 150, 30, 125, 0, 0, 2, 1)
					if #(MachineCoord - playerCoord) < 1.0 then
						helpNotification = '~INPUT_CONTEXT~ pour accéder à la machine à laver'
						if IsControlJustPressed(1, 38) then
							OpenMachineMenu(machineIndex)
						end
					end
				end
			end
		end

		if helpNotification then
			if not ESX.UI.Menu.IsOpenNamespace(GetCurrentResourceName()) then
				ESX.ShowHelpNotification(helpNotification)
			end
		else
			ESX.UI.Menu.CloseNamespace(GetCurrentResourceName())
		end

		if sleep then
			Citizen.Wait(500)
		end
	end
end)

function OpenManageMenu()
	if ESX.PlayerData.job.name ~= CurrentData.Society then
		ESX.ShowNotification('~r~L\'ordinateur semble sécurisé pour cette entreprise... (' .. tostring(CurrentData.Society) .. ')')
		return
	end

	local elements = {
		{label = 'Location de machine à laver', action = 'info'},
		{label = 'Jours restants : ' .. ESX.Math.Round(restingDays) .. ' jours', action = 'info'},
		{label = '_______________', action = 'info'},
	}

	for i=1, CurrentData.NumberMachines, 1 do
		table.insert(elements, {label = 'Machine louée', rightLabel = '✅', action = 'rentedMachine', machineIndex = i})
	end

	for i=CurrentData.NumberMachines, 3, 1 do
		table.insert(elements, {
			label = 'Louer une machine',
			rightLabel = ESX.Math.GroupDigits(ESX.Math.Round(Config.RentWashPrice * restingDays)) .. '$',
			action = 'rentMachine',
			machineIndex = i
		})
	end

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'manage_menu', {
		title = 'Gestion du blanchiment',
		elements = elements
	}, function(data, menu)
		if data.current.action == 'rentMachine' then
			TriggerServerEvent('fl_washmoney:rentMachine', CurrentData.Society)
		elseif data.current.action == 'rentedMachine' then
		elseif data.current.action == 'info' then
		end

		menu.close()
	end, function(data, menu)
		PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)
		menu.close()
	end, function(data, menu)
		PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', false)
	end)
end

function OpenMachineMenu(machineIndex)
	local washing = CurrentData.CurrentlyWashing >= (Config.WashingMachine * machineIndex)
	local washed = CurrentData.AlreadyWashed >= (Config.WashingMachine * machineIndex)

	local rightLabel = '$' .. ESX.Math.GroupDigits(ESX.Math.Round(Config.WashingMachine))
	local text = 'Laver ?'
	if washing then
		text = 'Lavage en cours...'
		rightLabel = '⏳'
	elseif washed then
		text = 'Lavage terminé...'
		rightLabel = '✅'
	end

	local elements = {{
			label = text,
			rightLabel = rightLabel,
			machineIndex = i
		}}

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'manage_menu', {
		title = 'Machine N°' .. machineIndex,
		elements = elements
	}, function(data, menu)

		if washing then
			ESX.ShowNotification('~y~Lavage déjà en cours... ⏳')
		elseif washed then
			ESX.ShowNotification('~g~Vous ramassez l\'argent lavé')
			TriggerServerEvent('fl_washmoney:getMoneyWashed', CurrentData.Society)
		else
			if GetBlackMoney() >= Config.WashingMachine then
				TriggerServerEvent('fl_washmoney:putMoneyInWashing', CurrentData.Society)
			else
				ESX.ShowNotification('~r~Vous n\'avez pas assez d\'argent sale (Minimum $' .. ESX.Math.GroupDigits(ESX.Math.Round(Config.WashingMachine)) .. ')')
			end
		end

		menu.close()
	end, function(data, menu)
		PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)
		menu.close()
	end, function(data, menu)
		PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', false)
	end)
end

function GetBlackMoney()
	local xPlayer = ESX.GetPlayerData()
	for _, account in pairs(xPlayer.accounts) do
		if account.name == 'black_money' then
			return account.money
		end
	end

	return -1
end

RegisterNetEvent('fl_washmoney:updateCurrentData')
AddEventHandler('fl_washmoney:updateCurrentData', function(Society)
	ESX.TriggerServerCallback('fl_washmoney:getWasherData', function(WasherData)
		CurrentData = WasherData
		RefreshWarehouse()
	end, Society)
end)

AddEventHandler('instance:loaded', function()
	TriggerEvent('instance:registerType', 'washmoney',
	function(instance)
		print(ESX.Dump(instance))
		ESX.Game.Teleport(PlayerPedId(), Config.Exit)
		RefreshWarehouse()
	end, function(instance)
		ESX.Game.Teleport(PlayerPedId(), Config.Washers[CurrentData.Society].entrance)
		CurrentData = nil
	end)
end)
TriggerEvent('instance:isLoaded')

RegisterNetEvent('instance:onCreate')
AddEventHandler('instance:onCreate', function(instance)
	if not instance then error('instance:onCreate return nil instance') end
	if instance.type == 'washmoney' then
		TriggerEvent('instance:enter', instance)
	end
end)