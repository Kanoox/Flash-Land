local shieldActive = false
local shieldEntity = nil
local hadPistol = false

-- ANIM
local animDict = "combat@gestures@gang@pistol_1h@beckon"
local animName = "0"

local prop = "prop_ballistic_shield"
local pistol = `WEAPON_PISTOL`

AddEventHandler('fl_shield:shield', function()
	if shieldActive then
		DisableShield()
	else
		EnableShield()
	end
end)

function EnableShield()
	if IsPedInAnyVehicle(PlayerPedId(), true) then
		return
	end

	TriggerEvent('nwx:setHolstering', false)
	Citizen.Wait(200)
	shieldActive = true
	local ped = PlayerPedId()
	local pedPos = GetEntityCoords(ped, false)

	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do
		Citizen.Wait(100)
	end

	TaskPlayAnim(ped, animDict, animName, 8.0, -8.0, -1, (2 + 16 + 32), 0.0, 0, 0, 0)

	ESX.Streaming.RequestModel(GetHashKey(prop))

	shieldEntity = CreateObject(GetHashKey(prop), pedPos.x, pedPos.y, pedPos.z, true, true, true)
	AttachEntityToEntity(shieldEntity, ped, GetEntityBoneIndexByName(ped, "IK_L_Hand"), 0.0, -0.05, -0.10, -30.0, 180.0, 40.0, 0, 0, 1, 0, 0, 1)
	SetWeaponAnimationOverride(ped, `Gang1H`)

	if HasPedGotWeapon(ped, pistol, 0) or GetSelectedPedWeapon(ped) == pistol then
		SetCurrentPedWeapon(ped, pistol, 1)
		hadPistol = true
	else
		hadPistol = false
	end
end

function DisableShield()
	local ped = PlayerPedId()
	DeleteEntity(shieldEntity)
	ClearPedTasksImmediately(ped)
	SetWeaponAnimationOverride(ped, `Default`)

	if not hadPistol then
		RemoveWeaponFromPed(ped, pistol)
	end

	hadPistol = false
	shieldActive = false
	TriggerEvent('nwx:setHolstering', true)
end

Citizen.CreateThread(function()
	while true do
		if shieldActive then
			DisableControlAction(0, 23, true)
			DisableControlAction(0, 25, true)

			local playerPed = PlayerPedId()
			local _,weaponHash = GetCurrentPedWeapon(playerPed, 1)
			if weaponHash ~= `WEAPON_UNARMED` and GetPedAmmoTypeFromWeapon(playerPed, weaponHash) ~= `AMMO_PISTOL` then
				print('a:'..tostring(weaponHash ~= `WEAPON_UNARMED`))
				print('b:'..tostring(GetPedAmmoTypeFromWeapon(playerPed, weaponHash) ~= `AMMO_PISTOL`))
				SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true)
			end
		else
			Citizen.Wait(500)
		end
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		if shieldActive then
			local ped = PlayerPedId()

			if not IsEntityPlayingAnim(ped, animDict, animName, 1) then
				RequestAnimDict(animDict)
				repeat
					Citizen.Wait(0)
				until HasAnimDictLoaded(animDict)

				TaskPlayAnim(ped, animDict, animName, 8.0, -8.0, -1, (2 + 16 + 32), 0.0, 0, 0, 0)
			end

			SetCurrentPedWeapon(ped, pistol, 1)

			for _, vehicle in EnumerateVehicles() do
				SetEntityNoCollisionEntity(vehicle, shieldEntity, false)
			end
		end
		Citizen.Wait(500)
	end
end)