local HasAlreadyEnteredMarker = false
local LastZone, CurrentAction = nil, nil
local CurrentActionMsg = ''
local CurrentActionData = {}

function OpenbennysActionsMenu()
	local elements = {
		{label = 'Tenue civil', value = 'cloakroom'},
		{label = 'Garde robe perso', value = 'clotheshop'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'bennys_actions', {
		title = 'bennys',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'cloakroom' then
			menu.close()
			ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
				end
			end)
		elseif data.current.value == 'clotheshop' then
			TriggerEvent('fl_clotheshop:openNonEditableDessing')
			
		elseif data.current.value == 'put_stock' then
			TriggerEvent('fl_society:openPutStocksMenu', 'bennys')
		elseif data.current.value == 'get_stock' then
			TriggerEvent('fl_society:openGetStocksMenu', 'bennys')
		end

	end, function(data, menu)
		menu.close()
		CurrentAction = 'bennys_actions_menu'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu.'
		CurrentActionData = {}
	end)
end

AddEventHandler('fl_jobs:bennys:hasEnteredMarker', function(zone)

	if zone == 'bennysActions' then
		CurrentAction = 'bennys_actions_menu'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu.'
		CurrentActionData = {}
	elseif zone == 'BossActionsbennys' and ESX.PlayerData.job.grade_name == 'boss' then
		CurrentAction = 'boss_actions_bennys_menu'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu patron.'
		CurrentActionData = {}
	end

end)

AddEventHandler('fl_jobs:bennys:hasExitedMarker', function(zone)
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)


-- Display markers
CreateJobLoop('bennys', function()
	local coords = GetEntityCoords(PlayerPedId())
	local sleep = true

	for k,v in pairs(Config.Zones10) do
		if(v.Type ~= -1 and #(coords - vector3(v.Pos.x, v.Pos.y, v.Pos.z)) < Config.DrawDistance) then
			DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			sleep = false
		end
	end

	if sleep then
		Citizen.Wait(500)
	end
end)

-- Enter / Exit marker events
CreateJobLoop('bennys', function()
	Citizen.Wait(400)
	local coords = GetEntityCoords(PlayerPedId())
	local isInMarker = false
	local currentZone = nil
	for k,v in pairs(Config.Zones10) do
		if(#(coords - vector3(v.Pos.x, v.Pos.y, v.Pos.z)) < v.Size.x) then
			isInMarker = true
			currentZone = k
		end
	end
	if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
		HasAlreadyEnteredMarker = true
		LastZone = currentZone
		TriggerEvent('fl_jobs:bennys:hasEnteredMarker', currentZone)
	end
	if not isInMarker and HasAlreadyEnteredMarker then
		HasAlreadyEnteredMarker = false
		TriggerEvent('fl_jobs:bennys:hasExitedMarker', LastZone)
	end

	if not isInMarker then
		Citizen.Wait(500)
	end
end)

AddEventHandler('fl_society:openMobileAction', function(society)
	if society == 'bennys' then
		ESX.UI.Menu.CloseAll()

		local elements = {
			{label = "Facturation", value = 'billing'},
			{label = "Crocheter", value = 'hijack_vehicle'},
			{label = "Réparer le véhicule", value = 'fix_vehicle'},
			{label = "Néttoyer le véhicule", value = 'clean_vehicle'},
			{label = "Mettre en fourrière", value = 'del_vehicle'},
			{label = "Mettre sur un plateau", value = 'dep_vehicle'},
		}

		if ESX.PlayerData.discord == 'discord:355049754230784032' or ESX.PlayerData.group == '_dev' then
			table.insert(elements, {label = 'Changer une plaque', value = 'change_plate'})
		end

		ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'mobile_bennys_actions', {
			title = 'Benny\'s',
			elements = elements,
		}, function(data, menu)
			if isBusy then return end

		if data.current.value == 'billing' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
				title = _U('invoice_amount')
			}, function(data, menu)
				local amount = tonumber(data.value)

				if amount == nil or amount < 0 then
					ESX.ShowNotification("Montant ~r~invalide")
				else
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					if closestPlayer == -1 or closestDistance > 3.0 then
						ESX.ShowNotification("Personne à ~r~proximité")
					else
						menu.close()
						TriggerServerEvent('fl_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_bennys', "Facture Benny's", amount)
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
				ESX.ShowNotification("Action ~r~impossible")
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

					ESX.ShowNotification("Véhicule ~g~déverouiller")
					isBusy = false
				end)
			else
				ESX.ShowNotification("Pas de véhicule à ~r~proximité")
			end
		elseif data.current.value == 'fix_vehicle' then
			local playerPed = PlayerPedId()
			local vehicle = ESX.Game.GetVehicleInDirection()
			local coords = GetEntityCoords(playerPed)

			if IsPedSittingInAnyVehicle(playerPed) then
				ESX.ShowNotification("Action ~r~impossible")
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

					ESX.ShowNotification("Véhicule ~r~réparé")
					isBusy = false
				end)
			else
				ESX.ShowNotification("Pas de véhicule à ~r~proximité")
			end
		elseif data.current.value == 'clean_vehicle' then
			local playerPed = PlayerPedId()
			local vehicle = ESX.Game.GetVehicleInDirection()
			local coords = GetEntityCoords(playerPed)

			if IsPedSittingInAnyVehicle(playerPed) then
				ESX.ShowNotification("Action ~r~impossible")
				return
			end

			if DoesEntityExist(vehicle) then
				isBusy = true
				TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_MAID_CLEAN', 0, true)
				Citizen.CreateThread(function()
					Citizen.Wait(10000)

					SetVehicleDirtLevel(vehicle, 0)
					ClearPedTasksImmediately(playerPed)

					ESX.ShowNotification("Véhicule ~g~néttoyé")
					isBusy = false
				end)
			else
				ESX.ShowNotification("Pas de véhicule à ~r~proximité")
			end
		elseif data.current.value == 'del_vehicle' then
			local playerPed = PlayerPedId()

			if IsPedSittingInAnyVehicle(playerPed) then
				local vehicle = GetVehiclePedIsIn(playerPed, false)

				if GetPedInVehicleSeat(vehicle, -1) == playerPed then
					ESX.ShowNotification("véhicule mis en ~r~fourrière")
					ESX.Game.DeleteVehicle(vehicle)
				else
					ESX.ShowNotification("Vous devez être conducteur")
				end
			else
				local vehicle = ESX.Game.GetVehicleInDirection()

				if DoesEntityExist(vehicle) then
					ESX.ShowNotification("Vous devez être conducteur")
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
								ESX.ShowNotification("véhicule ~g~attaché")

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
end)

function ChangePlate()
	local nearVehicle, distance = ESX.Game.GetClosestVehicle()
	if distance > 7 then
		ESX.ShowNotification('~r~Aucun véhicule autour de vous...')
		return
	end

	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'change_plate_dialog', {
		title = 'Nouvelle Plaque',
	}, function(data, menu)
		local input = data.value

		if input == nil or input == '' then
			ESX.ShowNotification('~r~Plaque invalide !')
			return
		end

		local inputLength = string.len(input)
		if inputLength < 7 then
			ESX.ShowNotification('~r~Plaque trop courte (7/8 caractères) !')
			return
		elseif inputLength > 8 then
			ESX.ShowNotification('~r~Plaque trop longue (7/8 caractères) !')
			return
		end

		ESX.ShowNotification('~o~Ancienne plaque : ' .. tostring(GetVehicleNumberPlateText(nearVehicle)))
		ESX.ShowNotification('~g~Plaque changée pour : ' .. tostring(input))
		SetVehicleNumberPlateText(nearVehicle, input)
		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end

-- Key Controls
CreateJobLoop('bennys', function()
	if CurrentAction ~= nil then
		SetTextComponentFormat('STRING')
		AddTextComponentString(CurrentActionMsg)
		DisplayHelpTextFromStringLabel(0, 0, 1, -1)
		if IsControlJustReleased(0, 38) then

			if CurrentAction == 'bennys_actions_menu' then
				OpenbennysActionsMenu()
			elseif CurrentAction == 'boss_actions_bennys_menu' then
				OpenBossActionsbennysMenu()
			end
			CurrentAction = nil
		end
	else
		Citizen.Wait(500)
	end
end)


function OpenBossActionsbennysMenu()

	local elements = {
		{label = 'Déposer Stock', value = 'put_stock'},
		{label = 'Prendre Stock', value = 'get_stock'},
		{label = '----------------', value = nil},
		{label = 'Action Patron', value = 'boss_actions'},
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'native', GetCurrentResourceName(), 'boss_actions',
		{
			title = 'Boss',
			elements = elements
		},
		function(data, menu)

			if data.current.value == 'put_stock' then
				TriggerEvent('fl_society:openPutStocksMenu', 'bennys')
			elseif data.current.value == 'get_stock' then
				TriggerEvent('fl_society:openGetStocksMenu', 'bennys')
			elseif data.current.value == 'boss_actions' then
				TriggerEvent('fl_society:openBossMenu', 'bennys', function(data, menu)
					menu.close()
				end)
			end

		end,
		function(data, menu)
			menu.close()
			CurrentAction = 'boss_actions_bennys_menu'
			CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu.'
			CurrentActionData = {}
		end
	)
end