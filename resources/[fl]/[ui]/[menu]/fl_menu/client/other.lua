local function startPointing(plyPed)
	ESX.Streaming.RequestAnimDict('anim@mp_point', function()
		SetPedConfigFlag(plyPed, 36, 1)
		TaskMoveNetworkByName(plyPed, 'task_mp_pointing', 0.5, 0, 'anim@mp_point', 24)
		RemoveAnimDict('anim@mp_point')
	end)
end

local function stopPointing()
	RequestTaskMoveNetworkStateTransition(plyPed, 'Stop')

	if not IsPedInjured(plyPed) then
		ClearPedSecondaryTask(plyPed)
	end

	SetPedConfigFlag(plyPed, 36, 0)
	ClearPedSecondaryTask(plyPed)
end

local HandStatus = false
Citizen.CreateThread(function()
	local keepingCrouch = 0
	while true do
		Citizen.Wait(0)

		if IsControlPressed(0, Config.Controls.Crouch.keyboard) and keepingCrouch >= 0 then
			keepingCrouch = keepingCrouch + 1
		end

		if IsDisabledControlJustReleased(0, Config.Controls.Crouch.keyboard) then
			keepingCrouch = 0
			if not Player.justCrouched then
				Player.crouched = false
				ResetPedMovementClipset(PlayerPedId(), 0)
			end
			Player.justCrouched = false
		end

		if keepingCrouch >= 50 then
			keepingCrouch = -1
			local plyPed = PlayerPedId()
			ResetPedMovementClipset(plyPed, 0)
			SetPedStealthMovement(plyPed, 0, "DEFAULT_ACTION")

			if DoesEntityExist(plyPed) and not IsEntityDead(plyPed) and IsPedOnFoot(plyPed) then
				--Player.crouched = true
				Player.crouched = not Player.crouched

				if Player.crouched then
					Player.justCrouched = true
					ESX.Streaming.RequestAnimSet('move_ped_crouched', function()
						SetPedMovementClipset(plyPed, 'move_ped_crouched', 0.25)
						RemoveAnimSet('move_ped_crouched')
					end)
				else
					ResetPedMovementClipset(PlayerPedId(), 0)
				end
			end
		end


		if IsControlJustReleased(1, Config.Controls.Pointing.keyboard) and IsInputDisabled(2) then
			local plyPed = PlayerPedId()

			if (DoesEntityExist(plyPed)) and (not IsEntityDead(plyPed)) and (IsPedOnFoot(plyPed)) then
				if Player.handsUp then
					Player.handsUp = false
				end

				Player.pointing = not Player.pointing

				if Player.pointing then
					startPointing(plyPed)
				else
					stopPointing(plyPed)
				end
			end
		end

		if Player.crouched or Player.handsUp or Player.pointing then
			if not IsPedOnFoot(PlayerPedId()) then
				ResetPedMovementClipset(plyPed, 0)
				stopPointing()
				Player.crouched, Player.handsUp, Player.pointing = false, false, false
			elseif Player.pointing then
				local ped = PlayerPedId()
				local camPitch = GetGameplayCamRelativePitch()

				if camPitch < -70.0 then
					camPitch = -70.0
				elseif camPitch > 42.0 then
					camPitch = 42.0
				end

				camPitch = (camPitch + 70.0) / 112.0

				local camHeading = GetGameplayCamRelativeHeading()
				local cosCamHeading = Cos(camHeading)
				local sinCamHeading = Sin(camHeading)

				if camHeading < -180.0 then
					camHeading = -180.0
				elseif camHeading > 180.0 then
					camHeading = 180.0
				end

				camHeading = (camHeading + 180.0) / 360.0
				local coords = GetOffsetFromEntityInWorldCoords(ped, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
				local rayHandle, blocked = GetShapeTestResult(StartShapeTestCapsule(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, ped, 7))

				SetTaskMoveNetworkSignalFloat(ped, 'Pitch', camPitch)
				SetTaskMoveNetworkSignalFloat(ped, 'Heading', (camHeading * -1.0) + 1.0)
				SetTaskMoveNetworkSignalBool(ped, 'isBlocked', blocked)
				SetTaskMoveNetworkSignalBool(ped, 'isFirstPerson', N_0xee778f8c7e1142e2(N_0x19cafa3c87f7c2ff()) == 4)
			end
		end
	end
end)

-- local handsup = false
-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(0)

-- 		local plyPed = PlayerPedId()

-- 		--if (IsControlJustPressed(1, Config.handsUP.clavier) or IsDisabledControlJustPressed(1, Config.handsUP.clavier)) then
-- 		if IsControlPressed(0, 21) and IsControlJustReleased(0, 73) then
-- 			if DoesEntityExist(plyPed) and not IsEntityDead(plyPed) then
-- 				if not IsPedInAnyVehicle(plyPed, false) and not IsPedSwimming(plyPed) and not IsPedShooting(plyPed) and not IsPedClimbing(plyPed) and not IsPedCuffed(plyPed) and not IsPedDiving(plyPed) and not IsPedFalling(plyPed) and not IsPedJumpingOutOfVehicle(plyPed) and not IsPedUsingAnyScenario(plyPed) and not IsPedInParachuteFreeFall(plyPed) then
-- 					RequestAnimDict("random@mugging3")

-- 					while not HasAnimDictLoaded("random@mugging3") do
-- 						Citizen.Wait(100)
-- 					end

-- 					if not handsup then
-- 						handsup = true
-- 						TaskPlayAnim(plyPed, "random@mugging3", "handsup_standing_base", 8.0, -8, -1, 49, 0, 0, 0, 0)
-- 					elseif handsup then
-- 						handsup = false
-- 						ClearPedSecondaryTask(plyPed)
-- 					end
-- 				end
-- 			end
-- 		end
-- 	end
-- end)