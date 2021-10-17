local blackout = false

RegisterNetEvent('vSync:blackout')
AddEventHandler('vSync:blackout', function(toggle)
	blackout = toggle
end)

--[[Citizen.CreateThread(function()
	SetRandomBoats(false)
	SetGarbageTrucks(false)
	SetCreateRandomCops(false)
	SetCreateRandomCopsNotOnScenarios(false)
	SetCreateRandomCopsOnScenarios(false)

	for i = 1, 12 do
		EnableDispatchService(i, false)
	end
	while true do
		Citizen.Wait(0)

		DisablePlayerVehicleRewards(PlayerId())

		if not blackout then
			SetPedDensityMultiplierThisFrame(0.0)
			SetParkedVehicleDensityMultiplierThisFrame(0.0)
			SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
			SetRandomVehicleDensityMultiplierThisFrame(0.0)
			SetVehicleDensityMultiplierThisFrame(0.0)
		else
			SetPedDensityMultiplierThisFrame(0.0)
			SetParkedVehicleDensityMultiplierThisFrame(0.0)
			SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
			SetRandomVehicleDensityMultiplierThisFrame(0.0)
			SetVehicleDensityMultiplierThisFrame(0.0)
		end
	end
end)]]--

Citizen.CreateThread(function()
	while true do
		Wait(10)
		SetRandomBoats(false)
		SetGarbageTrucks(false)
		SetCreateRandomCops(false)
		SetCreateRandomCopsNotOnScenarios(false)
		SetCreateRandomCopsOnScenarios(false)
		DisablePlayerVehicleRewards(PlayerId())
		SetPedDensityMultiplierThisFrame(0.0)
		SetParkedVehicleDensityMultiplierThisFrame(0.0)
		SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
		SetRandomVehicleDensityMultiplierThisFrame(0.0)
		SetVehicleDensityMultiplierThisFrame(0.0)
	end
end)

Citizen.CreateThread(function()
    while true 
    	do

		SetParkedVehicleDensityMultiplierThisFrame(0.0)
		
		local playerPed = GetPlayerPed(-1)
		local pos = GetEntityCoords(playerPed) 
		RemoveVehiclesFromGeneratorsInArea(pos['x'] - 5000.0, pos['y'] - 5000.0, pos['z'] - 5000.0, pos['x'] + 5000.0, pos['y'] + 5000.0, pos['z'] + 5000.0);
		
		SetGarbageTrucks(0)
		SetRandomBoats(0)
    	
		Citizen.Wait(1)
	end

end)

Citizen.CreateThread(function()
    while true do
        Wait(800)

        local player = GetPlayerPed(-1)
        local PlayerPedId = PlayerPedId(player)

        local veh = GetVehiclePedIsTryingToEnter(PlayerPedId)
        if veh ~= nil and DoesEntityExist(veh) then

            local lockStatus = GetVehicleDoorLockStatus(veh)
            if lockStatus == 7 then
                SetVehicleDoorsLocked(veh, 2)
            end

            local ped = GetPedInVehicleSeat(veh, -1)
            if ped then
                SetPedCanBeDraggedOut(ped, false)
            end

        end
    end
end)

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(10)
		ClearAreaOfVehicles (0.0, 0.0, 0.0, 200000000, false, false, false, false, false)
	    ClearAreaOfVehicles (0.0, 0.0, 0.0, 200000000, false, false, false, false, false)
	    ClearAreaOfVehicles (0.0, 0.0, 0.0, 200000000, false, false, false, false, false)
    end
end)

-- Peds in vehicle flee
--[[Citizen.CreateThread(function()
	local pointingPed = nil
	while true do
		local isFreeAiming, ped = GetEntityPlayerIsFreeAimingAt(PlayerId())

		if isFreeAiming then
			if not IsPedInAnyVehicle(PlayerPedId(), false) and IsPedArmed(PlayerPedId(), 4) then
				local vehicle = GetVehiclePedIsIn(ped)
				if vehicle ~= 0 then
					if pointingPed == ped then
						NetworkRequestControlOfEntity(pointingPed)
						repeat
							NetworkRequestControlOfEntity(pointingPed)
							Citizen.Wait(100)
						until NetworkHasControlOfEntity(pointingPed)
						print('Starting fleing...')
						ClearPedTasks(pointingPed)
						TaskLeaveVehicle(pointingPed, vehicle, 256)
						while IsPedInAnyVehicle(pointingPed, false) do
							Citizen.Wait(0)
						end
						SetBlockingOfNonTemporaryEvents(pointingPed, true)
						ResetPedLastVehicle(pointingPed)
						TaskReactAndFleePed(pointingPed, PlayerPedId())
					else
						pointingPed = ped
					end
				else
					pointingPed = nil
				end
			else
				Citizen.Wait(1000)
			end
		else
			pointingPed = nil
		end

		Citizen.Wait(400)
	end
end)]]--

Citizen.CreateThread(function()
	while true do
		for _,ped in pairs(ESX.Game.GetPeds()) do
			SetPedDropsWeaponsWhenDead(ped, false)
		end

		ClearPedBloodDamage(PlayerPedId()) -- Temp because OneSync Infinity desync
		InvalidateIdleCam()
		N_0x9e4cfff989258472() -- Disable the vehicle idle camera
		Citizen.Wait(1000)
	end
end)