local IsAnimated = false

AddEventHandler('fl_basicneeds:isEating', function(cb)
	cb(IsAnimated)
end)

RegisterNetEvent('fl_basicneeds:onEat')
AddEventHandler('fl_basicneeds:onEat', function(prop_name)
	if not IsAnimated then
		IsAnimated = true
		local playerPed = PlayerPedId()
		Citizen.CreateThread(function()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
			AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 18905), 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
			RequestAnimDict('amb@code_human_wander_eating_donut@male@idle_a')
			while not HasAnimDictLoaded('amb@code_human_wander_eating_donut@male@idle_a') do
				Citizen.Wait(1)
			end
			TaskPlayAnim(playerPed, 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_c', 8.0, -8, -1, 49, 0, 0, 0, 0)
			Wait(4000)
			IsAnimated = false
			ClearPedSecondaryTask(playerPed)
			DeleteObject(prop)
		end)
	end
end)

RegisterNetEvent('fl_basicneeds:onDrink')
AddEventHandler('fl_basicneeds:onDrink', function(prop_name)
	if not IsAnimated then
		IsAnimated = true
		local playerPed = PlayerPedId()
		Citizen.CreateThread(function()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2,  true,  true, true)
			AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 57005), 0.13, 0.02, -0.05, -85.0, 175.0, 0.0, true, true, false, true, 1, true)
			RequestAnimDict('amb@code_human_wander_drinking@male@idle_a')
			while not HasAnimDictLoaded('amb@code_human_wander_drinking@male@idle_a') do
				Citizen.Wait(1)
			end
			TaskPlayAnim(playerPed, 'amb@code_human_wander_drinking@male@idle_a', 'idle_c', 8.0, -8, -1, 49, 0, 0, 0, 0)
			Wait(4000)
			IsAnimated = false
			ClearPedSecondaryTask(playerPed)
			DeleteObject(prop)
		end)
	end
end)

RegisterNetEvent('fl_basicneeds:onSmoke')
AddEventHandler('fl_basicneeds:onSmoke', function(prop_name)
	if not IsAnimated then
		IsAnimated = true
		local playerPed = PlayerPedId()
		Citizen.CreateThread(function()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2,  true,  true, true)
				AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 58868), 0.01, 0.025, 0.019, 10.0, 190.0, 50.0, true, true, false, true, 1, true)
			RequestAnimDict('amb@world_human_aa_smoke@male@idle_a')
			while not HasAnimDictLoaded('amb@world_human_aa_smoke@male@idle_a') do
				Wait(1)
			end
			TaskPlayAnim(playerPed, 'amb@world_human_aa_smoke@male@idle_a', 'idle_a', 8.0, -8, -1, 49, 0, 0, 0, 0)
			Wait(40000)
			IsAnimated = false
			ClearPedSecondaryTask(playerPed)
			DeleteObject(prop)
		end)
	end
end)

RegisterNetEvent('fl_basicneeds:onBacterium1')
AddEventHandler('fl_basicneeds:onBacterium1', function()
	local playerPed = PlayerPedId()
	local health = GetEntityHealth(playerPed) - 25
	SetEntityHealth(playerPed,  health)
end)

RegisterNetEvent('fl_basicneeds:onBacterium2')
AddEventHandler('fl_basicneeds:onBacterium2', function()
	DoScreenFadeOut(1000)
	Citizen.Wait(1000)
	ClearPedTasksImmediately(PlayerPedId())
	SetTimecycleModifier("spectator5")
	SetPedMotionBlur(PlayerPedId(), true)
	SetPedMovementClipset(PlayerPedId(), "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
	SetPedIsDrunk(PlayerPedId(), true)
	DoScreenFadeIn(1000)
	Citizen.Wait(300000)
	DoScreenFadeOut(1000)
	Citizen.Wait(1000)
	DoScreenFadeIn(1000)
	ClearTimecycleModifier()
	ResetScenarioTypesEnabled()
	ResetPedMovementClipset(PlayerPedId(), 0)
	SetPedIsDrunk(PlayerPedId(), false)
	SetPedMotionBlur(PlayerPedId(), false)
end)

RegisterNetEvent('fl_basicneeds:offBacterium')
AddEventHandler('fl_basicneeds:offBacterium', function()
	ClearTimecycleModifier()
	ResetScenarioTypesEnabled()
	ResetPedMovementClipset(PlayerPedId(), 0)
	SetPedIsDrunk(PlayerPedId(), false)
	SetPedMotionBlur(PlayerPedId(), false)
end)

RegisterNetEvent('fl_basicneeds:onPot')
AddEventHandler('fl_basicneeds:onPot', function()
	ESX.Streaming.RequestAnimSet("MOVE_M@DRUNK@SLIGHTLYDRUNK")
	TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_SMOKING_POT", 0, true)
	Citizen.Wait(5000)
	DoScreenFadeOut(1000)
	Citizen.Wait(1000)
	ClearPedTasksImmediately(PlayerPedId())
	SetTimecycleModifier("spectator5")
	SetPedMotionBlur(PlayerPedId(), true)
	SetPedMovementClipset(PlayerPedId(), "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
	SetPedIsDrunk(PlayerPedId(), true)
	DoScreenFadeIn(1000)
	Citizen.Wait(600000)
	DoScreenFadeOut(1000)
	Citizen.Wait(1000)
	DoScreenFadeIn(1000)
	ClearTimecycleModifier()
	ResetScenarioTypesEnabled()
	ResetPedMovementClipset(PlayerPedId(), 0)
	SetPedIsDrunk(PlayerPedId(), false)
	SetPedMotionBlur(PlayerPedId(), false)
end)

RegisterNetEvent('fl_basicneeds:onEatCoke')
AddEventHandler('fl_basicneeds:onEatCoke', function()
	local playerPed = PlayerPedId()
	SetTimecycleModifier("spectator4")
	SetPedMovementClipset(playerPed, "MOVE_M@BRAVE@A", true)

	if GetPedArmour(playerPed) < 50 and not hasDrugEffect then
		AddArmourToPed(playerPed, math.random(20, 30))
	else
		AddArmourToPed(playerPed, 5)
		TriggerEvent('esx:showNotification', 'La ~r~Coke~s~ n\'a pas eu d\'effet sur vous')
	end

	startDrugTimer()
	SetPlayerHealthRechargeMultiplier(playerPed, 2.5)
	local timeToWait = GetGameTimer() + 30000
	while GetGameTimer() < timeToWait do
		SetTimecycleModifier("spectator4")
		Citizen.Wait(100)
	end
	ClearTimecycleModifier()
end)

RegisterNetEvent('fl_basicneeds:traceur')
AddEventHandler('fl_basicneeds:traceur', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(PlayerPedId())
	local veh, distance = ESX.Game.GetClosestVehicle({x = coords.x, y = coords.y, z = coords.z})

	if distance < 2 then
		TaskStartScenarioInPlace(PlayerPedId(), "world_human_vehicle_mechanic", 0, false)
		Citizen.SetTimeout(10 * 1000, function()
			ClearPedTasksImmediately(playerPed)

			local vehicle, distance = ESX.Game.GetClosestVehicle({x = coords.x, y = coords.y, z = coords.z})

			if veh == vehicle and distance < 2 then
				vehBlip = AddBlipForEntity(veh)
				SetBlipColour(vehBlip, 1)
				timer = math.random(60, 220)
				InTraceur()
				TriggerEvent('esx:showNotification', 'Vous venez de poser un ~y~traceur~s~.' )
			else
				TriggerEvent('esx:showNotification', 'Il semblerais que la voiture soit partie' )
			end
		end)
	else
		TriggerEvent('esx:showNotification', 'Vous êtes trop loin du vehicule.')
	end
end)

function InTraceur()
	while timer > 0 do
		Citizen.Wait(1000)
		if timer == 30 then
			TriggerEvent('esx:showNotification', 'Votre ~y~traceur~s~ semble devenir defectueux.')
		end
		timer = timer - 1
	end

	TriggerEvent('esx:showNotification', 'Votre ~y~traceur~s~ ne donne plus aucun signal .')
	RemoveBlip(vehBlip)
end

RegisterNetEvent('fl_basicneeds:onEatSteroids')
AddEventHandler('fl_basicneeds:onEatSteroids', function()
	local time = 20
	repeat
		Citizen.Wait(1000)

		SetTimecycleModifier("VolticFlash")
		SetPedMovementClipset(PlayerPedId(), "move_m@gangster@var_i", -1)
		SetRunSprintMultiplierForPlayer(PlayerId(), 1.3)
		ResetPlayerStamina(PlayerId())
		time =  time - 1
	until time <= 0

	ResetPedMovementClipset(PlayerPedId(), 0)
	SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
	ClearTimecycleModifier()
end)

local hasDrugEffect = false

RegisterNetEvent('fl_basicneeds:meth')
AddEventHandler('fl_basicneeds:meth', function()
    applyDrugsEffects()
    methDrugEffect()
end)

RegisterNetEvent('fl_basicneeds:weed')
AddEventHandler('fl_basicneeds:weed', function()
    applyDrugsEffects()
    weedDrugEffect()
end)

RegisterNetEvent('fl_basicneeds:shit')
AddEventHandler('fl_basicneeds:shit', function()
    applyDrugsEffects()
    shitDrugEffect()
end)

RegisterNetEvent('fl_basicneeds:opium')
AddEventHandler('fl_basicneeds:opium', function()
    applyDrugsEffects()
    opiumDrugEffect()
end)

-- Start the 10 minutes timer for drugs
function startDrugTimer()
    Citizen.CreateThread(function()
        hasDrugEffect = true

        local timeToWait = GetGameTimer() + Config.TimeBetweenDrugs
        while GetGameTimer() < timeToWait do
            Citizen.Wait(1)
        end

        hasDrugEffect = false
    end)
end

function applyDrugsEffects()
    -- If the player already has consum drug in less than 10 minutes
    if hasDrugEffect then
        SetEntityHealth(PlayerPedId(), 0)
        return
    end

    -- Start 10 minutes timer
    startDrugTimer()

    -- Apply drug effect
    ESX.Streaming.RequestAnimSet("MOVE_M@DRUNK@SLIGHTLYDRUNK")
	TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_SMOKING_POT", 0, true)
	Citizen.Wait(5000)
	DoScreenFadeOut(1000)
	Citizen.Wait(1000)
	ClearPedTasksImmediately(PlayerPedId())
	SetTimecycleModifier("spectator5")
	SetPedMotionBlur(PlayerPedId(), true)
	SetPedMovementClipset(PlayerPedId(), "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
	SetPedIsDrunk(PlayerPedId(), true)
	DoScreenFadeIn(1000)
	Citizen.SetTimeout(60 * 1000, function()
        DoScreenFadeOut(1000)
        Citizen.Wait(1000)
        DoScreenFadeIn(1000)
        ClearTimecycleModifier()
        ResetScenarioTypesEnabled()
        ResetPedMovementClipset(PlayerPedId(), 0)
        SetPedIsDrunk(PlayerPedId(), false)
        SetPedMotionBlur(PlayerPedId(), false)
    end)
end

function methDrugEffect()
    Citizen.CreateThread(function()
        SetRunSprintMultiplierForPlayer(PlayerId(), 1.2)

        local timeToWait = GetGameTimer() + Config.TimeBetweenDrugs
        while GetGameTimer() < timeToWait and not IsEntityDead(PlayerPedId()) do
            Citizen.Wait(1)
        end

        SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
    end)
end

function weedDrugEffect()
	local playerHealth = GetEntityHealth(PlayerPedId())

	if playerHealth <= GetEntityMaxHealth(PlayerPedId()) - 10 then
		SetEntityHealth(PlayerPedId(), playerHealth+10) -- 10% of the player life
	end
end

function shitDrugEffect()
	local playerHealth = GetEntityHealth(PlayerPedId())

	if playerHealth <= GetEntityMaxHealth(PlayerPedId()) - 10 then
		SetEntityHealth(PlayerPedId(), playerHealth+10) -- 10% of the player life
	end
end

function opiumDrugEffect()
    Citizen.CreateThread(function()
        SetSwimMultiplierForPlayer(PlayerId(), 1.2)

        local timeToWait = GetGameTimer() + Config.TimeBetweenDrugs
        while GetGameTimer() < timeToWait and not IsEntityDead(PlayerPedId()) do
            Citizen.Wait(1)
        end

        SetSwimMultiplierForPlayer(PlayerId(), 1.0)
    end)
end