local start = false
local holsteredPolice = {}

AddEventHandler("esx:onPlayerSpawn", function()
	SetPedSuffersCriticalHits(playerPed, false)
end)

local armed = false
local playerPed = PlayerPedId()
--Degat arme
Citizen.CreateThread(function()
	Citizen.Wait(1000)
	while true do
		playerPed = PlayerPedId()
		armed = IsPedArmed(playerPed, 4)
		if IsPedArmed(playerPed, 1) then
			SetWeaponDamageModifier(GetSelectedPedWeapon(playerPed), 0.5)
		end
		Citizen.Wait(100)
	end
end)

local wasPressingRightClick = 0


--Désactivation headshot
Citizen.CreateThread(function()
	while true do
		SetPedSuffersCriticalHits(playerPed, false)
		Citizen.Wait(10 * 1000)
	end
end)


-- Recul des armes

--[[
local recoils = {
	[`weapon_pistol`] = 1.5,
	[`weapon_pistol_mk2`] = 1.5,
	[`weapon_combatpistol`] = 1.6,
	[`weapon_appistol`] = 1.7,
	[`weapon_stungun`] = 0.5,
	[`weapon_pistol50`] = 2.0,
	[`weapon_snspistol`] = 1.5,
	[`weapon_snspistol_mk2`] = 1.7,
	[`weapon_heavypistol`] = 2.0,
	[`weapon_vintagepistol`] = 1.5,
	[`weapon_flare`] = 1.0,
	[`weapon_marksmanpistol`] = 1.6,
	[`weapon_revolver`] = 1.5,
	[`weapon_revolver_mk2`] = 1.7,
	[`weapon_doubleaction`] = 1.5,
	[`weapon_raypistol`] = 1.7,
	[`weapon_ceramicpistol`] = 1.7,
	[`weapon_navyrevolver`] = 1.7,
	[`weapon_gadgetpistol`] = 1.7,

	[`weapon_microsmg`] = 1.1,
	[`weapon_smg`] = 0.7,
	[`weapon_smg_mk2`] = 0.6,
	[`weapon_assaultsmg`] = 0.6,
	[`weapon_combatpdw`] = 0.8,
	[`weapon_machinepistol`] = 0.8,
	[`weapon_minismg`] = 0.7,
	[`weapon_raycarbine`] = 0.7,

	[`weapon_pumpshotgun`] = 1.0,
	[`weapon_pumpshotgun_mk2`] = 1.0,
	[`weapon_sawnoffshotgun`] = 0.9,
	[`weapon_assaultshotgun`] = 0.6,
	[`weapon_bullpupshotgun`] = 2.0, -- Flashball
	[`weapon_musket`] = 1.0,
	[`weapon_heavyshotgun`] = 1.0,
	[`weapon_dbshotgun`] = 0.9,
	[`weapon_autoshotgun`] = 0.4,
	[`weapon_combatshotgun`] = 0.4,

	[`weapon_assaultrifle`] = 0.8,
	[`weapon_assaultrifle_mk2`] = 0.6,
	[`weapon_carbinerifle`] = 0.8,
	[`weapon_carbinerifle_mk2`] = 0.6,
	[`weapon_advancedrifle`] = 0.7,
	[`weapon_specialcarbine`] = 1.0,
	[`weapon_specialcarbine_mk2`] = 1.0,
	[`weapon_bullpuprifle`] = 0.5,
	[`weapon_bullpuprifle_mk2`] = 0.5,
	[`weapon_compactrifle`] = 0.5,
	[`weapon_militaryrifle`] = 0.5,

	[`weapon_mg`] = 0.6,
	[`weapon_combatmg`] = 0.3,
	[`weapon_combatmg_mk2`] = 0.4,
	[`weapon_gusenberg`] = 1.6,

	[`weapon_sniperrifle`] = 0.5,
	[`weapon_heavysniper`] = 0.5,
	[`weapon_heavysniper_mk2`] = 0.5,
	[`weapon_marksmanrifle`] = 0.5,
	[`weapon_marksmanrifle_mk2`] = 0.5,

	[`weapon_rpg`] = 1.5,
	[`weapon_grenadelauncher`] = 1.3,
	[`weapon_grenadelauncher_smoke`] = 1.3,
	[`weapon_minigun`] = 0.05,
	[`weapon_firework`] = 0.0,
	[`weapon_railgun`] = 2.4,
	[`weapon_hominglauncher`] = 1.0,
	[`weapon_compactlauncher`] = 0.6,
	[`weapon_rayminigun`] = 0.6,
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if armed then
			if GetVehiclePedIsIn(playerPed, false) == 0 then
				if IsPedShooting(playerPed) then
					local _,wep = GetCurrentPedWeapon(playerPed)
					if recoils[wep] == nil then
						recoils[wep] = 1.0
						print('Unknown weapon shooting')
					end

					local pitch = GetGameplayCamRelativePitch()
					SetGameplayCamRelativePitch(pitch + recoils[wep], 1.0)

					local heading = GetGameplayCamRelativeHeading()
					SetGameplayCamRelativeHeading(heading + (math.random(-5, 5) / 5))
				end
			else
				Citizen.Wait(1000)
			end
		else
			Citizen.Wait(500)
		end
	end
end)
--]]

local holstered = true
local canFire = true
local currWeapon = nil
local isHolsteringEnable = true

AddEventHandler('nwx:setHolstering', function(toggle)
	isHolsteringEnable = toggle
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(200)
		TickWeapon()
	end
end)

function TickWeapon()
	local playerPed = PlayerPedId()
	if not isHolsteringEnable then return end

	if IsEntityDead(playerPed) then
		SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true)
		Citizen.Wait(1000)
		return
	end

	if GetPedParachuteState(playerPed) == 2 then
		Citizen.Wait(1000)
		return
	end

	local newWeap = GetSelectedPedWeapon(playerPed)
	if currWeapon == nil then
		currWeapon = newWeap
		return
	end

	if newWeap == 966099553 then
		SetCurrentPedWeapon(playerPed, 966099553, true)
		return
	end

	if IsPedInAnyVehicle(playerPed, true) or currWeapon == newWeap then
		holsteredPolice = {}
		Citizen.Wait(300)
		return
	end

	if newWeap == `WEAPON_STUNGUN` or newWeap == `WEAPON_COMBATPISTOL` then
		ESX.Streaming.RequestAnimDict("rcmjosh4")
		if not holsteredPolice[newWeap] then
			canFire = false
			holsteredPolice[newWeap] = true
			TaskPlayAnim(playerPed, "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
			SetCurrentPedWeapon(playerPed, newWeap, true)
			Citizen.Wait(2000)
			canFire = true
		end
		return
	end

	SetCurrentPedWeapon(playerPed, currWeapon, true)

	if IsBigWeapon(newWeap) then
		local vehicle = ESX.Game.GetVehicleInDirection()

		if not HasBag() and vehicle == nil then
			SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true)
			ESX.ShowHelpNotification('~r~Rapprochez vous d\'un véhicule ou prenez un sac pour sortir cette arme')
			return
		end

		if vehicle then
			Citizen.CreateThread(function()
				SetVehicleDoorOpen(vehicle, 5, false, false)
				Citizen.Wait(2000)
				SetVehicleDoorShut(vehicle, 5, false)
			end)
		end
	end

	ESX.Streaming.RequestAnimDict("reaction@intimidation@1h")

	if holstered or newWeap ~= `WEAPON_UNARMED` then
		canFire = false
		TaskPlayAnimAdvanced(playerPed, "reaction@intimidation@1h", "intro", GetEntityCoords(playerPed, true), 0, 0, GetEntityHeading(playerPed), 8.0, 3.0, -1, 50, 0, 0, 0)
		Citizen.Wait(1000)
		SetCurrentPedWeapon(playerPed, newWeap, true)
		currWeapon = newWeap
		Citizen.Wait(2000)
		ClearPedTasks(playerPed)
		holstered = false
		canFire = true
	else
		canFire = false
		TaskPlayAnimAdvanced(playerPed, "reaction@intimidation@1h", "outro", GetEntityCoords(playerPed, true), 0, 0, GetEntityHeading(playerPed), 8.0, 3.0, -1, 50, 0, 0, 0)
		Citizen.Wait(1000)
		SetCurrentPedWeapon(playerPed, newWeap, true)
		currWeapon = newWeap
		Citizen.Wait(2000)
		ClearPedTasks(playerPed)
		holstered = false
		canFire = true
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if not canFire then
			DisableControlAction(0, 25, true)
			DisablePlayerFiring(PlayerPedId(), true)
		end
	end
end)

local BigWeapons = {
	`WEAPON_MICROSMG`,
	`WEAPON_MINISMG`,
	`WEAPON_SMG`,
	`WEAPON_SMG_MK2`,
	`WEAPON_ASSAULTSMG`,
	`WEAPON_MG`,
	`WEAPON_COMBATMG`,
	`WEAPON_COMBATMG_MK2`,
	`WEAPON_COMBATPDW`,
	`WEAPON_GUSENBERG`,
	`WEAPON_ASSAULTRIFLE`,
	`WEAPON_ASSAULTRIFLE_MK2`,
	`WEAPON_CARBINERIFLE`,
	`WEAPON_CARBINERIFLE_MK2`,
	`WEAPON_ADVANCEDRIFLE`,
	`WEAPON_SPECIALCARBINE`,
	`WEAPON_BULLPUPRIFLE`,
	`WEAPON_COMPACTRIFLE`,
	`WEAPON_PUMPSHOTGUN`,
	`WEAPON_SWEEPERSHOTGUN`,
	`WEAPON_SAWNOFFSHOTGUN`,
	`WEAPON_BULLPUPSHOTGUN`,
	`WEAPON_ASSAULTSHOTGUN`,
	`WEAPON_MUSKET`,
	`WEAPON_HEAVYSHOTGUN`,
	`WEAPON_DBSHOTGUN`,
	`WEAPON_SNIPERRIFLE`,
	`WEAPON_HEAVYSNIPER`,
	`WEAPON_HEAVYSNIPER_MK2`,
	`WEAPON_MARKSMANRIFLE`,
	`WEAPON_GRENADELAUNCHER`,
	`WEAPON_GRENADELAUNCHER_SMOKE`,
	`WEAPON_RPG`,
	`WEAPON_MINIGUN`,
	`WEAPON_FIREWORK`,
	`WEAPON_RAILGUN`,
	`WEAPON_HOMINGLAUNCHER`,
	`WEAPON_COMPACTLAUNCHER`,
	`WEAPON_SPECIALCARBINE_MK2`,
	`WEAPON_BULLPUPRIFLE_MK2`,
	`WEAPON_PUMPSHOTGUN_MK2`,
	`WEAPON_MARKSMANRIFLE_MK2`,
	`WEAPON_RAYPISTOL`,
	`WEAPON_RAYCARBINE`,
	`WEAPON_RAYMINIGUN`,
	`WEAPON_DIGISCANNER`,
	`WEAPON_COMBATSHOTGUN`,
	`WEAPON_MILITARYRIFLE`,
}

function IsBigWeapon(Weapon)
	for _,AnyWeapon in pairs(BigWeapons) do
		if AnyWeapon == Weapon then
			return true
		end
	end
	return false
end

local InvisibleDuffelBags = {0, 8, 9, 20, 30, 42, 43, 46, 47, 52, 63, 65, 74, 83, 84}
function HasBag()
	local bag = GetPedDrawableVariation(PlayerPedId(), 5)
	for _,AnyBag in pairs(InvisibleDuffelBags) do
		if AnyBag == bag then
			return false
		end
	end
	return true
end

--Ko
local knockedOut = false
local wait = math.random(1,5)
local count = 50

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		local myPed = PlayerPedId()
		if IsPedInMeleeCombat(myPed) then
			if GetEntityHealth(myPed) < 150 then
				SetPlayerInvincible(PlayerId(), false)
				SetPedToRagdoll(myPed, 1000, 1000, 0, 0, 0, 0)
				ESX.ShowNotification("~r~Tu as été mis KO!")
				wait = math.random(1,4)
				knockedOut = true
				SetEntityHealth(myPed, 175)
			end
		end
		if knockedOut then
			SetPlayerInvincible(PlayerId(), false)
			DisablePlayerFiring(PlayerId(), true)
			SetPedToRagdoll(myPed, 1000, 1000, 0, 0, 0, 0)
			ResetPedRagdollTimer(myPed)

			if wait >= 0 then
				count = count - 1
				if count == 0 then
					count = 50
					wait = wait - 1
					SetEntityHealth(myPed, GetEntityHealth(myPed)+1)
				end
			else
				SetPlayerInvincible(PlayerId(), false)
				knockedOut = false
			end
		end
	end
end)

RegisterNetEvent('nwx:flashballed')
AddEventHandler('nwx:flashballed', function()
	wait = 2
	knockedOut = true
	ESX.ShowNotification("~r~Tu as été mis KO par une flashball !")
end)

local offScreen = false
local offScreenVerySoon = false

function stunGun()
	local playerPed = PlayerPedId()
	ESX.Streaming.RequestAnimSet("move_m@drunk@verydrunk")
	offScreenVerySoon = true
	DoScreenFadeOut(800)
	repeat
		Citizen.Wait(50)
	until IsScreenFadedOut()
	offScreen = true
	DoScreenFadeIn(0)
	SetPedMinGroundTimeForStungun(playerPed, 15000)
	SetPedMovementClipset(playerPed, "move_m@drunk@verydrunk", true)
	SetTimecycleModifier("spectator5")
	SetPedIsDrunk(playerPed, true)
	Citizen.Wait(15000)
	SetPedMotionBlur(playerPed, true)
	DoScreenFadeOut(0)
	offScreen = false
	offScreenVerySoon = false
	DoScreenFadeIn(800)
	Citizen.Wait(60000)
	DoScreenFadeOut(800)
	Citizen.Wait(1000)
	ClearTimecycleModifier()
	ResetScenarioTypesEnabled()
	ResetPedMovementClipset(playerPed, 0)
	SetPedIsDrunk(playerPed, false)
	SetPedMotionBlur(playerPed, false)
	DoScreenFadeIn(800)
end

Citizen.CreateThread(function()
	 while true do
		Citizen.Wait(0)
		if offScreen then
			DrawRect(0.5, 0.5, 3.0, 3.0, 0, 0, 0, 255)
		elseif not offScreenVerySoon then
			Citizen.Wait(400)
		end
	 end
end)

local toBeProofNow = false
Citizen.CreateThread(function()
	 while true do
		if IsPedBeingStunned(PlayerPedId()) then
			stunGun()
		end
		SetEntityProofs(PlayerPedId(), false, false, toBeProofNow, false, false, false, false, false)
		ClearEntityLastDamageEntity(PlayerPedId())
		Citizen.Wait(200)
	 end
end)

RegisterNetEvent('fl_core:proofSmoke')
AddEventHandler('fl_core:proofSmoke', function(toBeProof)
	toBeProofNow = toBeProof
end)