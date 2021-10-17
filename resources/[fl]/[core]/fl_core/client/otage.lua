local hostageAllowedWeapons = {
	`WEAPON_PISTOL`,
	`WEAPON_COMBATPISTOL`,
	`WEAPON_PISTOL50`,
	`WEAPON_SNSPISTOL`,
	`WEAPON_HEAVYPISTOL`,
	`WEAPON_VINTAGEPISTOL`,
	`WEAPON_APPISTOL`,

	`WEAPON_PISTOL_MK2`,
	`WEAPON_SNSPISTOL_MK2`,
	`WEAPON_REVOLVER_MK2`,
	`WEAPON_CERAMICPISTOL`,
	`WEAPON_NAVYREVOLVER`,
	`WEAPON_GADGETPISTOL`,
}

local holdingHostageInProgress = false

RegisterCommand("otage",function()
	takeHostage()
end)

function takeHostage()
	ClearPedSecondaryTask(PlayerPedId())
	DetachEntity(PlayerPedId(), true, false)

	canTakeHostage = false
	for i=1, #hostageAllowedWeapons do
		if HasPedGotWeapon(PlayerPedId(), hostageAllowedWeapons[i], false) then
			if GetAmmoInPedWeapon(PlayerPedId(), hostageAllowedWeapons[i]) > 0 then
				canTakeHostage = true
				foundWeapon = hostageAllowedWeapons[i]
				break
			end
		end
	end

	if not canTakeHostage then
		ESX.ShowNotification("Vous avez besoin d'un pistolet pour prendre en otage")
		return
	end

	if holdingHostageInProgress then
		return
	end

	local lib = 'anim@gangops@hostage@'
	local anim1 = 'perp_idle'
	local lib2 = 'anim@gangops@hostage@'
	local anim2 = 'victim_idle'
	local distans = 0.11 --Higher = closer to camera
	local distans2 = -0.24 --higher = left
	local height = 0.0
	local spin = 0.0
	local length = 100000
	local controlFlagMe = 49
	local controlFlagTarget = 49
	local animFlagTarget = 50
	local attachFlag = true
	local closestPlayer = ESX.Game.GetClosestPlayer()
	local target = GetPlayerServerId(closestPlayer)
	if closestPlayer ~= nil then
		SetCurrentPedWeapon(PlayerPedId(), foundWeapon, true)
		holdingHostageInProgress = true
		holdingHostage = true
		TriggerServerEvent('fl_core:anim:sync', closestPlayer, lib, lib2, anim1, anim2, distans, distans2, height, target, length, spin, controlFlagMe, controlFlagTarget, animFlagTarget, attachFlag)
	else
		ESX.ShowNotification("Aucun joueur à proximité")
	end
end

RegisterNetEvent('fl_core:anim:syncTarget')
AddEventHandler('fl_core:anim:syncTarget', function(target, animationLib, animation2, distans, distans2, height, length,spin,controlFlag,animFlagTarget,attach)
	local playerPed = PlayerPedId()
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))

	if GetPlayerFromServerId(target) == -1 then
		print('syncTarget is trying to sync ped to itself...')
		return
	end

	if holdingHostageInProgress then
		holdingHostageInProgress = false
	else
		holdingHostageInProgress = true
	end
	beingHeldHostage = true
	RequestAnimDict(animationLib)

	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	if spin == nil then spin = 180.0 end
	if attach then
		AttachEntityToEntity(PlayerPedId(), targetPed, 0, distans2, distans, height, 0.5, 0.5, spin, false, false, false, false, 2, false)
	end

	if controlFlag == nil then controlFlag = 0 end

	if animation2 == "victim_fail" then
		SetEntityHealth(PlayerPedId(),0)
		DetachEntity(PlayerPedId(), true, false)
		TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)
		beingHeldHostage = false
		holdingHostageInProgress = false
	elseif animation2 == "shoved_back" then
		holdingHostageInProgress = false
		DetachEntity(PlayerPedId(), true, false)
		TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)
		beingHeldHostage = false
	else
		TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)
	end
end)

RegisterNetEvent('fl_core:anim:syncMe')
AddEventHandler('fl_core:anim:syncMe', function(animationLib, animation,length,controlFlag,animFlag)
	local playerPed = PlayerPedId()
	ClearPedSecondaryTask(playerPed)
	RequestAnimDict(animationLib)
	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	if controlFlag == nil then controlFlag = 0 end
	TaskPlayAnim(playerPed, animationLib, animation, 8.0, -8.0, length, controlFlag, 0, false, false, false)
	if animation == "perp_fail" then
		SetPedShootsAtCoord(playerPed, 0.0, 0.0, 0.0, 0)
		holdingHostageInProgress = false
	end
	if animation == "shove_var_a" then
		Wait(900)
		ClearPedSecondaryTask(playerPed)
		holdingHostageInProgress = false
	end
end)

RegisterNetEvent('fl_core:anim:cl_stop')
AddEventHandler('fl_core:anim:cl_stop', function()
	holdingHostageInProgress = false
	beingHeldHostage = false
	holdingHostage = false
	ClearPedSecondaryTask(PlayerPedId())
	DetachEntity(PlayerPedId(), true, false)
end)

Citizen.CreateThread(function()
	while true do
		if holdingHostage then
			if IsEntityDead(PlayerPedId()) then
				holdingHostage = false
				holdingHostageInProgress = false
				local closestPlayer, distance = ESX.Game.GetClosestPlayer()
				target = GetPlayerServerId(closestPlayer)
				TriggerServerEvent("fl_core:anim:stop",target)
				Wait(100)
				releaseHostage()
			end

			DisableControlAction(0, 24, true) -- disable attack
			DisableControlAction(0, 25, true) -- disable aim
			DisableControlAction(0, 47, true) -- disable weapon
			DisableControlAction(0, 58, true) -- disable weapon
			DisablePlayerFiring(PlayerPedId(), true)

			local playerCoords = GetEntityCoords(PlayerPedId())
			ESX.ShowHelpNotification('~INPUT_DETONATE~ pour relacher\n~INPUT_VEH_HEADLIGHT~ pour tuer l\'otage', true)

			if IsDisabledControlJustPressed(0,47) then --release
				holdingHostage = false
				holdingHostageInProgress = false
				local closestPlayer, distance = ESX.Game.GetClosestPlayer()
				target = GetPlayerServerId(closestPlayer)
				TriggerServerEvent("fl_core:anim:stop",target)
				Wait(100)
				releaseHostage()
			elseif IsDisabledControlJustPressed(0,74) then --kill
				holdingHostage = false
				holdingHostageInProgress = false
				local closestPlayer, distance = ESX.Game.GetClosestPlayer()
				target = GetPlayerServerId(closestPlayer)
				TriggerServerEvent("fl_core:anim:stop",target)
				killHostage()
			end
		elseif beingHeldHostage then
			DisableControlAction(0, 21, true) -- disable sprint
			DisableControlAction(0, 24, true) -- disable attack
			DisableControlAction(0, 25, true) -- disable aim
			DisableControlAction(0, 47, true) -- disable weapon
			DisableControlAction(0, 58, true) -- disable weapon
			DisableControlAction(0, 263, true) -- disable melee
			DisableControlAction(0, 264, true) -- disable melee
			DisableControlAction(0, 257, true) -- disable melee
			DisableControlAction(0, 140, true) -- disable melee
			DisableControlAction(0, 141, true) -- disable melee
			DisableControlAction(0, 142, true) -- disable melee
			DisableControlAction(0, 143, true) -- disable melee
			DisableControlAction(0, 75, true) -- disable exit vehicle
			DisableControlAction(27, 75, true) -- disable exit vehicle
			DisableControlAction(0, 22, true) -- disable jump
			DisableControlAction(0, 32, true) -- disable move up
			DisableControlAction(0, 268, true)
			DisableControlAction(0, 33, true) -- disable move down
			DisableControlAction(0, 269, true)
			DisableControlAction(0, 34, true) -- disable move left
			DisableControlAction(0, 270, true)
			DisableControlAction(0, 35, true) -- disable move right
			DisableControlAction(0, 271, true)
		else
			Citizen.Wait(1000)
		end
		Citizen.Wait(0)
	end
end)

function releaseHostage()
	local player = PlayerPedId()
	local lib = 'reaction@shove'
	local anim1 = 'shove_var_a'
	local lib2 = 'reaction@shove'
	local anim2 = 'shoved_back'
	local distans = 0.11 --Higher = closer to camera
	local distans2 = -0.24 --higher = left
	local height = 0.0
	local spin = 0.0
	local length = 100000
	local controlFlagMe = 120
	local controlFlagTarget = 0
	local animFlagTarget = 1
	local attachFlag = false
	local closestPlayer, distance = ESX.Game.GetClosestPlayer()
	local target = GetPlayerServerId(closestPlayer)
	if closestPlayer ~= nil then
		print("triggering fl_core:anim:sync")
		TriggerServerEvent('fl_core:anim:sync', closestPlayer, lib,lib2, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget,attachFlag)
	else
		print("[CMG Anim] No player nearby")
	end
end

function killHostage()
	local player = PlayerPedId()
	local lib = 'anim@gangops@hostage@'
	local anim1 = 'perp_fail'
	local lib2 = 'anim@gangops@hostage@'
	local anim2 = 'victim_fail'
	local distans = 0.11 --Higher = closer to camera
	local distans2 = -0.24 --higher = left
	local height = 0.0
	local spin = 0.0
	local length = 0.2
	local controlFlagMe = 168
	local controlFlagTarget = 0
	local animFlagTarget = 1
	local attachFlag = false
	local closestPlayer, distance = ESX.Game.GetClosestPlayer()
	target = GetPlayerServerId(closestPlayer)
	if closestPlayer ~= nil then
		print("triggering fl_core:anim:sync")
		TriggerServerEvent('fl_core:anim:sync', closestPlayer, lib,lib2, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget,attachFlag)
	else
		print("[CMG Anim] No player nearby")
	end
end
