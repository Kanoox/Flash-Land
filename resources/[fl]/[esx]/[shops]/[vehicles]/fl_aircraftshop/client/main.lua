local HasAlreadyEnteredMarker = false
local LastZone = nil
local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}
local PositionBeforeShopMenu = nil
local Categories = {}
local Vehicles = {}
local LastVehicles = {}
local CurrentVehicleData = nil

Citizen.CreateThread(function()
	Citizen.Wait(10000)

	ESX.TriggerServerCallback('fl_aircraftshop:getCategories', function(categories)
		Categories = categories
	end)

	ESX.TriggerServerCallback('fl_aircraftshop:getVehicles', function(vehicles)
		Vehicles = vehicles
	end)
end)

RegisterNetEvent('fl_aircraftshop:sendCategories')
AddEventHandler('fl_aircraftshop:sendCategories', function(categories)
	Categories = categories
end)

RegisterNetEvent('fl_aircraftshop:sendVehicles')
AddEventHandler('fl_aircraftshop:sendVehicles', function(vehicles)
	Vehicles = vehicles
end)

function DeleteShopInsideVehicles()
	while #LastVehicles > 0 do
		local vehicle = LastVehicles[1]
		ESX.Game.DeleteVehicle(vehicle)
		table.remove(LastVehicles, 1)
	end
end

function StartShopRestriction()
	Citizen.CreateThread(function()
		while PositionBeforeShopMenu do
			Citizen.Wait(1)
			DisableControlAction(0, 75,  true) -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
		end
	end)
end

-- Open Buy License Menu
function OpenBuyLicenseMenu(zone)
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'shop_license', {
		title = _U('aircraft_dealer'),
		description = _U('buy_license'),
		elements = {
			{ label = _U('no'), value = 'no' },
			{
				label = _U('yes'),
				value = 'yes',
				rightLabel = _U('generic_shopitem', ESX.Math.GroupDigits(Config.LicensePrice)),
				rightLabelColor = 'green',
			},
		}
	}, function(data, menu)
		if data.current.value == 'yes' then
			ESX.TriggerServerCallback('fl_aircraftshop:buyLicense', function(bought)
				if bought then
					menu.close()
					OpenShopMenu()
				end
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

-- Open Shop Menu
function OpenShopMenu()
	local playerPed = PlayerPedId()
	PositionBeforeShopMenu = GetEntityCoords(playerPed)

	StartShopRestriction()
	ESX.UI.Menu.CloseAll()

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
			print(('fl_aircraftshop: vehicle "%s" does not exist'):format(Vehicles[i].model))
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

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'vehicle_shop',
	{
		title = _U('aircraft_dealer'),
		elements = elements
	}, function(data, menu)
		local vehicleData = vehiclesByCategory[data.current.name][data.current.index]

		ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'shop_confirm', {
			title = _U('aircraft_dealer'),
			description = _U('buy_aircraft_shop', vehicleData.name, ESX.Math.GroupDigits(vehicleData.price)),
			elements = {
				{label = _U('no'), value = 'no'},
				{label = _U('yes'), value = 'yes'}
			}
		}, function(data2, menu2)
			if data2.current.value == 'yes' then
				ESX.TriggerServerCallback('fl_aircraftshop:buyVehicle', function(hasEnoughMoney)
					if hasEnoughMoney then
						PositionBeforeShopMenu = nil

						menu2.close()
						menu.close()

						DeleteShopInsideVehicles()

						Citizen.Wait(10)

						ESX.Game.SpawnVehicle(vehicleData.model, Config.Zones.ShopOutside.Pos, Config.Zones.ShopOutside.Heading, function(vehicle)
							TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

							local newPlate = GeneratePlate()
							local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
							vehicleProps.plate = newPlate
							SetVehicleNumberPlateText(vehicle, newPlate)

							TriggerServerEvent('fl_controlvehicle:registerKey', vehicleProps.plate, GetPlayerServerId(PlayerId()))
							TriggerServerEvent('fl_aircraftshop:setVehicleOwned', vehicleProps)

							ESX.ShowNotification(_U('aircraft_purchased'))
						end)

						FreezeEntityPosition(playerPed, false)
						SetEntityVisible(playerPed, true)
					else
						ESX.ShowNotification(_U('not_enough_money'))
					end
				end, vehicleData.model)
			else
				menu2.close()
			end

		end, function(data2, menu2)
			menu2.close()
		end)
	end, function(data, menu)
		menu.close()

		DeleteShopInsideVehicles()

		local playerPed = PlayerPedId()

		CurrentAction = 'shop_menu'
		CurrentActionMsg = _U('shop_menu')
		CurrentActionData = {}

		FreezeEntityPosition(playerPed, false)
		SetEntityVisible(playerPed, true)
		SetEntityCoords(playerPed, PositionBeforeShopMenu)

		PositionBeforeShopMenu = nil
	end, function(data, menu)
		local vehicleData = vehiclesByCategory[data.current.name][data.current.index]
		local playerPed = PlayerPedId()

		DeleteShopInsideVehicles()
		WaitForVehicleToLoad(vehicleData.model)

		ESX.Game.SpawnLocalVehicle(vehicleData.model, Config.Zones.ShopInside.Pos, Config.Zones.ShopInside.Heading, function(vehicle)
			table.insert(LastVehicles, vehicle)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			FreezeEntityPosition(vehicle, true)
		end)
	end)

	DeleteShopInsideVehicles()

	if not firstVehicleData then
		error('firstVehicleData is nil')
		return
	end

	WaitForVehicleToLoad(firstVehicleData.model)

	ESX.Game.SpawnLocalVehicle(firstVehicleData.model, Config.Zones.ShopInside.Pos, Config.Zones.ShopInside.Heading, function(vehicle)
		table.insert(LastVehicles, vehicle)
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		FreezeEntityPosition(vehicle, true)
	end)
end

function WaitForVehicleToLoad(modelHash)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)

		while not HasModelLoaded(modelHash) do
			Citizen.Wait(1)

			DisableControlAction(0, 27, true)
			DisableControlAction(0, 173, true)
			DisableControlAction(0, 174, true)
			DisableControlAction(0, 175, true)
			DisableControlAction(0, 176, true) -- ENTER key
			DisableControlAction(0, 177, true)

			drawLoadingText(_U('shop_awaiting_model'), 255, 255, 255, 255)
		end
	end
end

-- Entered Marker
AddEventHandler('fl_aircraftshop:hasEnteredMarker', function(zone)
	if zone == 'ShopEntering' then
		CurrentAction = 'shop_menu'
		CurrentActionMsg = _U('shop_menu')
		CurrentActionData = {}
	elseif zone == 'ResellVehicle' then
		local playerPed = PlayerPedId()

		if IsPedSittingInAnyVehicle(playerPed) then
			local vehicle = GetVehiclePedIsIn(playerPed, false)
			local vehicleData, model, resellPrice, plate

			if GetPedInVehicleSeat(vehicle, -1) == playerPed then
				for i=1, #Vehicles, 1 do
					if GetHashKey(Vehicles[i].model) == GetEntityModel(vehicle) then
						vehicleData = Vehicles[i]
						break
					end
				end

				resellPrice = ESX.Math.Round(vehicleData.price / 100 * Config.ResellPercentage)
				model = GetEntityModel(vehicle)
				plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))

				CurrentAction = 'resell_vehicle'
				CurrentActionMsg = _U('sell_menu', vehicleData.name, ESX.Math.GroupDigits(resellPrice))

				CurrentActionData = {
					vehicle = vehicle,
					label = vehicleData.name,
					price = resellPrice,
					model = model,
					plate = plate
				}
			end
		end
	end
end)

-- Exited Marker
AddEventHandler('fl_aircraftshop:hasExitedMarker', function(zone)
	if not PositionBeforeShopMenu then
		ESX.UI.Menu.CloseAll()
	end

	CurrentAction = nil
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if PositionBeforeShopMenu then
			ESX.UI.Menu.CloseAll()

			DeleteShopInsideVehicles()

			local playerPed = PlayerPedId()

			FreezeEntityPosition(playerPed, false)
			SetEntityVisible(playerPed, true)
			SetEntityCoords(playerPed, PositionBeforeShopMenu)
		end
	end
end)

-- Create Blips
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.Zones.ShopEntering.Pos.x, Config.Zones.ShopEntering.Pos.y, Config.Zones.ShopEntering.Pos.z)

	SetBlipSprite(blip, 90)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 0.7)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(_U('aircraft_dealer'))
	EndTextCommandSetBlipName(blip)
end)

-- Draw Markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local coords = GetEntityCoords(PlayerPedId())
		local canSleep = true

		for k,v in pairs(Config.Zones) do
			if(v.Type ~= -1 and #(coords - vector3(v.Pos.x, v.Pos.y, v.Pos.z)) < Config.DrawDistance) then
				canSleep = false
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
			end
		end

		if canSleep then
			Citizen.Wait(500)
		end
	end
end)

-- Activate Menu when in Markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

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
			LastZone = currentZone
			TriggerEvent('fl_aircraftshop:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('fl_aircraftshop:hasExitedMarker', LastZone)
		end

		if not isInMarker then
			Citizen.Wait(500)
		end
	end
end)

-- Key controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)

		if CurrentAction == nil then
			Citizen.Wait(500)
		else
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) then
				if CurrentAction == 'shop_menu' then
					if Config.LicenseEnable then
						ESX.TriggerServerCallback('fl_license:checkLicense', function(hasAircraftLicense)
							if hasAircraftLicense then
								OpenShopMenu()
							else
								OpenBuyLicenseMenu()
							end
						end, GetPlayerServerId(PlayerId()), 'aircraft')
					else
						OpenShopMenu()
					end
				elseif CurrentAction == 'resell_vehicle' then
					ESX.TriggerServerCallback('fl_aircraftshop:resellVehicle', function(vehicleSold)
						if vehicleSold then
							ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
							ESX.ShowNotification(_U('aircraft_sold_for', CurrentActionData.label, ESX.Math.GroupDigits(CurrentActionData.price)))
						else
							ESX.ShowNotification(_U('not_yours'))
						end
					end, CurrentActionData.plate, CurrentActionData.model)
				end
				CurrentAction = nil
			end
		end
	end
end)

function drawLoadingText(text, red, green, blue, alpha)
	SetTextFont(4)
	SetTextProportional(0)
	SetTextScale(0.0, 0.5)
	SetTextColour(red, green, blue, alpha)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)

	BeginTextCommandDisplayText("STRING")
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(0.5, 0.5)
end