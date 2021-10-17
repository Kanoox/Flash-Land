local CurrentAction, CurrentActionMsg, CurrentActionData = nil, '', {}
local HasAlreadyEnteredMarker, LastHospital, LastPart, LastPartNum
local IsBusy = false

function OpenAmbulanceActionsMenu()
	local elements = {
		{label = _U('cloakroom'), value = 'cloakroom'}
	}

	if ESX.PlayerData.job.grade_name == 'boss' then
		table.insert(elements, {label = _U('boss_actions'), value = 'boss_actions'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'ambulance_actions', {
		title = _U('ambulance'),
		elements = elements
	}, function(data, menu)
		if data.current.value == 'cloakroom' then
			OpenCloakroomMenu()
		elseif data.current.value == 'boss_actions' then
			TriggerEvent('fl_society:openBossMenu', 'ambulance', function(data, menu)
				menu.close()
			end, {})
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenMobileAmbulanceActionsMenu()
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'citizen_interaction', {
		title = _U('ems_menu_title'),
		elements = {
			{label = 'Facturer client', value = 'billing_ambulance'},
			{label = _U('ems_menu_revive'), value = 'revive'},
			{label = _U('ems_menu_small'), value = 'small'},
			{label = _U('ems_menu_big'), value = 'big'},
			{label = _U('ems_menu_putincar'), value = 'put_in_vehicle'},
			{label = 'Recherche de patient invisible', value = 'invisible_patient'},
		}
	}, function(data, menu)
		if IsBusy then return end
		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

		if closestPlayer == -1 or closestDistance > 50.0 then
			ESX.ShowNotification('~r~Personne aux alentours... Recherche lancée...')
			TriggerServerEvent('fl_ambulancejob:svsearch')
		else
			if data.current.value == 'invisible_patient' then
				ESX.ShowNotification('~r~Recherche lancée...')
				TriggerServerEvent('fl_ambulancejob:svsearch')
			elseif data.current.value == 'billing_ambulance' then
				ESX.UI.Menu.Open(
					'dialog', GetCurrentResourceName(), 'ambulance_billing',
					{
						title = 'Montant de la facture'
					},
					function(data, menu)
						local amount = tonumber(data.value)
						if amount == nil then
							ESX.ShowNotification('Montant invalide')
						else
							menu.close()
							TriggerServerEvent('fl_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_ambulance', 'ambulance', amount)
						end
					end,
				function(data, menu)
					menu.close()
				end)
			elseif data.current.value == 'revive' then
				IsBusy = true

				local hasMedikit = false
				for _,item in pairs(ESX.GetPlayerData().inventory) do
					if item.name == 'medikit' and item.count > 0 then
						hasMedikit = true
					end
				end

				if hasMedikit then
					local closestPlayerPed = GetPlayerPed(closestPlayer)

					if IsPedDeadOrDying(closestPlayerPed, 1) then
						local playerPed = PlayerPedId()

						ESX.ShowNotification(_U('revive_inprogress'))

						 local lib, anim = 'mini@cpr@char_a@cpr_str', 'cpr_pumpchest'

						for i=1, 15, 1 do
							Citizen.Wait(900)

							ESX.Streaming.RequestAnimDict(lib, function()
								TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
							end)
						end

						TriggerServerEvent('fl_ambulancejob:removeItem', 'medikit')
						TriggerServerEvent('fl_ambulancejob:revive', GetPlayerServerId(closestPlayer))

						-- Show revive award?
						if Config.ReviveReward > 0 then
							ESX.ShowNotification(_U('revive_complete_award', GetPlayerName(closestPlayer), Config.ReviveReward))
						else
							ESX.ShowNotification(_U('revive_complete', GetPlayerName(closestPlayer)))
						end
					else
						ESX.ShowNotification(_U('player_not_unconscious'))
					end
				else
					ESX.ShowNotification(_U('not_enough_medikit'))
				end

				IsBusy = false
			elseif data.current.value == 'small' then
				local hasBandage = false
				for _,item in pairs(ESX.GetPlayerData().inventory) do
					if item.name == 'bandage' and item.count > 0 then
						hasBandage = true
					end
				end

				if hasBandage then
					local closestPlayerPed = GetPlayerPed(closestPlayer)
					local health = GetEntityHealth(closestPlayerPed)

					if health > 0 then
						local playerPed = PlayerPedId()

						IsBusy = true
						ESX.ShowNotification(_U('heal_inprogress'))
						TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
						Citizen.Wait(10000)
						ClearPedTasks(playerPed)

						TriggerServerEvent('fl_ambulancejob:removeItem', 'bandage')
						TriggerServerEvent('fl_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'small')
						ESX.ShowNotification(_U('heal_complete', GetPlayerName(closestPlayer)))
						IsBusy = false
					else
						ESX.ShowNotification(_U('player_not_conscious'))
					end
				else
					ESX.ShowNotification(_U('not_enough_bandage'))
				end

			elseif data.current.value == 'big' then
				local hasMedikit = false
				for _,item in pairs(ESX.GetPlayerData().inventory) do
					if item.name == 'medikit' and item.count > 0 then
						hasMedikit = true
					end
				end

				if hasMedikit then
					local closestPlayerPed = GetPlayerPed(closestPlayer)
					local health = GetEntityHealth(closestPlayerPed)

					if health > 0 then
						local playerPed = PlayerPedId()

						IsBusy = true
						ESX.ShowNotification(_U('heal_inprogress'))
						TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
						Citizen.Wait(10000)
						ClearPedTasks(playerPed)

						TriggerServerEvent('fl_ambulancejob:removeItem', 'medikit')
						TriggerServerEvent('fl_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'big')
						ESX.ShowNotification(_U('heal_complete', GetPlayerName(closestPlayer)))
						IsBusy = false
					else
						ESX.ShowNotification(_U('player_not_conscious'))
					end
				else
					ESX.ShowNotification(_U('not_enough_medikit'))
				end
			elseif data.current.value == 'put_in_vehicle' then
				TriggerServerEvent('fl_ambulancejob:putInVehicle', GetPlayerServerId(closestPlayer))
			end
		end
	end, function(data, menu)
		menu.close()
	end)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerCoords = GetEntityCoords(PlayerPedId())
		local letSleep, isInMarker, hasExited = true, false, false
		local currentHospital, currentPart, currentPartNum

		for hospitalNum,hospital in pairs(Config.Hospitals) do

			-- Ambulance Actions
			for k,v in ipairs(hospital.AmbulanceActions) do
				local distance = #(playerCoords - v)

				if distance < Config.DrawDistance then
					DrawMarker(Config.Marker.type, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.x, Config.Marker.y, Config.Marker.z, Config.Marker.r, Config.Marker.g, Config.Marker.b, Config.Marker.a, false, false, 2, Config.Marker.rotate, nil, nil, false)
					letSleep = false
				end

				if distance < Config.Marker.x then
					isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'AmbulanceActions', k
				end
			end

			-- Pharmacies
			for k,v in ipairs(hospital.Pharmacies) do
				local distance = #(playerCoords - v)

				if distance < Config.DrawDistance then
					DrawMarker(Config.Marker.type, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.x, Config.Marker.y, Config.Marker.z, Config.Marker.r, Config.Marker.g, Config.Marker.b, Config.Marker.a, false, false, 2, Config.Marker.rotate, nil, nil, false)
					letSleep = false
				end

				if distance < Config.Marker.x then
					isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'Pharmacy', k
				end
			end

		end

		-- Logic for exiting & entering markers
		if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastHospital ~= currentHospital or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then
			if (LastHospital ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
				(LastHospital ~= currentHospital or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
			then
				TriggerEvent('fl_ambulancejob:hasExitedMarker', LastHospital, LastPart, LastPartNum)
				hasExited = true
			end

			HasAlreadyEnteredMarker, LastHospital, LastPart, LastPartNum = true, currentHospital, currentPart, currentPartNum
			TriggerEvent('fl_ambulancejob:hasEnteredMarker', currentHospital, currentPart, currentPartNum)
		end

		if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('fl_ambulancejob:hasExitedMarker', LastHospital, LastPart, LastPartNum)
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

AddEventHandler('fl_ambulancejob:hasEnteredMarker', function(hospital, part, partNum)
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
		if part == 'AmbulanceActions' then
			CurrentAction = part
			CurrentActionMsg = _U('actions_prompt')
			CurrentActionData = {}
		elseif part == 'Pharmacy' then
			CurrentAction = part
			CurrentActionMsg = _U('open_pharmacy')
			CurrentActionData = {}
		end
	end
end)

AddEventHandler('fl_ambulancejob:hasExitedMarker', function(hospital, part, partNum)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) then
				if CurrentAction == 'AmbulanceActions' then
					OpenAmbulanceActionsMenu()
				elseif CurrentAction == 'Pharmacy' then
					OpenPharmacyMenu()
				end
				CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)

AddEventHandler('fl_society:openMobileAction', function(society)
	if society == 'ambulance' then
		OpenMobileAmbulanceActionsMenu()
	end
end)

RegisterNetEvent('fl_ambulancejob:putInVehicle')
AddEventHandler('fl_ambulancejob:putInVehicle', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords, 5.0) then
		local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)

		if DoesEntityExist(vehicle) then
			local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

			for i=maxSeats - 1, 0, -1 do
				if IsVehicleSeatFree(vehicle, i) then
					freeSeat = i
					break
				end
			end

			if freeSeat then
				TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
			end
		end
	end
end)

function OpenCloakroomMenu()
	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'cloakroom', {
		title = _U('cloakroom'),
		elements = {
			{label = _U('ems_clothes_civil'), value = 'citizen_wear'},
			{label = _U('ems_clothes_ems'), value = 'ambulance_wear'},
			{label = 'Garde robe perso', value = 'clotheshop'},
		}
	}, function(data, menu)
		if data.current.value == 'citizen_wear' then
			ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function(skin, jobSkin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		elseif data.current.value == 'ambulance_wear' then
			ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
				end
			end)
		elseif data.current.value == 'clotheshop' then
			TriggerEvent('fl_clotheshop:openNonEditableDessing')
		end

		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end

function OpenPharmacyMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'pharmacy', {
		title = _U('pharmacy_menu_title'),
		elements = {
			{label = _U('pharmacy_take'), rightLabel = _U('medikit'), value = 'medikit'},
			{label = _U('pharmacy_take'), rightLabel = _U('bandage'), value = 'bandage'}
		}
	}, function(data, menu)
		TriggerServerEvent('fl_ambulancejob:giveItem', data.current.value)
	end, function(data, menu)
		menu.close()
	end)
end

RegisterNetEvent('fl_ambulancejob:heal')
AddEventHandler('fl_ambulancejob:heal', function(healType, quiet)
	local playerPed = PlayerPedId()
	local maxHealth = GetEntityMaxHealth(playerPed)

	if healType == 'small' then
		local health = GetEntityHealth(playerPed)
		local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 8))
		SetEntityHealth(playerPed, newHealth)
	elseif healType == 'big' then
		SetEntityHealth(playerPed, maxHealth)
	end

	if not quiet then
		ESX.ShowNotification(_U('healed'))
	end
end)

RegisterNetEvent('fl_ambulancejob:clsearch')
AddEventHandler('fl_ambulancejob:clsearch', function(medicId)
	if not ESX.IsPlayerDead() then return end

	local playerPed = PlayerPedId()
	local playersInArea = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 50.0)

	for i=1, #playersInArea, 1 do
		local nearPlayer = playersInArea[i]
		if nearPlayer == GetPlayerFromServerId(medicId) then
			AttachEntityToEntity(playerPed, GetPlayerPed(nearPlayer), 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
			Citizen.Wait(1000)
			DetachEntity(playerPed, true, false)
			ClearPedTasksImmediately(playerPed)
			break
		end
	end
end)