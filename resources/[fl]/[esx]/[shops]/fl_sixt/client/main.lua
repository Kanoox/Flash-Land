local HasAlreadyEnteredMarker = false
local LastZone = nil
local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}
local IsInShopMenu = false
local Categories = {}
local Vehicles = {}
local LastVehicles = {}
local CurrentVehicleData = nil

Citizen.CreateThread(function()
	Citizen.Wait(15000)

	ESX.TriggerServerCallback('fl_sixt:getCategories', function (categories)
		Categories = categories
	end)

	ESX.TriggerServerCallback('fl_sixt:getVehicles', function (vehicles)
		Vehicles = vehicles
	end)

	if ESX.PlayerData.job.name == 'sixt' then
		Config.Zones.ShopEntering.Type = 1

		if ESX.PlayerData.job.grade_name == 'boss' then
			Config.Zones.BossActions.Type = 1
		end

	else
		Config.Zones.ShopEntering.Type = -1
		Config.Zones.BossActions.Type = -1
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	if xPlayer.job.name == 'sixt' then
		Config.Zones.ShopEntering.Type = 1

		if xPlayer.job.grade_name == 'boss' then
			Config.Zones.BossActions.Type = 1
		end

	else
		Config.Zones.ShopEntering.Type = -1
		Config.Zones.BossActions.Type = -1
	end
end)

RegisterNetEvent('fl_sixt:sendCategories')
AddEventHandler('fl_sixt:sendCategories', function (categories)
	Categories = categories
end)

RegisterNetEvent('fl_sixt:sendVehicles')
AddEventHandler('fl_sixt:sendVehicles', function (vehicles)
	Vehicles = vehicles
end)

function DeleteShopInsideVehicles()
	while #LastVehicles > 0 do
		local vehicle = LastVehicles[1]

		ESX.Game.DeleteVehicle(vehicle)
		table.remove(LastVehicles, 1)
	end
end

function ReturnVehicleProvider()
	ESX.TriggerServerCallback('fl_sixt:getCommercialVehicles', function (vehicles)
		local elements = {}
		local returnPrice
		for i=1, #vehicles, 1 do
			returnPrice = ESX.Math.Round(vehicles[i].price * 0.75)

			table.insert(elements, {
				label = vehicles[i].name,
				rightLabel = _U('generic_shopitem', ESX.Math.GroupDigits(returnPrice)),
				rightLabelColor = 'orange',
				value = vehicles[i].name
			})
		end

		ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'return_provider_menu', {
			title = _U('return_provider_menu'),
			elements = elements
		}, function (data, menu)
			TriggerServerEvent('fl_sixt:returnProvider', data.current.value)

			Citizen.Wait(300)
			menu.close()
			ReturnVehicleProvider()
		end, function (data, menu)
			menu.close()
		end)
	end)
end

function StartShopRestriction()
	IsInShopMenu = true
	Citizen.CreateThread(function()
		while IsInShopMenu do
			Citizen.Wait(0)

			DisableControlAction(0, 75, true) -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
		end
	end)
end

function OpenShopMenu()
	if #Categories == 0 then
		ESX.ShowNotification('Aucune catégorie de véhicule disponible à l\'achat')
		return
	end

	if #Vehicles == 0 then
		ESX.ShowNotification('Aucun véhicule disponible à l\'achat')
		return
	end

	StartShopRestriction()
	ESX.UI.Menu.CloseAll()

	local playerPed = PlayerPedId()

	FreezeEntityPosition(playerPed, true)
	SetEntityVisible(playerPed, false)
	SetEntityCoords(playerPed, Config.Zones.ShopInside.Pos.x, Config.Zones.ShopInside.Pos.y, Config.Zones.ShopInside.Pos.z)

	local vehiclesByCategory = {}
	local elements = {}
	local firstVehicleData = nil

	for i=1, #Categories, 1 do
		vehiclesByCategory[Categories[i].name] = {}
	end

	for i=1, #Vehicles, 1 do
		if IsModelInCdimage(GetHashKey(Vehicles[i].model)) then
			table.insert(vehiclesByCategory[Vehicles[i].category], Vehicles[i])
		else
			print(('fl_sixt: vehicle "%s" does not exist'):format(Vehicles[i].model))
		end
	end

	for i=1, #Categories, 1 do
		local category = Categories[i]
		local categoryVehicles = vehiclesByCategory[category.name]
		local items = {}

		for j=1, #categoryVehicles, 1 do
			local vehicle = categoryVehicles[j]

			if i == 1 and j == 1 then
				firstVehicleData = vehicle
			end

			table.insert(items, vehicle.name .. ' ' .. _U('generic_shopitem', ESX.Math.GroupDigits(vehicle.price)))
		end

		table.insert(elements, {
			name = category.name,
			label = category.label,
			type = 'list',
			items = items
		})
	end

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'vehicle_shop', {
		title = _U('car_dealer'),
		elements = elements
	}, function (data, menu)
		local vehicleData = vehiclesByCategory[data.current.name][data.current.index]

		ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'shop_confirm', {
			title = _U('buy_vehicle_shop', vehicleData.name, ESX.Math.GroupDigits(vehicleData.price)),
			elements = {
				{label = _U('no'), value = 'no'},
				{label = _U('yes'), value = 'yes'}
			}
		}, function(data2, menu2)
			if data2.current.value == 'yes' then
				ESX.TriggerServerCallback('fl_sixt:buyVehicleSociety', function(hasEnoughMoney)
					if hasEnoughMoney then
						IsInShopMenu = false

						DeleteShopInsideVehicles()

						local playerPed = PlayerPedId()

						CurrentAction = 'shop_menu'
						CurrentActionMsg = _U('shop_menu')
						CurrentActionData = {}
						InCurrentAction()

						FreezeEntityPosition(playerPed, false)
						SetEntityVisible(playerPed, true)
						SetEntityCoords(playerPed, Config.Zones.ShopEntering.Pos.x, Config.Zones.ShopEntering.Pos.y, Config.Zones.ShopEntering.Pos.z)

						menu2.close()
						menu.close()

						ESX.ShowNotification(_U('vehicle_purchased'))
					else
						ESX.ShowNotification(_U('broke_company'))
					end
				end, 'sixt', vehicleData.model)
			end
		end, function (data2, menu2)
			menu2.close()
		end)
	end, function (data, menu)
		menu.close()
		DeleteShopInsideVehicles()
		local playerPed = PlayerPedId()

		CurrentAction = 'shop_menu'
		CurrentActionMsg = _U('shop_menu')
		CurrentActionData = {}
		InCurrentAction()

		FreezeEntityPosition(playerPed, false)
		SetEntityVisible(playerPed, true)
		SetEntityCoords(playerPed, Config.Zones.ShopEntering.Pos.x, Config.Zones.ShopEntering.Pos.y, Config.Zones.ShopEntering.Pos.z)

		IsInShopMenu = false
	end, function (data, menu)
		local vehicleData = vehiclesByCategory[data.current.name][data.current.index]
		local playerPed = PlayerPedId()

		DeleteShopInsideVehicles()
		WaitForVehicleToLoad(vehicleData.model)

		ESX.Game.SpawnLocalVehicle(vehicleData.model, Config.Zones.ShopInside.Pos, Config.Zones.ShopInside.Heading, function (vehicle)
			table.insert(LastVehicles, vehicle)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			FreezeEntityPosition(vehicle, true)
			SetModelAsNoLongerNeeded(vehicleData.model)
		end)
	end)

	DeleteShopInsideVehicles()
	WaitForVehicleToLoad(firstVehicleData.model)

	ESX.Game.SpawnLocalVehicle(firstVehicleData.model, Config.Zones.ShopInside.Pos, Config.Zones.ShopInside.Heading, function (vehicle)
		table.insert(LastVehicles, vehicle)
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		FreezeEntityPosition(vehicle, true)
		SetModelAsNoLongerNeeded(firstVehicleData.model)
	end)

end

function WaitForVehicleToLoad(modelHash)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)

		BeginTextCommandBusyString('STRING')
		AddTextComponentSubstringPlayerName(_U('shop_awaiting_model'))
		EndTextCommandBusyString(4)

		while not HasModelLoaded(modelHash) do
			Citizen.Wait(1)
			DisableAllControlActions(0)
		end

		RemoveLoadingPrompt()
	end
end

function OpenResellerMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'reseller', {
		title = _U('car_dealer'),
		elements = {
			{label = _U('buy_vehicle'), value = 'buy_vehicle'},
			{label = _U('pop_vehicle'), value = 'pop_vehicle'},
			{label = _U('depop_vehicle'), value = 'depop_vehicle'},
			{label = _U('return_provider'), value = 'return_provider'},
			{label = _U('create_bill'), value = 'create_bill'},
			{label = _U('get_rented_vehicles'), value = 'get_rented_vehicles'},
			{label = _U('set_vehicle_owner_rent'), value = 'set_vehicle_owner_rent'},
			{label = _U('deposit_stock'), value = 'put_stock'},
			{label = _U('take_stock'), value = 'get_stock'}
		}
	}, function (data, menu)
		local action = data.current.value

		if action == 'buy_vehicle' then
			OpenShopMenu()
		elseif action == 'put_stock' then
			TriggerEvent('fl_society:openPutStocksMenu', 'sixt')
		elseif action == 'get_stock' then
			TriggerEvent('fl_society:openGetStocksMenu', 'sixt')
		elseif action == 'pop_vehicle' then
			OpenPopVehicleMenu()
		elseif action == 'depop_vehicle' then
			DeleteShopInsideVehicles()
		elseif action == 'return_provider' then
			ReturnVehicleProvider()
		elseif action == 'create_bill' then

			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
			if closestPlayer == -1 or closestDistance > 3.0 then
				ESX.ShowNotification(_U('no_players'))
				return
			end

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'amount', {
				title = _U('invoice_amount')
			}, function (data2, menu2)
				local amount = tonumber(data2.value)

				if amount == nil then
					ESX.ShowNotification(_U('invalid_amount'))
				else
					menu2.close()
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestPlayer == -1 or closestDistance > 3.0 then
						ESX.ShowNotification(_U('no_players'))
					else
						TriggerServerEvent('fl_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_sixt', _U('car_dealer'), tonumber(data2.value))
					end
				end
			end, function (data2, menu2)
				menu2.close()
			end)

		elseif action == 'get_rented_vehicles' then
			OpenRentedVehiclesMenu()
		elseif action == 'set_vehicle_owner_rent' then

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'set_vehicle_owner_rent_amount', {
				title = _U('rental_amount')
			}, function (data2, menu2)
				local amount = tonumber(data2.value)

				if amount == nil then
					ESX.ShowNotification(_U('invalid_amount'))
				else
					menu2.close()

					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestPlayer == -1 or closestDistance > 5.0 then
						ESX.ShowNotification(_U('no_players'))
					else
						local newPlate = GeneratePlate()
						local vehicleProps = ESX.Game.GetVehicleProperties(LastVehicles[#LastVehicles])
						local model = CurrentVehicleData.model
						vehicleProps.plate = newPlate
						SetVehicleNumberPlateText(LastVehicles[#LastVehicles], newPlate)
						TriggerServerEvent('fl_sixt:rentVehicle', model, vehicleProps.plate, CurrentVehicleData.price, amount, GetPlayerServerId(closestPlayer))

						TriggerServerEvent('fl_sixt:setVehicleOwnedPlayerId', GetPlayerServerId(closestPlayer), vehicleProps)
						TriggerServerEvent('fl_controlvehicle:registerKey', vehicleProps.plate, GetPlayerServerId(closestPlayer))

						ESX.ShowNotification(_U('vehicle_set_rented', vehicleProps.plate, GetPlayerName(closestPlayer)))
						TriggerServerEvent('fl_sixt:setVehicleForAllPlayers', vehicleProps, Config.Zones.ShopInside.Pos.x, Config.Zones.ShopInside.Pos.y, Config.Zones.ShopInside.Pos.z, 5.0)
					end
				end
			end, function (data2, menu2)
				menu2.close()
			end)
		end
	end, function (data, menu)
		menu.close()

		CurrentAction = 'reseller_menu'
		CurrentActionMsg = _U('shop_menu')
		CurrentActionData = {}
		InCurrentAction()
	end)
end

function OpenPopVehicleMenu()
	ESX.TriggerServerCallback('fl_sixt:getCommercialVehicles', function (vehicles)
		local elements = {}

		for i=1, #vehicles, 1 do
			table.insert(elements, {
				rightLabel =  '[MSRP ' .. _U('generic_shopitem', ESX.Math.GroupDigits(vehicles[i].price)) .. ']',
				rightLabelColor = 'green',
				label = vehicles[i].name,
				value = vehicles[i].name
			})
		end

		ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'commercial_vehicles', {
			title = _U('vehicle_dealer'),
			elements = elements
		}, function (data, menu)
			local model = data.current.value

			DeleteShopInsideVehicles()

			ESX.Game.SpawnVehicle(model, Config.Zones.ShopInside.Pos, Config.Zones.ShopInside.Heading, function (vehicle)
				local plate = GetVehicleNumberPlateText(vehicle)
				TriggerServerEvent('fl_controlvehicle:giveKey', plate) -- vehicle lock
				table.insert(LastVehicles, vehicle)


				for i=1, #Vehicles, 1 do
					if model == Vehicles[i].model then
						CurrentVehicleData = Vehicles[i]
						break
					end
				end
			end)
		end, function (data, menu)
			menu.close()
		end)
	end)
end

function OpenRentedVehiclesMenu()
	ESX.TriggerServerCallback('fl_sixt:getRentedVehicles', function (vehicles)
		local elements = {}

		for i=1, #vehicles, 1 do
			table.insert(elements, {
				label = vehicles[i].firstname .. ' ' .. vehicles[i].lastname .. ' : ' .. vehicles[i].name,
				value = vehicles[i].name,
				rightLabel = vehicles[i].plate,
				rightLabelColor = 'orange',
			})
		end

		ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'rented_vehicles', {
			title = _U('rent_vehicle'),
			elements = elements
		}, nil, function (data, menu)
			menu.close()
		end)
	end)
end

function OpenBossActionsMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'reseller',{
		title = _U('dealer_boss'),
		elements = {
			{label = _U('boss_actions'), value = 'boss_actions'},
	}}, function (data, menu)
		if data.current.value == 'boss_actions' then
			TriggerEvent('fl_society:openBossMenu', 'sixt', function(data2, menu2)
				menu2.close()
			end)
		end

	end, function (data, menu)
		menu.close()

		CurrentAction = 'boss_actions_menu'
		CurrentActionMsg = _U('shop_menu')
		CurrentActionData = {}
		InCurrentAction()
	end)
end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function (job)
	if ESX.PlayerData.job.name == 'sixt' then
		Config.Zones.ShopEntering.Type = 1

		if ESX.PlayerData.job.grade_name == 'boss' then
			Config.Zones.BossActions.Type = 1
		end
	else
		Config.Zones.ShopEntering.Type = -1
		Config.Zones.BossActions.Type = -1
	end
end)

AddEventHandler('fl_sixt:hasEnteredMarker', function (zone)
	if zone == 'ShopEntering' then
		if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'sixt' then
			CurrentAction = 'reseller_menu'
			CurrentActionMsg = _U('shop_menu')
			CurrentActionData = {}
			InCurrentAction()
		end
	elseif zone == 'GiveBackVehicle' and Config.EnablePlayerManagement then
		local playerPed = PlayerPedId()

		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle = GetVehiclePedIsIn(playerPed, false)

			CurrentAction = 'give_back_vehicle'
			CurrentActionMsg = _U('vehicle_menu')
			CurrentActionData = {vehicle = vehicle}
		end
	elseif zone == 'BossActions' and Config.EnablePlayerManagement and ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'sixt' and ESX.PlayerData.job.grade_name == 'boss' then
		CurrentAction = 'boss_actions_menu'
		CurrentActionMsg = _U('shop_menu')
		CurrentActionData = {}
	end
	InCurrentAction()
end)

AddEventHandler('fl_sixt:hasExitedMarker', function (zone)
	if not IsInShopMenu then
		ESX.UI.Menu.CloseAll()
	end

	CurrentAction = nil
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if IsInShopMenu then
			ESX.UI.Menu.CloseAll()

			DeleteShopInsideVehicles()
			local playerPed = PlayerPedId()

			FreezeEntityPosition(playerPed, false)
			SetEntityVisible(playerPed, true)
			SetEntityCoords(playerPed, Config.Zones.ShopEntering.Pos.x, Config.Zones.ShopEntering.Pos.y, Config.Zones.ShopEntering.Pos.z)
		end
	end
end)

-- Create Blips
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.Zones.ShopEntering.Pos.x, Config.Zones.ShopEntering.Pos.y, Config.Zones.ShopEntering.Pos.z)

	SetBlipSprite(blip, 326)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 0.7)
	SetBlipAsShortRange(blip, true)
	SetBlipColour(blip, 46)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(_U('car_dealer'))
	EndTextCommandSetBlipName(blip)
end)

-- Display markers
CreateJobLoop('sixt', function()
	local sleep = true
	local coords = GetEntityCoords(PlayerPedId())

	for k,v in pairs(Config.Zones) do
		if(v.Type ~= -1 and #(coords - vector3(v.Pos.x, v.Pos.y, v.Pos.z)) < Config.DrawDistance) then
			DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
			sleep = false
		end
	end

	if sleep then
		Citizen.Wait(500)
	end
end)

-- Enter / Exit marker events
CreateJobLoop('sixt', function()
	Citizen.Wait(200)

	local coords = GetEntityCoords(PlayerPedId())
	local isInMarker = false
	local currentZone = nil

	for k,v in pairs(Config.Zones) do
		if(#(coords - vector3(v.Pos.x, v.Pos.y, v.Pos.z)) < v.Size.x) then
			isInMarker = true
			currentZone = k
		end
	end

	if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
		HasAlreadyEnteredMarker = true
		LastZone                = currentZone
		TriggerEvent('fl_sixt:hasEnteredMarker', currentZone)
	end

	if not isInMarker and HasAlreadyEnteredMarker then
		HasAlreadyEnteredMarker = false
		TriggerEvent('fl_sixt:hasExitedMarker', LastZone)
	end

	if not isInMarker then
		Citizen.Wait(200)
	end
end)

function InCurrentAction()
	while CurrentAction ~= nil do
		Citizen.Wait(0)
		ESX.ShowHelpNotification(CurrentActionMsg)

		if IsControlJustReleased(0, 38) then
			if CurrentAction == 'shop_menu' then
				if Config.LicenseEnable then
					ESX.TriggerServerCallback('fl_license:checkLicense', function(hasDriversLicense)
						if hasDriversLicense then
							OpenShopMenu()
						else
							ESX.ShowNotification(_U('license_missing'))
						end
					end, GetPlayerServerId(PlayerId()), 'drive')
				else
					OpenShopMenu()
				end
			elseif CurrentAction == 'reseller_menu' then
				OpenResellerMenu()
			elseif CurrentAction == 'give_back_vehicle' then
				ESX.TriggerServerCallback('fl_sixt:giveBackVehicle', function(isRentedVehicle)
					if isRentedVehicle then
						ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
						ESX.ShowNotification(_U('delivered'))
					else
						ESX.ShowNotification(_U('not_rental'))
					end
				end, ESX.Math.Trim(GetVehicleNumberPlateText(CurrentActionData.vehicle)))
			elseif CurrentAction == 'boss_actions_menu' then
				OpenBossActionsMenu()
			end

			CurrentAction = nil
		end
	end
end