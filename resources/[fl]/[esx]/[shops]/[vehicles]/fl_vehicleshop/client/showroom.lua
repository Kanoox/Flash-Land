local CatalogCurrentAction = nil
local CatalogCurrentActionMsg = ''

local Categories = {}
local Vehicles = {}
local LastVehicles = {}

local CatalogShopInside = vector4(-75.60, -821.0, 284.39, 284.39)
local CataloguePos = vector3(-50.38, -1089.53, 26.42-1)

Citizen.CreateThread(function()
	ESX.TriggerServerCallback('fl_vehicleshop:getCategories', function (categories)
		Categories = categories
	end)

	ESX.TriggerServerCallback('fl_vehicleshop:getVehicles', function (vehicles)
		Vehicles = vehicles
	end)
end)

function DeleteCatalogueVehicles()
	while #LastVehicles > 0 do
		local vehicle = LastVehicles[1]
		ESX.Game.DeleteVehicle(vehicle)
		table.remove(LastVehicles, 1)
	end
end

function OpenCatalogueMenu()
	ESX.UI.Menu.CloseAll()

	local playerPed = PlayerPedId()

	FreezeEntityPosition(playerPed, true)
	SetEntityVisible(playerPed, false)
	SetEntityCoords(playerPed, CatalogShopInside)

	local vehiclesByCategory = {}
	local elements           = {}
	local firstVehicleData   = nil

	for i=1, #Categories, 1 do
		vehiclesByCategory[Categories[i].name] = {}
	end

	for i=1, #Vehicles, 1 do
		table.insert(vehiclesByCategory[Vehicles[i].category], Vehicles[i])
	end

	for i=1, #Categories, 1 do
		local category = Categories[i]
		local categoryVehicles = vehiclesByCategory[category.name]
		local vehicleNames = {}

		for j=1, #categoryVehicles, 1 do
			local vehicle = categoryVehicles[j]

			if i == 1 and j == 1 then
				firstVehicleData = vehicle
			end

			table.insert(vehicleNames, vehicle.name)
		end

		table.insert(elements, {
			name = category.name,
			label = category.label,
			type = 'list',
			items = vehicleNames,
		})
	end

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'vehicle_shop_catalogue', {
		title    = 'Catalogue',
		elements = elements,
	}, function (data, menu)
		local vehicleData = vehiclesByCategory[data.current.name][data.current.index]
		ESX.ShowNotification('~r~Contactez le vendeur ...')
	end, function (data, menu)
		menu.close()
		DeleteCatalogueVehicles()

		FreezeEntityPosition(playerPed, false)

		SetEntityCoords(playerPed, CataloguePos)
		SetEntityVisible(playerPed, true)
	end, function (data, menu)
		local vehicleData = vehiclesByCategory[data.current.name][data.current.index]

		DeleteCatalogueVehicles()
		ESX.Game.SpawnLocalVehicle(vehicleData.model, {
			x = CatalogShopInside.x,
			y = CatalogShopInside.y,
			z = CatalogShopInside.z
		}, CatalogShopInside.w, function(vehicle)
			table.insert(LastVehicles, vehicle)
			SetVehicleEngineOn(vehicle, false, true, true)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			FreezeEntityPosition(vehicle, true)
		end)
	end)

	DeleteCatalogueVehicles()
	ESX.Game.SpawnLocalVehicle(firstVehicleData.model, {
		x = CatalogShopInside.x,
		y = CatalogShopInside.y,
		z = CatalogShopInside.z
	}, CatalogShopInside.w, function (vehicle)
		table.insert(LastVehicles, vehicle)
		SetVehicleEngineOn(vehicle, false, true, true)
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		FreezeEntityPosition(vehicle, true)
	end)
end
Citizen.CreateThread(function()
	while true do
		Wait(0)

		local sleep = true
		local coords = GetEntityCoords(PlayerPedId())

		CatalogCurrentAction = nil
		CatalogCurrentActionMsg = nil

		local distance = #(coords - CataloguePos)
		if distance < 50.0 then
			DrawMarker(27, CataloguePos, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 255, 255, 255, 255, false, false, 2, false, false, false, false)
			sleep = false

			if distance < 1.5 then
				CatalogCurrentAction = 'cars_menu'
				CatalogCurrentActionMsg = 'Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le Catalogue'
			end
		end

		if CatalogCurrentAction ~= nil then
			if not ESX.UI.Menu.IsOpenNamespace(GetCurrentResourceName()) and CatalogCurrentActionMsg ~= nil then
				ESX.ShowHelpNotification(CatalogCurrentActionMsg)
			end

			if IsControlJustPressed(0, 38) then
				if CatalogCurrentAction == 'cars_menu' then
					OpenCatalogueMenu()
				end

				CatalogCurrentAction = nil
			end
		end

		if sleep then
			Citizen.Wait(1000)
		end
	end
end)