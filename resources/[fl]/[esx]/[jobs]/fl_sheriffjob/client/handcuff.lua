local IsHandcuffed = false
local dragStatus = {}

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('fl_sheriffjob:unrestrain')
	end
end)

AddEventHandler('fl_sheriffjob:openHandcuffMenu', function()
	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'menu_menottes', {
		title = 'Menu Menottes',
		elements = {
				{label = 'Mettre les menottes', value = 'handcuff'},
				{label = 'Enlever les menottes', value = 'remove_handcuff'},
				{label = 'Escorter la personne', value = 'drag'},
				{label = 'Mettre dans le véhicule', value = 'put_in_vehicle'},
				{label = 'Retirer du véhicule', value = 'out_the_vehicle'},
			}
	}, function(data, menu)
		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
		if closestPlayer ~= -1 and closestDistance <= 3.0 then
			local action = data.current.value

			if action == 'handcuff' then
				local target, distance = ESX.Game.GetClosestPlayer()
				local playerheading = GetEntityHeading(PlayerPedId())
				local playerlocation = GetEntityForwardVector(PlayerPedId())
				local playerCoords = GetEntityCoords(PlayerPedId())
				local target_id = GetPlayerServerId(target)
				if distance <= 2.0 then
					TriggerServerEvent('fl_sheriffjob:requestarrest', target_id, playerheading, playerCoords, playerlocation)
					Wait(5000)
					TriggerServerEvent('fl_sheriffjob:handcuff', GetPlayerServerId(closestPlayer))
				else
					ESX.ShowNotification('~r~Personne proche de vous ...')
				end
			elseif action == 'remove_handcuff' then
				local target, distance = ESX.Game.GetClosestPlayer()
				local playerheading = GetEntityHeading(PlayerPedId())
				local playerlocation = GetEntityForwardVector(PlayerPedId())
				local playerCoords = GetEntityCoords(PlayerPedId())
				local target_id = GetPlayerServerId(target)
				TriggerServerEvent('fl_sheriffjob:requestrelease', target_id, playerheading, playerCoords, playerlocation)
				Wait(5000)
				TriggerServerEvent('fl_sheriffjob:handcuff', GetPlayerServerId(closestPlayer))
			elseif action == 'drag' then
				TriggerServerEvent('fl_sheriffjob:drag', GetPlayerServerId(closestPlayer))
			elseif action == 'put_in_vehicle' then
				TriggerServerEvent('fl_sheriffjob:putInVehicle', GetPlayerServerId(closestPlayer))
			elseif action == 'out_the_vehicle' then
				TriggerServerEvent('fl_sheriffjob:OutVehicle', GetPlayerServerId(closestPlayer))
			end
		else
			ESX.ShowNotification('~r~Pas de joueurs proches')
		end

	end, function(data, menu)
		menu.close()
	end)
end)

RegisterNetEvent('fl_sheriffjob:handcuff')
AddEventHandler('fl_sheriffjob:handcuff', function()
	IsHandcuffed = not IsHandcuffed
	local playerPed = PlayerPedId()

	Citizen.CreateThread(function()
		if IsHandcuffed then
			RequestAnimDict('mp_arresting')
			while not HasAnimDictLoaded('mp_arresting') do
				Citizen.Wait(100)
			end

			TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 53, 0, 0, 0, 0)
			DisablePlayerFiring(playerPed, true)
			SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true)
			SetPedCanPlayGestureAnims(playerPed, false)
			DisplayRadar(false)
		else
			ClearPedSecondaryTask(playerPed)
			DisablePlayerFiring(playerPed, false)
			SetPedCanPlayGestureAnims(playerPed, true)
			FreezeEntityPosition(playerPed, false)
			DisplayRadar(true)
		end
	end)
end)

RegisterNetEvent('fl_sheriffjob:unrestrain')
AddEventHandler('fl_sheriffjob:unrestrain', function()
	if IsHandcuffed then
		local playerPed = PlayerPedId()
		IsHandcuffed = false

		ClearPedSecondaryTask(playerPed)
		DisablePlayerFiring(playerPed, false)
		SetPedCanPlayGestureAnims(playerPed, true)
		FreezeEntityPosition(playerPed, false)
		DisplayRadar(true)
	end
end)

RegisterNetEvent('fl_sheriffjob:dragErrorResponse')
AddEventHandler('fl_sheriffjob:dragErrorResponse', function()
	ESX.ShowNotification('~r~La personne n\'a pas de menotte...')
end)

RegisterNetEvent('fl_sheriffjob:drag')
AddEventHandler('fl_sheriffjob:drag', function(copId)
	if not IsHandcuffed then
		TriggerServerEvent('fl_sheriffjob:dragErrorResponse', copId)
		return
	end

	dragStatus.isDragged = not dragStatus.isDragged
	dragStatus.CopId = copId
end)

Citizen.CreateThread(function()
	local playerPed
	local targetPed

	while true do
		Citizen.Wait(1)

		if IsHandcuffed then
			playerPed = PlayerPedId()

			if dragStatus.isDragged then
				local pp = GetPlayerFromServerId(dragStatus.CopId)
				if pp ~= -1 then
					targetPed = GetPlayerPed(pp)

					-- undrag if target is in an vehicle
					if not IsPedInAnyVehicle(targetPed, true) then
						AttachEntityToEntity(playerPed, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
					else
						dragStatus.isDragged = false
						DetachEntity(playerPed, true, false)
					end

					if IsPedDeadOrDying(targetPed, true) then
						dragStatus.isDragged = false
						DetachEntity(playerPed, true, false)
					end
				end

			else
				DetachEntity(playerPed, true, false)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('fl_sheriffjob:putInVehicle')
AddEventHandler('fl_sheriffjob:putInVehicle', function()
	if not IsHandcuffed then
		TriggerServerEvent('fl_sheriffjob:dragErrorResponse', copId)
		return
	end

	local coords = GetEntityCoords(playerPed)
	local vehicle, distance = ESX.Game.GetClosestVehicle()

	if DoesEntityExist(vehicle) and distance < 8 then
		local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

		for i=maxSeats - 1, 0, -1 do
			if IsVehicleSeatFree(vehicle, i) then
				freeSeat = i
				break
			end
		end

		if freeSeat then
			TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, freeSeat)
			dragStatus.isDragged = false
		else
			print('No free seat')
		end
	else
		print('v2 Closest no' .. tostring(distance))
	end
end)

RegisterNetEvent('fl_sheriffjob:OutVehicleErrorResponse')
AddEventHandler('fl_sheriffjob:OutVehicleErrorResponse', function()
	ESX.ShowNotification('~r~La personne n\'est pas dans un véhicule')
end)

RegisterNetEvent('fl_sheriffjob:OutVehicle')
AddEventHandler('fl_sheriffjob:OutVehicle', function(copId)
	local playerPed = PlayerPedId()

	if not IsPedSittingInAnyVehicle(playerPed) then
		TriggerServerEvent('fl_sheriffjob:OutVehicleErrorResponse', copId)
		return
	end

	local vehicle = GetVehiclePedIsIn(playerPed, false)
	TaskLeaveVehicle(playerPed, vehicle, 16)
end)

-- Handcuff
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()

		if IsHandcuffed then
            DisableControlAction(0, 24, true) -- Attack
            DisableControlAction(0, 257, true) -- Attack 2
            DisableControlAction(0, 25, true) -- Aim
            DisableControlAction(0, 263, true) -- Melee Attack 1
            DisableControlAction(0, 166, true) -- F5
            DisableControlAction(0, 45, true) -- Reload
            DisableControlAction(0, 22, true) -- Jump
            DisableControlAction(0, 44, true) -- Cover
            DisableControlAction(0, 37, true) -- Select Weapon
			DisableControlAction(0, 99, true) -- Next Weapon
            DisableControlAction(0, 100, true) -- Prec Weapon
            -- DisableControlAction(0, 23, true) -- Enter vehicle

            DisableControlAction(0, 288, true) -- F1
            DisableControlAction(0, 289, true) -- F2
            DisableControlAction(0, 170, true) -- Animations
            --DisableControlAction(0, 167, true) -- Job
            DisableControlAction(0, 168, true) -- Job
            DisableControlAction(0, 29, true) -- Pointing
            DisableControlAction(0, 32, true) -- Holster
            DisableControlAction(0, 74, true) -- H
            DisableControlAction(0, 38, true) -- E
            DisableControlAction(0, 243, true) -- ²

            DisableControlAction(0, 0, true) -- Disable changing view
            DisableControlAction(0, 26, true) -- Disable looking behind
            DisableControlAction(0, 73, true) -- Disable clearing animation
            DisableControlAction(2, 199, true) -- Disable pause screen

            DisableControlAction(0, 59, true) -- Disable steering in vehicle
            DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
            DisableControlAction(0, 72, true) -- Disable reversing in vehicle

            DisableControlAction(2, 36, true) -- Disable going stealth

            DisableControlAction(0, 47, true)  -- Disable weapon
            DisableControlAction(0, 264, true) -- Disable melee
            DisableControlAction(0, 257, true) -- Disable melee
            DisableControlAction(0, 140, true) -- Disable melee
            DisableControlAction(0, 141, true) -- Disable melee
            DisableControlAction(0, 142, true) -- Disable melee
            DisableControlAction(0, 143, true) -- Disable melee
            DisableControlAction(0, 75, true)  -- Disable exit vehicle
            DisableControlAction(27, 75, true) -- Disable exit vehicle

			SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true)

			if IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) ~= 1 and not IsEntityInWater(PlayerPedId()) then
				ESX.Streaming.RequestAnimDict('mp_arresting', function()
					TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 53, 0.0, false, false, false)
				end)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

-- Nouvelle menotte

function LoadAnimDictionary(dictname)
	if not HasAnimDictLoaded(dictname) then
		RequestAnimDict(dictname)
		while not HasAnimDictLoaded(dictname) do
			Citizen.Wait(1)
		end
		RemoveAnimDict(dictname)
	end
end

RegisterNetEvent('fl_sheriffjob:getarrested')
AddEventHandler('fl_sheriffjob:getarrested', function(playerheading, playercoords, playerlocation)
	local playerPed = PlayerPedId()
	SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true)
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	SetEntityCoords(playerPed, x, y, z)
	SetEntityHeading(playerPed, playerheading)
	Citizen.Wait(250)
	TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'cuffseffect', 0.7)
	LoadAnimDictionary('mp_arrest_paired')
	TaskPlayAnim(playerPed, 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8, 3750 , 2, 0, 0, 0, 0)
	Citizen.Wait(3760)
	cuffed = true
	LoadAnimDictionary('mp_arresting')
	TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
end)

RegisterNetEvent('fl_sheriffjob:doarrested')
AddEventHandler('fl_sheriffjob:doarrested', function()
	Citizen.Wait(250)
	LoadAnimDictionary('mp_arrest_paired')
	TaskPlayAnim(PlayerPedId(), 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8,3750, 2, 0, 0, 0, 0)
	Citizen.Wait(3000)
end)

RegisterNetEvent('fl_sheriffjob:douncuffing')
AddEventHandler('fl_sheriffjob:douncuffing', function()
	Citizen.Wait(250)
	LoadAnimDictionary('mp_arresting')
	TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'a_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Citizen.Wait(5500)
	ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent('fl_sheriffjob:getuncuffed')
AddEventHandler('fl_sheriffjob:getuncuffed', function(playerheading, playercoords, playerlocation)
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	z = z - 1.0
	SetEntityCoords(PlayerPedId(), x, y, z)
	SetEntityHeading(PlayerPedId(), playerheading)
	Citizen.Wait(250)
	LoadAnimDictionary('mp_arresting')
	TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'b_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Citizen.Wait(5500)
	cuffed = false
	ClearPedTasks(PlayerPedId())
end)