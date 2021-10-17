local HasAlreadyEnteredMarker, OnJob, IsNearCustomer, CustomerIsEnteringVehicle, CustomerEnteredVehicle, CurrentActionData = false, false, false, false, false, {}
local CurrentCustomer, CurrentCustomerBlip, DestinationBlip, targetCoords, LastZone, CurrentAction, CurrentActionMsg

function DrawSub(msg, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandPrint(time, 1)
end

function ShowLoadingPromt(msg, time, type)
	Citizen.CreateThread(function()
		Citizen.Wait(0)

		BeginTextCommandBusyString('STRING')
		AddTextComponentSubstringPlayerName(msg)
		EndTextCommandBusyString(type)
		Citizen.Wait(time)

		RemoveLoadingPrompt()
	end)
end

function GetRandomWalkingNPC()
	local search = {}
	local peds = ESX.Game.GetPeds()

	for i=1, #peds, 1 do
		if IsPedHuman(peds[i]) and IsPedWalking(peds[i]) and not IsPedAPlayer(peds[i]) then
			table.insert(search, peds[i])
		end
	end

	if #search > 0 then
		return search[GetRandomIntInRange(1, #search)]
	end

	for i=1, 250, 1 do
		local ped = GetRandomPedAtCoord(0.0, 0.0, 0.0, math.huge + 0.0, math.huge + 0.0, math.huge + 0.0, 26)

		if DoesEntityExist(ped) and IsPedHuman(ped) and IsPedWalking(ped) and not IsPedAPlayer(ped) then
			table.insert(search, ped)
		end
	end

	if #search > 0 then
		return search[GetRandomIntInRange(1, #search)]
	end
end

function ClearCurrentMission()
	if DoesBlipExist(CurrentCustomerBlip) then
		RemoveBlip(CurrentCustomerBlip)
	end

	if DoesBlipExist(DestinationBlip) then
		RemoveBlip(DestinationBlip)
	end

	CurrentCustomer = nil
	CurrentCustomerBlip = nil
	DestinationBlip = nil
	IsNearCustomer = false
	CustomerIsEnteringVehicle = false
	CustomerEnteredVehicle = false
	targetCoords = nil
end

function StartTaxiJob()
	ShowLoadingPromt('Prise de service : Taxi/Uber', 5000, 3)
	ClearCurrentMission()

	OnJob = true
end

function StopTaxiJob()
	local playerPed = PlayerPedId()

	if IsPedInAnyVehicle(playerPed, false) and CurrentCustomer ~= nil then
		local vehicle = GetVehiclePedIsIn(playerPed,  false)
		TaskLeaveVehicle(CurrentCustomer,  vehicle,  0)

		if CustomerEnteredVehicle then
			TaskGoStraightToCoord(CurrentCustomer,  targetCoords.x,  targetCoords.y,  targetCoords.z,  1.0,  -1,  0.0,  0.0)
		end
	end

	ClearCurrentMission()
	OnJob = false
	DrawSub('Mission terminée', 5000)
end

function OpenTaxiCloakroom()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'taxi_cloakroom',
	{
		title = 'Vestiaire Taxi',
		elements = {
			{ label = 'Tenue Civile', value = 'wear_citizen' },
			{ label = 'Tenue Taxi',    value = 'wear_work'}
		}
	}, function(data, menu)
		if data.current.value == 'wear_citizen' then
			ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		elseif data.current.value == 'wear_work' then
			ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
				end
			end)
		end
	end, function(data, menu)
		menu.close()

		CurrentAction = 'cloakroom_taxi'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu.'
		CurrentActionData = {}
	end)
end

function OpenVehicleSpawnerTaxiMenu()
	ESX.UI.Menu.CloseAll()

	local elements = {}

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'vehicle_taxi_spawner',
	{
		title = 'Véhicules de service',
		elements = Config.AuthorizedTaxiVehicles
	}, function(data, menu)
		if not ESX.Game.IsSpawnPointClear(Config.Zones1.VehicleSpawnTaxiPoint.Pos, 5.0) then
			ESX.ShowNotification('Emplacement déjà utilisé !')
			return
		end

		menu.close()
		ESX.Game.SpawnVehicle(data.current.model, Config.Zones1.VehicleSpawnTaxiPoint.Pos, Config.Zones1.VehicleSpawnTaxiPoint.Heading, function(vehicle)
			local playerPed = PlayerPedId()
			local platenum = math.random(100, 900)
			SetVehicleNumberPlateText(vehicle, "TAXI" .. platenum)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			local plate = GetVehicleNumberPlateText(vehicle)
			plate = string.gsub(plate, " ", "")
			TriggerServerEvent('fl_controlvehicle:giveKey', plate) -- vehicle lock
		end)
	end, function(data, menu)
		CurrentAction = 'vehicle_taxi_spawner'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu.'
		CurrentActionData = {}

		menu.close()
	end)
end

function DeleteJobTaxiVehicle()
	local vehicle = GetVehiclePedIsIn(PlayerPedId(),  false)
	local plate = GetVehicleNumberPlateText(CurrentActionData.vehicle)
	TriggerServerEvent('fl_controlvehicle:deleteKeyJobs', plate, NetworkGetNetworkIdFromEntity(CurrentActionData.vehicle))
end

function OpenTaxiActionsMenu()
	local elements = {
		{label = 'Déposer Stock', value = 'put_stock'},
		{label = 'Prendre Stock', value = 'get_stock'}
	}

	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
		table.insert(elements, {label = 'Action Patron', value = 'boss_actions'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'taxi_actions', {
		title = 'Taxi',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'put_stock' then
			TriggerEvent('fl_society:openPutStocksMenu', 'taxi')
		elseif data.current.value == 'get_stock' then
			TriggerEvent('fl_society:openGetStocksMenu', 'taxi')
		elseif data.current.value == 'boss_actions' then
			TriggerEvent('fl_society:openBossMenu', 'taxi', function(data, menu)
				menu.close()
			end)
		end

	end, function(data, menu)
		menu.close()

		CurrentAction = 'taxi_actions_menu'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu.'
		CurrentActionData = {}
	end)
end

function OpenMobileTaxiActionsMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'mobile_taxi_actions', {
		title = 'Taxi',
		elements = {
			{label = 'Facture', value = 'billing'},
			{label = 'Commencer/Arreter rechercher client', value = 'start_job'}
	}}, function(data, menu)
		if data.current.value == 'billing' then

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
				title = 'Montant de la facture'
			}, function(data, menu)

				local amount = tonumber(data.value)
				if amount == nil then
					ESX.ShowNotification('Montant invalide')
				else
					menu.close()
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					if closestPlayer == -1 or closestDistance > 3.0 then
						ESX.ShowNotification('Aucun joueur à proximité')
					else
						TriggerServerEvent('fl_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_taxi', 'Taxi', amount)
						ESX.ShowNotification('La facture est bien enregistré !')
					end

				end

			end, function(data, menu)
				menu.close()
			end)

		elseif data.current.value == 'start_job' then
			if OnJob then
				StopTaxiJob()
			else
				if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'taxi' then
					local playerPed = PlayerPedId()
					local vehicle = GetVehiclePedIsIn(playerPed, false)

					if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
						if tonumber(ESX.PlayerData.job.grade) >= 3 then
							StartTaxiJob()
						else
							if IsInAuthorizedVehicle() then
								StartTaxiJob()
							else
								ESX.ShowNotification('Vous devez être dans un taxi pour commencer la mission')
							end
						end
					else
						if tonumber(ESX.PlayerData.job.grade) >= 3 then
							ESX.ShowNotification('Vous devez être dans un véhicule pour commencer la mission')
						else
							ESX.ShowNotification('Vous devez être dans un taxi pour commencer la mission')
						end
					end
				end
			end
		end
	end, function(data, menu)
		menu.close()
	end)
end

function IsInAuthorizedVehicle()
	local playerPed = PlayerPedId()
	local vehModel = GetEntityModel(GetVehiclePedIsIn(playerPed, false))

	for i=1, #Config.AuthorizedTaxiVehicles, 1 do
		if vehModel == GetHashKey(Config.AuthorizedTaxiVehicles[i].model) then
			return true
		end
	end

	return false
end

AddEventHandler('fl_jobs:taxi:hasEnteredMarkerTaxi', function(zone)
	if zone == 'VehicleTaxiSpawner' then
		CurrentAction = 'vehicle_taxi_spawner'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le ~y~menu~s~.'
		CurrentActionData = {}
	elseif zone == 'VehicleTaxiDeleter' then
		local playerPed = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(playerPed, false)

		if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
			CurrentAction = 'delete_taxi_vehicle'
			CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ rentrer le ~y~Véhicule~s~.'
			CurrentActionData = { vehicle = vehicle }
		end
	elseif zone == 'TaxiActions' then
		CurrentAction = 'taxi_actions_menu'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le ~y~menu~s~.'
		CurrentActionData = {}

	elseif zone == 'CloakroomTaxi' then
		CurrentAction = 'cloakroom_taxi'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le ~y~menu~s~.'
		CurrentActionData = {}
	end
end)

AddEventHandler('fl_jobs:taxi:hasExitedMarkerTaxi', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

-- Enter / Exit marker events, and draw markers
CreateJobLoop('taxi', function()
	Citizen.Wait(400)
	local coords = GetEntityCoords(PlayerPedId())
	local isInMarker, letSleep, currentZone = false, true

	for k,v in pairs(Config.Zones1) do
		local distance = #(coords - vector3(v.Pos.x, v.Pos.y, v.Pos.z))

		if v.Type ~= -1 and distance < Config.DrawDistance then
			letSleep = false
			DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, false, 2, v.Rotate, nil, nil, false)
		end

		if distance < v.Size.x then
			isInMarker, currentZone = true, k
		end
	end

	if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
		HasAlreadyEnteredMarker, LastZone = true, currentZone
		TriggerEvent('fl_jobs:taxi:hasEnteredMarkerTaxi', currentZone)
	end

	if not isInMarker and HasAlreadyEnteredMarker then
		HasAlreadyEnteredMarker = false
		TriggerEvent('fl_jobs:taxi:hasExitedMarkerTaxi', LastZone)
	end

	if letSleep then
		Citizen.Wait(500)
	end
end)

-- Taxi Job
CreateJobLoop('taxi', function()
	local playerPed = PlayerPedId()

	if OnJob then
		if CurrentCustomer == nil then
			DrawSub('Conduisez à la recherche de ~y~passagers', 5000)

			if IsPedInAnyVehicle(playerPed, false) and GetEntitySpeed(playerPed) > 0 then
				local waitUntil = GetGameTimer() + GetRandomIntInRange(30000, 45000)

				while OnJob and waitUntil > GetGameTimer() do
					DrawSub('Il y a des ~y~passagers~s~ près de cette zone !', 5000)
					Citizen.Wait(0)
				end

				if OnJob and IsPedInAnyVehicle(playerPed, false) and GetEntitySpeed(playerPed) > 0 then
					while CurrentCustomer == nil or IsPedFatallyInjured(CurrentCustomer) do
						CurrentCustomer = GetRandomWalkingNPC()
						Citizen.Wait(0)
					end

					if CurrentCustomer ~= nil then
						CurrentCustomerBlip = AddBlipForEntity(CurrentCustomer)

						SetBlipAsFriendly(CurrentCustomerBlip, true)
						SetBlipColour(CurrentCustomerBlip, 2)
						SetBlipCategory(CurrentCustomerBlip, 3)
						SetBlipRoute(CurrentCustomerBlip, true)

						SetEntityAsMissionEntity(CurrentCustomer, true, false)
						ClearPedTasksImmediately(CurrentCustomer)
						SetBlockingOfNonTemporaryEvents(CurrentCustomer, true)

						local standTime = GetRandomIntInRange(60000, 180000)
						TaskStandStill(CurrentCustomer, standTime)

						ESX.ShowNotification('Vous avez ~g~trouvé~s~ un client, conduisez jusqu\'à ce dernier')
					end
				end
			end
		else
			if IsPedInAnyVehicle(playerPed, false) then
				local vehicle = GetVehiclePedIsIn(playerPed, false)
				local playerCoords = GetEntityCoords(playerPed)
				local customerCoords = GetEntityCoords(CurrentCustomer)
				local customerDistance = #(playerCoords - customerCoords)

				if IsPedSittingInVehicle(CurrentCustomer, vehicle) then
					if CustomerEnteredVehicle then
						local targetDistance = #(playerCoords - targetCoords)

						if targetDistance <= 10.0 then
							TaskLeaveVehicle(CurrentCustomer, vehicle, 0)

							ESX.ShowNotification('Vous êtes ~g~arrivé~s~ à destination')

							TaskGoStraightToCoord(CurrentCustomer, targetCoords.x, targetCoords.y, targetCoords.z, 1.0, -1, 0.0, 0.0)
							SetEntityAsMissionEntity(CurrentCustomer, false, true)
							TriggerServerEvent('fl_jobs:taxi:successTaxi')
							RemoveBlip(DestinationBlip)

							local scope = function(customer)
								ESX.SetTimeout(60000, function()
									DeletePed(customer)
								end)
							end

							scope(CurrentCustomer)

							CurrentCustomer, CurrentCustomerBlip, DestinationBlip, IsNearCustomer, CustomerIsEnteringVehicle, CustomerEnteredVehicle, targetCoords = nil, nil, nil, false, false, false, nil
						end

						if targetCoords then
							DrawMarker(36, targetCoords.x, targetCoords.y, targetCoords.z + 1.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 234, 223, 72, 155, false, false, 2, true, nil, nil, false)
						end
					else
						RemoveBlip(CurrentCustomerBlip)
						CurrentCustomerBlip = nil
						targetCoords = Config.JobTaxiLocations[GetRandomIntInRange(1, #Config.JobTaxiLocations)]
						local distance = #(playerCoords - targetCoords)
						while distance < Config.MinimumTaxiDistance do
							Citizen.Wait(5)

							targetCoords = Config.JobTaxiLocations[GetRandomIntInRange(1, #Config.JobTaxiLocations)]
							distance = #(playerCoords - targetCoords)
						end

						local street = table.pack(GetStreetNameAtCoord(targetCoords.x, targetCoords.y, targetCoords.z))
						local msg = nil

						if street[2] ~= 0 and street[2] ~= nil then
							msg = string.format('~s~Emmenez-moi s\'il vous plait', GetStreetNameFromHashKey(street[1]), GetStreetNameFromHashKey(street[2]))
						else
							msg = string.format('~s~Emmenez-moi s\'il vous plait', GetStreetNameFromHashKey(street[1]))
						end

						ESX.ShowNotification(msg)

						DestinationBlip = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)

						BeginTextCommandSetBlipName('STRING')
						AddTextComponentSubstringPlayerName('Destination')
						EndTextCommandSetBlipName(blip)
						SetBlipRoute(DestinationBlip, true)

						CustomerEnteredVehicle = true
					end
				else
					DrawMarker(36, customerCoords.x, customerCoords.y, customerCoords.z + 1.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 234, 223, 72, 155, false, false, 2, true, nil, nil, false)

					if not CustomerEnteredVehicle then
						if customerDistance <= 40.0 then

							if not IsNearCustomer then
								ESX.ShowNotification('Vous êtes à proximité du client, approchez-vous de lui.')
								IsNearCustomer = true
							end

						end

						if customerDistance <= 20.0 then
							if not CustomerIsEnteringVehicle then
								ClearPedTasksImmediately(CurrentCustomer)

								local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

								for i=maxSeats - 1, 0, -1 do
									if IsVehicleSeatFree(vehicle, i) then
										freeSeat = i
										break
									end
								end

								if freeSeat then
									TaskEnterVehicle(CurrentCustomer, vehicle, -1, freeSeat, 2.0, 0)
									CustomerIsEnteringVehicle = true
								end
							end
						end
					end
				end
			else
				DrawSub('Veuillez remonter dans votre véhicule pour continuer la mission', 5000)
			end
		end
	else
		Citizen.Wait(500)
	end
end)

AddEventHandler('fl_society:openMobileAction', function(society)
	if society == 'taxi' then
		OpenMobileTaxiActionsMenu()
	end
end)

-- Key Controls
CreateJobLoop('taxi', function()
	if CurrentAction and not ESX.IsPlayerDead() then
		ESX.ShowHelpNotification(CurrentActionMsg)

		if IsControlJustReleased(0, 38) then
			if CurrentAction == 'taxi_actions_menu' then
				OpenTaxiActionsMenu()
			elseif CurrentAction == 'cloakroom_taxi' then
				OpenTaxiCloakroom()
			elseif CurrentAction == 'vehicle_taxi_spawner' then
				OpenVehicleSpawnerTaxiMenu()
			elseif CurrentAction == 'delete_taxi_vehicle' then
				DeleteJobTaxiVehicle()
			end

			CurrentAction = nil
		end
	else
		Citizen.Wait(500)
	end
end)
