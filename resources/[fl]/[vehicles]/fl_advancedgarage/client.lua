local AllBlips = {}
local HasAlreadyEnteredMarker = false
local LastZone = nil
local CurrentAction = nil
local CurrentActionMsg = ''
local userProperties = {}
local this_Garage = {}
local TableHas = function (tab, val)
	for index, value in ipairs(tab) do
		if value == val then
			return true
		end
	end

	return false
end

Citizen.CreateThread(function()
	RefreshBlips()
	PlayerLoadedOwnedProperties(ESX.GetPlayerData())
end)

RegisterNetEvent('fl_property:ownedPropertyChanged')
AddEventHandler('fl_property:ownedPropertyChanged', function(OwnedProperties)
	Citizen.Wait(2000)
	PlayerLoadedOwnedProperties(ESX.GetPlayerData())
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerLoadedOwnedProperties(ESX.GetPlayerData())
	RefreshBlips()
end)

RegisterNetEvent('esx:setFaction')
AddEventHandler('esx:setFaction', function(faction)
	PlayerLoadedOwnedProperties(ESX.GetPlayerData())
	RefreshBlips()
end)

AddEventHandler('fl_advancedgarage:openMenuGarage', function(PointType)
	OpenMenuGarage(PointType)
end)

function PlayerLoadedOwnedProperties(xPlayer)
	userProperties = {}
end

function OpenMenuGarage(PointType)
	ESX.UI.Menu.CloseAll()

	local elements = {}

	if PointType == 'car_garage_point' then
		ListOwnedMenu('car')
	elseif PointType == 'boat_garage_point' then
		ListOwnedMenu('boat')
	elseif PointType == 'aircraft_garage_point' then
		ListOwnedMenu('aircraft')
	elseif PointType == 'car_store_point' then
		StoreOwnedMenu('car')
	elseif PointType == 'boat_store_point' then
		StoreOwnedMenu('boat')
	elseif PointType == 'aircraft_store_point' then
		StoreOwnedMenu('aircraft')
	elseif PointType == 'car_pound_point' then
		ReturnOwnedMenu('car')
	elseif PointType == 'boat_pound_point' then
		ReturnOwnedMenu('boat')
	elseif PointType == 'aircraft_pound_point' then
		ReturnOwnedMenu('aircraft')
	end
end

function ListOwnedMenu(type)
	local elements = {}

	ESX.TriggerServerCallback('fl_advancedgarage:getOwned', function(owned)
		if #owned == 0 then
			ESX.ShowNotification('Vous ne possédez aucun véhicule !')
			return
		end

		for _,vehicleData in pairs(owned) do
			local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(vehicleData.vehicle.model))
			if vehicleName == nil or vehicleName == 'NULL' then
				vehicleName = vehicleData.vehicle.model
			end
			local plate = vehicleData.plate
			local labelvehicle

			if vehicleData.stored then
				labelvehicle = '| '..plate..' | '..vehicleName..' | Entrée |'
			else
				labelvehicle = '| '..plate..' | '..vehicleName..' | Fourrière |'
			end

			table.insert(elements, {label = labelvehicle, vehicleData = vehicleData})
		end

		ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'spawn_owned_' .. type, {
			title = 'Garage ' .. _U(type),
			elements = elements
		}, function(data, menu)
			if data.current.vehicleData.stored then
				menu.close()
				SpawnVehicle(data.current.vehicleData.vehicle)
			else
				ESX.ShowNotification('Votre véhicule est à la fourrière.')
			end
		end, function(data, menu)
			menu.close()
		end)
	end, type)
end

function StoreOwnedMenu(type)
	local playerPed  = PlayerPedId()
	if IsPedInAnyVehicle(playerPed,  false) then
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)

		ESX.TriggerServerCallback('fl_advancedgarage:storeVehicle', function(valid)
			if valid then
				ESX.Game.DeleteVehicle(vehicle)
				ESX.ShowNotification('Votre véhicule est stocké dans le garage.')
			else
				ESX.ShowNotification('Vous ne pouvez pas stocker ce véhicule !')
			end
		end, vehicleProps)
	else
		ESX.ShowNotification('Il n\'y a pas de véhicule à stocker dans le garage.')
	end
end

function ReturnOwnedMenu(type)
	ESX.TriggerServerCallback('fl_advancedgarage:getOutOwned', function(owned)
		local elements = {}

		for _,vehicleProps in pairs(owned) do
			local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(vehicleProps.model))
			if vehicleName == nil or vehicleName == 'NULL' then
				vehicleName = vehicleProps.model
			end

			table.insert(elements, {
				label = '| '..vehicleProps.plate..' | '..vehicleName..' | '.._U('return')..' | $'..tostring(Config.PoundPrice[type]),
				vehicleProps = vehicleProps
			})
		end

		ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'return_owned_' .. type, {
			title = _U('pound') .. _U(type) .. ' | $' .. Config.PoundPrice[type],
			elements = elements
		}, function(data, menu)
			ESX.TriggerServerCallback('fl_advancedgarage:checkMoney', function(hasEnoughMoney)
				if hasEnoughMoney then
					TriggerServerEvent('fl_advancedgarage:pay', type)
					SpawnVehicle(data.current.vehicleProps)
				else
					ESX.ShowNotification('Vous n\'avez pas assez d\'argent !')
				end
			end, type)
		end, function(data, menu)
			menu.close()
		end)
	end, type)
end

function SpawnVehicle(vehicleProps)
	ESX.Dump(vehicleProps)
	ESX.Game.SpawnVehicle(vehicleProps.model, {
		x = this_Garage.SpawnPoint.x,
		y = this_Garage.SpawnPoint.y,
		z = this_Garage.SpawnPoint.z + 1.0,
	}, this_Garage.SpawnPoint.w, function(vehicle)
		ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
		PlaceObjectOnGroundProperly(vehicle)
		TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
		SetVehicleEngineOn(vehicle, true, true)
		if vehicleProps.engineHealth and vehicleProps.engineHealth <= 150 then
			ESX.ShowNotification('~r~Votre véhicule est endommagé...')
		end
	end)

	TriggerServerEvent('fl_advancedgarage:setVehicleState', vehicleProps.plate)
end

AddEventHandler('fl_advancedgarage:hasEnteredMarker', function(zone)
	CurrentAction = zone
	if string.find(zone, 'pound') then
		CurrentActionMsg = 'Appuyez sur ~INPUT_PICKUP~ accèder à la fourrière'
	elseif string.find(zone, 'garage') then
		CurrentActionMsg = 'Appuyez sur ~INPUT_PICKUP~ accèder au garage'
	elseif string.find(zone, 'store') then
		CurrentActionMsg = 'Appuyez sur ~INPUT_PICKUP~ stocker le véhicule dans le garage'
	end
end)

AddEventHandler('fl_advancedgarage:hasExitedMarker', function()
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
	CurrentActionMsg = nil
end)

function GetMarkerTypeFromTypeText(type)
	if type == 'car' then
		return 36
	elseif type == 'boat' then
		return 35
	elseif type == 'aircraft' then
		return 33
	else
		return 36
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local canSleep = true

		for k,v in pairs(Config.Garages) do
			if #(coords - v.GaragePoint) < Config.DrawDistance then
				canSleep = false
				DrawMarker(GetMarkerTypeFromTypeText(v.Type), v.GaragePoint.x, v.GaragePoint.y, v.GaragePoint.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.PointMarker.x, Config.PointMarker.y, Config.PointMarker.z, Config.PointMarker.r, Config.PointMarker.g, Config.PointMarker.b, 100, false, false, 2, true, false, false, false)
			end
			if #(coords - v.DeletePoint) < Config.DrawDistance then
				canSleep = false
				DrawMarker(1, v.DeletePoint.x, v.DeletePoint.y, v.DeletePoint.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.DeleteMarker.x, Config.DeleteMarker.y, Config.DeleteMarker.z, Config.DeleteMarker.r, Config.DeleteMarker.g, Config.DeleteMarker.b, 100, false, false, 2, true, false, false, false)
			end
		end

		for k,v in pairs(Config.Pounds) do
			if #(coords - v.PoundPoint) < Config.DrawDistance then
				canSleep = false
				DrawMarker(36, v.PoundPoint.x, v.PoundPoint.y, v.PoundPoint.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.PoundMarker.x, Config.PoundMarker.y, Config.PoundMarker.z, Config.PoundMarker.r, Config.PoundMarker.g, Config.PoundMarker.b, 100, false, false, 2, true, false, false, false)
			end
		end

		for k,v in pairs(Config.PrivateCarGarages) do
			if TableHas(userProperties, v.Private) then
				if #(coords - v.GaragePoint) < Config.DrawDistance then
					canSleep = false
					DrawMarker(GetMarkerTypeFromTypeText(v.Type), v.GaragePoint.x, v.GaragePoint.y, v.GaragePoint.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.PointMarker.x, Config.PointMarker.y, Config.PointMarker.z, Config.PointMarker.r, Config.PointMarker.g, Config.PointMarker.b, 100, false, false, 2, true, false, false, false)
					end
				if #(coords - v.DeletePoint) < Config.DrawDistance then
					canSleep = false
					DrawMarker(1, v.DeletePoint.x, v.DeletePoint.y, v.DeletePoint.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.DeleteMarker.x, Config.DeleteMarker.y, Config.DeleteMarker.z, Config.DeleteMarker.r, Config.DeleteMarker.g, Config.DeleteMarker.b, 100, false, false, 2, true, false, false, false)
				end
			end
		end

		if canSleep then
			Citizen.Wait(1000)
		end
	end
end)

Citizen.CreateThread(function()
	local currentZone = 'garage'
	while true do
		Citizen.Wait(0)

		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local isInMarker = false

		for k,v in pairs(Config.Garages) do
			if (#(coords - vector3(v.GaragePoint.x, v.GaragePoint.y, v.GaragePoint.z)) < Config.PointMarker.x) then
				isInMarker = true
				this_Garage = v
				currentZone = v.Type .. '_garage_point'
				break
			end

			if(#(coords - vector3(v.DeletePoint.x, v.DeletePoint.y, v.DeletePoint.z)) < Config.DeleteMarker.x) then
				isInMarker = true
				this_Garage = v
				currentZone = v.Type .. '_store_point'
				break
			end
		end

		for k,v in pairs(Config.Pounds) do
			if (#(coords - vector3(v.PoundPoint.x, v.PoundPoint.y, v.PoundPoint.z)) < Config.PoundMarker.x) then
				isInMarker = true
				this_Garage = v
				currentZone = v.Type .. '_pound_point'
				break
			end
		end

		for _,v in pairs(Config.PrivateCarGarages) do
			if not v.Private or TableHas(userProperties, v.Private) then
				local type = v.Type
				if type == nil then
					type = 'car'
				end
 				if (#(coords - vector3(v.GaragePoint.x, v.GaragePoint.y, v.GaragePoint.z)) < Config.PointMarker.x) then
					isInMarker = true
					this_Garage = v
					currentZone = type .. '_garage_point'
					break
				end

				if(#(coords - vector3(v.DeletePoint.x, v.DeletePoint.y, v.DeletePoint.z)) < Config.DeleteMarker.x) then
					isInMarker = true
					this_Garage = v
					currentZone = type .. '_store_point'
					break
				end
			end
		end

		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			LastZone = currentZone
			TriggerEvent('fl_advancedgarage:hasEnteredMarker', currentZone)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('fl_advancedgarage:hasExitedMarker', LastZone)
		end

		if not isInMarker then
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction ~= nil then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) then
				OpenMenuGarage(CurrentAction)
				CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)

function RefreshBlips()
	if AllBlips[1] ~= nil then
		for i=1, #AllBlips, 1 do
			RemoveBlip(AllBlips[i])
			AllBlips[i] = nil
		end
	end

	local blipList = {}

	for k,v in pairs(Config.Garages) do
		local GarageSprite = 290
		if v.Type == 'aircraft' then GarageSprite = 423 end
		if v.Type == 'boat' then GarageSprite = 410 end

		table.insert(blipList, {
			coords = v.GaragePoint,
			text = _U('blip_garage'),
			sprite = GarageSprite,
			color = Config.BlipGarage.Color,
			scale = Config.BlipGarage.Scale,
		})
	end

	for k,v in pairs(Config.Pounds) do
		table.insert(blipList, {
			coords = v.PoundPoint,
			text = 'Fourrière',
			sprite = Config.BlipPound.Sprite,
			color = Config.BlipPound.Color,
			scale = Config.BlipPound.Scale,
		})
	end

	for _,AnyBlip in pairs(blipList) do
		local blip = AddBlipForCoord(AnyBlip.coords)
		SetBlipSprite(blip, AnyBlip.sprite)
		SetBlipScale(blip, AnyBlip.scale)
		SetBlipColour(blip, AnyBlip.color)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(AnyBlip.text)
		EndTextCommandSetBlipName(blip)
		table.insert(AllBlips, blip)
	end
end

RegisterNetEvent('fl_advancedgarage:requestVehicleState')
AddEventHandler('fl_advancedgarage:requestVehicleState', function(vehicleNetId)
	local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
	if DoesEntityExist(vehicle) then
		TriggerServerEvent('fl_advancedgarage:responseVehicleState', ESX.Game.GetVehicleProperties(vehicle))
	else
		print('fl_advancedgarage:requestVehicleState for unknown vehicle : ' .. tostring(vehicle))
	end
end)
