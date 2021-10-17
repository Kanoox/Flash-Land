local proofs = {}
local timeouts = {}
local explosions = {}

AddEventHandler('explosionEvent', function(sender, eventData)
	if eventData.explosionType == 20 then -- lacrymo
		CancelEvent()
		local pos = vector3(eventData.posX, eventData.posY, eventData.posZ)
		if explosions[sender] == nil then
			explosions[sender] = {}
		end
		proofs[sender] = false
		table.insert(explosions[sender], pos)

		local id = math.random(100000, 999999)
		for x=0,6,3 do
			for y=0,6,3 do
				Citizen.CreateThread(function()
					local newPos = vector3(pos.x + x - 3.0, pos.y + y - 3.0, pos.z + 0.5)
					TriggerEvent('fl_particles:sync', id, newPos, 'core', 'exp_grd_bzgas_smoke', true, 50)
				end)
			end
		end

		if timeouts[sender] ~= nil then ESX.ClearTimeout(timeouts[sender]) end
		timeouts[sender] = ESX.SetTimeout(50 * 1000, function()
			TriggerClientEvent('fl_core:proofSmoke', sender, false)
			proofs[sender] = nil
			timeouts[sender] = nil
			explosions[sender] = nil
		end)

	elseif eventData.explosionType == 21 then -- bzgaz
		-- TODO
		-- Cancel
		-- Aggrandir la zone
	end
end)

Citizen.CreateThread(function()
	while true do
		for playerId,wasProofed in pairs(proofs) do
			local ped = GetPlayerPed(playerId)
			local playerCoords = GetEntityCoords(ped)
			local toBeProof = false

			for _,pos in pairs(explosions[playerId]) do
				if #(playerCoords - pos) < 6.0 then
					toBeProof = true
				end
			end

			if wasProofed and not toBeProof then
				TriggerClientEvent('fl_core:proofSmoke', playerId, false)
			elseif toBeProof and not wasProofed then
				TriggerClientEvent('fl_core:proofSmoke', playerId, true)
			end
		end

		Citizen.Wait(50)
	end
end)