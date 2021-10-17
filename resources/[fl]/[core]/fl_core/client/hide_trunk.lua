local inTrunk = false

ClearTimecycleModifier()
DetachEntity(PlayerPedId(), true, true)
ClearPedTasks(PlayerPedId())
SetEntityVisible(PlayerPedId(), true, true)
DisplayRadar(true)

Citizen.CreateThread(function()
	local fps = 250
	while true do
		if inTrunk then
			fps = 0
			local playerPed = PlayerPedId()
			local vehicle = GetEntityAttachedTo(playerPed)
			if DoesEntityExist(vehicle) and not IsPedDeadOrDying(playerPed, true) then
				local lockStatus = GetVehicleDoorLockStatus(vehicle)
				local coords = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, 'boot'))
				SetEntityCollision(playerPed, false, false)
				ESX.ShowHelpNotification('~INPUT_DETONATE~ Sortir du coffre')
				DisplayRadar(false)

				if GetVehicleDoorAngleRatio(vehicle, 5) < 0.9 then
				    SetEntityVisible(playerPed, false, false)
					SetTimecycleModifier("NG_blackout")
					SetTimecycleModifierStrength(0.9999)
					ESX.Game.Utils.DrawText2D('Vous êtes dans un coffre', 0.5, 0.9, 1.0)
				else
					if not IsEntityPlayingAnim(playerPed, 'timetable@floyd@cryingonbed@base', 3) then
						ESX.Streaming.RequestAnimDict('timetable@floyd@cryingonbed@base')
						TaskPlayAnim(playerPed, 'timetable@floyd@cryingonbed@base', 'base', 8.0, -8.0, -1, 1, 0, false, false, false)

						SetEntityVisible(playerPed, true, false)
					end
					ClearTimecycleModifier()
				end

				if IsControlJustReleased(0, 47) then
					if lockStatus == 1 then -- Unlocked
						SetCarBootOpen(vehicle)
						SetEntityCollision(vehicle, true, true)
						SetEntityCollision(playerPed, true, true)
						Citizen.Wait(750)
						inTrunk = false
						DetachEntity(playerPed, true, true)
						SetEntityVisible(playerPed, true, false)
						ClearTimecycleModifier()
						DisplayRadar(true)
						ClearPedTasks(playerPed)
						SetEntityCoords(playerPed, GetOffsetFromEntityInWorldCoords(playerPed, 0.0, -0.5, -0.75))
						Citizen.Wait(250)
						SetVehicleDoorShut(vehicle, 5)
					elseif lockStatus == 2 then -- Locked
						ESX.ShowNotification('~r~Le coffre est fermé.')
					end
				end
			else
				DisplayRadar(true)
				ClearTimecycleModifier()
				SetEntityCollision(playerPed, true, true)
				DetachEntity(playerPed, true, true)
				SetEntityVisible(playerPed, true, false)
				ClearPedTasks(playerPed)
				SetEntityCoords(playerPed, GetOffsetFromEntityInWorldCoords(playerPed, 0.0, -0.5, 0.3))
				inTrunk = false
			end
		else
			fps = 500
		end
		Citizen.Wait(fps)
	end
end)

local displayTrunkOpen = true
local trunkCoords = nil
Citizen.CreateThread(function()
	local sleep = 500
	while true do
		if trunkCoords then
			sleep = 0
			if displayTrunkOpen then
				ESX.Game.Utils.DrawText3D(trunkCoords, '[G] Se cacher\n[H] Ouvrir\n[L] Coffre', 0.5)
			else
				ESX.Game.Utils.DrawText3D(trunkCoords, '[G] Se cacher\n[H] Fermer\n[L] Coffre', 0.5)
			end
		else
			sleep = 1500
		end
		Citizen.Wait(sleep)
	end
end)


Citizen.CreateThread(function()
	while true do
		local attente = 150
		trunkCoords = nil
		local playerPed = PlayerPedId()
		
		if not IsPedInAnyVehicle(playerPed, true) then
			local vehicle, distance = ESX.Game.GetClosestVehicle()
			if DoesEntityExist(vehicle) and distance < 10 then
				local lockStatus = GetVehicleDoorLockStatus(vehicle)
				local trunk = GetEntityBoneIndexByName(vehicle, 'boot')
				if trunk ~= -1 then
					local coords = GetWorldPositionOfEntityBone(vehicle, trunk)
					if #(GetEntityCoords(playerPed) - coords) <= 1.5 then
						attente = 5
						local pedInSeat = GetPedInVehicleSeat(vehicle, -1)
						local isAPlayer = pedInSeat == 0 or IsPedAPlayer(pedInSeat)
						if isAPlayer and not inTrunk then
							if GetVehicleDoorAngleRatio(vehicle, 5) < 0.9 then
								trunkCoords = coords
								displayTrunkOpen = true
								if IsControlJustReleased(0, 74) then
									if lockStatus == 1 then --unlocked
										SetCarBootOpen(vehicle)
									elseif lockStatus == 2 then -- locked
										ESX.ShowNotification('~r~La voiture est fermée.')
									end
								end
							else
								trunkCoords = coords
								displayTrunkOpen = false
								if IsControlJustReleased(0, 74) then
									SetVehicleDoorShut(vehicle, 5)
								end
							end

							if IsControlJustReleased(0, 47) then
								if lockStatus == 1 then -- Unlocked
									if not IsPedDeadOrDying(playerPed) and not IsPedFatallyInjured(playerPed) then
										local closestPlayerPed = GetPlayerPed(ESX.Game.GetClosestPlayer())
										if DoesEntityExist(closestPlayerPed) then
											if (IsPedInVehicle(closestPlayerPed, vehicle, false) or not IsEntityAttachedToAnyVehicle(closestPlayerPed)) or #(GetEntityCoords(closestPlayerPed) - GetEntityCoords(playerPed)) >= 5.0 then
												SetCarBootOpen(vehicle)
												Citizen.Wait(350)
												AttachEntityToEntity(playerPed, vehicle, -1, 0.0, -2.2, 0.5, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
												ESX.Streaming.RequestAnimDict('timetable@floyd@cryingonbed@base')
												TaskPlayAnim(playerPed, 'timetable@floyd@cryingonbed@base', 'base', 8.0, -8.0, -1, 1, 0, false, false, false)
												Citizen.Wait(50)
												inTrunk = true

												Citizen.Wait(1500)
												SetVehicleDoorShut(vehicle, 5)
											else
												ESX.ShowNotification('~r~Il y a déjà quelqu\'un dans ce coffre...')
											end
										end
									end
								elseif lockStatus == 2 then -- Locked
									ESX.ShowNotification('~r~Le coffre est fermé.')
								end
							end
						end
					end
				end
			end
		end
	Citizen.Wait(attente)
		
	end
end)
