RegisterCommand('wheelchair', function()
	ESX.Streaming.RequestModel(`prop_wheelchair_01`)
	CreateObject(`prop_wheelchair_01`, GetEntityCoords(PlayerPedId()) + GetEntityForwardVector(PlayerPedId()) + vector3(0.0, 0.0, -1.0), true)
end, false)

Citizen.CreateThread(function()
	while true do
		local sleep = 1000

		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)

		local closestObject = GetClosestObjectOfType(pedCoords, 3.0, `prop_wheelchair_01`, false)

		if DoesEntityExist(closestObject) then
			sleep = 5

			local wheelChairCoords = GetEntityCoords(closestObject)
			local wheelChairForward = GetEntityForwardVector(closestObject)

			local sitCoords = (wheelChairCoords + wheelChairForward * -0.5)
			local pickupCoords = (wheelChairCoords + wheelChairForward * 0.3)
			local deleteCoords = (wheelChairCoords + wheelChairForward * 0.1)

			local closestPlayer, closestPlayerDist = ESX.Game.GetClosestPlayer()
			local isOccupied = false
			local isDrived = false
			if closestPlayer ~= nil and closestPlayerDist <= 1.5 then
				isOccupied = IsEntityPlayingAnim(GetPlayerPed(closestPlayer), 'missfinale_c2leadinoutfin_c_int', '_leadin_loop2_lester', 3)
				isDrived = IsEntityPlayingAnim(GetPlayerPed(closestPlayer), 'anim@heists@box_carry@', 'idle', 3)
			end

			if not isOccupied and #(pedCoords - sitCoords) <= 1.0 then
				ESX.Game.Utils.DrawText3D(sitCoords, "[E] S'asseoir", 0.4)

				if IsControlJustPressed(0, 38) then
					Sit(closestObject)
				end
			end

			if not isDrived and #(pedCoords - pickupCoords) <= 1.0 then
				ESX.Game.Utils.DrawText3D(pickupCoords, "[E] Diriger", 0.4)

				if IsControlJustPressed(0, 38) then
					PickUp(closestObject)
				end
			end

			if not isOccupied and #(pedCoords - deleteCoords) <= 1.5 then
				ESX.Game.Utils.DrawText3D(deleteCoords, "[SUPPR] Récupérer", 0.4)

				if IsControlJustPressed(0, 214) then
					repeat
						Citizen.Wait(0)
						NetworkRequestControlOfEntity(closestObject)
					until NetworkHasControlOfEntity(closestObject)
					DeleteEntity(closestObject)
				end
			end
		end

		Citizen.Wait(sleep)
	end
end)

function Sit(wheelchairObject)
	print('[fl_wheelchair] Sit')
	local closestPlayer, closestPlayerDist = ESX.Game.GetClosestPlayer()

	if closestPlayer ~= nil and closestPlayerDist <= 1.5 then
		if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), 'missfinale_c2leadinoutfin_c_int', '_leadin_loop2_lester', 3) then
			ESX.ShowNotification("Quelqu'un utilise déjà cette chaise !")
			return
		end
	end

	ESX.Streaming.RequestAnimDict('missfinale_c2leadinoutfin_c_int')

	AttachEntityToEntity(PlayerPedId(), wheelchairObject, 0, 0, 0.0, 0.4, 0.0, 0.0, 180.0, 0.0, false, false, false, false, 2, true)

	local heading = GetEntityHeading(wheelchairObject)

	while IsEntityAttachedToEntity(PlayerPedId(), wheelchairObject) do
		Citizen.Wait(5)

		if IsPedDeadOrDying(PlayerPedId()) then
			DetachEntity(PlayerPedId(), true, true)
		end

		if not IsEntityPlayingAnim(PlayerPedId(), 'missfinale_c2leadinoutfin_c_int', '_leadin_loop2_lester', 3) then
			TaskPlayAnim(PlayerPedId(), 'missfinale_c2leadinoutfin_c_int', '_leadin_loop2_lester', 8.0, 8.0, -1, 69, 1, false, false, false)
		end

		if IsControlPressed(0, 32) then
			local wheelChairPos = GetEntityCoords(wheelchairObject)
			local wheelChairNextPos = wheelChairPos + GetEntityForwardVector(wheelchairObject) * -0.04
			local wheelChairNextPosRay = wheelChairNextPos + GetEntityForwardVector(wheelchairObject) * -0.5
			local ray = StartShapeTestRay(wheelChairPos.x, wheelChairPos.y, wheelChairPos.z, wheelChairNextPosRay.x, wheelChairNextPosRay.y, wheelChairNextPosRay.z, 511, PlayerPedId(), 0)
			local retval --[[ integer ]], hit --[[ boolean ]], endCoords --[[ vector3 ]], surfaceNormal --[[ vector3 ]], entityHit --[[ Entity ]] = GetShapeTestResult(ray)
			if hit == 0 then
				SetEntityCoords(wheelchairObject, wheelChairNextPos)
				PlaceObjectOnGroundProperly(wheelchairObject)
			end
		end

		if IsControlPressed(1,  34) then
			heading = heading + 0.8

			if heading > 360 then
				heading = 0
			end

			SetEntityHeading(wheelchairObject,  heading)
		end

		if IsControlPressed(1,  9) then
			heading = heading - 0.8

			if heading < 0 then
				heading = 360
			end

			SetEntityHeading(wheelchairObject,  heading)
		end

		if IsControlJustPressed(0, 73) then
			DetachEntity(PlayerPedId(), true, true)
			SetEntityCoords(PlayerPedId(), GetEntityCoords(wheelchairObject) + GetEntityForwardVector(wheelchairObject) * - 0.7)
		end
	end
	print('[fl_wheelchair] UnSitted')
end

function PickUp(wheelchairObject)
	print('[fl_wheelchair] PickUp')
	local closestPlayer, closestPlayerDist = ESX.Game.GetClosestPlayer()

	if closestPlayer ~= nil and closestPlayerDist <= 1.5 then
		if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), 'anim@heists@box_carry@', 'idle', 3) then
			ESX.ShowNotification("Quelqu'un à déjà la chaise roulante en main !")
			return
		end
	end

	NetworkRequestControlOfEntity(wheelchairObject)
	ESX.Streaming.RequestAnimDict("anim@heists@box_carry@")

	AttachEntityToEntity(wheelchairObject, PlayerPedId(), GetPedBoneIndex(PlayerPedId(),  28422), -0.00, -0.3, -0.73, 195.0, 180.0, 180.0, 0.0, false, false, true, false, 2, true)

	while IsEntityAttachedToEntity(wheelchairObject, PlayerPedId()) do
		Citizen.Wait(5)

		if not IsEntityPlayingAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 3) then
			TaskPlayAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 8.0, 8.0, -1, 50, 0, false, false, false)
		end

		if IsPedDeadOrDying(PlayerPedId()) then
			DetachEntity(wheelchairObject, true, true)
		end

		if IsControlJustPressed(0, 73) then
			DetachEntity(wheelchairObject, true, true)
		end
	end

	print('[fl_wheelchair] UnPickedUp')
end