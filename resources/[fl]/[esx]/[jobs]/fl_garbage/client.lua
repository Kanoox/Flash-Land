local currentstop = 0
local HasAlreadyEnteredArea, clockedin, vehiclespawned, albetogetbags, truckdeposit = false, false, false, false, false
local work_truck, NewDrop, LastDrop, binpos, truckpos, garbagebag, truckplate, mainblip, AreaType, AreaInfo, currentZone, currentstop, AreaMarker
local Blips, CollectionJobs, depositlist = {}, {}, {}

Citizen.CreateThread(function()
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.JobName then
		mainblip = AddBlipForCoord(Config.Zones[2].pos)

		SetBlipSprite (mainblip, 318)
		SetBlipDisplay(mainblip, 4)
		SetBlipScale (mainblip, 0.8)
		SetBlipColour (mainblip, 5)
		SetBlipAsShortRange(mainblip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(_U('blip_job'))
		EndTextCommandSetBlipName(mainblip)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	TriggerServerEvent('fl_garbagecrew:setconfig')
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	TriggerEvent('fl_garbagecrew:checkjob')
end)

RegisterNetEvent('fl_garbagecrew:movetruckcount')
AddEventHandler('fl_garbagecrew:movetruckcount', function(count)
	Config.TruckPlateNumb = count
end)

RegisterNetEvent('fl_garbagecrew:updatejobs')
AddEventHandler('fl_garbagecrew:updatejobs', function(newjobtable)
	CollectionJobs = newjobtable
end)

RegisterNetEvent('fl_garbagecrew:selectnextjob')
AddEventHandler('fl_garbagecrew:selectnextjob', function()
	if currentstop < Config.MaxStops then
		SetVehicleDoorShut(work_truck, 5, false)
		SetBlipRoute(Blips['delivery'], false)
		FindDeliveryLoc()
		albetogetbags = false
	else
		NewDrop = nil
		oncollection = false
		SetVehicleDoorShut(work_truck, 5, false)
		RemoveBlip(Blips['delivery'])
		SetBlipRoute(Blips['endmission'], true)
		albetogetbags = false
		ESX.ShowNotification(_U('return_depot'))
	end
end)

RegisterNetEvent('fl_garbagecrew:enteredarea')
AddEventHandler('fl_garbagecrew:enteredarea', function(zone)
	CurrentAction = zone.name

	if CurrentAction == 'timeclock'  and IsGarbageJob() then
		MenuCloakRoom()
	end

	if CurrentAction == 'vehiclelist' then
		if clockedin and not vehiclespawned then
			MenuVehicleSpawner()
		end
	end

	if CurrentAction == 'endmission' and vehiclespawned then
		CurrentActionMsg = _U('cancel_mission')
	end

	if CurrentAction == 'collection' and not albetogetbags then
		if IsPedInAnyVehicle(PlayerPedId()) and GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false)) == worktruckplate then
			CurrentActionMsg = _U('collection')
		else
			CurrentActionMsg = _U('need_work_truck')
		end
	end

	if CurrentAction == 'bagcollection' then
		if zone.bagsremaining > 0 then
			CurrentActionMsg = _U('collect_bags', tostring(zone.bagsremaining))
		else
			CurrentActionMsg = nil
		end
	end

	if CurrentAction == 'deposit' then
		CurrentActionMsg = _U('toss_bag')
	end

end)

RegisterNetEvent('fl_garbagecrew:leftarea')
AddEventHandler('fl_garbagecrew:leftarea', function()
	ESX.UI.Menu.CloseAll()
    CurrentAction = nil
	CurrentActionMsg = ''
end)

CreateJobLoop('garbage', function()
	local sleep = 500
	ply = PlayerPedId()
	plyloc = GetEntityCoords(ply)

	for i, v in pairs(Config.Zones) do
		if #(plyloc - v.pos)  < 20.0 and ESX.PlayerLoaded then
			sleep = 0
			if v.name == 'timeclock' and IsGarbageJob() then
				DrawMarker(1, v.pos.x, v.pos.y, v.pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.size,  v.size, 1.0, 204,204, 0, 100, false, true, 2, false, false, false, false)
			elseif v.name == 'endmission' and vehiclespawned then
				DrawMarker(1, v.pos.x, v.pos.y, v.pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0,  v.size,  v.size, 1.0, 204,204, 0, 100, false, true, 2, false, false, false, false)
			elseif v.name == 'vehiclelist' and clockedin and not vehiclespawned then
				DrawMarker(1, v.pos.x, v.pos.y, v.pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0,  v.size,  v.size, 1.0, 204,204, 0, 100, false, true, 2, false, false, false, false)
			end
		end
	end

	for i, v in pairs(CollectionJobs)  do
		if #(plyloc - v.pos) < 10.0 and truckpos == nil then
			sleep = 0
			DrawMarker(1, v.pos.x,  v.pos.y,  v.pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0,  3.0,  3.0, 1.0, 255,0, 0, 100, false, true, 2, false, false, false, false)
			break
		end
	end

	if truckpos ~= nil then
		if #(plyloc - truckpos) < 10.0  then
			sleep = 0
			DrawMarker(20, truckpos.x,  truckpos.y,  truckpos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0,  1.0, 1.0, 1.0, 0,100, 0, 100, false, true, 2, false, false, false, false)
		end
	end

	if oncollection then
		if #(plyloc - NewDrop.pos) < 20.0 and not albetogetbags then
			sleep = 0
			DrawMarker(1, NewDrop.pos.x,  NewDrop.pos.y,  NewDrop.pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0,  NewDrop.size,  NewDrop.size, 1.0, 204,204, 0, 100, false, true, 2, false, false, false, false)
		end
	end

	Citizen.Wait(sleep)
end)

AddEventHandler('fl_garbagecrew:checkjob', function()
	if ESX.PlayerData.job.name ~= Config.JobName then
		if mainblip ~= nil then
			RemoveBlip(mainblip)
			mainblip = nil
		end
	elseif mainblip == nil then
		mainblip = AddBlipForCoord(Config.Zones[2].pos)

		SetBlipSprite (mainblip, 318)
		SetBlipDisplay(mainblip, 4)
		SetBlipScale (mainblip, 0.8)
		SetBlipColour (mainblip, 5)
		SetBlipAsShortRange(mainblip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(_U('blip_job'))
		EndTextCommandSetBlipName(mainblip)
	end
end)

CreateJobLoop('garbage', function()
	if CurrentAction ~= nil and CurrentActionMsg ~= nil then
		SetTextComponentFormat('STRING')
		AddTextComponentString(CurrentActionMsg)
		DisplayHelpTextFromStringLabel(0, 0, 1, -1)

		if IsControlJustReleased(0, 38) then
			if CurrentAction == 'endmission' then
				if IsPedInAnyVehicle(PlayerPedId()) then
					local getvehicle = GetVehiclePedIsIn(PlayerPedId(), false)
					TaskLeaveVehicle(PlayerPedId(), getvehicle, 0)
				end
				while IsPedInAnyVehicle(PlayerPedId()) do
					Citizen.Wait(0)
				end
				DeleteVehicle(work_truck)
				if Blips['delivery'] ~= nil then
					RemoveBlip(Blips['delivery'])
					Blips['delivery'] = nil
				end

				if Blips['endmission'] ~= nil then
					RemoveBlip(Blips['endmission'])
					Blips['endmission'] = nil
				end
				SetBlipRoute(Blips['delivery'], false)
				SetBlipRoute(Blips['endmission'], false)
				vehiclespawned = false
				albetogetbags = false
				CurrentAction =nil
				CurrentActionMsg = nil
			end

			if CurrentAction == 'collection' then
				if CurrentActionMsg == _U('collection') then
					SelectBinAndCrew(GetEntityCoords(PlayerPedId()))
					CurrentAction = nil
					CurrentActionMsg  = nil
					IsInArea = false
				end
			end

			if CurrentAction == 'bagcollection' then
				CurrentAction = nil
				CurrentActionMsg = nil
				CollectBagFromBin(currentZone)
				IsInArea = false
			end

			if CurrentAction == 'deposit' then
				CurrentAction = nil
				CurrentActionMsg = nil
				PlaceBagInTruck(currentZone)
				IsInArea = false
			end
		end
	end
end)

-- thread so the script knows you have entered a markers area -
CreateJobLoop('garbage', function()
	local sleep = 1000
	ply = PlayerPedId()
	plyloc = GetEntityCoords(ply)
	IsInArea = false
	currentZone = nil

	for i,v in pairs(Config.Zones) do
		if #(plyloc - v.pos)  <  v.size then
			IsInArea = true
			currentZone = v
		end
	end

	if oncollection and not albetogetbags then
		if #(plyloc - NewDrop.pos)  <  NewDrop.size then
			IsInArea = true
			currentZone = NewDrop
		end
	end

	if truckpos ~= nil then
		if #(plyloc - truckpos)  <  2.0 then
			IsInArea = true
			currentZone = {type = 'Deposit', name = 'deposit', pos = truckpos,}
		end
	end

	for i,v in pairs(CollectionJobs) do
		if #(plyloc - v.pos)  <  2.0 and truckpos == nil then
			IsInArea = true
			currentZone = v
		end
	end

	if IsInArea and not HasAlreadyEnteredArea then
		HasAlreadyEnteredArea = true
		sleep = 0
		TriggerEvent('fl_garbagecrew:enteredarea', currentZone)
	end

	if not IsInArea and HasAlreadyEnteredArea then
		HasAlreadyEnteredArea = false
		sleep = 1000
		TriggerEvent('fl_garbagecrew:leftarea', currentZone)
	end

	Citizen.Wait(sleep)
end)

function CollectBagFromBin(currentZone)
	binpos = currentZone.pos
	truckplate = currentZone.trucknumber

	if not HasAnimDictLoaded("anim@heists@narcotics@trash") then
		RequestAnimDict("anim@heists@narcotics@trash")
		while not HasAnimDictLoaded("anim@heists@narcotics@trash") do
			Citizen.Wait(0)
		end
	end

	local worktruck = NetworkGetEntityFromNetworkId(currentZone.truckid)

	if DoesEntityExist(worktruck) and #(GetEntityCoords(worktruck) - GetEntityCoords(PlayerPedId())) < 25.0 then
		truckpos = GetOffsetFromEntityInWorldCoords(worktruck, 0.0, -5.25, 0.0)
		if not Config.Debug then
			TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)
		end
		TriggerServerEvent('fl_garbagecrew:bagremoval', currentZone.pos, currentZone.trucknumber)
		trashcollection = false
		if not Config.Debug then
			Citizen.Wait(4000)
		end
		ClearPedTasks(PlayerPedId())
		local randombag = math.random(0,2)

		if randombag == 0 then
			garbagebag = CreateObject(`prop_cs_street_binbag_01`, 0, 0, 0, true, true, true) -- creates object
			AttachEntityToEntity(garbagebag, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.4, 0, 0, 0, 270.0, 60.0, true, true, false, true, 1, true) -- object is attached to right hand
		elseif randombag == 1 then
			garbagebag = CreateObject(`bkr_prop_fakeid_binbag_01`, 0, 0, 0, true, true, true) -- creates object
			AttachEntityToEntity(garbagebag, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), .65, 0, -.1, 0, 270.0, 60.0, true, true, false, true, 1, true) -- object is attached to right hand
		elseif randombag == 2 then
			garbagebag = CreateObject(`hei_prop_heist_binbag`, 0, 0, 0, true, true, true) -- creates object
			AttachEntityToEntity(garbagebag, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.12, 0.0, 0.00, 25.0, 270.0, 180.0, true, true, false, true, 1, true) -- object is attached to right hand
		end

		TaskPlayAnim(PlayerPedId(), 'anim@heists@narcotics@trash', 'walk', 1.0, -1.0,-1,49,0,0, 0,0)
		CurrentAction = nil
		CurrentActionMsg = nil
		HasAlreadyEnteredArea = false
	else
		ESX.ShowNotification(_U('not_near_truck'))
		TriggerServerEvent('fl_garbagecrew:unknownlocation', currentZone.pos)
	end
end

function PlaceBagInTruck(thiszone)
	if not HasAnimDictLoaded("anim@heists@narcotics@trash") then
		RequestAnimDict("anim@heists@narcotics@trash")
		while not HasAnimDictLoaded("anim@heists@narcotics@trash") do
			Citizen.Wait(0)
		end
	end
	ClearPedTasksImmediately(PlayerPedId())
	TaskPlayAnim(PlayerPedId(), 'anim@heists@narcotics@trash', 'throw_b', 1.0, -1.0,-1,2,0,0, 0,0)
	Citizen.Wait(800)
	local garbagebagdelete = DeleteEntity(garbagebag)
	Citizen.Wait(100)
	ClearPedTasksImmediately(PlayerPedId())
	CurrentAction = nil
	CurrentActionMsg = nil
	depositlist = nil
	truckpos = nil
	TriggerServerEvent('fl_garbagecrew:bagdumped', binpos, truckplate)
	HasAlreadyEnteredArea = false
end

function SelectBinAndCrew(location)
	local bin = nil

	for i, v in pairs(Config.DumptersAvailable) do
		bin = GetClosestObjectOfType(location, 20.0, v, false, false, false )
		if bin ~= 0 then
			if CollectionJobs[GetEntityCoords(bin)] == nil then
				break
			else
				bin = 0
			end
		end
	end
	if bin ~= 0 then
		truckplate = GetVehicleNumberPlateText(work_truck)
		truckid = NetworkGetNetworkIdFromEntity(work_truck)
		TriggerServerEvent('fl_garbagecrew:setworkers', GetEntityCoords(bin), truckplate, truckid )
		truckpos = nil
		albetogetbags = true
		SetBlipRoute(Blips['delivery'], false)
		currentstop = currentstop + 1
		SetVehicleDoorOpen(work_truck, 5, false, false)
	else
		ESX.ShowNotification( _U('no_trash_aviable'))
		SetBlipRoute(Blips['endmission'], true)
		FindDeliveryLoc()
	end
end

function FindDeliveryLoc()
	if LastDrop ~= nil then
		lastregion = GetNameOfZone(LastDrop.pos)
	end
	local newdropregion = nil
	while newdropregion == nil or newdropregion == lastregion do
		randomloc = math.random(1, #Config.Collections)
		newdropregion = GetNameOfZone(Config.Collections[randomloc].pos)
	end
	NewDrop = Config.Collections[randomloc]
	LastDrop = NewDrop
	if Blips['delivery'] ~= nil then
		RemoveBlip(Blips['delivery'])
		Blips['delivery'] = nil
	end

	if Blips['endmission'] ~= nil then
		RemoveBlip(Blips['endmission'])
		Blips['endmission'] = nil
	end

	Blips['delivery'] = AddBlipForCoord(NewDrop.pos)
	SetBlipSprite (Blips['delivery'], 318)
	SetBlipAsShortRange(Blips['delivery'], true)
	SetBlipRoute(Blips['delivery'], true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(_U('blip_delivery'))
	EndTextCommandSetBlipName(Blips['delivery'])

	Blips['endmission'] = AddBlipForCoord(Config.Zones[1].pos)
	SetBlipSprite (Blips['endmission'], 318)
	SetBlipColour(Blips['endmission'], 1)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(_U('blip_goal'))
	EndTextCommandSetBlipName(Blips['endmission'])

	oncollection = true
	ESX.ShowNotification(_U('drive_to_collection'))
end

function IsGarbageJob()
	return ESX and ESX.PlayerData.job and ESX.PlayerData.job.name == Config.JobName
end

function MenuCloakRoom()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'cloakroom', {
			title    = _U('cloakroom'),
			elements = {
				{label = _U('job_wear'), value = 'job_wear'},
				{label = _U('citizen_wear'), value = 'citizen_wear'},
				{label = 'Garde robe perso', value = 'clotheshop'},
			}}, function(data, menu)
			if data.current.value == 'citizen_wear' then
				clockedin = false
				ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
				end)
			elseif data.current.value == 'job_wear' then
				clockedin = true
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

function MenuVehicleSpawner()
	local elements = {}

	for i=1, #Config.Trucks, 1 do
		table.insert(elements, {label = GetLabelText(GetDisplayNameFromVehicleModel(Config.Trucks[i])), value = Config.Trucks[i]})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'vehiclespawner', {
			title = _U('vehiclespawner'),
			elements = elements
		}, function(data, menu)
			ESX.Game.SpawnVehicle(data.current.value, Config.VehicleSpawn.pos, 270.0, function(vehicle)
				local trucknumber = Config.TruckPlateNumb + 1
				if trucknumber <=9 then
					SetVehicleNumberPlateText(vehicle, 'GCREW00'..trucknumber)
					worktruckplate =   'GCREW00'..trucknumber
				elseif trucknumber <=99 then
					SetVehicleNumberPlateText(vehicle, 'GCREW0'..trucknumber)
					worktruckplate =   'GCREW0'..trucknumber
				else
					SetVehicleNumberPlateText(vehicle, 'GCREW'..trucknumber)
					worktruckplate =   'GCREW'..trucknumber
				end
				TriggerServerEvent('fl_garbagecrew:movetruckcount')
				SetEntityAsMissionEntity(vehicle,true, true)
				TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
				SetVehicleFixed(vehicle)
				vehiclespawned = true
				albetogetbags = false
				work_truck = vehicle

				currentstop = 0
				FindDeliveryLoc()
			end)

			menu.close()
		end, function(data, menu)
			menu.close()
		end)
end
