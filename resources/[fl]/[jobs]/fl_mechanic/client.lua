local HasAlreadyEnteredMarker, LastZone = false, nil
local CurrentAction, CurrentActionMsg, CurrentActionData = nil, '', {}
local CurrentlyTowedVehicle, Blips, NPCOnJob, NPCTargetTowable, NPCTargetTowableZone = nil, {}, false, nil, nil
local NPCHasSpawnedTowable, NPCLastCancel, NPCHasBeenNextToTowable, NPCTargetDeleterZone = false, GetGameTimer() - 5 * 60000, false, false
local isBusy = false

function SelectRandomTowable()
	local index = GetRandomIntInRange(1,  #Config.Towables)

	for k,v in pairs(Config.Zones) do
		if v.Pos.x == Config.Towables[index].x and v.Pos.y == Config.Towables[index].y and v.Pos.z == Config.Towables[index].z then
			return k
		end
	end
end

function StartNPCJob()
	NPCOnJob = true

	NPCTargetTowableZone = SelectRandomTowable()
	local zone = Config.Zones[NPCTargetTowableZone]

	Blips['NPCTargetTowableZone'] = AddBlipForCoord(zone.Pos.x,  zone.Pos.y,  zone.Pos.z)
	SetBlipRoute(Blips['NPCTargetTowableZone'], true)

	ESX.ShowNotification(_U('drive_to_indicated'))
end

function StopNPCJob(cancel)
	if Blips['NPCTargetTowableZone'] then
		RemoveBlip(Blips['NPCTargetTowableZone'])
		Blips['NPCTargetTowableZone'] = nil
	end

	if Blips['NPCDelivery'] then
		RemoveBlip(Blips['NPCDelivery'])
		Blips['NPCDelivery'] = nil
	end

	Config.Zones.VehicleDelivery.Type = -1

	NPCOnJob = false
	NPCTargetTowable = nil
	NPCTargetTowableZone = nil
	NPCHasSpawnedTowable = false
	NPCHasBeenNextToTowable = false

	if cancel then
		ESX.ShowNotification(_U('mission_canceled'))
	else
		TriggerServerEvent('fl_mechanic:onNPCJobCompleted')
	end
end

function OpenMechanicActionsMenu()
	local elements = {
		{label = _U('deposit_stock'), value = 'put_stock'},
		{label = _U('withdraw_stock'), value = 'get_stock'}
	}

	if ESX.PlayerData.job and ESX.PlayerData.job.grade_name == 'boss' then
		table.insert(elements, {label = _U('boss_actions'), value = 'boss_actions'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'mechanic_actions', {
		title = _U('mechanic'),
		elements = elements
	}, function(data, menu)
		if data.current.value == 'put_stock' then
			TriggerEvent('fl_society:openPutStocksMenu', 'mechanic')
		elseif data.current.value == 'get_stock' then
			TriggerEvent('fl_society:openGetStocksMenu', 'mechanic')
		elseif data.current.value == 'boss_actions' then
			TriggerEvent('fl_society:openBossMenu', 'mechanic', function(data, menu)
				menu.close()
			end)
		end
	end, function(data, menu)
		menu.close()

		CurrentAction = 'mechanic_actions_menu'
		CurrentActionMsg = _U('open_actions')
		CurrentActionData = {}
	end)
end

function OpenMechanicHarvestMenu()
	local elements = {
		{label = _U('gas_can'), value = 'gaz_bottle'},
		{label = _U('repair_tools'), value = 'fix_tool'},
		{label = _U('body_work_tools'), value = 'caro_tool'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'mechanic_harvest', {
		title = _U('harvest'),
		elements = elements
	}, function(data, menu)
		menu.close()

		if data.current.value == 'gaz_bottle' then
			TriggerServerEvent('fl_mechanic:startHarvest')
		elseif data.current.value == 'fix_tool' then
			TriggerServerEvent('fl_mechanic:startHarvest2')
		elseif data.current.value == 'caro_tool' then
			TriggerServerEvent('fl_mechanic:startHarvest3')
		end
	end, function(data, menu)
		menu.close()
		CurrentAction = 'mechanic_harvest_menu'
		CurrentActionMsg = _U('harvest_menu')
		CurrentActionData = {}
	end)
end

function OpenMechanicCraftMenu()
	local elements = {
		{label = _U('blowtorch'), value = 'blow_pipe'},
		{label = _U('repair_kit'), value = 'fix_kit'},
		{label = _U('body_kit'), value = 'caro_kit'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'mechanic_craft', {
		title = _U('craft'),
		elements = elements
	}, function(data, menu)
		menu.close()

		if data.current.value == 'blow_pipe' then
			TriggerServerEvent('fl_mechanic:startCraft')
		elseif data.current.value == 'fix_kit' then
			TriggerServerEvent('fl_mechanic:startCraft2')
		elseif data.current.value == 'caro_kit' then
			TriggerServerEvent('fl_mechanic:startCraft3')
		end
	end, function(data, menu)
		menu.close()

		CurrentAction = 'mechanic_craft_menu'
		CurrentActionMsg = _U('craft_menu')
		CurrentActionData = {}
	end)
end

function OpenMobileMechanicActionsMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'mobile_mechanic_actions', {
		title = _U('mechanic'),
		elements = {
			{label = _U('billing'), value = 'billing'},
			{label = _U('hijack'), value = 'hijack_vehicle'},
			{label = _U('repair'), value = 'fix_vehicle'},
			{label = _U('clean'), value = 'clean_vehicle'},
			{label = _U('imp_veh'), value = 'del_vehicle'},
			{label = _U('flat_bed'), value = 'dep_vehicle'},
	}}, function(data, menu)
		if isBusy then return end

		if data.current.value == 'billing' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
				title = _U('invoice_amount')
			}, function(data, menu)
				local amount = tonumber(data.value)

				if amount == nil or amount < 0 then
					ESX.ShowNotification(_U('amount_invalid'))
				else
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					if closestPlayer == -1 or closestDistance > 3.0 then
						ESX.ShowNotification(_U('no_players_nearby'))
					else
						menu.close()
						TriggerServerEvent('fl_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_mechanic', _U('mechanic'), amount)
					end
				end
			end, function(data, menu)
				menu.close()
			end)
		elseif data.current.value == 'hijack_vehicle' then
			local playerPed = PlayerPedId()
			local vehicle = ESX.Game.GetVehicleInDirection()
			local coords = GetEntityCoords(playerPed)

			if IsPedSittingInAnyVehicle(playerPed) then
				ESX.ShowNotification(_U('inside_vehicle'))
				return
			end

			if DoesEntityExist(vehicle) then
				isBusy = true
				TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)
				Citizen.CreateThread(function()
					Citizen.Wait(10000)

					SetVehicleDoorsLocked(vehicle, 1)
					SetVehicleDoorsLockedForAllPlayers(vehicle, false)
					ClearPedTasksImmediately(playerPed)

					ESX.ShowNotification(_U('vehicle_unlocked'))
					isBusy = false
				end)
			else
				ESX.ShowNotification(_U('no_vehicle_nearby'))
			end
		elseif data.current.value == 'fix_vehicle' then
			local playerPed = PlayerPedId()
			local vehicle = ESX.Game.GetVehicleInDirection()
			local coords = GetEntityCoords(playerPed)

			if IsPedSittingInAnyVehicle(playerPed) then
				ESX.ShowNotification(_U('inside_vehicle'))
				return
			end

			if DoesEntityExist(vehicle) then
				isBusy = true
				TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
				Citizen.CreateThread(function()
					Citizen.Wait(20000)

					SetVehicleFixed(vehicle)
					SetVehicleDeformationFixed(vehicle)
					SetVehicleUndriveable(vehicle, false)
					SetVehicleEngineOn(vehicle, true, true)
					ClearPedTasksImmediately(playerPed)

					ESX.ShowNotification(_U('vehicle_repaired'))
					isBusy = false
				end)
			else
				ESX.ShowNotification(_U('no_vehicle_nearby'))
			end
		elseif data.current.value == 'clean_vehicle' then
			local playerPed = PlayerPedId()
			local vehicle = ESX.Game.GetVehicleInDirection()
			local coords = GetEntityCoords(playerPed)

			if IsPedSittingInAnyVehicle(playerPed) then
				ESX.ShowNotification(_U('inside_vehicle'))
				return
			end

			if DoesEntityExist(vehicle) then
				isBusy = true
				TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_MAID_CLEAN', 0, true)
				Citizen.CreateThread(function()
					Citizen.Wait(10000)

					SetVehicleDirtLevel(vehicle, 0)
					ClearPedTasksImmediately(playerPed)

					ESX.ShowNotification(_U('vehicle_cleaned'))
					isBusy = false
				end)
			else
				ESX.ShowNotification(_U('no_vehicle_nearby'))
			end
		elseif data.current.value == 'del_vehicle' then
			local playerPed = PlayerPedId()

			if IsPedSittingInAnyVehicle(playerPed) then
				local vehicle = GetVehiclePedIsIn(playerPed, false)

				if GetPedInVehicleSeat(vehicle, -1) == playerPed then
					ESX.ShowNotification(_U('vehicle_impounded'))
					ESX.Game.DeleteVehicle(vehicle)
				else
					ESX.ShowNotification(_U('must_seat_driver'))
				end
			else
				local vehicle = ESX.Game.GetVehicleInDirection()

				if DoesEntityExist(vehicle) then
					ESX.ShowNotification(_U('vehicle_impounded'))
					ESX.Game.DeleteVehicle(vehicle)
				else
					ESX.ShowNotification(_U('must_near'))
				end
			end
		elseif data.current.value == 'dep_vehicle' then
			local playerPed = PlayerPedId()
			local vehicle = GetVehiclePedIsIn(playerPed, true)

			local towmodel = `flatbed`
			local isVehicleTow = IsVehicleModel(vehicle, towmodel)

			if isVehicleTow then
				local targetVehicle = ESX.Game.GetVehicleInDirection()

				if CurrentlyTowedVehicle == nil then
					if targetVehicle ~= 0 then
						if not IsPedInAnyVehicle(playerPed, true) then
							if vehicle ~= targetVehicle then
								AttachEntityToEntity(targetVehicle, vehicle, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
								CurrentlyTowedVehicle = targetVehicle
								ESX.ShowNotification(_U('vehicle_success_attached'))

								if NPCOnJob then
									if NPCTargetTowable == targetVehicle then
										ESX.ShowNotification(_U('please_drop_off'))
										Config.Zones.VehicleDelivery.Type = 1

										if Blips['NPCTargetTowableZone'] then
											RemoveBlip(Blips['NPCTargetTowableZone'])
											Blips['NPCTargetTowableZone'] = nil
										end

										Blips['NPCDelivery'] = AddBlipForCoord(Config.Zones.VehicleDelivery.Pos.x, Config.Zones.VehicleDelivery.Pos.y, Config.Zones.VehicleDelivery.Pos.z)
										SetBlipRoute(Blips['NPCDelivery'], true)
									end
								end
							else
								ESX.ShowNotification(_U('cant_attach_own_tt'))
							end
						end
					else
						ESX.ShowNotification(_U('no_veh_att'))
					end
				else
					AttachEntityToEntity(CurrentlyTowedVehicle, vehicle, 20, -0.5, -12.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
					DetachEntity(CurrentlyTowedVehicle, true, true)

					if NPCOnJob then
						if NPCTargetDeleterZone then

							if CurrentlyTowedVehicle == NPCTargetTowable then
								ESX.Game.DeleteVehicle(NPCTargetTowable)
								TriggerServerEvent('fl_mechanic:onNPCJobMissionCompleted')
								StopNPCJob()
								NPCTargetDeleterZone = false
							else
								ESX.ShowNotification(_U('not_right_veh'))
							end

						else
							ESX.ShowNotification(_U('not_right_place'))
						end
					end

					CurrentlyTowedVehicle = nil
					ESX.ShowNotification(_U('veh_det_succ'))
				end
			else
				ESX.ShowNotification(_U('imp_flatbed'))
			end
		end
	end, function(data, menu)
		menu.close()
	end)
end

--Vestiaire
function OpenMechanicCloakroomMenu()
	local elements = {
		{label = _U('work_wear'), value = 'cloakroom'},
		{label = _U('civ_wear'), value = 'civ_wear'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'mechanic_cloakroom', {
		title = _U('mechanic'),
		elements = elements
	}, function(data, menu)
		if data.current.value == 'cloakroom' then
			ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, {
						['tshirt_1'] = 15,  ['tshirt_2'] = 0,
						['torso_1'] = 66,   ['torso_2'] = 1,
						['arms'] = 17,
						['pants_1'] = 39,   ['pants_2'] = 1,
						['shoes_1'] = 24,   ['shoes_2'] = 0,
					})
				else
					TriggerEvent('skinchanger:loadClothes', skin, {
						['tshirt_1'] = 15,  ['tshirt_2'] = 0,
						['torso_1'] = 66,   ['torso_2'] = 1,
						['arms'] = 17,
						['pants_1'] = 39,   ['pants_2'] = 1,
						['shoes_1'] = 24,   ['shoes_2'] = 0,
					})
				end
			end)
		elseif data.current.value == 'civ_wear' then
			ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function(skin, jobSkin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		end
		menu.close()
	end, function(data, menu)
		menu.close()

		CurrentAction= 'mechanic_cloakroom_menu'
		CurrentActionMsg= _U('open_actions')
		CurrentActionData = {}
	end)
end

--Vehicles
function OpenMechanicVehiclesMenu()
	local elements = {
		{label = _U('vehicle_list'),   value = 'vehicle_list'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'mechanic_vehicles', {

		title = _U('mechanic'),
		elements = elements
	}, function(data, menu)
		if data.current.value == 'vehicle_list' then
			local elements = {
				{label = _U('flat_bed'), value = 'flatbed'},
				{label = _U('tow_truck'), value = 'towtruck2'}
			}

			if ESX.PlayerData.job and (ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job.grade_name == 'chief' or ESX.PlayerData.job.grade_name == 'experimente') then
				table.insert(elements, {label = 'SlamVan', value = 'slamvan3'})
			end

			ESX.UI.Menu.CloseAll()

			ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'spawn_vehicle', {
				title = _U('service_vehicle'),
				elements = elements
			}, function(data, menu)
				ESX.Game.SpawnVehicle(data.current.value, Config.Zones.VehicleSpawnPoint.Pos, 90.0, function(vehicle)
					local playerPed = PlayerPedId()
					local plate = GetVehicleNumberPlateText(vehicle)
					TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
					TriggerServerEvent('fl_controlvehicle:giveKey', plate) -- vehicle lock
				end)
				menu.close()
			end, function(data, menu)
				menu.close()
				OpenMechanicVehiclesMenu()
			end)

		end
	end, function(data, menu)
		menu.close()

		CurrentAction = 'mechanic_vehicles_menu'
		CurrentActionMsg = _U('open_actions')
		CurrentActionData = {}
	end)
end

RegisterNetEvent('fl_mechanic:onHijack')
AddEventHandler('fl_mechanic:onHijack', function()
	local playerPed = PlayerPedId()
	local vehicle   = ESX.Game.GetVehicleInDirection()
	local coords = GetEntityCoords(playerPed)

	if IsPedSittingInAnyVehicle(playerPed) then
		ESX.ShowNotification(_U('inside_vehicle'))
		return
	end

		local chance = math.random(100)
		local alarm = math.random(100)

		if DoesEntityExist(vehicle) then
			if alarm <= 60 then
				SetVehicleAlarm(vehicle, true)
				StartVehicleAlarm(vehicle)
			end

			TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)

			Citizen.CreateThread(function()
				Citizen.Wait(10000)
				if chance <= 30 then
					SetVehicleDoorsLocked(vehicle, 1)
					SetVehicleDoorsLockedForAllPlayers(vehicle, false)
					ClearPedTasksImmediately(playerPed)
					ESX.ShowNotification(_U('veh_unlocked'))
				else
					ESX.ShowNotification(_U('hijack_failed'))
					ClearPedTasksImmediately(playerPed)
				end
			end)
		end
end)

RegisterNetEvent('fl_mechanic:onCarokit')
AddEventHandler('fl_mechanic:onCarokit', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle

		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end

		if DoesEntityExist(vehicle) then
			TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_HAMMERING', 0, true)
			Citizen.CreateThread(function()
				Citizen.Wait(10000)
				SetVehicleFixed(vehicle)
				SetVehicleDeformationFixed(vehicle)
				ClearPedTasksImmediately(playerPed)
				ESX.ShowNotification(_U('body_repaired'))
			end)
		end
	end
end)

RegisterNetEvent('fl_mechanic:onFixkit')
AddEventHandler('fl_mechanic:onFixkit', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle

		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end

		if DoesEntityExist(vehicle) then
			TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
			Citizen.CreateThread(function()
				Citizen.Wait(20000)
				SetVehicleFixed(vehicle)
				SetVehicleDeformationFixed(vehicle)
				SetVehicleUndriveable(vehicle, false)
				ClearPedTasksImmediately(playerPed)
				ESX.ShowNotification(_U('veh_repaired'))
			end)
		end
	end
end)

AddEventHandler('fl_mechanic:hasEnteredMarker', function(zone)
	if zone == 'NPCJobTargetTowable' then

	elseif zone =='VehicleDelivery' then
		NPCTargetDeleterZone = true
	elseif zone == 'MechanicActions' then
		CurrentAction = 'mechanic_actions_menu'
		CurrentActionMsg = _U('open_actions')
		CurrentActionData = {}
	elseif zone == 'Garage' then
		CurrentAction = 'mechanic_harvest_menu'
		CurrentActionMsg = _U('harvest_menu')
		CurrentActionData = {}
	elseif zone == 'Craft' then
		CurrentAction = 'mechanic_craft_menu'
		CurrentActionMsg = _U('craft_menu')
		CurrentActionData = {}
	elseif zone == 'MechanicCloakroom' then
		CurrentAction = 'mechanic_cloakroom_menu'
		CurrentActionMsg = _U('open_actions')
		CurrentActionData = {}
	elseif zone == 'MechanicVehicles' then
		CurrentAction = 'mechanic_vehicles_menu'
		CurrentActionMsg = _U('open_actions')
		CurrentActionData = {}
	elseif zone == 'VehicleDeleter' then
		local playerPed = PlayerPedId()

		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle = GetVehiclePedIsIn(playerPed,  false)

			CurrentAction = 'delete_vehicle'
			CurrentActionMsg = _U('veh_stored')
			CurrentActionData = {vehicle = vehicle}
		end
	end
end)

AddEventHandler('fl_mechanic:hasExitedMarker', function(zone)
	if zone =='VehicleDelivery' then
		NPCTargetDeleterZone = false
	elseif zone == 'Craft' then
		TriggerServerEvent('fl_mechanic:stopCraft')
		TriggerServerEvent('fl_mechanic:stopCraft2')
		TriggerServerEvent('fl_mechanic:stopCraft3')
	elseif zone == 'Garage' then
		TriggerServerEvent('fl_mechanic:stopHarvest')
		TriggerServerEvent('fl_mechanic:stopHarvest2')
		TriggerServerEvent('fl_mechanic:stopHarvest3')
	end

	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)


-- Pop NPC mission vehicle when inside area
CreateJobLoop('mechanic', function()
	if NPCTargetTowableZone and not NPCHasSpawnedTowable then
		local coords = GetEntityCoords(PlayerPedId())
		local zone = Config.Zones[NPCTargetTowableZone]

		if #(coords - vector3(zone.Pos.x, zone.Pos.y, zone.Pos.z)) < Config.NPCSpawnDistance then
			local model = Config.Vehicles[GetRandomIntInRange(1,  #Config.Vehicles)]

			ESX.Game.SpawnVehicle(model, zone.Pos, 0, function(vehicle)
				NPCTargetTowable = vehicle
			end)

			NPCHasSpawnedTowable = true
		else
			Citizen.Wait(200)
		end
	end

	if NPCTargetTowableZone and NPCHasSpawnedTowable and not NPCHasBeenNextToTowable then
		local coords = GetEntityCoords(PlayerPedId())
		local zone = Config.Zones[NPCTargetTowableZone]

		if #(coords - vector3(zone.Pos.x, zone.Pos.y, zone.Pos.z)) < Config.NPCNextToDistance then
			ESX.ShowNotification(_U('please_tow'))
			NPCHasBeenNextToTowable = true
		else
			Citizen.Wait(200)
		end
	end
end)

Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.Zones.MechanicActions.Pos.x, Config.Zones.MechanicActions.Pos.y, Config.Zones.MechanicActions.Pos.z)

	SetBlipSprite(blip, 446)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 0.7)
	SetBlipColour(blip, 5)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(_U('mechanic'))
	EndTextCommandSetBlipName(blip)

	RefreshBlips()
end)

function RefreshBlips()
	if ESX.PlayerData.job.name ~= 'mechanic' then return end

	local blip = AddBlipForCoord(Config.Zones.Craft.Pos)
	SetBlipSprite (blip, 566)
	SetBlipDisplay(blip, 4)
	SetBlipScale (blip, 0.75)
	SetBlipColour (blip, 1)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Mécano - Fabrication de kit")
	EndTextCommandSetBlipName(blip)

	local blip = AddBlipForCoord(Config.Zones.Garage.Pos)
	SetBlipSprite (blip, 566)
	SetBlipDisplay(blip, 4)
	SetBlipScale (blip, 0.75)
	SetBlipColour (blip, 1)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Mécano - Récupération matériel")
	EndTextCommandSetBlipName(blip)
end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', RefreshBlips)

CreateJobLoop('mechanic', function()
	local coords, letSleep = GetEntityCoords(PlayerPedId()), true

	for k,v in pairs(Config.Zones) do
		if v.Type ~= -1 and #(coords - vector3(v.Pos.x, v.Pos.y, v.Pos.z)) < Config.DrawDistance then
			DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, nil, nil, false)
			letSleep = false
		end
	end

	if letSleep then
		Citizen.Wait(500)
	end
end)

CreateJobLoop('mechanic', function()
	Citizen.Wait(10)

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
		TriggerEvent('fl_mechanic:hasEnteredMarker', currentZone)
	end

	if not isInMarker and HasAlreadyEnteredMarker then
		HasAlreadyEnteredMarker = false
		TriggerEvent('fl_mechanic:hasExitedMarker', LastZone)
	end
end)

-- Key Controls
CreateJobLoop('mechanic', function()
	if CurrentAction then
		ESX.ShowHelpNotification(CurrentActionMsg)

		if IsControlJustReleased(0, 38) then

			if CurrentAction == 'mechanic_actions_menu' then
				OpenMechanicActionsMenu()
			elseif CurrentAction == 'mechanic_harvest_menu' then
				OpenMechanicHarvestMenu()
			elseif CurrentAction == 'mechanic_craft_menu' then
				OpenMechanicCraftMenu()
			elseif CurrentAction == 'mechanic_cloakroom_menu' then
				OpenMechanicCloakroomMenu()
			elseif CurrentAction == 'mechanic_vehicles_menu' then
				OpenMechanicVehiclesMenu()
			elseif CurrentAction == 'delete_vehicle' then
				ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
			elseif CurrentAction == 'remove_entity' then
				--DeleteEntity(CurrentActionData.entity)
				NetworkRegisterEntityAsNetworked(CurrentActionData.entity)
				Citizen.Wait(100)

				NetworkRequestControlOfEntity(CurrentActionData.entity)

				if not IsEntityAMissionEntity(CurrentActionData.entity) then
					SetEntityAsMissionEntity(CurrentActionData.entity)
				end

				Citizen.Wait(100)
				DeleteEntity(CurrentActionData.entity)
			end

			CurrentAction = nil
		end
	end

	if IsControlJustReleased(0, 178) and not ESX.IsPlayerDead() then
		if NPCOnJob then
			if GetGameTimer() - NPCLastCancel > 5 * 60000 then
				StopNPCJob(true)
				NPCLastCancel = GetGameTimer()
			else
				ESX.ShowNotification(_U('wait_five'))
			end
		else
			local playerPed = PlayerPedId()

			if IsPedInAnyVehicle(playerPed, false) and IsVehicleModel(GetVehiclePedIsIn(playerPed, false), `flatbed`) then
				StartNPCJob()
			else
				ESX.ShowNotification(_U('must_in_flatbed'))
			end
		end
	end
end)

AddEventHandler('fl_society:openMobileAction', function(society)
	if society == 'mechanic' then
		OpenMobileMechanicActionsMenu()
	end
end)