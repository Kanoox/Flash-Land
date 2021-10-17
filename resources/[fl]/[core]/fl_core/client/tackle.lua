local isTackling, isGettingTackled, isRagdoll = false, false, false
local tackleLib = 'missmic2ig_11'
local tackleAnim = 'mic_2_ig_11_intro_goon'
local tackleVictimAnim = 'mic_2_ig_11_intro_p_one'
local lastTackleTime = 0

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)

		if isRagdoll then
			SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
		else
			Citizen.Wait(400)
		end
	end
end)

RegisterNetEvent('nwx:getTackled')
AddEventHandler('nwx:getTackled', function(target)
	if GetPlayerFromServerId(target) == -1 then return end
	isGettingTackled = true

	local playerPed = PlayerPedId()
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))

	RequestAnimDict(tackleLib)

	while not HasAnimDictLoaded(tackleLib) do
		Citizen.Wait(10)
	end

	AttachEntityToEntity(PlayerPedId(), targetPed, 11816, 0.25, 0.5, 0.0, 0.5, 0.5, 180.0, false, false, false, false, 2, false)
	TaskPlayAnim(playerPed, tackleLib, tackleVictimAnim, 8.0, -8.0, 3000, 0, 0, false, false, false)

	Citizen.Wait(3000)
	DetachEntity(PlayerPedId(), true, false)

	isRagdoll = true
	Citizen.Wait(3000)
	isRagdoll = false

	isGettingTackled = false
end)

RegisterNetEvent('nwx:playTackle')
AddEventHandler('nwx:playTackle', function()
	local playerPed = PlayerPedId()

	RequestAnimDict(tackleLib)

	while not HasAnimDictLoaded(tackleLib) do
		Citizen.Wait(10)
	end

	TaskPlayAnim(playerPed, tackleLib, tackleAnim, 8.0, -8.0, 3000, 0, 0, false, false, false)

	Citizen.Wait(3000)

	isTackling = false
end)

-- Main thread
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)

		if not isTackling then
			if IsControlPressed(0, 21) and IsControlPressed(0, 47) and GetGameTimer() - lastTackleTime > 10 * 1000 then
				Citizen.Wait(10)
				local closestPlayer, distance = ESX.Game.GetClosestPlayer()

				if distance ~= -1 and distance <= 1.5 and not isTackling and not isGettingTackled and not IsPedInAnyVehicle(PlayerPedId()) and not IsPedInAnyVehicle(GetPlayerPed(closestPlayer)) then
					isTackling = true
					lastTackleTime = GetGameTimer()

					TriggerServerEvent('nwx:tryTackle', GetPlayerServerId(closestPlayer))
				end
			end
		else
			Citizen.Wait(100)
		end

	end
end)

-- Porter
local piggyBackInProgress = false

Citizen.CreateThread(function()
	while true do
		if piggyBackInProgress then
			local playerPed = PlayerPedId()
			local closestPlayer, distance = ESX.Game.GetClosestPlayer()
			local closestPed = GetPlayerPed(closestPlayer)
			if IsPedInAnyVehicle(playerPed, true) and not IsPedDeadOrDying(closestPed, 0) then
				--piggyBackInProgress = false
				--ClearPedSecondaryTask(PlayerPedId())
				--DetachEntity(PlayerPedId(), true, false)
				--DetachEntity(closestPed, true, false)
				--TriggerServerEvent('nwx:carryStop', GetPlayerServerId(closestPlayer))
			end
		end
		Citizen.Wait(1000)
	end
end)

RegisterCommand('porter', function(source, args)
	Carry(source, args)
end, false)

RegisterCommand('carry', function(source, args)
	Carry(source, args)
end, false)

function Carry(source, args)
	if not piggyBackInProgress then
		piggyBackInProgress = true
		local lib = 'anim@arena@celeb@flat@paired@no_props@'
		local anim1 = 'piggyback_c_player_a'
		local anim2 = 'piggyback_c_player_b'
		local closestPlayer, distance = ESX.Game.GetClosestPlayer()
		if closestPlayer ~= nil and distance < 3 then
			TriggerServerEvent('nwx:carry', GetPlayerServerId(closestPlayer), lib, anim1, anim2, -0.07, 0.0, 0.45, 100000, 0.0, 49, 33, 1)
		else
			piggyBackInProgress = false
			print("Pas de joueur à proximité")
		end
	else
		piggyBackInProgress = false
		ClearPedSecondaryTask(PlayerPedId())
		DetachEntity(PlayerPedId(), true, false)
		local closestPlayer, distance = ESX.Game.GetClosestPlayer()
		if closestPlayer == nil and distance < 3 then print("Nobody in radius 3") return end
		local closestPed = GetPlayerPed(closestPlayer)
		ClearPedSecondaryTask(closestPed)
		DetachEntity(closestPed, true, false)
		TriggerServerEvent('nwx:carryStop', GetPlayerServerId(closestPlayer))
	end
end

RegisterNetEvent('nwx:carryTarget')
AddEventHandler('nwx:carryTarget', function(target, animationLib, animation2, distans, distans2, height, length,spin,controlFlag)
	local playerPed = PlayerPedId()
	local playerServer = GetPlayerFromServerId(target)
	if playerServer == -1 then return end

	local targetPed = GetPlayerPed(playerServer)
	piggyBackInProgress = true
	RequestAnimDict(animationLib)

	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	if spin == nil then spin = 180.0 end
	AttachEntityToEntity(playerPed, targetPed, 0, distans2, distans, height, 0.5, 0.5, spin, false, false, false, false, 2, false)
	if controlFlag == nil then controlFlag = 0 end
	TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)
end)

RegisterNetEvent('nwx:carrySync')
AddEventHandler('nwx:carrySync', function(animationLib, animation,length,controlFlag,animFlag)
	local playerPed = PlayerPedId()
	RequestAnimDict(animationLib)

	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	Wait(500)
	if controlFlag == nil then controlFlag = 0 end
	TaskPlayAnim(playerPed, animationLib, animation, 8.0, -8.0, length, controlFlag, 0, false, false, false)

	Citizen.Wait(length)
end)

RegisterNetEvent('nwx:carryStopTarget')
AddEventHandler('nwx:carryStopTarget', function(target)
	local playerPed = PlayerPedId()
	local pid = GetPlayerFromServerId(target)
	if pid == -1 then
		print('Error occured while stopping carrying')
		return
	end
	local targetPed = GetPlayerPed(pid)
	piggyBackInProgress = false
	ClearPedSecondaryTask(PlayerPedId())
	ClearPedSecondaryTask(playerPed)
	DetachEntity(GetPlayerPed(GetPlayerFromServerId(target)), true, false)
	DetachEntity(playerPed, true, false)
end)
