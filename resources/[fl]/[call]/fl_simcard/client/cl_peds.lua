Citizen.CreateThread(function()
	Citizen.Wait(5000)
	for _,Shop in pairs(Config.Shops) do
		Shop.Peds = {}
		for _,PedInfo in pairs(Shop.npc) do

			ESX.Streaming.RequestModel(GetHashKey(PedInfo.model))

			local ped = CreatePed(4, GetHashKey(PedInfo.model), PedInfo.pos.x, PedInfo.pos.y, PedInfo.pos.z, PedInfo.pos.w, false, false)
			SetPedRandomComponentVariation(ped)
			SetPedRandomProps(ped)
			SetBlockingOfNonTemporaryEvents(ped, false)
			FreezeEntityPosition(ped, true)
			DisablePedPainAudio(ped, true)
			SetPedSeeingRange(ped, 0)
			SetPedFleeAttributes(ped, 0, 0)
			SetPedArmour(ped, 200)
			SetPedSuffersCriticalHits(ped, false)
			SetPedMaxHealth(ped, 200)
			SetPedDiesWhenInjured(ped, true)
			SetEntityInvincible(ped, true)
			SetAmbientVoiceName(ped, 'GENERIC_HI')

			if PedInfo.dict and PedInfo.anim then
				RequestAnimDict(PedInfo.anim)
				repeat
					Citizen.Wait(0)
				until HasAnimDictLoaded(PedInfo.anim)
				TaskPlayAnim(ped, PedInfo.anim, PedInfo.dict, 8.0, 0.0, -1, 1, 0, 0, 0, 0)
			elseif PedInfo.scenario then
				TaskStartScenarioInPlace(ped, PedInfo.scenario, 0, 0)
			else
				TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT', 0, 0)
			end

			table.insert(Shop.Peds, ped)

			SetModelAsNoLongerNeeded(GetHashKey(PedInfo.model))
		end
	end
end)