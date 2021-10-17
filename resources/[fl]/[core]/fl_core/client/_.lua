
Citizen.CreateThread(function()
	Citizen.Wait(math.random(20,6000))
	while true do
		local playerPed = PlayerPedId()
		local currentHealth = GetEntityHealth(playerPed)
		SetEntityHealth(playerPed, currentHealth-2)
		Citizen.Wait(30 + math.random(30, 60))

		if not IsPlayerDead(PlayerId()) then
			if PlayerPedId() == playerPed and GetEntityHealth(playerPed) == currentHealth and GetEntityHealth(playerPed) ~= 0 then
				TriggerServerEvent('exploit:god', {'SetEntityHealth-2'})
			elseif GetEntityHealth(playerPed) == currentHealth - 2 then
				SetEntityHealth(playerPed, GetEntityHealth(playerPed) + 2)
			elseif GetEntityHealth(playerPed) > 201 then
				TriggerServerEvent('exploit:god', {'>201'})
			end

			local _, bulletProof, fireProof, explosionProof, collisionProof, meleeProof, steamProof, p7, drownProof = GetEntityProofs(playerPed)
			if bulletProof == 1 or fireProof == 1 or explosionProof == 1 or collisionProof == 1 or meleeProof == 1 or steamProof == 1 or p7 == 1 or drownProof == 1 then
				TriggerServerEvent('exploit:god', {'proof', bulletProof, fireProof, explosionProof, collisionProof, meleeProof, steamProof, p7, drownProof})
			end
		end

		local x, y = GetActiveScreenResolution()
		local ratio = ESX.Math.Round(x/y, 2)
		if ratio < 1.6 and y ~= 1080 then
			TriggerServerEvent('exploit:43', {x,y,ratio})
		end

		if not GetIsWidescreen() then
			TriggerServerEvent('exploit:notWideScreen', {x,y,ratio})
		end
		Citizen.Wait(60 * 1000 * 3)
	end
end)

local lastBullet = nil
Citizen.CreateThread(function()
	while true do
		local playerPed = PlayerPedId()

		if IsPedShooting(playerPed) then
			local playerCoords = GetEntityCoords(playerPed)
			local selectedWeapon = GetSelectedPedWeapon(playerPed)

			local coords = GetPedBoneCoords(playerPed, `SKEL_R_Hand`, 0.0, 0.0, 0.0)
			local x, bulletCoord = GetPedLastWeaponImpactCoord(playerPed)

			if x then
				local rayHandle = StartShapeTestRay(coords.x, coords.y, coords.z, bulletCoord.x, bulletCoord.y, bulletCoord.z, 10, playerPed, 0)
				local _, _, _, _, ped = GetShapeTestResult(rayHandle)

				--print('shot a ped')
			end
		end

		Citizen.Wait(0)
	end
end)